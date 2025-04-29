{ lclInputs, system, ... }:
{
  shared.environment.systemPackages = with lclInputs.pkgs; [
    bluez
    blueman
  ];
}
