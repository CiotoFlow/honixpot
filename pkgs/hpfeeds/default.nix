{ stdenv, fetchFromGitHub, pythonPackages }:

with pythonPackages;

buildPythonPackage rec {
  name = "hpfeeds";

  src = fetchFromGitHub {
	  owner = "rep";
    repo = "hpfeeds";
    rev = "249b2f7f44e6e017f5139e3f074fa0710e0a830c";
    sha256 = "1j13sph84zzr2qwhqw05bgaljph5k1zll1kpbmdjfiy6wn3z8bg6";
  };

  propagatedBuildInputs = [ ];
  
  meta = with stdenv.lib; {
    homepage = https://github.com/rep/hpfeeds;
    description = "Generic authenticated datafeed protocol";
    platforms = platforms.all;
  };
}
