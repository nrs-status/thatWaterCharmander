{ lclInputs, pkgs, ... }: {
  shared.users.users.sieyes = {
    packages = (with pkgs; [ nickel firefox kitty wofi btop mods ])
      ++ (with lclInputs.frontArmToPlanePackages;
        [ montezuma_circles_scroll.nixvim.base ]);
  };
}
