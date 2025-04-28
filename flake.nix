{
  inputs.frontArmToPlane.url = github:nrs-status/frontArmToPlane;
  outputs = inputs: let total = rec {
    nixpkgs = inputs.frontArmToPlane.inputs.nixpkgs;
    pkgslib = inputs.frontArmToPlane.pkgslib;
    baselib = inputs.frontArmToPlane.baselib;
    tclib = inputs.frontArmToPlane.tclib;
    types = inputs.frontArmToPlane.baselib.mkTypesAttrs {
      typesdir = ./kaoun_slides_totem;
      importsToPass = {
        inputs = { inherit pkgslib baselib tclib; };
      };
    };
    lcllib = baselib.importPairAttrsOfDir {
      filePath = ./h_run_overcar;
      inputForImportPairs = {
        inputs = {
          inherit baselib pkgslib tclib;
        };
      };
    };
    modulesAttrs = baselib.importPairAttrsOfDir {
      filePath = ./zeus_olympia;
      inputForImportPairs = {
        inputs = { lib = pkgslib; inherit tclib baselib; };
      };
    };
    selectedModules = lcllib.mkSelectedModules {
      inherit modulesAttrs;
      inputs = {
        inherit baselib tclib pkgslib nixpkgs;
      };
      moduleNameList = import ./emp_triage_can/wranHearst.nix;
    };
    modules = tclib.tc types.NixosDecl (lcllib.constructNixos { inherit selectedModules; });
    final = nixpkgs.lib.nixosSystem { inherit modules; }; };
  in total.baselib.wrapDebug {
    inherit total;
    activateDebug = true;
  };
}
