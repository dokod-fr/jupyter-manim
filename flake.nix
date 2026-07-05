{
  description = "Manim notebooks";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };

      tex = pkgs.texlive.combine {
        inherit (pkgs.texlive)
          scheme-medium
          collection-latexextra
          collection-fontsrecommended
          collection-fontsextra;
      };

      python = pkgs.python312.withPackages (ps: with ps; [
        manim
        jupyterlab
        notebook
        ipykernel
      ]);
    in {
      devShells.default = pkgs.mkShell {
        packages = [
          python
          pkgs.ffmpeg
          tex
        ];

        shellHook = ''
          python -m ipykernel install \
            --user \
            --name manim \
            --display-name "Python (Manim)" \
            >/dev/null 2>&1 || true
        '';
      };
    });
}

