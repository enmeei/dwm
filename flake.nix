{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {

      imports = [
        inputs.flake-parts.flakeModules.easyOverlay
      ];
      systems = [
        "x86_64-linux"
      ];

      perSystem = { config, self', inputs', pkgs, system, ... }:
        let
          dwmDrv = pkgs.dwm.overrideAttrs (oldAttrs: {
            src = ./.;
          });
        in
        rec
        {
          overlayAttrs = {
            inherit (config.packages) dwm;
          };

          packages = {
            dwm = dwmDrv;
          };
          packages.default = packages.dwm;

        };

    };
}

