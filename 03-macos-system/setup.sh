#!/usr/bin/env bash

set -xe

nix run nix-darwin -- switch --flake ~/nix-demo/03-macos-system
