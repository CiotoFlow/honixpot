{ stdenv, pythonPackages }:

with pythonPackages;

buildPythonPackage rec {
  name = "pylibinjection-0.2.4";

  src = fetchurl {
    url = "https://pypi.python.org/packages/source/p/pylibinjection/${name}.tar.gz";
    sha256 = "0hhgwlspwc135jlwi611rql6c5p6rb18ac9ymy34h0n26ys91h3y";
  };

  propagatedBuildInputs = [ cython ];
  
  meta = with stdenv.lib; {
    homepage = https://github.com/glastopf/pylibinjection;
    description = "Wrapper for the Libinjection library.";
	license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}

