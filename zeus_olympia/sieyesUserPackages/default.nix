{ lclInputs, pkgs, ... }: {
  shared.users.users.sieyes = {
    packages = (with pkgs; [
      okular
      qpdf
      unzip
      bottles
      google-chrome
      firefox
      kitty
      wofi
      btop
      mods
      qimgv # img viewer
    ]) ++ (with lclInputs.frontArmToPlanePackages; [
      montezuma_circles_scroll.nixvim.base
      alaric_kicksdown_messi
    ]);
  };
}
