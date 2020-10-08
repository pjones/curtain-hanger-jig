{ sources ? import ./nix/sources.nix
, pkgs ? import sources.nixpkgs { }
, nix-openscad ? import sources.nix-openscad { inherit pkgs; }
}:
nix-openscad {
  src = ./.;
  name = "curtain-hanger-jig";

  scadFiles = [
    "examples/oval.scad"
  ];
}
