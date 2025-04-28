{
  inputs.frontArmToPlane.url = github:nrs-status/frontArmToPlane;
  outputs = inputs: let total = rec {
    nixpkgs = inputs.frontArmToPlane.inputs.nixpkgs;
    pkgs = inputs.frontArmToPlane.pkgs;
    pkgslib = inputs.frontArmToPlane.pkgslib;
    baselib = inputs.frontArmToPlane.baselib;
    tclib = inputs.frontArmToPlane.tclib;
    types = inputs.frontArmToPlane.baselib.mkTypesAttrs {
      typesdir = ./kaoun_slides_totem;
      importsToPass = {
        inputs = { inherit pkgslib baselib tclib; };
      };
    };
    lcllib = import ./h_run_overcar { inherit pkgslib baselib; };
    modulesAttrs = baselib.importPairAttrsOfDir {
      filePath = ./zeus_olympia;
      inputForImportPairs = {
        inputs = { inherit pkgslib tclib baselib pkgs; };
      };
    };
    selectedModules = lcllib.mkSelectedModules {
      inherit modulesAttrs;
      moduleNameList = import ./emp_triage_can/wranHearst.nix;
    };
    totalModule = lcllib.constructNixos { inherit selectedModules; };
    modules = tclib.typecheck {
      target = totalModule;
      type = types.NixosDecl;
      activateDebug = false;
    };
    nixosSystemInput = { modules = lcllib.modulesAttrsToNixosSystemInput { typecheckNixosDecl = modules; }; };
    final = { nixosConfigurations.wranHearst = nixpkgs.lib.nixosSystem nixosSystemInput; };
  };
  in total.baselib.wrapDebug {
    inherit total;
    activateDebug = true;
  };
}
