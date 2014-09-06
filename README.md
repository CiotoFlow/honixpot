honixpot
============

```
$ nix-build build-cluster.nix --arg cluster presets/kippo.nix
$ result/bin/nixos-run-vms
```

Login as root from the attacker vm:

```
# ssh -p 2222 root@kippo
```
