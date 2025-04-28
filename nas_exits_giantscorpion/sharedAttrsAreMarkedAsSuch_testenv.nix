rec {
  flakes = {
    frontArmToPlane = builtins.getFlake "github:nrs-status/frontArmToPlane";
  };
  pkgslib = flakes.frontArmToPlane.pkgslib;
  baselib = flakes.frontArmToPlane.baselib;
  tclib = flakes.frontArmToPlane.tclib;
  pkgs = flakes.frontArmToPlane.pkgs;
  lcllib = import ../h_run_overcar { inherit pkgslib baselib; };
  modulesAttrs = baselib.importPairAttrsOfDir {
    filePath = ../zeus_olympia;
    inputForImportPairs = {
      inputs = {
        inherit tclib baselib pkgs;
      };
    };
  };
  selectedModules = lcllib.mkSelectedModules {
    inherit modulesAttrs;
    moduleNameList = import ../emp_triage_can/wranHearst.nix;
  };
  totalModule = lcllib.constructNixos { inherit selectedModules; };
  sharedAttrsAreMarkedAsSuch = import ../kaoun_slides_totem/predicates/sharedAttrsAreMarkedAsSuch.nix {
    inputs = {
      inherit baselib pkgslib tclib; 
    };
    activateDebug = true;
  };
  theType = {
    typeName = "TestType";
  };
  result = sharedAttrsAreMarkedAsSuch.final.handler {
    target = totalModule;
    type = theType;
  };
}
