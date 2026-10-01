# Terminal multiplexer.
{
  programs.tmux = {
    enable = true;
    mouse = true;
    secureSocket = true;
    terminal = "tmux-256color";
    clock24 = true;
  };
}
