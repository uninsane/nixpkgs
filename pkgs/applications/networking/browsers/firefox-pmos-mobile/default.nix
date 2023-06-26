{ firefox-unwrapped
, lib
, fetchFromGitLab
, stdenv
, wrapFirefox
, libName ? "firefox"
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

    patches = [
      ./fix-hardcoded-paths.patch
    ];

    makeFlags = [
      "DESTDIR=${placeholder "out"}"
      "FIREFOX_DIR=/lib/${libName}"
    ];

    postInstall = ''
      mv "$out/usr/share" "$out/share"
      rmdir "$out/usr"
      substituteAllInPlace "$out/lib/${libName}/mobile-config-autoconfig.js"
    '';

    meta = with lib; {
      description = "Mobile-friendly Firefox configurations from postmarketOS";
      homepage = "https://gitlab.com/postmarketOS/mobile-config-firefox";
      license = licenses.gpl3Plus;
      maintainers = with maintainers; [ zhaofengli ];
    };
  };

  wrapped = wrapFirefox firefox-unwrapped {
    version = "${lib.getVersion firefox-unwrapped}-pmos-${version}";
    inherit libName;
    extraPolicies = pin.policies;
  };
in wrapped.overrideAttrs (old: {
  buildCommand = old.buildCommand + ''
    # Inject default configs with AutoConfig commented out
    # They are problematic as the AutoConfig file is specified by wrapFirefox
    sed '/general\.config\.\(filename\|obscure_value\)/ s|^|//|g' \
      < "${mobile-config-firefox}/lib/${libName}/defaults/pref/mobile-config-prefs.js" \
      > "$out/lib/${libName}/defaults/pref/mobile-config-prefs.js"

    # Inject forced configs
    cat "${mobile-config-firefox}/lib/${libName}/mobile-config-autoconfig.js" >> "$out/lib/${libName}/mozilla.cfg"
  '';

  passthru = (old.passthru or {}) // {
    updateScript = ./update.sh;
  };
})
