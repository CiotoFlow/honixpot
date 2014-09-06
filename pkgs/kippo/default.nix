{ stdenv, fetchurl, pythonPackages, makeWrapper }:

with pythonPackages;

stdenv.mkDerivation rec {
  name = "kippo-${version}";
  version = "0.9";

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "https://github.com/desaster/kippo/archive/v${version}.tar.gz";
    sha256 = "05sga1rc1kn4zirjs8fzfgxjh7na1figx29g7dmqba5607zhx1s9";
  };

  buildInputs = [ makeWrapper pythonPackages.python pyasn1 twisted pycrypto ];

  # Replace start.sh with a systemd-friendly one
  installPhase = ''
    mkdir -p $out
    cp -rf -- * $out/
	rm -f $out/start.sh
    makeWrapper "twistd -n -y $out/kippo.tac" $out/start.sh \
	  --prefix PATH : ${twisted}/bin \
	  --prefix PYTHONPATH : $out:$PYTHONPATH
  '';

  patches = [ ./config.patch ];
  patchFlags = [ "-p0" ];
  
  meta = with stdenv.lib; {
    homepage = https://github.com/desaster/kippo;
    description = "Medium interaction SSH honeypot designed to log brute force attacks.";
    platforms = platforms.all;
  };
}