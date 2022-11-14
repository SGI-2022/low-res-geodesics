let
  pkgs = import <nixpkgs> {};
  mach-nix = import (builtins.fetchGit {
    url = "https://github.com/DavHau/mach-nix";
    ref = "master";
  }) {};
in
mach-nix.mkPythonShell {
  requirements = ''
    gpytoolbox
    numpy
    cvxpy
    polyscope
  '';
  providers = {
    cvxpy = "nixpkgs";
    polyscope = "wheel";    
  };
  _.polyscope.buildInputs.add = with pkgs; [ glfw-wayland ];
}
