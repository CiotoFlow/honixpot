{ stdenv, pythonPackages }:

with pythonPackages;

buildPythonPackage rec {
  name = "libtaxii-1.1.103";

  src = fetchurl {
    url = "https://pypi.python.org/packages/source/l/libtaxii/${name}.tar.gz";
    md5 = "c0008637a77e4e8dda5fbf2bd6a01892";
  };

  propagatedBuildInputs = [ dateutil lxml ];
  
  meta = with stdenv.lib; {
    homepage = http://taxii.mitre.org/;
    description = "Python library for handling TAXII Messages and invoking TAXII Services.";
    platforms = platforms.all;
  };
}
