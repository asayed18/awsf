# Linux Installation & Integration Guide

This guide covers Linux-specific installation and integration options for AWSF.

## Quick Install

```bash
# Install dependencies
pip install -r requirements.txt

# Install fzf (if not already installed)
# Ubuntu/Debian
sudo apt install fzf

# Fedora/RHEL/CentOS
sudo dnf install fzf

# Arch Linux
sudo pacman -S fzf

# Configure AWS CLI
aws configure

# Populate resources
python3 scripts/populate_resources.py

# Run AWSF
python3 src/awsf.py
```

## Desktop Integration

The `create_linux_desktop.sh` script creates a desktop entry that integrates AWSF into your Linux desktop environment.

### What It Does

1. **Creates a Desktop Entry** (`.desktop` file)
   - Adds AWSF to your application menu
   - Makes it searchable in application launchers (GNOME, KDE, etc.)
   
2. **Generates an Icon**
   - Creates a simple icon for the application
   - Uses ImageMagick if available for better quality
   
3. **Creates a Launcher Script**
   - Installs `awsf` command to `~/.local/bin`
   - Makes it accessible from any terminal

4. **Detects Your Terminal Emulator**
   - Automatically detects and configures for:
     - GNOME Terminal
     - Konsole (KDE)
     - XFCE Terminal
     - Terminator
     - Alacritty
     - Kitty
     - Tilix
     - And more...

### Running the Script

```bash
cd /path/to/awsf
./scripts/create_linux_desktop.sh
```

### Manual Desktop Entry

If you prefer to create the desktop entry manually, create `~/.local/share/applications/awsf.desktop`:

```desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=AWSF - AWS Fuzzy Finder
Comment=Fuzzy search tool for AWS resources
Exec=gnome-terminal -- bash -c 'cd /path/to/awsf && python3 src/awsf.py; exec bash'
Icon=/path/to/icon.png
Terminal=true
Categories=Development;Utility;
Keywords=AWS;Cloud;DevOps;Lambda;S3;Search;
```

Replace `/path/to/awsf` and adjust the terminal command for your preferred terminal emulator.

## Shell Integration

### Bash/Zsh

Add to `~/.bashrc` or `~/.zshrc`:

```bash
# AWSF - AWS Fuzzy Finder
export PATH="$HOME/.local/bin:$PATH"
alias awsf='python3 /path/to/awsf/src/awsf.py'
alias awsf-populate='python3 /path/to/awsf/scripts/populate_resources.py'
```

### Fish

Add to `~/.config/fish/config.fish`:

```fish
# AWSF - AWS Fuzzy Finder
set -gx PATH $HOME/.local/bin $PATH
alias awsf 'python3 /path/to/awsf/src/awsf.py'
alias awsf-populate 'python3 /path/to/awsf/scripts/populate_resources.py'
```

Then reload: `source ~/.bashrc` (or restart your terminal)

## Keyboard Shortcuts

You can create a custom keyboard shortcut to launch AWSF quickly:

### GNOME (Ubuntu, Fedora Workstation)

1. Open **Settings** → **Keyboard** → **Keyboard Shortcuts**
2. Click **+** to add a custom shortcut
3. Name: `AWSF`
4. Command: `gnome-terminal -- bash -c 'cd /path/to/awsf && python3 src/awsf.py; exec bash'`
5. Set your preferred shortcut (e.g., `Ctrl+Alt+A`)

### KDE Plasma

1. Open **System Settings** → **Shortcuts** → **Custom Shortcuts**
2. Right-click → **New** → **Global Shortcut** → **Command/URL**
3. Trigger: Set your preferred shortcut
4. Action: `konsole --workdir /path/to/awsf -e bash -c 'python3 src/awsf.py; exec bash'`

### XFCE

1. Open **Settings** → **Keyboard** → **Application Shortcuts**
2. Click **Add**
3. Command: `xfce4-terminal --working-directory=/path/to/awsf -e 'bash -c "python3 src/awsf.py; exec bash"'`
4. Set your preferred shortcut

## Terminal Emulator Customization

### GNOME Terminal Profile

Create a custom profile for AWSF:

```bash
# Create new profile
dconf dump /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ > awsf-profile.dconf

# Edit the profile settings
gnome-terminal --window-with-profile=AWSF
```

### Konsole Profile

1. Open Konsole
2. **Settings** → **Manage Profiles**
3. Create a new profile named "AWSF"
4. Customize colors, font, and behavior
5. Save and use in the desktop entry

## Distribution-Specific Notes

### Ubuntu/Debian
- Python 3 is usually pre-installed
- Install pip: `sudo apt install python3-pip`
- AWS CLI: `sudo apt install awscli` or use pip

### Fedora/RHEL/CentOS
- Python 3: `sudo dnf install python3`
- AWS CLI: `sudo dnf install awscli` or use pip

### Arch Linux
- Python: `sudo pacman -S python python-pip`
- AWS CLI: `sudo pacman -S aws-cli`
- AUR: Consider creating an AUR package for easier installation

### openSUSE
- Python: `sudo zypper install python3 python3-pip`
- fzf: `sudo zypper install fzf`

## Troubleshooting

### Command not found

If `awsf` command is not found, ensure `~/.local/bin` is in your PATH:

```bash
echo $PATH | grep -q "$HOME/.local/bin" || echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Desktop entry not appearing

1. Update desktop database:
   ```bash
   update-desktop-database ~/.local/share/applications
   ```

2. Log out and log back in

3. Check if the file exists:
   ```bash
   ls -la ~/.local/share/applications/awsf.desktop
   ```

### Terminal doesn't stay open

If the terminal closes immediately after running, modify the `Exec` line in the `.desktop` file to include `exec bash` at the end.

### Permission denied

Make sure scripts are executable:

```bash
chmod +x scripts/*.sh
chmod +x src/awsf.py
```

## Advanced Integration

### systemd User Service

Create a background service for auto-updating resources:

`~/.config/systemd/user/awsf-update.service`:
```ini
[Unit]
Description=AWSF Resource Update
After=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/bin/python3 /path/to/awsf/scripts/populate_resources.py
```

`~/.config/systemd/user/awsf-update.timer`:
```ini
[Unit]
Description=Update AWSF resources daily

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
```

Enable:
```bash
systemctl --user enable --now awsf-update.timer
```

### Rofi/dmenu Integration

Use AWSF with application launchers:

```bash
# In your launcher command
bash -c "python3 /path/to/awsf/src/awsf.py"
```

## Package Managers (Future)

Plans to support:
- **Debian/Ubuntu**: `.deb` package
- **Fedora/RHEL**: `.rpm` package  
- **Arch Linux**: AUR package
- **Snap**: Universal package
- **Flatpak**: Sandboxed package

---

Need help? [Open an issue](https://github.com/asayed18/awsf/issues) on GitHub!
