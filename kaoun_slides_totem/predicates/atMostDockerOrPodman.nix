{ inputs, activateDebug ? false }:
with inputs;
let 
  hasPath = pkgslib.attrsets.hasAttrByPath;
  dockerPath = [ "virtualisation" "docker" ];
  podmanPath = [ "virtualisation" "podman" ];
in rec {
  predName = "atMostDockerOrPodman";
  function = modulesAttrs: (hasPath dockerPath modulesAttrs) && (hasPath podmanPath modulesAttrs);
  handler = { target, type }:
    if !(function target) then 
      target
    else
      throw ((tclib.stdTcError { inherit type predName; }) + "; add either virtualisation.docker or virtualisation.podman but not both");
}
