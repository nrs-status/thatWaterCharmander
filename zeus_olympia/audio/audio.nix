{ inputs }:
{
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  shared.environment.systemPackages = with inputs.pkgs; [
    pavucontrol
    pulseaudio
  ];
}
