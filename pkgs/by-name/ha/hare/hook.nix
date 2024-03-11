{ stdenv
, makeSetupHook
, hare
}:
let
  arch = stdenv.hostPlatform.uname.processor;
in
makeSetupHook
{
  name = "hare-hook";
  propagatedBuildInputs = [ hare ];
  substitutions = {
    hare_default_flags = [ "-q" "-R" "-a${arch}" ];
  };
  passthru = { inherit hare; };
  meta = {
    description = "A setup hook for using Hare in nixpkgs";
    inherit (hare.meta) maintainers platforms badPlatforms;
  };
} ./setup-hook.sh
