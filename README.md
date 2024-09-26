## Workstation role
This role will turn a basic install of Fedora into a workstation which is suitable for most work:

  * Run VMs managed with cockpit-machines
  * Run containers with podman (also visible in Cockpit)
  * Minimal, but still complete Sway or Xfce desktop
    * Developer toolchain (vim, vscodium, drawio)
    * Office tools (firefox, thunderbird, some libreoffice utilities)
    * Discord for communication
    * Spotify for music
    * Bitwarden password manager

Some of the tools provided come from native RPM packages, others from flatpaks.
All permissions granted by flatpak to app containers can be managed with FlatSeal.

This role assumes the target system is installed with a minimal Fedora environment. An example Kickstart
file can be found in the docs folder. Setting up the required infrastructure to utilize this via PXE is
beyond the scope of this document.
