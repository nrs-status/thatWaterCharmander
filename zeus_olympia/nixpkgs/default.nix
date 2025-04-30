{ ... }:
{ nixpkgs = {
  nixpkgs = {
    hostPlatform = "x86_64-linux";
    config = {
      allowUnfree = true;
    };
  };
};
}
