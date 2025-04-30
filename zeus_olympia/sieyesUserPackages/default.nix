{ lclInputs, pkgs, ... }:
{ 
  sieyesUserPackages = {
    shared.users.users.sieyes = {
      packages = with pkgs; [ 
        google-chrome
      ];
    };
};
}
