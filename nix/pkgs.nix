let
  haskellNix = import (builtins.fetchTarball https://github.com/input-output-hk/haskell.nix/archive/master.tar.gz) {};

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