{ lclInputs, system, ... }:
with lclInputs;
{ 
    networking = {
      networkmanager.enable = true;
      hostName = pkgslib.mkDefault "lanchamarcou";
      useDHCP = pkgslib.mkDefault true;
    };
    shared.services.openssh.enable = true;
}
