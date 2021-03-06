{ stdenv, fetchurl, autoreconfHook, pkgconfig, zlib, libuuid, libossp_uuid, CoreFoundation, IOKit, lm_sensors }:

stdenv.mkDerivation rec{
  version = "1.15.0";
  name = "netdata-${version}";

  src = fetchurl {
    url = "https://github.com/netdata/netdata/releases/download/v${version}/netdata-v${version}.tar.gz";
    sha256 = "04frfy08k6m70y3s8j3gvnfnqqd9d5mwj3j6krk9dsh34332abvx";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ zlib ]
    ++ (if stdenv.isDarwin then [ libossp_uuid CoreFoundation IOKit ] else [ libuuid ]);

  patches = [
    ./no-files-in-etc-and-var.patch
  ];

  postInstall = stdenv.lib.optionalString (!stdenv.isDarwin) ''
    # rename this plugin so netdata will look for setuid wrapper
    mv $out/libexec/netdata/plugins.d/apps.plugin \
       $out/libexec/netdata/plugins.d/apps.plugin.org
  '';

  preConfigure = ''
    substituteInPlace collectors/python.d.plugin/python_modules/third_party/lm_sensors.py \
      --replace 'ctypes.util.find_library("sensors")' '"${lm_sensors.out}/lib/libsensors${stdenv.hostPlatform.extensions.sharedLibrary}"'
  '';

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
  ];

  postFixup = ''
    rm -r $out/sbin
  '';

  meta = with stdenv.lib; {
    description = "Real-time performance monitoring tool";
    homepage = https://my-netdata.io/;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.lethalman ];
  };

}
