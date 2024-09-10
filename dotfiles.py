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


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--home", default=os.environ["HOME"])
    parser.add_argument("--dotfiles", default=os.path.normpath(os.path.join(os.path.dirname(__file__), "dotfiles")))

    sub = parser.add_subparsers(dest="command", required=True)

    import_ = sub.add_parser("import")
    import_.add_argument("source")
    import_.set_defaults(func=do_import)

    args = parser.parse_args()
    args.func(args)
