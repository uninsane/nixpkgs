{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, vala
, libgee
, libhandy
, granite
, gtk3
, pulseaudio
, libcanberra-gtk3
, switchboard
, buildPackages
, gettext
, glib
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-sound";
  version = "2.3.3";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-JXt/S+vNzuRaRC0DMX13Lxv+OoAPRQmSLv9fsvnkWY4=";
  };

  nativeBuildInputs = [
    gettext  # for msgfmt
    glib
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    granite
    gtk3
    libcanberra-gtk3
    libgee
    libhandy
    pulseaudio
    switchboard
  ];

  # required for cross compilation
  env.PKG_CONFIG_GIO_2_0_GLIB_COMPILE_RESOURCES = "${lib.getDev buildPackages.glib}/bin/glib-compile-resources";

  strictDeps = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Switchboard Sound Plug";
    homepage = "https://github.com/elementary/switchboard-plug-sound";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
