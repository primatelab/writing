#!/usr/bin/env bash

SCRIPT_DIR=$(dirname $(realpath $0))
lightbrown="\033[1;38;5;94m"
darkbrown="\033[38;5;95m"

echo -e "$lightbrown    📚  running the Writing! init script 📚 $darkbrown"

al="alias writing=\". $SCRIPT_DIR/.writing/writingenv.sh $SCRIPT_DIR\""
if [[ $(grep -c "$al" ~/.bash_aliases) -eq 0 ]]; then
  echo $al >> ~/.bash_aliases
fi

if [[ $(grep -c "msk=1;38;5;95" ~/.bash_aliases) -eq 0 ]]; then
  echo 'export LS_COLORS="$LS_COLORS:*.msk=1;38;5;95"' >> ~/.bash_aliases
fi


########## Detect package manager #############

if type yum &>/dev/null; then
  pac='yum'
elif type apt &>/dev/null; then
  pac='apt'
else
  echo -e "$darkbrown You're Linuxing wrong."
  exit
fi


########## Install requirements #############

for i in git screen python3-pip pandoc; do
  type $i &>/dev/null || echo -e "$darkbrown Installing $i" && sudo $pac install -y $i
done

for i in pyqt5 lxml; do
  type $i &>/dev/null || echo -e "$darkbrown Installing $i" && pip install $i
done


########## Install manuskript ###############

function reresource() {
  rm -rf "$SCRIPT_DIR/.writing/manuskript/resources/$1"
  ln -s "$SCRIPT_DIR/.writing/$1" "$SCRIPT_DIR/.writing/manuskript/resources/$1"
}

cd $SCRIPT_DIR/.writing && git clone https://github.com/olivierkes/manuskript.git
if [[ $? -ne 0 ]]; then
  cd $SCRIPT_DIR/.writing/manuskript && git pull
fi

rm -rf "$SCRIPT_DIR/.writing/manuskript/sample-projects"
reresource themes
reresource backgrounds
reresource dictionaries
rm $SCRIPT_DIR/backgrounds
ln -s "$SCRIPT_DIR/.writing/backgrounds" "$SCRIPT_DIR/backgrounds"

#################  Install Prosegrinder pandoc templates ############

echo -e "$darkbrown Installing Pandoc Templates"
cd $SCRIPT_DIR/.writing && git clone https://github.com/prosegrinder/pandoc-templates.git
if [[ $? -ne 0 ]]; then
  cd $SCRIPT_DIR/.writing/pandoc-templates && git pull
fi

#################  Install LanguageTool ############

echo -e "$darkbrown Installing LanguageTool"
sudo snap install languagetool

echo -e "$darkbrown Installing LanguageTool Python"
sudo pip install language_tool_python

#################  Install viu ############

if [[ ! -e "$SCRIPT_DIR/.writing/viu" ]]; then
  curl -o "$SCRIPT_DIR/.writing/viu" "https://github.com/atanunq/viu/releases/download/v1.4.0/viu" && chmod +x "$SCRIPT_DIR/.writing/viu"
fi


cd $SCRIPT_DIR/.writing

##################### Add the password to the git config

rou=$(git config --get remote.origin.url | sed 's$https://$$g')
if [[ $(echo $rou | egrep -c [^:]*:[^@]*@ ) -eq 0 ]]; then
  echo -e '\n*******************************************************\n'
  echo -n 'Enter the git username: '
  read username
  echo -n "Enter the git password for $username: "
  stty -echo
  read password
  stty echo
  newurl="https://$username:$password@$rou"
  git config --replace-all remote.origin.url "$newurl"
  echo
fi

touch $SCRIPT_DIR/.writing/initted
