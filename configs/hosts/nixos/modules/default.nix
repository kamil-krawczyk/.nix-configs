{
  config,
  lib,
  pkgs,
  inputs,
  outputs,
  ...
}: {
  imports = [
    ../../../options.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  ### boot ####################################################################

  boot.tmp.cleanOnBoot = true;

  ### networking ##############################################################

  networking = {
    networkmanager.enable = true;
    firewall.enable = true;
    enableIPv6 = false;
  };

  ### time zone, locale #######################################################

  time.timeZone = "Europe/Warsaw";

  i18n = {
    defaultLocale = "pl_PL.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "pl_PL.UTF-8";
      LC_IDENTIFICATION = "pl_PL.UTF-8";
      LC_MEASUREMENT = "pl_PL.UTF-8";
      LC_MONETARY = "pl_PL.UTF-8";
      LC_NAME = "pl_PL.UTF-8";
      LC_NUMERIC = "pl_PL.UTF-8";
      LC_PAPER = "pl_PL.UTF-8";
      LC_TELEPHONE = "pl_PL.UTF-8";
      LC_TIME = "pl_PL.UTF-8";
    };
  };

  console.keyMap = "pl2";

  ### desktop ###################################################################

  services = {
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    desktopManager.gnome.enable = true;
    xserver = {
      enable = true;
      xkb = {
        layout = "pl";
        variant = "";
      };
    };
    gnome.gnome-browser-connector.enable = true;
  };

  ### audio #####################################################################

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  ### printing ##################################################################

  services = {
    printing.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };

  ### scanning ##################################################################

  hardware.sane = {
    enable = true;
    openFirewall = true;
  };

  users = {
    groups = {
      scanner = {};
      lp = {};
    };
  };

  ### ssh #####################################################################

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  ### shell ###################################################################

  programs.zsh.enable = true;
  environment.shells = [pkgs.zsh];
  users.defaultUserShell = pkgs.zsh;

  ### editor ##################################################################

  environment.variables = {
    EDITOR = "hx";
    SYSTEMD_EDITOR = "hx";
  };

  ### virtualisation ##########################################################

  virtualisation = {
    libvirtd.enable = true;
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
    };
  };

  programs.virt-manager.enable = true;

  users.groups = {
    libvirtd = {};
    podman = {};
  };

  ### packages ################################################################

  environment = {
    systemPackages = with pkgs; [
      age
      sops
      ssh-to-age

      git
      helix
      tmux

      dconf
      dconf-editor
      gnome-tweaks
      gnomeExtensions.caffeine
      xsel

      nerd-fonts.jetbrains-mono
    ];

    gnome.excludePackages = with pkgs; [
      epiphany
      geary
    ];
  };

  ### nix, nixpkgs, home-manager ##############################################

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
    };
    gc = {
      automatic = true;
      persistent = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  nixpkgs.config.allowUnfree = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs outputs;
      hostConfig = config.host;
      userConfig = config.user;
    };
  };

  ### users ###################################################################

  users.users.kamil = {
    isNormalUser = true;
    description = "Kamil Krawczyk";
    extraGroups = [
      "networkmanager"
      "wheel"
      "lp"
      "scanner"
      "libvirtd"
      "podman"
    ];
  };

  home-manager.users.kamil = {
    home = {
      username = "kamil";
      homeDirectory = "/home/kamil";
      stateVersion = config.system.stateVersion;
    };
    imports = [
      ../../../home
      ../../../home/profiles/nixos
      ../../../home/profiles/${config.host.profile}
    ];
  };

  ### misc ####################################################################

  fonts.fontDir.enable = true;
}
