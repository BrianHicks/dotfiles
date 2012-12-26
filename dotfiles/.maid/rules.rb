def archive_and_retain(base, name, exts, archive_after, retain_for)
  rule "Archive/retain #{name}" do
    archive = File.join base, 'archive', name
    file_matcher = "*.{#{exts.join(',')}}"
    mkdir(archive)

    # archive eligible files
    dir(File.join(base, file_matcher)).each do |path|
      move(path, archive) if archive_after.since?(modified_at(path))
    end

    # only retain a number of files
    dir(File.join(archive, file_matcher)).each do |path|
      trash(path) if retain_for.since?(accessed_at(path))
    end
  end
end

Maid.rules do
  archive_and_retain('~/Downloads', 'software', %w(dmg app pkg wdgt jar jnlp exe), 1.week, 52.weeks)
  archive_and_retain('~/Downloads', 'documents', %w(csv, xslx, docx, pdf), 1.week, 52.weeks)
  archive_and_retain('~/Downloads', 'movies', %w(m4v), 1.week, 52.weeks)
  archive_and_retain('~/Downloads', 'pictures', %w(png jpg jpeg), 1.week, 52.weeks)

  rule "Put font zips in Dropbox" do
    font_archive = '~/Dropbox/fonts'
    mkdir(font_archive)

    font_exts = %w(.woff .ttf .otf .ps .webfont .eot)

    dir('~/Downloads/*.zip').each do |zipfile|
      has_fonts = false
      can_archive = true

      zipfile_contents(zipfile).each do |path|
        if font_exts.member?(File.extname(path))
          has_fonts = true
        end

        if File.exists?(File.expand_path(File.join('~/Downloads', path)))
          can_archive = false
        end
      end

      if has_fonts
        if can_archive
          move(zipfile, font_archive)
        else
          puts "#{zipfile} has fonts, but is expanded. Delete expanded archive to archive."
        end
      end
    end
  end

  rule "Archive/retain old zips" do
    zip_archive = '~/Downloads/archive/zips'
    mkdir(zip_archive)

    # figure out whether or not to archive
    dir('~/Downloads/*.zip').each do |zipfile|
      latest_accessed = nil
      any_expanded = false

      zipfile_contents(zipfile).each do |path|
        expanded_path = File.expand_path(File.join('~/Downloads', path))

        if File.exists? expanded_path
          any_expanded = true
          last_accessed = modified_at(expanded_path)
          if latest_accessed.nil? or last_accessed > latest_accessed
            latest_accessed = last_accessed
          end
        end
      end

      if any_expanded
        if 1.week.since? latest_accessed
          zipfile_contents(zipfile).each do |path|
            expanded_path = File.expand_path(File.join('~/Downloads', path))
            trash(expanded_path)
          end
        end
      end
      if 2.weeks.since? modified_at(zipfile)
        trash(zipfile)
      end
    end
  end

  archive_and_retain('~/Downloads', 'keys', %w(pem pub cer), 1.week, 1000.weeks)

  # last rule since it touches everything
  archive_and_retain('~/Downloads', 'etc', %w(*), 5.weeks, 52.weeks)
end
