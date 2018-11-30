DOTFILES_SOURCE=$(pwd)
echo $DOTFILES_SOURCE

ln -s $DOTFILES_SOURCE/zshrc.extras ~/.zshrc.extras
echo "source ~/.zshrc.extras" >> ~/.zshrc

ln -s $DOTFILES_SOURCE/tmux.conf ~/.tmux.conf
ln -s $DOTFILES_SOURCE/tmux.conf.ui ~/.tmux.conf.ui
ln -s $DOTFILES_SOURCE/tmux.conf.ubuntu ~/.tmux.conf.ubuntu
ln -s $DOTFILES_SOURCE/tmux.conf.osx ~/.tmux.conf.osx

ln -s $DOTFILES_SOURCE/vimrc ~/.vimrc
mkdir -p ~/.config/nvim
ln -s $DOTFILES_SOURCE/vimrc ~/.config/nvim/init.vim

ln -s $DOTFILES_SOURCE/ideavimrc ~/.ideavimrc

if command -v rbenv 2>/dev/null; then
  echo "symlinking rbenv default-gems"
  ln -s $DOTFILES_SOURCE/default-gems $(rbenv root)/default-gems
else
  echo "rbenv not installed"
  echo "Don't forget to symlink default-gems file later!"
fi
