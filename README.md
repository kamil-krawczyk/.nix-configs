[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

# :snowflake: Nix-based macOS Host Configurations

This repository contains the configuration files for my macOS machine(s),
managed using the Nix package manager — [nix-darwin](https://github.com/LnL7/nix-darwin)
for system-level configuration and [Home Manager](https://github.com/nix-community/home-manager)
for per-user environments.

> **Scope:** this repository targets **macOS (Darwin) only**. It does not
> configure NixOS or any Linux host. It can, however, manage several local
> user accounts on the same machine. The sections below on Nix and NixOS are
> kept for educational context on the wider ecosystem this project builds on.

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
*(This repository takes advantage of that — see "Adding a user" below.)*

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

# :pencil: :apple: Setup & Usage Notes

I install the Nix package manager on Darwin systems using the graphical
[Determinate Nix Installer](https://docs.determinate.systems).

According to the note on the nix-darwin project page, since Determinate manages the Nix
installation itself, Nix management should be disabled in the nix-darwin configuration:

    nix.enable = false;

Please remember to take care of periodic Nix updates in this case:

    sudo determinate-nixd upgrade

After installing Nix and downloading the repository with configuration, the
first system rebuild should be done using the following command:

    sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#konoha

Further system rebuilds can be performed directly using the `darwin-rebuild`
command:

    sudo darwin-rebuild switch --flake .#konoha

(replace `konoha` with the name of the host you're building, see `configs/hosts/`)

### Adding a user

Create `configs/home/users/<name>/default.nix` (and an SSH public key next to
it, if you sign commits like the default user does), then set `user.name` to
`<name>` for the host that should use it.

### Adding a host

Create `configs/hosts/<hostname>/default.nix` importing `../../modules`, then
register it under `darwinConfigurations` in `flake.nix`.

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

