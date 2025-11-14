#!/bin/bash
set -e

echo "🐧 Creating Linux Desktop Integration for AWSF"
echo "=============================================="

# Color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Get directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Desktop entry details
APP_NAME="AWSF"
DESKTOP_FILE="$HOME/.local/share/applications/awsf.desktop"
ICON_FILE="$HOME/.local/share/icons/awsf.png"

# Detect terminal emulator
detect_terminal() {
    # List of common terminal emulators in order of preference
    local terminals=("gnome-terminal" "konsole" "xfce4-terminal" "terminator" "xterm" "alacritty" "kitty" "tilix" "mate-terminal")
    
    for term in "${terminals[@]}"; do
        if command -v "$term" &> /dev/null; then
            echo "$term"
            return 0
        fi
    done
    
    echo "x-terminal-emulator"
}

TERMINAL=$(detect_terminal)
print_status "Detected terminal: $TERMINAL"

# Create necessary directories
print_status "Creating directories..."
mkdir -p "$HOME/.local/share/applications"
mkdir -p "$HOME/.local/share/icons"

# Create a simple icon (text-based for now)
print_status "Creating icon..."
if command -v convert &> /dev/null; then
    # If ImageMagick is installed, create a nice icon
    convert -size 256x256 xc:transparent \
        -font DejaVu-Sans-Bold -pointsize 120 \
        -fill '#FF9900' -annotate +50+180 'AWS' \
        -fill '#232F3E' -pointsize 60 -annotate +80+230 'F' \
        "$ICON_FILE" 2>/dev/null && print_success "Icon created with ImageMagick"
else
    # Fallback: Create a simple SVG icon
    cat > "${ICON_FILE%.png}.svg" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<svg width="256" height="256" xmlns="http://www.w3.org/2000/svg">
  <rect width="256" height="256" fill="#232F3E" rx="20"/>
  <text x="128" y="140" font-family="sans-serif" font-size="100" fill="#FF9900" text-anchor="middle" font-weight="bold">AWS</text>
  <text x="128" y="200" font-family="sans-serif" font-size="60" fill="#FF9900" text-anchor="middle">F</text>
</svg>
EOF
    ICON_FILE="${ICON_FILE%.png}.svg"
    print_warning "ImageMagick not found, created SVG icon instead"
fi

# Determine terminal command based on detected terminal
case $TERMINAL in
    gnome-terminal|mate-terminal)
        EXEC_CMD="$TERMINAL -- bash -c 'cd \"$PROJECT_ROOT\" && python3 src/awsf.py; exec bash'"
        ;;
    konsole)
        EXEC_CMD="$TERMINAL --workdir \"$PROJECT_ROOT\" -e bash -c 'python3 src/awsf.py; exec bash'"
        ;;
    xfce4-terminal|terminator|tilix)
        EXEC_CMD="$TERMINAL --working-directory=\"$PROJECT_ROOT\" -e 'bash -c \"python3 src/awsf.py; exec bash\"'"
        ;;
    alacritty)
        EXEC_CMD="$TERMINAL --working-directory \"$PROJECT_ROOT\" -e bash -c 'python3 src/awsf.py; exec bash'"
        ;;
    kitty)
        EXEC_CMD="$TERMINAL --directory \"$PROJECT_ROOT\" bash -c 'python3 src/awsf.py; exec bash'"
        ;;
    *)
        EXEC_CMD="$TERMINAL -e 'bash -c \"cd $PROJECT_ROOT && python3 src/awsf.py; exec bash\"'"
        ;;
esac

# Create .desktop file
print_status "Creating desktop entry..."
cat > "$DESKTOP_FILE" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=AWSF - AWS Fuzzy Finder
Comment=Fuzzy search tool for AWS resources
Exec=$EXEC_CMD
Icon=$ICON_FILE
Terminal=true
Categories=Development;Utility;
Keywords=AWS;Cloud;DevOps;Lambda;S3;Search;
StartupNotify=true
EOF

# Make desktop file executable
chmod +x "$DESKTOP_FILE"

print_success "Desktop entry created at: $DESKTOP_FILE"

# Update desktop database
print_status "Updating desktop database..."
if command -v update-desktop-database &> /dev/null; then
    update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true
    print_success "Desktop database updated"
else
    print_warning "update-desktop-database not found, you may need to log out and back in"
fi

# Create a launcher script for convenience
LAUNCHER_SCRIPT="$HOME/.local/bin/awsf"
print_status "Creating launcher script..."

mkdir -p "$HOME/.local/bin"
cat > "$LAUNCHER_SCRIPT" << EOF
#!/bin/bash
cd "$PROJECT_ROOT"
python3 src/awsf.py "\$@"
EOF

chmod +x "$LAUNCHER_SCRIPT"
print_success "Launcher created at: $LAUNCHER_SCRIPT"

# Check if ~/.local/bin is in PATH
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    print_warning "~/.local/bin is not in your PATH"
    echo ""
    echo "Add this to your shell profile (~/.bashrc, ~/.zshrc, or ~/.config/fish/config.fish):"
    echo ""
    echo "export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo ""
fi

print_success "Linux desktop integration setup complete!"
echo ""
echo "🎉 You can now:"
echo "• Find 'AWSF - AWS Fuzzy Finder' in your application menu"
echo "• Run 'awsf' from any terminal (if ~/.local/bin is in PATH)"
echo "• Pin it to your favorites/dock for quick access"
echo ""
echo "💡 Tips:"
echo "• The app will open in your default terminal emulator"
echo "• You can create a keyboard shortcut in your desktop settings"
echo "• For better integration, install 'imagemagick' for a nicer icon"
