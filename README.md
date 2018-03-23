# nixos-bootstrap

`nixos-bootstrap` is a Dockerfile that allows you to bootstrap a NixOS installation from another
Linux distribution. It works by downloading Nix, and building the `nixos-generate-config` and
`nixos-install` tools.

The Dockerfile is pretty simple, and you are encouraged to check it and build it yourself. This way
you can be sure what you are installing.

## Usage

 1. Build the image:

        sudo docker build src -t nixos-bootstrap

 2. Format your target disk and mount its root partition at `./mnt`.

 3. Generate the default NixOS config in `./mnt/etc/nixos`.

        sudo docker run --rm \
            --volume "$PWD/mnt:/mnt" \
            nixos-bootstrap \
            nixos-generate-config --root /mnt

 4. Customize the NixOS config as appropriate.

 5. Install NixOS:

        sudo docker run --rm \
            --privileged \
            --volume "$PWD/mnt:/mnt" \
            nixos-bootstrap \
            nixos-install --root /mnt

    If you want indication of progress, you can add `--interactive --tty` to the above command.
