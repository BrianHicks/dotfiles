require 'uri'

def archive_and_retain(base, name, exts, archive_after, trash_after)
  rule "Archive/retain #{name}" do
    archive = File.join base, 'archive', name
    file_matcher = "*.{#{exts.join(',')}}"
    mkdir(archive) if not File.directory?(archive)

    # trash old files
    if not trash_after.nil?
      dir(File.join(archive, file_matcher)).each do |path|
        trash(path) if trash_after.since?(accessed_at(path))
      end
    end

    # archive files
    dir(File.join(base, file_matcher)).each do |path|
      move(path, archive) if archive_after.since?(modified_at(path))
    end
  end
end

Maid.rules do
  rule "Organize WTR PDFs in folders by week and month" do
    dir("~/BTSync/Shared/WTRs/*.pdf").each do |f|
      in_year = /(\d+).(\d+)/.match(f)
      next if in_year.nil?

      destination = "~/BTSync/shared/WTRs/#{created_at(f).year}/#{in_year[1]}/#{in_year[2]}/"
      mkdir(destination) if not File.directory? destination

      move(f, destination)
    end
  end

  # bank statements
  archive_and_retain("~/Downloads", "financial", %w(qif), 2.days, nil)
  rule "Rename bank statements" do
    root = "~/Downloads"
    dir(File.join root, "*.qif").each do |f|
      source = URI(downloaded_from(f)[0])
      created = created_at(f)

      rename(f, File.join(root, "#{source.host}-#{created.year}-#{created.month}-#{created.day}.qif"))
    end
  end

  # fonts
  rule "Keep Fonts" do
    font_archive = "~/Downloads/archive/fonts"
    mkdir(font_archive) if not File.directory?(font_archive)

    font_exts = %w(.woff .ttf .otf .ps .webfont .eot)
    dir("~/Downloads/*.zip").each do |zipfile|
      has_fonts = zipfile_contents(zipfile).any? { |path| font_exts.member?(File.extname(path)) }
      
      move(zipfile, font_archive) if has_fonts
    end
  end

  # misc downloads
  archive_and_retain("~/Downloads", "documents", %w(pdf doc docx xsl xslx csv), 1.week, 52.weeks)
  archive_and_retain("~/Downloads", "software", %w(dmg app pkg wdgt jar jnlp exe), 1.day, nil)
  archive_and_retain("~/Downloads", "video", %w(m4v mov), 2.days, 26.weeks)
  archive_and_retain("~/Downloads", "pictures", %w(png jpg jpeg gif), 1.week, 52.weeks)
end
