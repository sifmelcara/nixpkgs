{ lib
, kdePackages
, symlinkJoin
, callPackage
, unwrapped ? kdePackages.callPackage ./. { }
, krita-plugin-gmic
, binaryPlugins ? [
    # Default plugins provided by upstream appimage
    krita-plugin-gmic
  ]
,
}:

unwrapped
