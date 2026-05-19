git clone https://github.com/fsquillace/junest.git ~/.local/share/junest
export PATH=~/.local/share/junest/bin:$PATH
export PATH="$PATH:~/.junest/usr/bin_wrappers"

junest setup
junest

sudo sed -i 's/#MAKEFLAGS.*/MAKEFLAGS="-j$(nproc)"/g' /etc/makepkg.conf
sudo pacman -Syu base-devel

# Continue with the Arch Linux method
