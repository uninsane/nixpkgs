{ stdenv
, lib
, fetchurl
, substituteAll
, bubblewrap
, buildPackages
, cargo
, git
, meson
, ninja
, pkg-config
, rustc
, rustPlatform
, gtk4
, cairo
, libheif
, libxml2
, gnome
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glycin-loaders";
  version = "0.1.2";

  src = fetchurl {
    url = "mirror://gnome/sources/glycin-loaders/${lib.versions.majorMinor finalAttrs.version}/glycin-loaders-${finalAttrs.version}.tar.xz";
    hash = "sha256-x2wBklq9BwF0WJzLkWpEpXOrZbHp1JPxVOQnVkMebdc=";
  };

  patches = [
    # Fix paths in glycin library.
    # Not actually needed for this package since we are only building loaders
    # and this patch is relevant just to apps that use the loaders
    # but apply it here to ensure the patch continues to apply.
    finalAttrs.passthru.glycinPathsPatch
  ];

  nativeBuildInputs = [
    buildPackages.gettext
    cargo
    git
    meson
    ninja
    pkg-config
    rustc
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    gtk4 # for GdkTexture
    cairo
    libheif
    libxml2 # for librsvg crate
  ];

  cargoVendorDir = "vendor";

  # glycin install script expects to find artifacts in cargo_target/loaders/release/
  # but rustc unconditionally outputs them to cargo_target/loaders/<target-triple>/release/ when cross compiling
  preBuild = lib.optionalString (stdenv.hostPlatform.config != stdenv.buildPlatform.config) ''
    mkdir -p cargo_target/loaders/release
    ln -s ../${stdenv.hostPlatform.rust.rustcTarget}/release/glycin-heif cargo_target/loaders/release/glycin-heif
    ln -s ../${stdenv.hostPlatform.rust.rustcTarget}/release/glycin-image-rs cargo_target/loaders/release/glycin-image-rs
    ln -s ../${stdenv.hostPlatform.rust.rustcTarget}/release/glycin-jxl cargo_target/loaders/release/glycin-jxl
    ln -s ../${stdenv.hostPlatform.rust.rustcTarget}/release/glycin-svg cargo_target/loaders/release/glycin-svg
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "glycin-loaders";
    };

    glycinPathsPatch = substituteAll {
      src = ./fix-glycin-paths.patch;
      bwrap = "${bubblewrap}/bin/bwrap";
    };
  };

  meta = with lib; {
    description = "Glycin loaders for several formats";
    homepage = "https://gitlab.gnome.org/sophie-h/glycin";
    maintainers = teams.gnome.members;
    license = with licenses; [ mpl20 /* or */ lgpl21Plus ];
    platforms = platforms.linux;
  };
})
