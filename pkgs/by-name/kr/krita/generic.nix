{
  lib,
  fetchFromGitHub,
  wrapQtAppsHook,
  stdenv,
  kdePackages,
  fetchpatch,
  fetchurl,
  cmake,
  extra-cmake-modules,
  karchive,
  kconfig,
  kwidgetsaddons,
  kcompletion,
  kcoreaddons,
  kguiaddons,
  ki18n,
  kitemmodels,
  kitemviews,
  kwindowsystem,
  kio,
  kcrash,
  breeze-icons,
  boost,
  libraw,
  fftw,
  eigen,
  exiv2,
  fribidi,
  libaom,
  libheif,
  #libkdcraw,
  lcms2,
  gsl,
  openexr,
  giflib,
  libjxl,
  mlt,
  openjpeg,
  opencolorio,
  xsimd,
  poppler,
  curl,
  ilmbase,
  immer,
  kseexpr,
  lager,
  libmypaint,
  libunibreak,
  libwebp,
  qtmultimedia,
  quazip,
  SDL2,
  zug,
  pkg-config,
  python3Packages,
}:

kdePackages.mkKdeDerivation rec {
  pname = "krita-unwrapped";
  # master at 2025-07-29
  version = "c676b322363e758b2d49a4913e674f7d40853883";

  src = fetchFromGitHub {
    owner = "KDE";
    repo = "krita";
    rev = version;
    hash = "sha256-H48zgMqWyeEQC69jAQ+u2N3yFUu7lUStcADaCIR9vdE=";
  };

  patches = [ ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    python3Packages.sip
    wrapQtAppsHook
  ];

  buildInputs = [
    karchive
    kconfig
    kwidgetsaddons
    kcompletion
    kcoreaddons
    kguiaddons
    ki18n
    kitemmodels
    kitemviews
    kwindowsystem
    kio
    kcrash
    breeze-icons
    boost
    libraw
    fftw
    eigen
    exiv2
    fribidi
    lcms2
    gsl
    openexr
    lager
    libaom
    libheif
    #libkdcraw
    giflib
    libjxl
    mlt
    openjpeg
    opencolorio
    xsimd
    poppler
    curl
    ilmbase
    immer
    kseexpr
    libmypaint
    libunibreak
    libwebp
    qtmultimedia
    quazip
    SDL2
    zug
    python3Packages.pyqt6
  ];

  env.NIX_CFLAGS_COMPILE = toString (lib.optional stdenv.cc.isGNU "-Wno-deprecated-copy");

  # Krita runs custom python scripts in CMake with custom PYTHONPATH which krita determined in their CMake script.
  # Patch the PYTHONPATH so python scripts can import sip successfully.
  postPatch =
    let
      pythonPath = python3Packages.makePythonPath (
        with python3Packages;
        [
          sip
          setuptools
        ]
      );
    in
    ''
      # Not taking effect on master branch due to [Fix detection of SIP on macOS · KDE/krita@413dc4e](https://github.com/KDE/krita/commit/413dc4e92226bd90229b0847cf977fbe62ea5c39)
      # Not sure if still needed
      # substituteInPlace cmake/modules/FindSIP.cmake \
      #   --replace 'PYTHONPATH=''${_sip_python_path}' 'PYTHONPATH=${pythonPath}'


      substituteInPlace cmake/modules/SIPMacros.cmake \
        --replace 'PYTHONPATH=''${_krita_python_path}' 'PYTHONPATH=${pythonPath}'

      substituteInPlace plugins/impex/jp2/jp2_converter.cc \
        --replace '<openjpeg.h>' '<${openjpeg.incDir}/openjpeg.h>'
    '';

  cmakeBuildType = "RelWithDebInfo";

  cmakeFlags = [
    # "-DPYQT5_SIP_DIR=${python3Packages.pyqt5}/${python3Packages.python.sitePackages}/PyQt5/bindings"

    # Not sure if still needed, cmake say it's not used in master branch
    # "-DPYQT_SIP_DIR_OVERRIDE=${python3Packages.pyqt5}/${python3Packages.python.sitePackages}/PyQt5/bindings"

    # qt designer still requires qt5
    # "-DBUILD_KRITA_QT_DESIGNER_PLUGINS=ON"

    "-DBUILD_WITH_QT6=ON"
  ];

  meta = {
    description = "Free and open source painting application";
    homepage = "https://krita.org/";
    maintainers = with lib.maintainers; [
      sifmelcara
      nek0
    ];
    mainProgram = "krita";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Only;
  };
}
