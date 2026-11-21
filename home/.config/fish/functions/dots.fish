function dots --wraps=git --description 'git in ~/dots'
    git -C $HOME/dots $argv
end
