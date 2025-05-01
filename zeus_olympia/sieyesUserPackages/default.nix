{ lclInputs, pkgs, ... }:
{ 
    shared.users.users.sieyes = {
      packages = (with pkgs; [ 
	firefox
	kitty
	wofi
	btop
	nix-direnv
	mods
      ]) ++ (with lclInputs.frontArmToPlanePackages; [
	montezuma_circles_scroll.nixvim.base 
      ]);
    };
}
