git submodule init
git submodule update
git submodule foreach git checkout master
git submodule foreach git pull

# update vim-powerline to the last working commit
pushd dotfiles/.vim/bundle/vim-powerline
    git checkout 99277d9
popd
