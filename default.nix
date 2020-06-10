let 
  pkgsNix = import ./nix/pkgs.nix;
in
{ pkgs ? pkgsNix.native
}:
pkgs.haskell-nix.stackProject {
  src = pkgs.haskell-nix.haskellLib.cleanGit { src = ./.; };
}