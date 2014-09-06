{ stdenv, pythonPackages, pylibinjection, libtaxii, hpfeeds }:

with pythonPackages;

buildPythonPackage rec {
  name = "glastopf-${version}";
  version = "3.1.2";

  src = fetchurl {
    url = "https://pypi.python.org/packages/source/G/Glastopf/Glastopf-${version}.tar.gz";
    sha256 = "0hfmbs5is3x1jv2wrwfa0hn1vqlkw2cpfjrcq7sh0d3jwnbql75v";
  };

  propagatedBuildInputs = [ gevent webob pylibinjection sqlalchemy jinja2 requests libtaxii hpfeeds ];
  
  buildPhase = "true";

  doCheck = false;

  installPhase = ''
    mkdir -p $out/lib/${python.libPrefix}/site-packages/
    mkdir -p $out/bin
    
    cp -rf glastopf $out/lib/${python.libPrefix}/site-packages/
    cp bin/glastopf-runner $out/bin/
  '';

  meta = with stdenv.lib; {
    homepage = http://glastopf.org/;
    description = "Honeypot which emulates thousands of vulnerabilities to gather data from attacks targeting web applications.";
    platforms = platforms.all;
  };
}
