# Home Manager modules shared by every home (nix-darwin hosts and standalone).
# Base modules are always active; optional features are gated by `my.<feature>.enable`.
{
  imports = [
    ./identity.nix
    ./session.nix
    ./shell.nix
    ./git.nix
    ./neovim.nix
    ./tmux.nix

    # Optional features
    ./kiro
  ];
}
