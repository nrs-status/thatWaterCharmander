{ lclInputs, pkgs, ... }:
{ 
    shared.users.users.sieyes = {
      packages = with pkgs; [ 
        firefox
	bat
	ripgrep
        pciutils #for debugging drivers
      ];
    };
}
