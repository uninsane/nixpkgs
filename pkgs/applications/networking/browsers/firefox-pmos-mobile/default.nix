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
      ./make-compat-with-wrapFirefox.patch
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

  extraPolicies = pin.policies;
  extraPrefsFiles = [
    "${mobile-config-firefox}/lib/${libName}/mobile-config-autoconfig.js"
    "${mobile-config-firefox}/lib/${libName}/defaults/pref/mobile-config-prefs.js"
  ];
  wrapped = wrapFirefox firefox-unwrapped {
    version = "${lib.getVersion firefox-unwrapped}-pmos-${version}";
    inherit libName extraPolicies extraPrefsFiles;
  };
in wrapped.overrideAttrs (old: {
  passthru = (old.passthru or {}) // {
    inherit extraPolicies extraPrefsFiles mobile-config-firefox;
    updateScript = ./update.sh;
  };
})
