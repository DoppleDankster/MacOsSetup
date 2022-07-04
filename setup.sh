#!/usr/bin/env zsh

alias python=$(which python3)

# nice colors :)))
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
LIME_YELLOW=$(tput setaf 190)
POWDER_BLUE=$(tput setaf 153)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BRIGHT=$(tput bold)
NORMAL=$(tput sgr0)
BLINK=$(tput blink)
REVERSE=$(tput smso)
UNDERLINE=$(tput smul)

colored_write () {
    printf "${1} ${2}${NORMAL}\n"
 }

ask_question () {
    while true; do
        read yn
        case $yn in
            [Yy]* ) return 1;;
            [Nn]* ) return 0;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}




colored_write "$BLUE" "Welcome to the MAC OS Setup Installer."
echo ""
colored_write "$BLUE" "This little script will setup the following:"
colored_write "$BLUE" "- Oh my zsh: a framework for ZSH with syntax highlighting, completion and plugins"
colored_write "$BLUE" "- FZF: a regex engine used to parse through terminal history and files"
colored_write "$BLUE" "- Pyenv & Poetry: Python version and dependendy management"
colored_write "$BLUE" "- NPM: The Javascript package manager"
colored_write "$BLUE" "- GIT: the user/email and an alias"
colored_write "$BLUE" "- SSH: a key for gitlab and an SSH config (key needs to be added manually)"

# This func checks if brew is installed or not
install_brew () {
    colored_write "$GREEN" "Do you want to install Brew ? (Y)es or (N)o"
    ask_question
    if [ $? = 0 ];
    then
        colored_write "$RED" "Skipping Brew install..."
        echo ""
        return 0
    fi

	if hash brew 2>/dev/null;
	then
        	colored_write "$RED" "Brew is already installed...skipping"
	else
    	colored_write "$GREEN" "Installing Brew..."
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	fi
}



# This func will install FZF if necessary
configure_fzf () {

    colored_write "$GREEN" "Do you want to install FZF? (Y)es or (N)o"
    ask_question
    if [ $? = 0 ];
    then
        colored_write "$RED" "Skipping FZF install..."
        echo ""
        return 0
    fi
    if [ hash fzf 2>/dev/null ];
    then
        colored_write "$RED" "FZF is already installed...skipping"
    else
        git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
        "$HOME/.fzf/install"
    fi
}

# This func will setup oh my zsh and the syntax highlighting plugin
configure_ohmyzsh () {

    colored_write "$GREEN" "Do you want to install Oh My Zsh? (Y)es or (N)o"
    ask_question
    if [ $? = 0 ];
    then
        colored_write "$RED" "Skipping Oh My Zsh install..."
        echo ""
        return 0
    fi
    if [ -d "$HOME/.oh-my-zsh" ];
    then
        colored_write "$RED" "OhMyZsh is already installed...skipping"
    else
        colored_write "$GREEN" "Installing OhMyZsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    colored_write "$GREEN" "Installing the ZSH syntax highlighting plugin..."
    if [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ];
    then
        colored_write "$RED" "ZSH Syntax Highlighting plugin already installed...skipping"
    else
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    fi
}


# This func will setup pyenv
configure_pyenv () {
    colored_write "$GREEN" "Do you want to install Pyenv? (Y)es or (N)o"
    ask_question
    if [ $? = 0 ];
    then
        colored_write "$RED" "Skipping Oh My Pyenv install..."
        echo ""
        return 0
    fi

    if hash pyenv 2>/dev/null;
    then
        colored_write "$RED" "Pyenv is already installed...skipping"
    else
        colored_write "$GREEN" "Installing pyenv..."
        git clone https://github.com/pyenv/pyenv.git ~/.pyenv
        cd ~/.pyenv && src/configure && make -C src
        brew install openssl readline sqlite3 xz zlib tcl-tk
        $HOME/.pyenv/bin/pyenv install 3.9.9
        pyenv global 3.9.9
    fi

}


# This func will setup poetry
configure_poetry () {
    colored_write "$GREEN" "Do you want to install Poetry? (Y)es or (N)o"
    ask_question
    if [ $? = 0 ];
    then
        colored_write "$RED" "Skipping Poetry install..."
        echo ""
        return 0
    fi

    if hash poetry 2>/dev/null;
    then
        colored_write "$RED" "Poetry is already installed...skipping"
    else
        colored_write "$GREEN" "Installing poetry..."
        curl -sSL https://install.python-poetry.org | python -
    fi
    poetry config virtualenvs.in-project true
}

# This func will setup NPM
configure_npm () {

    colored_write "$GREEN" "Do you want to install NPM? (Y)es or (N)o"
    ask_question
    if [ $? = 0 ];
    then
        colored_write "$RED" "Skipping NPM install..."
        echo ""
        return 0
    fi
    if hash npm 2>/dev/null;
    then
        colored_write "$RED" "NPM is already installed...skipping"
    else
        colored_write "$GREEN" "Installing npm..."
        brew update
        brew install node
        mkdir -p "$HOME/.local/npm-packages"
        npm config set prefix "$HOME/.local/npm-packages"
    fi

}

configure_git () {

    colored_write "$GREEN" "Adding 'git glog' as a git alias to pretty print git trees"
    git config --global alias.glog "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
}

configure_ssh () {
    colored_write "$GREEN" "Do you need to create a gitlab ssh key? (Y)es or (N)o"
    ask_question
    if [ $? = 0 ];
    then
        colored_write "$RED" "Skipping SSH Key creation install..."
        echo ""
        return 0
    fi
    if [ -f "$HOME/.ssh/gitlab" ];
    then
        colored_write "$RED" "gitlab ssh key already found in .ssh folder... skipping"
    else
        ssh-keygen -b 4096 -t rsa -C "gitlab-key" -N '' -f ~/.ssh/gitlab <<< y >/dev/null 2>&1
    fi

    if [ -f "$HOME/.ssh/config" ];
    then
        colored_write "$RED" "Looks like the ssh config file is alredy here... skipping"
    else
        echo "AddKeysToAgent yes\n\n" > "~/.ssh/config"
        echo "Host gitlab.com\n    IdentityFile ~/.ssh/gitlab\n    IdentitesOnly yes" >> "$HOME/.ssh/config"
    fi
}

install_brew 
configure_fzf
configure_pyenv
configure_ohmyzsh
cp ./zshrc "$HOME/.zshrc"
cp ./profile "$HOME/.profile"
. "$HOME/.zshrc"
. "$HOME/.profile"
configure_poetry
configure_npm
configure_git
configure_ssh
. "$HOME/.zshrc"

colored_write "$BLUE" "Everything should be working fine ! Good bye."
