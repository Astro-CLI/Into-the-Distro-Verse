#!/bin/bash

# Move docs files
mv distroverse--docs--arch.html docs/
mv distroverse--docs--fedora.html docs/
mv distroverse--docs--debian.html docs/
mv distroverse--docs--nix.html docs/
mv distroverse--docs--security.html docs/
mv distroverse--docs--snapshots.html docs/
mv distroverse--docs--timeshift-io-optimization.html docs/
mv distroverse--docs--system_maintenance.html docs/
mv distroverse--docs--file-sync-guide.html docs/
mv distroverse--docs--wayland-privilege-escalation.html docs/
mv distroverse--docs--homebrew.html docs/
mv distroverse--docs--flatpak.html docs/
mv distroverse--docs--snaps.html docs/
mv distroverse--docs--virtualization.html docs/
mv distroverse--docs--audio-video.html docs/
mv distroverse--docs--local-ai.html docs/
mv distroverse--docs--accessibility-tts.html docs/
mv distroverse--docs--streaming--README.html docs/
mv distroverse--docs--streaming--music.html docs/
mv distroverse--docs--streaming--video.html docs/
mv apache-tor-docker.html docs/

# Move configs files
mv distroverse--configs--kde--README.html configs/
mv distroverse--configs--grub--README.html configs/

# Move packages files
mv distroverse--packages--README.html packages/

# Move apps files
mv distroverse--apps--packettracer--saves--SOYMSA--README.html apps/packettracer/

# Move main README
mv distroverse--README.html README.html

echo "Files moved successfully!"
