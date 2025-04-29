{ lclInputs, system }:
{
  networking = {
    hostName = lclInputs.pkgslib.mkDefault "wranHearst";
  };

  services.openssh.enable = true;
}
