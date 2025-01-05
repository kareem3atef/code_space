#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Install Zsh
if ! command -v zsh >/dev/null 2>&1; then
    echo "Installing Zsh..."
    sudo apt update && sudo apt install -y zsh
else
    echo "Zsh is already installed."
fi

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
else
    echo "Oh My Zsh is already installed."
fi

# Clone Zsh Syntax Highlighting plugin
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "Cloning Zsh Syntax Highlighting plugin..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
else
    echo "Zsh Syntax Highlighting plugin is already cloned."
fi

# Clone Zsh Autosuggestions plugin
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "Cloning Zsh Autosuggestions plugin..."
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
else
    echo "Zsh Autosuggestions plugin is already cloned."
fi

# Clone Powerlevel10k theme
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    echo "Cloning Powerlevel10k theme..."
    git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
else
    echo "Powerlevel10k theme is already cloned."
fi

# Set Zsh as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Setting Zsh as default shell..."
    chsh -s $(which zsh)
else
    echo "Zsh is already the default shell."
fi

# Update .zshrc to include plugins and theme
ZSHRC="$HOME/.zshrc"
if ! grep -q "^ZSH_THEME=\"powerlevel10k/powerlevel10k\"" "$ZSHRC"; then
    echo "Updating .zshrc with theme and plugins..."
    sed -i "s/^ZSH_THEME=.*/ZSH_THEME=\"powerlevel10k\/powerlevel10k\"/" "$ZSHRC"
fi

if ! grep -q "plugins=(.*zsh-autosuggestions.*zsh-syntax-highlighting.*)" "$ZSHRC"; then
    sed -i "/^plugins=/c\plugins=(git zsh-autosuggestions zsh-syntax-highlighting)" "$ZSHRC"
fi

echo "Installation and setup completed! Restart your terminal or run 'zsh' to use Zsh."
