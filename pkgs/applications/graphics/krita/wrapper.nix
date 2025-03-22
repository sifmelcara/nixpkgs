{
  lib,
  libsForQt5,
  symlinkJoin,
  unwrapped ? libsForQt5.callPackage ./. { },
  krita-plugin-gmic,
  binaryPlugins ? [
    # Default plugins provided by upstream appimage
    krita-plugin-gmic
  ],
}:

unwrapped
