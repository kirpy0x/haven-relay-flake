{
  # Define the inputs (dependencies) for your flake
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  # Define the outputs (what your flake provides)
  outputs = { self, nixpkgs }: {
    nixosModules.haven-relay = import ./haven-relay.nix;
  };
}
