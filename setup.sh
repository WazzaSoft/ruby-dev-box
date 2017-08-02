#!/bin/bash

echo -e "\e[0;32mInstalling required packages...\e[0m"

sudo apt-get update

sudo apt-get install -y autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev git vim

git config --global core.editor vim

echo -e "\e[0;32mInstalling rbenv...\e[0m"

git clone https://github.com/rbenv/rbenv.git ~/.rbenv
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

sudo chown -R vagrant:vagrant ~/

echo "gem: --no-document" > ~/.gemrc
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

source ~/.bashrc

echo -e "\e[0;32mInstalling ruby. This will take a while...\e[0m"

rbenv install 2.4.1
rbenv global 2.4.1

rbenv rehash

echo -e "\e[0;32mInstalling rails...\e[0m"

gem install bundler
gem install rails

rbenv rehash

echo -e "\e[0;32mInstalling nvm...\e[0m"

curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash


sudo chown -R vagrant:vagrant ~/.nvm

source ~/.bashrc

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

echo -e "\e[0;32mInstalling node...\e[0m"

nvm install node

echo -e "\e[0;32mInstalling yarn...\e[0m"

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install -y yarn

echo -e "\e[0;32mInstalling postgres...\e[0m"

sudo apt-get install -y postgresql
echo "postgres:postgres" | sudo chpasswd
sudo su postgres -c "createuser vagrant -s"
sudo su postgres -c "createdb vagrant --owner vagrant"
sudo service postgresql reload

echo -e "\e[0;32mInstalling bash prompt script...\e[0m"

sudo echo '#!/home/vagrant/.rbenv/shims/ruby
ls = `ls --color=always`;
width = `tput cols`.to_i - 5;
total_length = 0;
str = "";
ls = ls.split("\n");
items = [];
ls.each do |item|
 len = item.gsub(/\e.*?m/, "").length;
 if len + total_length <= width
   items << item;
   width -= 1;
   total_length += len;
 end
end
print items.join(" ")' > /usr/bin/lsline
sudo chmod +x /usr/bin/lsline


read -r -d '' BASH_PROMPT <<'EOM'
#/bin/bash
PROMPT_COMMAND=__prompt_command
function __prompt_command() {
local exit_status="$?"
# Set up formatting codes
# Formatting
local bold="\e[1m"
local dim="\e[2m"
local underline="\e[4m"
local blink="\e[5m"
local reverse="\e[7m"
local hidden="\e[8m"
# Foreground Colors
local f_default="\e[39m"
local f_black="\e[30m"
local f_red="\e[31m"
local f_green="\e[32m"
local f_yellow="\e[33m"
local f_blue="\e[34m"
local f_magenta="\e[35m"
local f_cyan="\e[36m"
local f_light_gray="\e[37m"
local f_dark_gray="\e[90m"
local f_light_red="\e[91m"
local f_light_green="\e[92m"
local f_light_yellow="\e[93m"
local f_light_blue="\e[94m"
local f_light_magenta="\e[95m"
local f_light_cyan="\e[96m"
local f_white="\e[97m"
# Background Colors
local b_default="\e[49m"
local b_black="\e[40m"
local b_red="\e[41m"
local b_green="\e[42m"
local b_yellow="\e[43m"
local b_blue="\e[44m"
local b_magenta="\e[45m"
local b_cyan="\e[46m"
local b_light_gray="\e[47m"
local b_dark_gray="\e[100m"
local b_light_red="\e[101m"
local b_light_green="\e[102m"
local b_light_yellow="\e[103m"
local b_light_blue="\e[104m"
local b_light_magenta="\e[105m"
local b_light_cyan="\e[106m"
local b_white="\e[107m"
# Resets
local r_all="\e[0m"
local r_bold="\e[21m"
local r_dim="\e[22m"
local r_underline="\e[24m"
local r_blink="\e[25m"
local r_reverse="\e[27m"
local r_hidden="\e[28m"
local r_foreground="$f_default"
local r_background="$b_default"




# For quick configuration
local USER_COLOR="${f_blue}"
local ROOT_USER_COLOR="${bold}${f_red}"
local USER_HOST_COLOR="${f_white}"
local ROOT_HOST_COLOR="${bold}${f_red}"
local USER_DIR_COLOR="${f_yellow}"
local ROOT_DIR_COLOR="${bold}${f_red}"
local USER_PROMPT="$ "
local ROOT_PROMPT="# "





# In case I want to change these variables later.
local USER="\u"
local HOST="\h"
local DIR=$(pwd)
local DIR="$DIR"
local LSLINE=$(lsline)
if [ "$exit_status" -ne 0 ]; then
    local ARROW="${bold}${f_red}-->${r_all}"
else
    local ARROW="${bold}${f_green}-->${r_all}"
fi
# Conditional items based on root or not.
if [ "$EUID" -ne 0 ]; then
    USER="${USER_COLOR}${USER}${r_all}"
    HOST="${USER_HOST_COLOR}${HOST}${r_all}"
    DIR="${USER_DIR_COLOR}${DIR}${r_all}"
    PROMPT="${USER_PROMPT}"
else
    USER="${ROOT_USER_COLOR}${USER}${r_all}"
    HOST="${ROOT_HOST_COLOR}${HOST}${r_all}"
    DIR="${ROOT_DIR_COLOR}${DIR}${r_all}"
    PROMPT="${ROOT_PROMPT}"
fi
PS1="\n${USER}@${HOST} [${DIR}]\n ${ARROW} ${LSLINE}\n${PROMPT}"
}
EOM
echo "$BASH_PROMPT" > ~/.ps1
sudo echo "$BASH_PROMPT" > /etc/skel/.ps1

echo '. ~/.ps1' >> ~/.bashrc
echo '. ~/.ps1' >> /etc/skel/.bashrc

sudo chown -R vagrant:vagrant ~/

source ~/.bashrc



echo -e "\e[0;32mInstallation finished!\e[0m"
echo ""
echo "Start a new terminal session for changes to take place."
