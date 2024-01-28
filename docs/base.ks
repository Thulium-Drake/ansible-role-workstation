# This Kickstart file will look for the first disk and assume it completely!
# The Fedora resulting installation is ready to be used by this role for further
# configuration.
# Language and regional settings
lang en_US.UTF-8
keyboard --vckeymap=us --xlayouts='us'
timezone Europe/Amsterdam --utc

rootpw --lock
selinux --enforcing
firewall --enabled --ssh

# Default package selection
%packages
@^minimal-environment
kexec-tools
%end

# Misc settings for Kickstart
skipx
text
reboot

# Find first disk (NVMe > SATA) and generate partitioning scheme
%pre
export DRIVE=$(lsblk -N -no name | head -n1)
if test -z "$DRIVE"
then
  export DRIVE=$(lsblk -S -no name | grep -v rom | head -n1)
fi
cat << EOF > /tmp/part-scheme
ignoredisk --only-use="$DRIVE"
clearpart --all --initlabel --drives="$DRIVE"
reqpart --add-boot
part pv.192 --encrypted --luks-version=luks2 --grow --passphrase=changeme
volgroup main --pesize=4096 pv.192
logvol /home --fstype="xfs" --size=10240 --grow --maxsize=51200 --name=home --vgname=main
logvol / --fstype="xfs" --size=30720 --name=root --vgname=main
%end
%include /tmp/part-scheme

user --name=ansible --lock
sshkey --username=ansible "ssh-ed25519 AAAZZZZZ ansible@config.example.nl"

# Configure passwordless sudo for Ansible user
%post
  cat << EOF >> ~ansible/.ssh/authorized_keys
EOF

echo "ansible ALL = (root) NOPASSWD : ALL
Defaults:ansible !requiretty" > /etc/sudoers.d/ansible
fi
%end
