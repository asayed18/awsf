# Installation Guide

## Quick Start

### 1. Clone and Setup

```bash
git clone https://github.com/yourusername/awsf.git
cd awsf
./scripts/setup.sh
```

### 2. Configure AWS

```bash
aws configure
```

### 3. Populate Resources

```bash
python3 scripts/populate_resources.py
```

### 4. Start Searching

```bash
awsf
```

## Platform-Specific Installation

### macOS

```bash
# Install dependencies
brew install fzf python3

# Clone and setup
git clone https://github.com/asayed18/awsf.git
cd awsf
./scripts/setup.sh

# Optional: Create app bundle for Spotlight
./scripts/create_macos_app.sh
```

### Linux

```bash
# Install dependencies (Ubuntu/Debian)
sudo apt update
sudo apt install python3 python3-pip fzf awscli

# Or Fedora/RHEL
sudo dnf install python3 python3-pip fzf awscli

# Or Arch Linux
sudo pacman -S python python-pip fzf aws-cli

# Clone and setup
git clone https://github.com/asayed18/awsf.git
cd awsf
./scripts/setup.sh

# Optional: Create desktop entry for application menu
./scripts/create_linux_desktop.sh
```

📖 **For detailed Linux integration**, see [Linux Installation Guide](LINUX_INSTALL.md)

### Ubuntu/Debian

```bash
# Install dependencies
sudo apt update
sudo apt install python3 python3-pip fzf awscli

# Clone and setup
git clone https://github.com/asayed18/awsf.git
cd awsf
./scripts/setup.sh
```

### Amazon Linux

```bash
# Install dependencies
sudo yum install python3 python3-pip
sudo yum install fzf  # or install manually
pip3 install awscli

# Clone and setup
git clone https://github.com/asayed18/awsf.git
cd awsf
./scripts/setup.sh
```

### Manual Installation

If the setup script doesn't work for your system:

```bash
# 1. Install Python dependencies
pip3 install boto3

# 2. Install fzf (see: https://github.com/junegunn/fzf#installation)

# 3. Install AWS CLI (see: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

# 4. Configure AWS
aws configure

# 5. Make scripts executable
chmod +x scripts/*.py src/*.py

# 6. Create directories
mkdir -p data config

# 7. Create default config
cat > config/config.json << 'EOF'
{
  "aws_region": "us-east-1",
  "aws_profile": null,
  "console_base_url": "https://console.aws.amazon.com"
}
EOF

# 8. Create default settings
cat > config/settings.json << 'EOF'
{
  "enabled_services": [
    "lambda", "s3", "sqs", "kinesis", 
    "dynamodb", "rds", "apigateway"
  ]
}
EOF
```

## Configuration

### AWS Credentials

The tool works with any of these AWS credential methods:

1. **Environment Variables**:
   ```bash
   export AWS_ACCESS_KEY_ID="your-key-id"
   export AWS_SECRET_ACCESS_KEY="your-secret-key" 
   export AWS_SESSION_TOKEN="your-session-token"  # if using STS
   ```

2. **AWS CLI Configuration**:
   ```bash
   aws configure
   ```

3. **AWS Profile**:
   ```bash
   aws configure --profile myprofile
   # Then edit config/config.json to use the profile
   ```

4. **IAM Roles** (EC2/ECS/Lambda):
   - Automatically detected when running on AWS infrastructure

### Region Configuration

Edit `config/config.json`:

```json
{
  "aws_region": "us-west-2",
  "aws_profile": "production", 
  "console_base_url": "https://console.aws.amazon.com"
}
```

## Shell Integration

### Bash

Add to `~/.bashrc`:

```bash
alias awsf='python3 /path/to/awsf/src/awsf.py'
alias awsf-populate='python3 /path/to/awsf/scripts/populate_resources.py'
```

### Zsh

Add to `~/.zshrc`:

```bash
alias awsf='python3 /path/to/awsf/src/awsf.py'
alias awsf-populate='python3 /path/to/awsf/scripts/populate_resources.py'
```

### Fish

Add to `~/.config/fish/config.fish`:

```fish
alias awsf 'python3 /path/to/awsf/src/awsf.py'
alias awsf-populate 'python3 /path/to/awsf/scripts/populate_resources.py'
```

## Verification

Test your installation:

```bash
# Test AWS credentials
aws sts get-caller-identity

# Test Python dependencies
python3 -c "import boto3; print('boto3 OK')"

# Test fzf
echo -e "test\nlines" | fzf

# Test the tool
awsf --help
```

## Troubleshooting

### Common Issues

**Permission denied errors**:
```bash
chmod +x scripts/*.py src/*.py
```

**Python module not found**:
```bash
pip3 install boto3
# or
python3 -m pip install boto3
```

**fzf not found**:
```bash
# macOS
brew install fzf

# Ubuntu
sudo apt install fzf

# Manual install
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

**AWS credentials error**:
```bash
aws configure
# or set environment variables
export AWS_ACCESS_KEY_ID="your-key"
export AWS_SECRET_ACCESS_KEY="your-secret"
```

### Getting Help

If you encounter issues:

1. Check the [troubleshooting section](README.md#troubleshooting) in the main README
2. [Open an issue](https://github.com/yourusername/awsf/issues) with:
   - Your operating system
   - Python version (`python3 --version`)
   - Error messages
   - Steps to reproduce