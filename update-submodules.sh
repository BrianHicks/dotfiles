for submodule in $(git submodule | cut -d" " -f3); do
    pushd $submodule
        git stash
        git pull
        git checkout master
        git stash pop
    popd
done
