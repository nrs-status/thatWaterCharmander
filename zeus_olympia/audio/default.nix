{ lclInputs, system }:
{
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  shared = {
    pulseaudio.enable = false;
    environment.systemPackages = with lclInputs.pkgs; [
      pavucontrol
      pulseaudio
    ];
  };
}
