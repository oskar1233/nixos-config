# NixOS Configuration

## Structure

```
nixos-config/
├── flake.nix                           # Main entry point
├── flake.lock                          # Generated - pins versions
├── modules/
│   └── common.nix                      # Shared configuration
├── hosts/
│   ├── vm/
│   │   ├── configuration.nix           # VM-specific config
│   │   └── hardware-configuration.nix  # VM hardware (generate this)
│   └── amd64-machine/
│       ├── configuration.nix           # Machine-specific config
│       └── hardware-configuration.nix  # Hardware (generate this)
└── home/
    └── default.nix                     # Home-manager config
```

## Initial Setup (VM)

1. Boot into your NixOS VM

2. Enable flakes temporarily:
   ```bash
   export NIX_CONFIG="experimental-features = nix-command flakes"
   ```

3. Clone or copy this config:
   ```bash
   git clone <your-repo> ~/nixos-config
   cd ~/nixos-config
   ```

4. Generate hardware config:
   ```bash
   sudo nixos-generate-config --show-hardware-config > hosts/vm/hardware-configuration.nix
   ```

5. Build and switch:
   ```bash
   sudo nixos-rebuild switch --flake .#vm
   ```

6. Reboot to start niri

## Setting Up Another Machine

1. Boot NixOS installer or existing NixOS

2. Clone the config

3. Generate hardware config for that machine:
   ```bash
   sudo nixos-generate-config --show-hardware-config > hosts/amd64-machine/hardware-configuration.nix
   ```

4. Build and switch:
   ```bash
   sudo nixos-rebuild switch --flake .#amd64-machine
   ```

## Neovim Configuration

The neovim config directory is empty by design. Add your config to:
- `~/.config/nvim/init.lua` - main config
- `~/.config/nvim/lua/` - lua modules

Or manage it declaratively via home-manager by editing `home/default.nix`.

## Key Bindings (Niri)

| Binding | Action |
|---------|--------|
| Mod+Return | Terminal (foot) |
| Mod+D | Launcher (fuzzel) |
| Mod+Q | Close window |
| Mod+H/J/K/L | Focus left/down/up/right |
| Mod+Shift+H/J/K/L | Move window |
| Mod+1-5 | Switch workspace |
| Mod+Shift+1-5 | Move to workspace |
| Mod+F | Fullscreen |
| Mod+R | Cycle column widths |
| Print | Screenshot |
| Mod+Shift+E | Quit niri |

## Updating

```bash
cd ~/nixos-config
nix flake update
sudo nixos-rebuild switch --flake .#vm
```

## Tips

- Edit `modules/common.nix` for changes that apply everywhere
- Edit `hosts/<machine>/configuration.nix` for machine-specific changes
- Edit `home/default.nix` for user-level config (dotfiles, user packages)
- Run `nixos-rebuild switch --flake .#<host>` after changes
