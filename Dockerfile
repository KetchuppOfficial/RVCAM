FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -y nix
RUN echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf
