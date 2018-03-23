{
  nixos ? import <nixpkgs/nixos> { configuration = {}; }
}:

with nixos.pkgs;

buildEnv {
  name = "env";
  paths = [
    bash
    coreutils
    nix
    nixos.config.system.build.nixos-generate-config
    nixos.config.system.build.nixos-install
    utillinux.bin
  ];
  pathsToLink = [ "/bin" ];
}
