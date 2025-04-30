{ lclInputs, system, ... }:
with lclInputs;
{ 
  networking = {
    networking = {
      networkmanager.enable = true;
      hostName = pkgslib.mkDefault "wranHearst";
      useDHCP = pkgslib.mkDefault true;
    };
    services.openssh.enable = true;
};
}
