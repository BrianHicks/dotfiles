#!/usr/bin/env python3
import argparse
import os
import os.path
import subprocess


def ensure_link(src, dest):
    if os.path.islink(dest):
        if os.readlink(dest) == src:
            print(f"✅ {dest} already linked")
            return
        else:
            print(f"➖ removing existing symlink between {dest} and {src}")

    elif os.path.isfile(dest):
        with open(dest) as fh:
            dest_contents = fh.read()

        with open(src) as fh:
            src_contents = fh.read()

        if src_contents != dest_contents:
            raise Exception(f"{dest} already exists with different source as {src}. Please import instead!")
        else:
            # upgrading from a file to a symlink
            os.remove(dest)

    elif os.path.isdir(dest):
        raise Exception(f"{dest} is already a directory. Please remove this yourself.")

    os.makedirs(os.path.dirname(dest), exist_ok=True)
    os.symlink(src, dest)
    print(f"➕ linked {dest}")


def do_import(args):
    with open(args.source) as fh:
        contents = fh.read()

    in_dotfiles = os.path.join(args.dotfiles, os.path.relpath(args.source, args.home))
    in_dotfiles_dir = os.path.dirname(in_dotfiles)
    if not os.path.exists(in_dotfiles_dir):
        os.makedirs(in_dotfiles_dir)

    with open(in_dotfiles, 'w') as fh:
        fh.write(contents)

    ensure_link(in_dotfiles, args.source)


def do_apply(args):
    if os.path.isfile(args.checkpoint_file):
        with open(args.checkpoint_file) as fh:
            current = fh.read().strip()

        deleted_files = [
            filename for filename
            in subprocess.check_output(['git', 'diff', current, '--name-only', '--diff-filter=D']).decode('utf-8').split('\n')
            if os.path.commonpath([os.path.abspath(filename), args.dotfiles]) == args.dotfiles
        ]

        for deleted_file in deleted_files:
            deleted_file_home = os.path.join(args.home, os.path.relpath(deleted_file, args.dotfiles))
            if os.path.islink(deleted_file_home):
                os.unlink(deleted_file_home)

    for root, _, files in os.walk(args.dotfiles):
        for dotfile_name in files:
            dotfile = os.path.join(root, dotfile_name)
            dotfile_home = os.path.join(args.home, os.path.relpath(dotfile, args.dotfiles))

            ensure_link(dotfile, dotfile_home)

    with open(args.checkpoint_file, 'wb') as fh:
        fh.write(subprocess.check_output(['git', 'rev-parse', 'HEAD']))


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--home", default=os.environ["HOME"])
    parser.add_argument("--dotfiles", default=os.path.normpath(os.path.join(os.path.dirname(__file__), "dotfiles")))
    parser.add_argument("--checkpoint-file", default=os.path.normpath(os.path.join(os.path.dirname(__file__), ".checkpoint")))

    sub = parser.add_subparsers(dest="command", required=True)

    import_ = sub.add_parser("import")
    import_.add_argument("source")
    import_.set_defaults(func=do_import)

    apply = sub.add_parser("apply")
    apply.set_defaults(func=do_apply)

    args = parser.parse_args()
    args.func(args)
