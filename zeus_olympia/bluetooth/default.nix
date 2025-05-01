{ lclInputs, pkgs, system, ... }:
{
  shared.environment.systemPackages = with pkgs; [
    bluez
    blueman
  ];
}
