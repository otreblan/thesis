proot-distro install archlinux
proot-distro login archlinux

pacman -Syu base-devel sudo

useradd -m build
visudo # Make the new user a sudoer

su build
cd ~

git clone https://aur.archlinux.org/paru.git 
cd paru
makepkg -si --ignorearch

cd ~

git clone https://github.com/fdtd-lucuma/fdtd-lucuma
cd fdtd-lucuma

paru -Bi --mflags=--ignorearch pkg/arch/

fdtd-lucuma
