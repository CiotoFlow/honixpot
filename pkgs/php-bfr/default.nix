{ stdenv, phpPackages, fetchFromGitHub }:

with phpPackages;

buildPecl rec {
  name = "php-bfr";

  src = fetchFromGitHub {
    owner = "glastopf";
    repo = "BFR";
    rev = "2b4c5e74c573f812cddf8ac143c486b7209676fa";
    sha256 = "0gmm619khq6k3amxn8gz0a6byk7nvrhd3hl6cw37c65h20xj27wv";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/glastopf/BFR;
    description = "Better Function Replacer based on APD";
    platforms = platforms.linux;
  };
}