{
  inputs.frontArmToPlane.url = github:nrs-status/frontArmToPlane;
  outputs = inputs: let
    nixpkgs = inputs.frontArmToPlane.inputs.nixpkgs;
    pkgslib = inputs.frontArmToPlane.pkgslib;
    baselib = inputs.frontArmToPlane.baselib;
    tclib = inputs.frontArmToPlane.tclib;
    types = inputs.frontArmToPlane.baselib.mkTypesAttrs {
      typesdir = ./kaoun_slides_totem;
      importsToPass = {
        inputs = { inherit pkgslib baselib; };
      };
    };
  in {
    nixosConfigurations.wranHearst = nixpkgs.lib.nixosSystem {
      modules = baselib.tc types.NixDecl (import ./zeus_olympia);
    };
  };
}
