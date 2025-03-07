{
  config,
  lib,
  pkgs,
  hostConfig,
  ...
}:
with lib; let
  user = hostConfig.user."${config.home.username}";
in {
  home = {
    packages = with pkgs;
      [
        bat
        btop
        coreutils
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

        marksman
        nil
        vscode-langservers-extracted
      ]
      ++ lists.optionals (hostConfig.isLinux == false) [
        iterm2
        utm

        cocoapods
        ruby
      ]
      ++ lists.optionals (hostConfig.isLinux == true) [
        lsof
        ltrace
        strace

        drawio
        remmina
        wireshark
      ]
      ++ lists.optionals (pkgs.stdenv.hostPlatform.system != "aarch64-linux") [
        google-chrome
      ];

    sessionPath =
      []
      ++ lists.optionals (hostConfig.isLinux == false) ["${config.home.homeDirectory}/.flutter_sdk/flutter_3.29.0/bin"];

    sessionVariables =
      attrsets.optionalAttrs (hostConfig.isLinux == true) {
        EMAIL = "${user.email}";
      }
      // attrsets.optionalAttrs (pkgs.stdenv.hostPlatform.system != "aarch64-linux") {
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
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          streetsidesoftware.code-spell-checker

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

          github.copilot
          github.copilot-chat
        ];
        userSettings = {
          "cSpell.language" = "pl,en";
          "extensions.ignoreRecommendations" = true;
          "git.autofetch" = true;
          "git.enableSmartCommit" = true;
          "git.openRepositoryInParentFolders" = "always";
          "[dart]" = {
            "editor.formatOnSave" = true;
            "editor.formatOnType" = true;
            "editor.rulers" = [80];
            "editor.selectionHighlight" = false;
            "editor.tabCompletion" = "onlySnippets";
            "editor.wordBasedSuggestions" = "off";
          };
        };
      };
    };
  };
}
