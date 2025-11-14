#!/bin/bash
set -e

echo "🚀 AWSF (AWS Fuzzy Finder) Setup"
echo "================================="

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "📁 Project directory: $PROJECT_ROOT"

# Function to print status messages
print_status() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if Python 3 is installed
print_status "Checking Python 3..."
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version 2>&1 | cut -d' ' -f2)
    print_success "Python $PYTHON_VERSION found"
else
    print_error "Python 3 is required but not installed"
    exit 1
fi

# Check if pip is installed
print_status "Checking pip..."
if command -v pip3 &> /dev/null; then
    print_success "pip3 found"
elif command -v pip &> /dev/null; then
    print_success "pip found"
else
    print_error "pip is required but not installed"
    exit 1
fi

# Install Python dependencies
print_status "Installing Python dependencies..."
cd "$PROJECT_ROOT"
if pip3 install -r requirements.txt; then
    print_success "Python dependencies installed"
else
    print_error "Failed to install Python dependencies"
    exit 1
fi

# Check if fzf is installed
print_status "Checking fzf..."
if command -v fzf &> /dev/null; then
    print_success "fzf found"
else
    print_warning "fzf not found - fuzzy search functionality will be limited"
    echo "Install fzf:"
    echo "  macOS:        brew install fzf"
    echo "  Ubuntu/Debian: sudo apt install fzf"
    echo "  Fedora/RHEL:  sudo dnf install fzf"
    echo "  Arch Linux:   sudo pacman -S fzf"
    echo "  Manual:       https://github.com/junegunn/fzf#installation"
fi

# Check AWS CLI
print_status "Checking AWS CLI..."
if command -v aws &> /dev/null; then
    AWS_VERSION=$(aws --version 2>&1 | cut -d' ' -f1)
    print_success "$AWS_VERSION found"
    
    # Check if AWS is configured
    if aws sts get-caller-identity &> /dev/null; then
        print_success "AWS credentials configured"
    else
        print_warning "AWS credentials not configured"
        echo "Run: aws configure"
    fi
else
    print_warning "AWS CLI not found"
    echo "Install AWS CLI: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html"
fi

# Create data directory if it doesn't exist
print_status "Creating data directory..."
mkdir -p "$PROJECT_ROOT/data"
print_success "Data directory created"

# Make scripts executable
print_status "Making scripts executable..."
chmod +x "$PROJECT_ROOT/scripts/"*.py
chmod +x "$PROJECT_ROOT/src/"*.py
if [[ "$OSTYPE" == "darwin"* ]]; then
    chmod +x "$PROJECT_ROOT/scripts/"*.sh
fi
print_success "Scripts are now executable"

# Create shell aliases (optional)
echo ""
echo "📝 Optional: Add shell aliases"
echo "=============================="
echo "Add these lines to your shell profile:"
echo ""
echo "# AWSF (AWS Fuzzy Finder)"
echo "alias awsf='python3 $PROJECT_ROOT/src/awsf.py'"
echo "alias awsf-populate='python3 $PROJECT_ROOT/scripts/populate_resources.py'"
echo ""

# Detect shell and offer to add aliases
SHELL_NAME=$(basename "$SHELL")
case $SHELL_NAME in
    bash)
        PROFILE_FILE="$HOME/.bashrc"
        if [[ "$OSTYPE" == "darwin"* ]]; then
            PROFILE_FILE="$HOME/.bash_profile"
        fi
        ;;
    zsh)
        PROFILE_FILE="$HOME/.zshrc"
        ;;
    fish)
        PROFILE_FILE="$HOME/.config/fish/config.fish"
        ;;
    *)
        PROFILE_FILE=""
        ;;
esac

if [[ -n "$PROFILE_FILE" ]]; then
    echo "Detected $SHELL_NAME shell. Profile file: $PROFILE_FILE"
    read -p "Would you like to add aliases automatically? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "" >> "$PROFILE_FILE"
        echo "# AWS Fuzzy Finder" >> "$PROFILE_FILE"
        if [[ "$SHELL_NAME" == "fish" ]]; then
            echo "alias aws-find 'python3 $PROJECT_ROOT/src/aws_fuzzy_finder.py'" >> "$PROFILE_FILE"
            echo "alias aws-populate 'python3 $PROJECT_ROOT/scripts/populate_resources.py'" >> "$PROFILE_FILE"
        else
            echo "alias aws-find='python3 $PROJECT_ROOT/src/aws_fuzzy_finder.py'" >> "$PROFILE_FILE"
            echo "alias aws-populate='python3 $PROJECT_ROOT/scripts/populate_resources.py'" >> "$PROFILE_FILE"
        fi
        print_success "Aliases added to $PROFILE_FILE"
        echo "Run: source $PROFILE_FILE"
    fi
fi

echo ""
echo "🎉 Setup Complete!"
echo "=================="
echo ""
echo "Next steps:"
echo "1. Configure AWS if not done: aws configure"
echo "2. Populate resources: python3 scripts/populate_resources.py"
echo "3. Start searching: python3 src/awsf.py"
echo ""
echo "Optional enhancements:"
echo "• Install fzf for better fuzzy search experience"
echo "• Add shell aliases for quick access"

# Platform-specific integration
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "• Run scripts/create_macos_app.sh for Spotlight integration (macOS)"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "• Run scripts/create_linux_desktop.sh for application menu integration (Linux)"
fi

echo ""
print_success "AWSF is ready to use!"