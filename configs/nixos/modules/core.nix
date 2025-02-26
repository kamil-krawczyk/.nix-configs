{
  config,
  pkgs,
  inputs,
  outputs,
  ...
}: {
  imports = [
    ../../options.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
  ];

  ### nix, nixpkgs, home-manager ##############################################

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
    };
    gc = {
      automatic = true;
      persistent = true;
      dates = "10:00";
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
    };
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

  ### fonts ###################################################################

  fonts.fontDir.enable = true;

  ### shell ###################################################################

  programs.zsh.enable = true;
  environment.shells = [pkgs.zsh];
  users.defaultUserShell = pkgs.zsh;

  ### editor ##################################################################

  environment.variables = {
    EDITOR = "hx";
    SYSTEMD_EDITOR = "hx";
  };

  ### boot ####################################################################

  boot = {
    tmp.cleanOnBoot = true;
    plymouth = {
      enable = true;
      theme = "circle_flow";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = ["circle_flow"];
        })
      ];
    };
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    loader.timeout = 5;
  };

  ### network #################################################################

  networking = {
    networkmanager.enable = true;
    firewall.enable = true;
    enableIPv6 = false;
  };

  ### ssh #####################################################################

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      StreamLocalBindUnlink = "yes";
    };
  };

  ### desktop ###################################################################

  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    desktopManager.gnome.enable = true;
    xkb = {
      layout = "pl";
      variant = "";
    };
  };

  programs.dconf.enable = true;

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
    printing = {
      enable = true;
      drivers = with pkgs; [hplip];
    };
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
    extraBackends = with pkgs; [hplip];
  };

  users = {
    groups = {
      scanner = {};
      lp = {};
    };
  };

  ### packages ##################################################################

  environment = {
    systemPackages = with pkgs; [
      age
      sops
      ssh-to-age

      helix

      dconf
      dconf-editor
      gnome-tweaks
      gnomeExtensions.caffeine
      gnomeExtensions.night-theme-switcher
      gnomeExtensions.todo-list
      gnomeExtensions.user-themes
      gnomeExtensions.weather-oclock
      xsel
    ];

    gnome.excludePackages = with pkgs; [
      epiphany
      geary
    ];
  };
}
