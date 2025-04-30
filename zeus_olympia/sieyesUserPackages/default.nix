{ lclInputs, pkgs, ... }:
{ 
    shared.users.users.sieyes = {
      packages = with pkgs; [ 
        google-chrome
      ];
    };
}
