#!/bin/bash

#apt update -y
#apt upgrade -y

#install dependencies

pkg install -y bash bzip2 coreutils curl  findutils gzip ncurses-utils proot tar xz-utils

#download git and install proot-distro

#pkg install -y proot-distro
git clone https://github.com/termux/proot-distro
cd proot-distro
rm install.sh
echo "#!/usr/bin/env bash
set -e
: "${TERMUX_APP_PACKAGE:="io.neoterm"}"
: "${TERMUX_PREFIX:="/data/data/${TERMUX_APP_PACKAGE}/files/usr"}"
: "${TERMUX_ANDROID_HOME:="/data/data/${TERMUX_APP_PACKAGE}/files/home"}"

echo "Installing $TERMUX_PREFIX/bin/proot-distro"
install -d -m 700 "$TERMUX_PREFIX"/bin
sed -e "s|@TERMUX_APP_PACKAGE@|$TERMUX_APP_PACKAGE|g" \
	-e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" \
	-e "s|@TERMUX_HOME@|$TERMUX_ANDROID_HOME|g" \
	./proot-distro.sh > "$TERMUX_PREFIX"/bin/proot-distro
chmod 700 "$TERMUX_PREFIX"/bin/proot-distro

echo "Symlinking $TERMUX_PREFIX/bin/proot-distro --> $TERMUX_PREFIX/bin/pd"
ln -sfr "$TERMUX_PREFIX"/bin/proot-distro "$TERMUX_PREFIX"/bin/pd

install -d -m 700 "$TERMUX_PREFIX"/etc/proot-distro
for script in ./distro-plugins/*.sh*; do
	echo "Installing $TERMUX_PREFIX/etc/proot-distro/$(basename "$script")"
	install -Dm600 -t "$TERMUX_PREFIX"/etc/proot-distro/ "$script"
done

echo "Installing $TERMUX_PREFIX/share/bash-completion/completions/proot-distro"
install -d -m 700 "$TERMUX_PREFIX"/share/bash-completion/completions
sed -e "s|@TERMUX_APP_PACKAGE@|$TERMUX_APP_PACKAGE|g" \
	-e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" \
	-e "s|@TERMUX_HOME@|$TERMUX_ANDROID_HOME|g" \
	./completions/proot-distro.bash > "$TERMUX_PREFIX"/share/bash-completion/completions/proot-distro

echo "Symlinking $TERMUX_PREFIX/share/bash-completion/completions/proot-distro --> $TERMUX_PREFIX/share/bash-completion/completions/pd"
ln -sfr "$TERMUX_PREFIX"/share/bash-completion/completions/proot-distro "$TERMUX_PREFIX"/share/bash-completion/completions/pd

echo "Installing $TERMUX_PREFIX/share/doc/proot-distro/README.md"
install -Dm600 README.md "$TERMUX_PREFIX"/share/doc/proot-distro/README.md" >> install.sh

chmod +x install.sh
./install.sh
clear

#download alpine-ergo.sh setup plugin for proot-distro

cd ..
cd usr
cd etc
cd proot-distro
curl -s https://raw.githubusercontent.com/rustinmyeye/ErgoNodeAndroid/master/alpine-ergo.sh >> alpine-ergo.sh
clear

#install alpine linux with alpine plugin with proot-distro

proot-distro install alpine
clear

#run alpine linux and start node setup

proot-distro login alpine --  bash <(curl -s https://raw.githubusercontent.com/rustinmyeye/ErgoNodeAndroid/master/alpine-ergo-node.sh)
clear
proot-distro login alpine 


