{ stdenv, lib, fetchurl, meson, ninja, pkg-config, zathura_core
, girara, gettext, libarchive }:

stdenv.mkDerivation rec {
  pname = "zathura-cb";
  version = "cdb306d2aaaab0825f3bcddef3863cd708fe6c95";

  src = fetchurl {
    url = "https://git.pwmt.org/pwmt/zathura-cb/-/archive/cdb306d2aaaab0825f3bcddef3863cd708fe6c95/zathura-cb-cdb306d2aaaab0825f3bcddef3863cd708fe6c95.tar";
    sha256 = "sha256-vcCsyIogTm/2IuxUAOzU3h1C8M0YuGiRDz+0r3tyfXw=";
  };

  nativeBuildInputs = [ meson ninja pkg-config gettext ];
  buildInputs = [ libarchive zathura_core girara ];

  PKG_CONFIG_ZATHURA_PLUGINDIR = "lib/zathura";

  meta = with lib; {
    homepage = "https://pwmt.org/projects/zathura-cb/";
    description = "A zathura CB plugin";
    longDescription = ''
      The zathura-cb plugin adds comic book support to zathura.
      '';
    license = licenses.zlib;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jlesquembre ];
  };
}
