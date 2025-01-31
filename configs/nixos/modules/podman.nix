{pkgs, ...}: {
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
    };
  };

  environment.systemPackages = with pkgs; [
    dockerfile-language-server-nodejs
    docker-compose-language-service
  ];

  users.groups = {
    podman = {};
  };
}
