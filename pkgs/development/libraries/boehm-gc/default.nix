{ lib, stdenv, fetchurl, enableLargeConfig ? false }:

stdenv.mkDerivation rec {
  name = "boehm-gc-7.6.0";

  src = fetchurl {
    url = "http://www.hboehm.info/gc/gc_source/gc-7.6.0.tar.gz";
    sha256 = "a14a28b1129be90e55cd6f71127ffc5594e1091d5d54131528c24cd0c03b7d90";
  };

  outputs = [ "out" "dev" "doc" ];

  configureFlags =
    [ "--enable-cplusplus" ]
    ++ lib.optional enableLargeConfig "--enable-large-config";

  doCheck = true;

  libatomic_src = fetchurl {
    url = "http://www.hboehm.info/gc/gc_source/libatomic_ops-7.4.4.tar.gz";
    sha256 = "bf210a600dd1becbf7936dd2914cf5f5d3356046904848dcfd27d0c8b12b6f8f";
  };

  postUnpack =
    ''
      cd gc-7.6.0
      tar zxvf ${libatomic_src}
      ln -s libatomic_ops-7.4.4 libatomic_ops
      cd ..
    '';

  # Don't run the native `strip' when cross-compiling.
  dontStrip = stdenv ? cross;

  postInstall =
    ''
      mkdir -p $out/share/doc
      mv $out/share/gc $out/share/doc/gc
    '';

  meta = {
    description = "The Boehm-Demers-Weiser conservative garbage collector for C and C++";

    longDescription = ''
      The Boehm-Demers-Weiser conservative garbage collector can be used as a
      garbage collecting replacement for C malloc or C++ new.  It allows you
      to allocate memory basically as you normally would, without explicitly
      deallocating memory that is no longer useful.  The collector
      automatically recycles memory when it determines that it can no longer
      be otherwise accessed.

      The collector is also used by a number of programming language
      implementations that either use C as intermediate code, want to
      facilitate easier interoperation with C libraries, or just prefer the
      simple collector interface.

      Alternatively, the garbage collector may be used as a leak detector for
      C or C++ programs, though that is not its primary goal.
    '';

    homepage = http://hboehm.info/gc/;

    # non-copyleft, X11-style license
    license = http://hboehm.info/gc/license.txt;

    maintainers = [ ];
    platforms = stdenv.lib.platforms.all;
  };
}
