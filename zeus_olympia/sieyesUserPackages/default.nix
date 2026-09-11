{ lclInputs, pkgs, ... }: {
  shared.users.users.sieyes = {
    packages = (with pkgs; [
      okular #ebook/pdf/djvu/etc. reader
      unzip
      unrar
      bottles #games
      google-chrome
      firefox
      kitty
      wofi #launcher/menu
      btop
      mods
      qimgv #img viewer
      vlc
    ]) ++ (with lclInputs.frontArmToPlanePackages; [
      montezuma_circles_scroll.nixvim.base
      alaric_kicksdown_messi
    ]);
  };
}
