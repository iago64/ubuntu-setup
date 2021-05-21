# Update
sudo apt update

# Xmonad
echo "Installando xmonad y extras"
sudo apt install xmonad libghc-xmonad-contrib-dev dmenu xterm

# Xmobar
echo "Installando xmobar --> Barra superior con stats"
sudo apt install xmobar
mkdir ~/.config/xmobar
cp /usr/share/doc/xmobar/examples/xmobar.config ~/.config/xmobar/xmobarrc
curl https://archives.haskell.org/code.haskell.org/xmonad/man/xmonad.hs > ~/.xmonad/xmonad.hs
