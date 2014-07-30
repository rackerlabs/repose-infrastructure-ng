Repose Pairing Station Setup
===================
### Download the ISO from:

    wget http://cdimage.ubuntu.com/ubuntu-gnome/releases/14.04/release/ubuntu-gnome-14.04-desktop-amd64.iso

### Burn it to a USB drive:

    sudo dd bs=4M if=ubuntu-gnome-14.04-desktop-amd64.iso of=/dev/sd[1 letter]

### Boot the USB drive.
### On the Install screens:

* 1
    - Ensure "English" is selected.
    - Press "Install Ubuntu Gnome".
* 2 (Skipped)
* 3
    - Check "Download updates while installing".
    - Check "Install this third-party software".
* 4
    - Select "Erase ... and install".
    - Press "Install Now".
* 5
    - Ensure Chicago is selected.
    - Press "Continue".
* 6
    - Ensure "English" is selected.
    - Ensure "English" is selected.
* 7
    - Your name:             Administrator
    - Your computer's name:  ReposePairing
    - Pick a username:       administrator
    - Choose a password:     <PW>
    - Confirm your password: <PW>
    - Ensure "Require my password to log in" is selected.
    - Press "Continue".

### On the Installation Complete screen:

* Press "Restart Now"

### At the prompt:

* remove the installation media
* press ENTER to reboot the system

### At the login prompt:

* select the Administrator user
* enter the password.

### Open a terminal (Ctrl-Alt-T).
### Copy and paste (Ctrl-Shift-V) the following into the terminal to finish the installation:

    mkdir -p bin
    cd bin
    cat > pre-bootstrap-pairing.sh << EOF
    #!/bin/bash
    rm -f bootstrap-puppet-pairing.sh
    wget -O bootstrap-puppet-pairing.sh https://raw.githubusercontent.com/rackerlabs/repose-infrastructure-ng/master/bootstrap-puppet-pairing.sh &&
    chmod a+x bootstrap-puppet-pairing.sh &&
    sudo ./bootstrap-puppet-pairing.sh
    EOF
    chmod a+x pre-bootstrap-pairing.sh
    ./pre-bootstrap-pairing.sh
