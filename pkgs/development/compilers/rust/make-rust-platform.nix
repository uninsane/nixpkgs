{ makeScopeWithSplicing', generateSplicesForMkScope
, rust
, lib, buildPackages, cargo-auditable, stdenv, runCommand
}@prev:

{ rustc
, cargo
, cargo-auditable ? prev.cargo-auditable
, stdenv ? prev.stdenv
, ...
}:

let
  rustPlatformFun = self: let
    inherit (self) callPackage;
  in {
    rust = {
      rustc = lib.warn "rustPlatform.rust.rustc is deprecated. Use rustc instead." rustc;
      cargo = lib.warn "rustPlatform.rust.cargo is deprecated. Use cargo instead." cargo;
    };

    fetchCargoTarball = buildPackages.callPackage ../../../build-support/rust/fetch-cargo-tarball {
      git = buildPackages.gitMinimal;
      inherit cargo;
    };

    buildRustPackage = callPackage ../../../build-support/rust/build-rust-package {
      inherit stdenv rustc cargo cargo-auditable;
    };

    importCargoLock = buildPackages.callPackage ../../../build-support/rust/import-cargo-lock.nix { inherit cargo; };

    rustcSrc = callPackage ./rust-src.nix {
      inherit runCommand rustc;
    };

    rustLibSrc = callPackage ./rust-lib-src.nix {
      inherit runCommand rustc;
    };

    # Hooks
    inherit (callPackage ../../../build-support/rust/hooks {
      inherit stdenv cargo rustc rust;
    }) cargoBuildHook cargoCheckHook cargoInstallHook cargoNextestHook cargoSetupHook maturinBuildHook bindgenHook;
  };
in (makeScopeWithSplicing' {
  otherSplices = generateSplicesForMkScope "rustPlatform";
  f = rustPlatformFun;
})
