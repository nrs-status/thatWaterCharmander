{ lclInputs, pkgs, ... }: {
  shared.users.users.sieyes = {
    packages = (with pkgs; [ okular pdftk unzip bottles google-chrome nls firefox kitty wofi btop mods ])
      ++ (with lclInputs.frontArmToPlanePackages;
        [ montezuma_circles_scroll.nixvim.base ]);
  };
}
