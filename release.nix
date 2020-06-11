let
  pkgsNix = import ./nix/pkgs.nix;
  pkgsNative = pkgsNix.native;
  pkgsRaspberryPi = pkgsNix.crossRpi;
  pkgsArmv7l = pkgsNix.crossArmv7l;

  hsApp = import ./default.nix;
  appNative = hsApp { pkgs = pkgsNative; };
  appCrossRaspberryPi = hsApp { pkgs = pkgsRaspberryPi; };
  appCrossArmv7l = hsApp { pkgs = pkgsArmv7l; };

  patchForNotNixLinux = {app, name}:
    pkgsNative.runCommand "${app.name}-patched" { } ''
      set -eu
      cp ${app}/bin/${name} $out
      chmod +w $out
      ${pkgsNative.patchelf}/bin/patchelf --set-interpreter /lib/ld-linux-armhf.so.3 --set-rpath /lib:/usr/lib $out
      chmod -w $out
    '';

in {
  native = appNative.cross-haskell-app.components.exes.cross-haskell-app-exe;

  raspberry-pi = appCrossRaspberryPi.cross-haskell-app.components.exes.cross-haskell-app-exe;
  raspberry-pi-patched = patchForNotNixLinux { app = appCrossRaspberryPi.cross-haskell-app.components.exes.cross-haskell-app-exe; name ="cross-haskell-app-exe"; };

  armv7l = appCrossArmv7l.cross-haskell-app.components.exes.cross-haskell-app-exe;
  armv7l-patched = patchForNotNixLinux { app = appCrossArmv7l.cross-haskell-app.components.exes.cross-haskell-app-exe; name ="cross-haskell-app-exe"; };
}
