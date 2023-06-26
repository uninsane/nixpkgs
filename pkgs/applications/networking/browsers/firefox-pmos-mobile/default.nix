{ firefox-unwrapped
, lib
, fetchFromGitLab
, stdenv
, wrapFirefox
, libName ? "firefox"
, keepHomepage ? true
}:
let
  pin = import ./pin.nix;
  version = pin.version;

  mobile-config-firefox = stdenv.mkDerivation {
    pname = "mobile-config-firefox";
    inherit version;

    src = fetchFromGitLab {
      owner = "postmarketOS";
      repo = "mobile-config-firefox";
      rev = version;
      inherit (pin) sha256;
    };

    makeFlags = [ "DISTRO=NixOS" ];

    installPhase = ''
      mkdir $out
      cp out/home.html $out/
      cp out/userChrome.css $out/
      cp src/mobile-config-autoconfig.js $out/
      cp src/mobile-config-prefs.js $out/
    '';

    fixupPhase = ''
      substituteInPlace $out/mobile-config-autoconfig.js \
        --replace "/etc/mobile-config-firefox/userChrome.css" "$out/userChrome.css"
    '';

    meta = with lib; {
      description = "Mobile-friendly Firefox configurations from postmarketOS";
      homepage = "https://gitlab.com/postmarketOS/mobile-config-firefox";
      license = licenses.gpl3Plus;
      maintainers = with maintainers; [ zhaofengli ];
    };
  };

  extraPolicies = let
    policies = lib.recursiveUpdate pin.policies {
      Homepage.URL = "${mobile-config-firefox}/home.html";
    };
  in
    if keepHomepage then builtins.removeAttrs policies [ "Homepage" ] else policies;

  wrapped = wrapFirefox firefox-unwrapped {
    version = "${lib.getVersion firefox-unwrapped}-pmos-${version}";
    inherit libName extraPolicies;
  };
in wrapped.overrideAttrs (old: {
  buildCommand = old.buildCommand + ''
    # Inject default configs with AutoConfig commented out
    # They are problematic as the AutoConfig file is specified by wrapFirefox
    sed '/general\.config\.\(filename\|obscure_value\)/ s|^|//|g' < "${mobile-config-firefox}/mobile-config-prefs.js" > "$out/lib/${libName}/defaults/pref/mobile-config-prefs.js"

    # Inject forced configs
    cat "${mobile-config-firefox}/mobile-config-autoconfig.js" >> "$out/lib/${libName}/mozilla.cfg"
  '';

  passthru = (old.passthru or {}) // {
    updateScript = ./update.sh;
  };
})
