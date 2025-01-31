{
  config,
  pkgs,
  ...
}: let
  isRosetta =
    if config.nixpkgs.hostPlatform == "aarch64-darwin"
    then true
    else false;
in {
  users.users.kamil = {
    name = "kamil";
    home = "/Users/kamil";
    description = "Kamil Krawczyk";
  };

  ### home-manager ############################################################

  home-manager.users.kamil = {
    home = {
      username = "kamil";
      homeDirectory = "/Users/kamil";
      stateVersion = config.host.user."kamil".stateVersion;
    };
    imports = [
      ../modules/core.nix
      ../modules/dev.nix
    ];
  };

  ### homebrew ################################################################

  nix-homebrew = {
    user = "kamil";
    enableRosetta = isRosetta;
  };

  homebrew = {
    casks = [
      "beeper"
    ];
    masApps = {
      "Affinity Designer 2" = 1616831348;
      "Affinity Photo 2: Image Editor" = 1616822987;
      "Affinity Publisher 2" = 1606941598;
      "Amphetamine" = 937984704;
      "Xcode" = 497799835;
    };
  };

  ### settings ################################################################

  system.defaults = {
    dock = {
      autohide = true;
      autohide-delay = 0.1;
      autohide-time-modifier = 0.1;
      expose-animation-duration = 0.1;
      launchanim = false;
      minimize-to-application = true;
      show-recents = false;
      showhidden = true;
      slow-motion-allowed = false;
      persistent-apps = [
        "/System/Applications/Launchpad.app"
        "/System/Applications/Mail.app"
        "/Applications/Beeper.app"
        "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"
        "${pkgs.vscode}/Applications/Visual Studio Code.app"
        "${pkgs.iterm2}/Applications/iTerm2.app"
      ];
    };
  };
}
