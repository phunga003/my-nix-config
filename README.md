# my-nix-config

Personal NixOS configuration using flakes and Home Manager.
Designed for composable, reproducible environments across machines and VM fleets.

---

## Fresh Install

On a fresh NixOS machine before the config is applied.

**1. Install git and openssh**
```bash
nix-env -iA nixpkgs.git nixpkgs.openssh
```

**2. Enable flakes**
```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

**3. Generate an SSH key and add it to GitHub**
```bash
ssh-keygen -t ed25519 -C "your@email.com"
cat ~/.ssh/id_ed25519.pub
```
Copy the output and add it to GitHub → Settings → SSH Keys.

**4. Clone and apply**
```bash
git clone git@github.com:phunga003/my-nix-config.git ~/my-nix-config
cd ~/my-nix-config
git add .
sudo nixos-rebuild switch --flake .#wsl
```

Open a fresh terminal when done.

## Applying the Configuration

```bash
# Full system rebuild (requires sudo)
sudo nixos-rebuild switch --flake .#<host>

# Available hosts
sudo nixos-rebuild switch --flake .#wsl
```

After any change to `.nix` files, stage the changes before rebuilding:

```bash
git add .
sudo nixos-rebuild switch --flake .#wsl
```

Nix reads from the git-tracked state. Unstaged files are invisible to the build.

---

## Project Structure

```
flake.nix           Entry point. Declares all inputs (nixpkgs, home-manager,
                    nixos-wsl) and all nixosConfigurations outputs.

flake.lock          Pins every input to an exact commit. Always commit this.
                    Guarantees identical builds across machines and time.

modules/
  options.nix       Custom option declarations shared across the system.
                    Currently declares myconfig.username.

hosts/
  wsl/              WSL-specific machine identity. Declares which profiles
                    this machine imports and which capabilities are enabled.
                    Sets system.stateVersion and WSL options.

profiles/
  dev/
    lang/
      c.nix         C runtime (gcc, clang-tools) and tooling (clangd LSP).
                    Flags: profiles.dev.c.runtime, profiles.dev.c.tooling
      haskell.nix   Haskell runtime (ghc, cabal) and tooling (HLS, ormolu).
                    Flags: profiles.dev.haskell.runtime, profiles.dev.haskell.tooling
      nix.nix       Nix tooling only (nixd LSP, nixfmt). No runtime flag —
                    Nix is always present on NixOS.
                    Flag: profiles.dev.nixTools.tooling
      cpp.nix       C++ runtime and tooling.
    git.nix         Git installation (runtime only). Identity lives in home/.
    ssh.nix         SSH client config and agent startup.
  entertainment/
    music.nix       spotify-player. Import only on hosts with audio support.
  sec/              Security capability profiles (in progress).
  net/              Network capability profiles (in progress).

home/
  default.nix       Personal environment applied to all machines.
                    Helix (editor, LSP base config, theme), Zellij, Starship,
                    Bash, fonts, git identity, core packages.
  base.nix          Reserved for base home config extraction.
  ide.nix           Reserved for IDE-specific config.
  term.nix          Reserved for terminal-specific config.
```

---

## Adding a New Host

1. Create `hosts/<name>/default.nix`
2. Import the profiles the host needs
3. Set `myconfig.username`, `system.stateVersion`, and any capability flags
4. Add the host to `nixosConfigurations` in `flake.nix`

```nix
# flake.nix
nixosConfigurations.<name> = nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    home-manager.nixosModules.home-manager
    ./hosts/<name>/default.nix
  ];
};
```

---

## Adding a New Language Profile

1. Create `profiles/dev/lang/<language>.nix`
2. Declare `options.profiles.dev.<language>.runtime` and `.tooling` via `lib.mkEnableOption`
3. Use `lib.mkMerge` and `lib.mkIf` to conditionally install packages and wire the LSP into Helix
4. Import the profile in any host that needs it and set the flags

---

## Default Tooling

These are installed by `home/default.nix` on every machine.

### Helix (`hx`)

Terminal editor. Selection-first model — select then act, not act then motion.

```
hx <file>           open a file
Space f             fuzzy file picker
Space F             file picker from current directory
:w                  save
:q                  quit
:format             format current file (uses configured formatter)
w                   select word
x                   select line
v                   enter select mode, then use motions
>                   indent selection right
<                   indent selection left
Ctrl-w              switch between splits
```

LSPs activate automatically by file type. Completions appear inline.
Diagnostics show on the current line and inline on error lines.
Theme: Catppuccin Macchiato.

### Zellij

Terminal multiplexer. Persistent sessions, split panes, no memorization required —
keybindings are always shown at the bottom of the screen.

```
zellij              start a session
Alt n               new pane
Alt h / Alt l       move focus left / right
Alt arrow keys      same as above
Ctrl p + x          close current pane
Ctrl q              quit session
```

### erd

Directory tree viewer. Respects `.gitignore`, colors by file type, shows sizes.

```
erd                 tree from current directory
erd --layout flat   flat list instead of tree
erd -H              show hidden files
erd -L 2            limit depth to 2 levels
```

---

## Key Design Decisions

**One nixpkgs pin** — all inputs follow the same nixpkgs pin via `inputs.X.follows = "nixpkgs"`.
Maximizes binary cache hits and guarantees version consistency across the fleet.

**Capability flags** — runtime and tooling are separate concerns. A VM compiling from source
needs the runtime, not the LSP. A workstation needs both.

**Ephemeral VMs** — VM hosts are reprovisioned from a base ISO on every config update.
Persistent state lives on NAS-mounted volumes, never on the VM disk.

**stateVersion** — set once at first install, never changed. It marks when stateful data
was initialized, not which NixOS version you want to run. Update nixpkgs via `nix flake update`.
