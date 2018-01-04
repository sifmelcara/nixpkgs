{ stdenv, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "SpeechRecognition";
  version = "3.8.1";

  src = fetchFromGitHub {
    owner = "Uberi";
    repo = "speech_recognition";
    rev = "${version}";
    sha256 = "1lq6g4kl3y1b4ch3b6wik7xy743x6pp5iald0jb9zxqgyxy1zsz4";
  };

  doCheck = false; # it requires network to check

  meta = with stdenv.lib; {
    description = "Library for performing speech recognition, with support for several engines and APIs, online and offline.";
    homepage    = "https://github.com/Uberi/speech_recognition";
    license     = licenses.bsd3;
    platforms   = platforms.all;
  };
}
