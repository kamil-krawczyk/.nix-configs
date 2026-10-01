[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

# :snowflake: Nix-based macOS and Linux Configurations

This repository contains the configuration files for my macOS and Linux machines,
managed using the Nix package manager — [nix-darwin](https://github.com/LnL7/nix-darwin)
for system-level configuration and [Home Manager](https://github.com/nix-community/home-manager)
for per-user environments.

> **Scope:** this repository configures **macOS hosts** with nix-darwin and
> **Linux distributions** (non-NixOS) with standalone Home Manager. It does not
> configure NixOS itself. The sections below on Nix and NixOS are kept for
> educational context on the wider ecosystem this project builds on.

## Table of Contents

* [What is Nix?](#what-is-nix)
* [What is NixOS?](#what-is-nixos)
* [What is Nix-Darwin?](#what-is-nix-darwin)
* [What is Home Manager?](#what-is-home-manager)
* [Setup & Usage Notes](#pencil-setup--usage-notes)
  * [Installing Nix](#snowflake-installing-nix)
  * [macOS (nix-darwin)](#apple-macos-nix-darwin)
  * [Linux (standalone Home Manager)](#penguin-linux-standalone-home-manager)
  * [Layout](#file_folder-layout)
  * [Adding a host](#heavy_plus_sign-adding-a-host)
  * [Adding a user](#busts_in_silhouette-adding-a-user)
* [Acknowledgements](#pray-acknowledgements)

## What is Nix?

Nix is a purely functional package manager that allows for reproducible and
declarative system configurations. It offers several advantages over traditional
package managers, including:

* **Reproducibility:** Nix ensures that every package and its dependencies are
built from the same source code, guaranteeing that the same configuration will
always produce the same result.
* **Declarative Configuration:** Nix allows you to define your entire system
configuration in a declarative way, specifying what you want your system to look
like rather than how to achieve it.
* **Rollbacks:** Nix makes it easy to roll back to previous system
configurations if something goes wrong.
* **Multi-user Support:** Nix allows multiple users to have their own isolated
environments, each with its own set of packages and configurations.

## What is NixOS?

NixOS is a Linux distribution built on top of the Nix package manager. It takes
the principles of Nix to the extreme, treating the entire operating system as
a package. This means that everything from the kernel to the system services
is managed by Nix, providing a level of reproducibility and control that is
unmatched by other Linux distributions.

*(This repository does not configure NixOS itself — it's mentioned here only
for context, since Nix-Darwin below borrows heavily from its module system.)*

## What is Nix-Darwin?

Nix-Darwin is a tool that brings the benefits of Nix to macOS. It allows you to
manage your macOS system configuration in a declarative way, just like NixOS.

## What is Home Manager?

Home Manager is a tool that allows you to manage your user environment
using Nix. It can be used to manage your dotfiles, applications, and other
user-specific settings.

# :pencil: Setup & Usage Notes

## :snowflake: Installing Nix

On every machine, both nix-darwin hosts (macOS) and standalone Home Manager
homes (Linux), I install Nix using the
[Determinate Nix Installer](https://github.com/DeterminateSystems/nix-installer).
It installs Determinate Nix with flakes enabled, so no extra Nix configuration
is needed before the first build.

* macOS: the graphical installer package from
  [docs.determinate.systems](https://docs.determinate.systems).
* Linux: the command-line installer, which sets up a multi-user installation
  (via systemd):

      curl -fsSL https://install.determinate.systems/nix | sh -s -- install

Open a new terminal afterwards so `nix` is on the `PATH`.

Determinate manages the Nix installation itself, including its updates, so
remember to upgrade Nix periodically:

    sudo determinate-nixd upgrade

If `git` is not available yet, a temporary one can be taken from nixpkgs to
download the repository:

    nix shell nixpkgs#git

## :apple: macOS (nix-darwin)

According to the note on the nix-darwin project page, since Determinate manages the Nix
installation itself, Nix management is disabled in the nix-darwin configuration
(`configs/modules/darwin/default.nix`):

    nix.enable = false;

After installing Nix and downloading the repository with configuration, the
first system rebuild should be done using the following command:

    sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#konoha

Further system rebuilds can be performed directly using the `darwin-rebuild`
command:

    sudo darwin-rebuild switch --flake .#konoha

(replace `konoha` with the name of the host you're building, see `configs/hosts/`)

## :penguin: Linux (standalone Home Manager)

Linux machines (e.g. `ame`, a work PC running Ubuntu) are not managed by
NixOS. Only the user environment is managed, by Home Manager running
standalone. System packages and services stay with the distribution (`apt`).
Nix itself is managed by Determinate (see "Installing Nix" above), so Home
Manager does not touch the Nix installation or its settings either.

After installing Nix and downloading the repository with configuration, the
first activation runs Home Manager straight from its flake, because the
`home-manager` command is not installed yet. The `-b bak` flag renames
existing dotfiles shipped by Ubuntu (e.g. `~/.bashrc`, `~/.profile`) to
`*.bak` instead of failing on the conflict (on macOS the same is configured by
`home-manager.backupFileExtension`):

    nix run home-manager/master -- switch -b bak --flake .#kamil@ame

Further activations can use the `home-manager` command installed by the
configuration:

    home-manager switch -b bak --flake .#kamil@ame

(replace `kamil@ame` with the `<user>@<hostname>` you're activating, see
`configs/homes/`)

After the first activation, log out and back in, so the login shell picks up
the Home Manager session variables and the Nix profile `PATH`.

Home Manager configures zsh but cannot change the login shell. Ubuntu
defaults to bash, so switch it once by hand. Using the distribution's zsh
keeps the login working even if the Nix profile is broken:

    sudo apt install zsh
    chsh -s /usr/bin/zsh

## :file_folder: Layout

    configs/
      modules/
        darwin/     # nix-darwin modules shared by all Macs
        home/       # Home Manager modules shared by all homes
      profiles/
        darwin/     # per-role macOS settings (e.g. casks): personal, work
        home/       # per-role home settings (identity, SSH key, feature toggles)
      hosts/        # nix-darwin machines (konoha: personal, kiri: work)
      homes/        # standalone Home Manager homes, one per <user>@<host>
                    # (kamil@ame: work PC, Ubuntu)

Base modules are always active. Optional features are switched on with
`my.<feature>.enable` (e.g. `my.kiro.enable`), usually from a home profile.
On macOS, `my.kiro.enable` also installs the Kiro cask.

A home profile must set the user's identity (`my.identity.fullName`, `email`
and `sshPublicKeyFile`); evaluation fails if any of them is missing.

## :heavy_plus_sign: Adding a host

* macOS: create `configs/hosts/<hostname>/default.nix`, then register it
  under `darwinConfigurations` in `flake.nix` as
  `<hostname> = configureDarwin "<hostname>";`. The host file imports
  `../../modules/darwin` and a darwin profile, declares its users (see
  "Adding a user" below) and sets the host-specific values. The platform is
  taken only from `nixpkgs.hostPlatform`, so it is required:

  ```nix
  {config, ...}: {
    imports = [
      ../../modules/darwin
      ../../profiles/darwin/work.nix
    ];

    my.primaryUser = "kamil";

    my.users.kamil = {
      profiles = [../../profiles/home/work];
      stateVersion = "26.11"; # Home Manager release current at setup time
    };

    networking = {
      computerName = "<hostname>";
      hostName = config.networking.computerName;
    };

    system.stateVersion = 7; # nix-darwin release current at setup time

    nixpkgs.hostPlatform = "aarch64-darwin";
  }
  ```

* Linux: create `configs/homes/<user>@<hostname>/default.nix` importing
  `../../modules/home` and a home profile, then register it under
  `homeConfigurations` in `flake.nix` as `"<user>@<hostname>"`.

## :busts_in_silhouette: Adding a user

Every machine can manage several users. The example below adds a user `anna`.

First, create a home profile with the user's identity and feature toggles,
e.g. `configs/profiles/home/anna/default.nix`, with the user's SSH public key
next to it:

```nix
{
  my.identity = {
    fullName = "Anna Example";
    email = "anna@example.com";
    sshPublicKeyFile = ./id_ed25519.pub;
  };

  # my.kiro.enable = true;
}
```

### On macOS (nix-darwin)

Add the user to `my.users` in the host file, next to the existing ones:

```nix
my.users = {
  kamil = {
    profiles = [../../profiles/home/personal];
    stateVersion = "25.11";
  };
  anna = {
    profiles = [../../profiles/home/anna];
    stateVersion = "26.11";
  };
};
```

* The macOS account has to exist already; nix-darwin manages its Home Manager
  configuration but does not create the account.
* `stateVersion` is the Home Manager release current when the user is added,
  and should not be changed later.
* Homebrew and `system.defaults` are system-wide and applied on behalf of
  `my.primaryUser`, so casks from darwin profiles (and Kiro, if any user
  enables it) are installed for everyone on the host.

Apply it with the usual `sudo darwin-rebuild switch --flake .#<hostname>`.

### On Linux (standalone Home Manager)

Create `configs/homes/anna@<hostname>/default.nix`:

```nix
{
  imports = [
    ../../modules/home
    ../../profiles/home/anna
  ];

  home = {
    username = "anna";
    homeDirectory = "/home/anna";
    stateVersion = "26.11";
  };

  targets.genericLinux.enable = true;
  programs.home-manager.enable = true;
}
```

Register it in `flake.nix`:

```nix
homeConfigurations = {
  "kamil@ame" = configureHome "kamil@ame" "x86_64-linux";
  "anna@ame" = configureHome "anna@ame" "x86_64-linux";
};
```

Then activate it from the user's own account, as described in the Linux
section above:

    home-manager switch -b bak --flake .#anna@ame

# :pray: Acknowledgements

The following projects and their creators strongly inspired me while I was
learning Nix and building my own configurations.

* [Misterio77](https://github.com/Misterio77): :snowflake: [nix-config](https://github.com/Misterio77/nix-config)
* [ryan4yin](https://github.com/ryan4yin): :snowflake: [nix-config](https://github.com/ryan4yin/nix-config), :books: [NixOS & Flakes Book](https://nixos-and-flakes.thiscute.world)
* [vimjoyer](https://github.com/vimjoyer): :snowflake: [nixconf](https://github.com/vimjoyer/nixconf), :tv: [youtube.com/@vimjoyer](https://www.youtube.com/@vimjoyer)
* [EmergentMind](https://github.com/EmergentMind): :snowflake: [nix-config](https://github.com/EmergentMind/nix-config), :tv: [youtube.com/@Emergent_Mind](https://www.youtube.com/@Emergent_Mind)
* [librephoenix](https://github.com/librephoenix): :snowflake: [nixos-config](https://github.com/librephoenix/nixos-config), :tv: [youtube.com/@librephoenix](https://www.youtube.com/@librephoenix)
* [nmasur](https://github.com/nmasur): :snowflake: [dotfiles](https://github.com/nmasur/dotfiles)
* [dreamsofautonomy](https://github.com/dreamsofautonomy): :snowflake: [nix-darwin](https://github.com/dreamsofautonomy/nix-darwin), :tv: [youtube.com/@dreamsofautonomy](https://www.youtube.com/@dreamsofautonomy)

