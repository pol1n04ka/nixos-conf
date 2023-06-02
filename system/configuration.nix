# Made by Polina Prokopenko, May of 2023

{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.extraOptions = ''experimental-features = nix-command flakes'';

  # Bootloader.
  boot = {
    supportedFilesystems = [ "ntfs" ];
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
      };
    };
  };

  networking = {
    hostName = "topolina";
    networkmanager.enable = true;
    # wireless.enable = true; # wpa_supplicant
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  time.timeZone = "Europe/Rome";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "it_IT.UTF-8";
      LC_IDENTIFICATION = "it_IT.UTF-8";
      LC_MEASUREMENT = "it_IT.UTF-8";
      LC_MONETARY = "it_IT.UTF-8";
      LC_NAME = "it_IT.UTF-8";
      LC_NUMERIC = "it_IT.UTF-8";
      LC_PAPER = "it_IT.UTF-8";
      LC_TELEPHONE = "it_IT.UTF-8";
      LC_TIME = "it_IT.UTF-8";
    };
  };

  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "";
    libinput = { 
      enable = true;
      touchpad = { 
        scrollMethod = "edge";
        middleEmulation = true;
      };
    };
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
    windowManager.bspwm.enable = true;
  };

  fonts.fonts = with pkgs; [ 
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # enabling adb globally
  programs.adb.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.polina = {
    isNormalUser = true;
    description = "Polina Prokopenko";
    extraGroups = [ "networkmanager" "wheel" "adbusers" ];
    packages = with pkgs; [

      # general packages
      firefox
      google-chrome
      thunderbird
      qbittorrent
      spotify
      obsidian
      rclone # maybe it's good idea to delete this because of package below
      google-drive-ocamlfuse
      telegram-desktop

      # development
      kate
      vscode
      android-studio
      yakuake
      
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

    # text editing
    neovim
    nixpkgs-fmt

    # system utilities
    wget
    btop # cool system monitor
    nvtop # same as above, but for video cards
    bat # better cat alternative
    du-dust # du on steroids and rust
    httpie # curl, but on steroids and more readable
    picom # x11 compositor

    # some useful things for comfort
    # also it's better keep them system wide
    # android-tools # adb adn etc. 
    mpv
    kitty # terminal emulator [USER]
    maim # screenshot tool [USER]
    ranger # cli file browser
    tmux # cli compositor
    git # no comments

    # some programming stuff

  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
