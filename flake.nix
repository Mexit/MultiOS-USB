{
  description = "MultiOS-USB: One device with muliple ISO/WIM files";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      # Use the same nixpkgs
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
      ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          system,
          ...
        }:
        let
          inherit (inputs.gitignore.lib) gitignoreSource;
        in
        {
          packages.default = pkgs.stdenv.mkDerivation rec {
            src = gitignoreSource ./.;
            name = "multios-usb";
            buildInputs = with pkgs; [
              gnutar
              xz
              bzip2
              gptfdisk
              util-linux
              exfat
              dosfstools
            ];
            nativeBuildInputs = with pkgs; [ makeWrapper ];
            buildPhase = ''
              mkdir -p $out/bin
              cp -r $src $out/share
              ln -s $src/multios-usb.sh $out/bin/multios-usb
            '';
            postFixup = ''
              wrapProgram $out/bin/multios-usb \
                --chdir $out/share \
                --prefix PATH : ${pkgs.lib.makeBinPath buildInputs}
            '';
          };
        };
      flake = {
      };
    };
}
