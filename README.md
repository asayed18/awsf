# AWSF - AWS Fuzzy Finder ☁️

[![GitHub Stars](https://img.shields.io/github/stars/asayed18/awsf?style=social)](https://github.com/asayed18/awsf/stargazers)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python 3.6+](https://img.shields.io/badge/python-3.6+-blue.svg)](https://www.python.org/downloads/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)

[![Ko-fi](https://img.shields.io/badge/Ko--fi-Support%20Me-FF5E5B?logo=ko-fi&logoColor=white)](https://ko-fi.com/asayed18)
[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-Support-FFDD00?logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/asayed18)
[![GitHub Sponsors](https://img.shields.io/badge/GitHub%20Sponsors-Sponsor-EA4AAA?logo=github-sponsors&logoColor=white)](https://github.com/sponsors/asayed18)

> **Tired of the slow, clunky AWS Console search?** Clicking through multiple pages, waiting for searches to load, and navigating endless menus just to find a Lambda function or S3 bucket? 

**AWSF** is your solution - a lightning-fast, keyboard-driven fuzzy finder that brings all your AWS resources to your fingertips. Search Lambda functions, S3 buckets, SQS queues, DynamoDB tables, RDS instances, Kinesis streams, and API Gateway APIs instantly with fuzzy matching. No more frustration, no more waiting - just type and go.

## 🎬 Demo

![AWSF Demo](docs/demo.gif)

> Search, filter, and open AWS resources in seconds with an intuitive fuzzy finder interface.

## ✨ Features

- **🔍 Fuzzy Search**: Lightning-fast fuzzy search across all your AWS resources - no more sluggish console searches
- **🎯 Service-Specific Search**: Target specific AWS services (e.g., `lambda payment`, `s3 media`)
- **🏷️ Environment Detection**: Automatically detects and displays environment indicators (PROD, STAGE, DEV)
- **⚡ Quick Actions**: 
  - Press `Enter` to open resource in AWS Console
  - Press `Ctrl+C` to copy resource URL to clipboard
- **🎛️ Configurable Services**: Enable/disable specific AWS services
- **⚙️ Multi-Region Support**: Configure your preferred AWS region and profile
- **🖥️ Beautiful Interface**: Enhanced fzf interface with preview cards and icons
- **📱 Multiple Access Methods**: CLI, GUI integration, keyboard shortcuts

## 🚀 Supported AWS Services

| Service | Icon | Description |
|---------|------|-------------|
| Lambda | λ | Functions, layers |
| S3 | 🪣 | Buckets |
| SQS | 📬 | Queues |
| Kinesis | 🌊 | Data streams |
| DynamoDB | 🗄️ | Tables |
| RDS | 🗃️ | Instances, clusters |
| API Gateway | 🚪 | REST APIs |

## 📋 Prerequisites

- **Python 3.6+**
- **AWS CLI** configured (`aws configure`) or environment variables
- **fzf** fuzzy finder:
  - macOS: `brew install fzf`
  - Ubuntu/Debian: `sudo apt install fzf`
  - Fedora/RHEL: `sudo dnf install fzf`
  - Arch Linux: `sudo pacman -S fzf`
- **boto3** Python library (`pip install boto3`)

## 🛠️ Installation

### Quick Start

```bash
# Clone the repository
git clone https://github.com/asayed18/awsf.git
cd awsf

# Install dependencies
pip install -r requirements.txt

# Configure AWS (if not already done)
aws configure

# Populate your AWS resources
python3 scripts/populate_resources.py

# Start searching!
./awsf
```

### macOS Integration

```bash
# Add to your shell profile (bash/zsh/fish)
echo 'alias awsf="/path/to/awsf/awsf"' >> ~/.bashrc

# Or create a symlink
ln -s /path/to/awsf/awsf /usr/local/bin/awsf

# Optional: Create app bundle for Spotlight integration
./scripts/create_macos_app.sh
```

### Linux Integration

```bash
# Add to your shell profile
echo 'alias awsf="/path/to/awsf/src/awsf.py"' >> ~/.bashrc

# Or create a symlink
sudo ln -s /path/to/awsf/src/awsf.py /usr/local/bin/awsf

# Optional: Create desktop entry for application menu integration
./scripts/create_linux_desktop.sh

# The script will:
# • Create a .desktop file in ~/.local/share/applications
# • Add AWSF to your application menu
# • Create a launcher in ~/.local/bin/awsf
# • Generate an icon for the app
```

📖 **See [Linux Installation Guide](docs/LINUX_INSTALL.md)** for detailed instructions, desktop environment integration, and troubleshooting.

### System Integration

```bash
# Add to PATH for global access
export PATH="/path/to/awsf:$PATH"

# Reload your shell
source ~/.bashrc  # or ~/.zshrc, ~/.config/fish/config.fish
```

## 🎯 Usage

### Basic Search

```bash
# Interactive mode - search all enabled services
awsf

# Search all services for a term
awsf payment

# Search specific service
awsf lambda auth
awsf s3 media
awsf dynamodb user
```

### Settings and Configuration

```bash
# Open settings menu
awsf --settings

# Quick configuration edit
awsf --config

# Get help
awsf --help
```

### Search Examples

```bash
# Find Lambda functions with "auth" in the name
awsf lambda auth

# Find S3 buckets containing "media"
awsf s3 media

# Find DynamoDB tables with "user" 
awsf dynamodb user

# Search across all services for "api"
awsf api
```

## ⚙️ Configuration

### AWS Configuration

The tool respects your AWS configuration in the following order:

1. **Environment Variables**: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN`
2. **AWS Profile**: Specified in `config/config.json` or via `--profile`
3. **Default AWS Credentials**: From `~/.aws/credentials`

### Application Settings

Edit `config/config.json`:

```json
{
  "aws_region": "us-east-1",
  "aws_profile": "my-profile",
  "console_base_url": "https://console.aws.amazon.com"
}
```

### Service Management

Use the settings menu to enable/disable services:

```bash
awsf --settings
```

Or edit `config/settings.json` directly:

```json
{
  "enabled_services": [
    "lambda",
    "s3", 
    "sqs",
    "kinesis",
    "dynamodb",
    "rds",
    "apigateway"
  ]
}
```

## 🔄 Updating Resources

AWS resources change frequently. Update your local resource cache:

```bash
# Manual update
python3 scripts/populate_resources.py

# Update with specific region/profile
python3 scripts/populate_resources.py --region us-west-2 --profile production

# From settings menu
awsf --settings
# Select option 1: "Repopulate resource list"
```

## 🔐 IAM Permissions

Minimum required IAM permissions for resource discovery:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "lambda:ListFunctions",
                "s3:ListAllMyBuckets",
                "sqs:ListQueues",
                "kinesis:ListStreams",
                "kinesis:DescribeStream",
                "dynamodb:ListTables",
                "dynamodb:DescribeTable",
                "rds:DescribeDBInstances",
                "rds:DescribeDBClusters",
                "apigateway:GET"
            ],
            "Resource": "*"
        }
    ]
}
```

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## 💝 Show Your Support

AWSF is built with ❤️ for the AWS community. If this tool saves you time and makes your workflow smoother:

- ⭐ **Star this repository** - It helps others discover the tool and motivates continued development
- 🐛 **Report issues & ideas** - Your feedback shapes the [roadmap](https://github.com/asayed18/awsf/issues)
- � **Contribute code** - See our [Contributing Guide](CONTRIBUTING.md) to get started
- 💬 **Share your story** - Tweet about how AWSF helps your workflow (tag [@asayed](https://twitter.com/asayed))
- ☕ **Buy me a coffee** - Fuel late-night coding sessions → [Ko-fi](https://ko-fi.com/asayed18) | [Buy Me a Coffee](https://buymeacoffee.com/asayed18)
- 💎 **Become a sponsor** - Support ongoing development → [GitHub Sponsors](https://github.com/sponsors/asayed18)

Every star, issue report, and contribution helps make AWSF better for everyone. Thank you! 🙏

## � Security

See [SECURITY.md](SECURITY.md) for information about reporting security vulnerabilities.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⭐ Star History

If you find this tool useful, please consider giving it a star! It helps others discover the project.

## 🙏 Acknowledgments

- [fzf](https://github.com/junegunn/fzf) - The amazing fuzzy finder that powers our interface
- [boto3](https://github.com/boto/boto3) - AWS SDK for Python

---

Made with ❤️ for the AWS community