{ lclInputs, pkgs, ... }:
{ 
    shared.users.users.sieyes = {
      packages = with pkgs; [ 
        firefox
        pciutils #for debugging drivers
      ];
    };
}
