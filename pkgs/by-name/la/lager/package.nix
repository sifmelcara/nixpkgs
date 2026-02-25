{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  boost,
  immer,
  zug,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lager";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "arximboldi";
    repo = "lager";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ssGBQu8ba798MSTtJeCBE3WQ7AFfvSGLhZ7WBYHEgfw=";
  };

  patches = [
    # Required because boost 1.89 removed Boost::system
    (fetchpatch {
      name = "stop-using-boost-system";
      url = "https://github.com/arximboldi/lager/commit/038749dfcb2ad075e852070f88022b53a9792ab1.patch";
      hash = "sha256-peGpuyuCznCDqYo+9zk1FytLV+a6Um8fvjLmrm7Y2CI=";
    })
  ];

  buildInputs = [
    boost
    immer
    zug
  ];

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-Dlager_BUILD_EXAMPLES=OFF"
    "-Dlager_BUILD_TESTS=OFF"
  ];

  preConfigure = ''
    rm BUILD
  '';

  meta = {
    homepage = "https://github.com/arximboldi/lager";
    description = "C++ library for value-oriented design using the unidirectional data-flow architecture — Redux for C++";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sifmelcara ];
  };
})
