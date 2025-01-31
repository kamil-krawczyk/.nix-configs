{
  lib,
  pkgs,
  hostConfig,
  ...
}:
with lib; {
  config = mkMerge [
    (mkIf (hostConfig.isLinux == false) {
      home.packages = with pkgs; [
        iterm2
        utm

        cocoapods
        ruby
      ];
    })
    (mkIf (hostConfig.isLinux == true) {
      home.packages = with pkgs; [
        lsof
        ltrace
        strace
      ];
    })
    {
      home = {
        packages = with pkgs; [
          bat
          btop
          coreutils
          devenv
          dig
          jq
          neofetch
          netcat
          nmap
          ripgrep
          rlwrap
          socat
          tcpdump
          wget

          google-chrome
          wireshark

          nil
          marksman
          vscode-langservers-extracted
        ];

        sessionVariables = {
          CHROME_EXECUTABLE = "${pkgs.google-chrome}/bin/google-chrome-stable";
        };
      };

      programs = {
        bash.enable = true; # direnv requires newer bash

        direnv = {
          enable = true;
          enableZshIntegration = true;
          nix-direnv.enable = true;
        };

        vscode = {
          enable = true;
          extensions = with pkgs.vscode-extensions; [
            ban.spellright
            kamikillerto.vscode-colorize
            oderwat.indent-rainbow

            mkhl.direnv

            bierner.markdown-checkbox
            bierner.markdown-emoji
            bierner.markdown-mermaid
            bierner.markdown-preview-github-styles

            bbenoist.nix
            dart-code.flutter
            golang.go
            ms-python.python
            ms-vscode.cpptools-extension-pack
            svelte.svelte-vscode
          ];
        };
      };
    }
  ];
}
