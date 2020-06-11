let
  haskellNix = import (builtins.fetchTarball https://github.com/input-output-hk/haskell.nix/archive/21a6d6090a64ef5956c9625bcf00a15045d65042.tar.gz) {};

  nixpkgsSrc = haskellNix.sources.nixpkgs-2003;
  nixpkgsArgs = haskellNix.nixpkgsArgs;

  native = import nixpkgsSrc nixpkgsArgs;
  crossRpi = import nixpkgsSrc (nixpkgsArgs // {
    crossSystem = native.lib.systems.examples.raspberryPi;
  });
  crossArmv7l = import nixpkgsSrc (nixpkgsArgs // {
    crossSystem = native.lib.systems.examples.raspberryPi;
  });
in {
  inherit haskellNix;
  
  inherit nixpkgsSrc nixpkgsArgs;

  inherit native crossRpi crossArmv7l;
}