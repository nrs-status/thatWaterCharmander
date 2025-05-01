{ lclInputs, pkgs, ... }:
{ 
    shared.users.users.sieyes = {
      packages = with pkgs; [ 
        firefox
	kitty
	wofi
      ];
    };
}
