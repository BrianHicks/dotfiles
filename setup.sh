for f in $(ls -A dotfiles/); do ln -s `pwd`/dotfiles/$f ~; done
