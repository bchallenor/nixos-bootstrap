FROM debian:stable

ENV ARCHIVE_URL=https://nixos.org/releases/nix/nix-2.0/nix-2.0-x86_64-linux.tar.bz2
ENV ARCHIVE_SHA256=6312837aee33306cdbb351b75ba1638b89d21b30f0caf0346f9a742425f197ee

# Install requisite Debian packages
RUN apt-get update && apt-get install -y curl bzip2

# Create nix user
RUN useradd --create-home --shell /bin/bash nix

# Create nixbld user (for when we run nixos-install as root)
RUN groupadd --system nixbld
RUN useradd nixbld --system --gid nixbld --groups nixbld

# Create /nix directory
RUN mkdir -m 0755 /nix
RUN chown nix:nix /nix

# Switch to nix user
USER nix
ENV USER=nix
WORKDIR /home/nix

# Download Nix installer
RUN curl --output installer.tar.bz2 "$ARCHIVE_URL"
RUN echo "6312837aee33306cdbb351b75ba1638b89d21b30f0caf0346f9a742425f197ee  installer.tar.bz2" | sha256sum -c
RUN mkdir installer
RUN tar --dir installer --strip-components 1 -xjf installer.tar.bz2

# Install Nix
RUN installer/install

# Set the PATH so we only see Nix binaries after this point (i.e. nothing from the host)
ENV PATH=/nix/var/nix/profiles/per-user/nix/profile/bin

# Set NIX_PATH to the NixOS channel
RUN nix-channel --remove nixpkgs && \
    nix-channel --add https://nixos.org/channels/nixos-unstable-small nixos && \
    nix-channel --update
ENV NIX_PATH=nixpkgs=/nix/var/nix/profiles/per-user/nix/channels/nixos/nixpkgs

# Build the nixos-bootstrap environment
COPY env.nix .
RUN nix build --file env.nix --out-link nixos-bootstrap

# Set the PATH to the nixos-bootstrap environment
ENV PATH=/home/nix/nixos-bootstrap/bin

# Switch back to root user for the install
USER root
ENV USER=root
WORKDIR /

# Declare /mnt as the volume for the install
VOLUME /mnt
