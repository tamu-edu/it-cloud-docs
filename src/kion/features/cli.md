# Kion CLI

The Kion Command Line Interface (CLI) is a powerful tool that allows you to access your cloud accounts and manage credentials directly from your terminal. Rather than logging into the Kion web portal and clicking through menus, you can quickly generate temporary credentials, open cloud consoles, and automate cloud access workflows using simple commands.

## Why Use the Kion CLI?

The Kion CLI offers several benefits that make it particularly valuable for teams working with cloud infrastructure:

**Speed and Efficiency**
- Access cloud accounts in seconds without navigating through web interfaces
- Switch between multiple accounts and roles quickly
- Integrate cloud access into scripts and automation workflows

**Developer Productivity**
- Generate temporary AWS credentials for use with the AWS CLI, SDKs, and infrastructure-as-code tools
- Open authenticated cloud console sessions directly from your terminal
- Create "favorites" for frequently-accessed accounts to save even more time

**Security**
- Uses the same secure authentication as the Kion web portal
- Generates short-term credentials that automatically expire (typically 4 hours)
- Supports SAML authentication so you don't need to store API keys
- Credentials are cached securely in your system keychain

**Automation-Friendly**
- Easily integrate with shell scripts, PowerShell scripts, and CI/CD pipelines
- Use as an AWS credential process to automatically refresh credentials
- Run commands against multiple accounts in quick succession

## Getting the Kion CLI

The Kion CLI is available for Windows, macOS, and Linux.

🔗 **[Kion CLI Repository](https://github.com/kionsoftware/kion-cli)**

### Installation on Windows

**Prerequisites:**
- Install [Go programming language](https://go.dev/dl/) (version 1.20 or newer)
- Install [Git for Windows](https://git-scm.com/download/win)

**Quick Install (Windows):**

```powershell
# Clone and build
git clone https://github.com/kionsoftware/kion-cli.git
cd kion-cli
make build-win-amd64

# Move to a permanent location
New-Item -ItemType Directory -Force -Path "C:\Program Files\Kion"
Move-Item kion.exe "C:\Program Files\Kion\kion.exe"

# Add to PATH (as Administrator)
$KionPath = "C:\Program Files\Kion"
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";$KionPath", "Machine")

# Restart PowerShell, then verify
kion --version
```

**Verify it's working:**
```powershell
kion --version
```

You should see the Kion CLI version number. If not, restart PowerShell and try again.

### Installation on macOS

macOS users can use Homebrew for the easiest installation:

```bash
brew install kionsoftware/tap/kion-cli
```

### Installation on Linux

Linux users can download the appropriate binary for their architecture from the [releases page](https://github.com/kionsoftware/kion-cli/releases) and place it in `/usr/local/bin` or another directory in their PATH.

## Configuration

Before using the Kion CLI, you need to configure it with your Kion instance details. There are several ways to authenticate, but we'll focus on the most common methods.

### Creating a Configuration File

The Kion CLI uses a configuration file named `.kion.yml` stored in your home directory. 

**For Windows users**, your home directory is typically `C:\Users\YourUsername\`. Create a file called `.kion.yml` in this location.

**Tip for Windows users:** Windows Explorer may not let you create files starting with a dot. Use PowerShell instead:

```powershell
# Navigate to your home directory
cd ~

# Create the .kion.yml file
New-Item -Path ".kion.yml" -ItemType File

# Open it in Notepad for editing
notepad .kion.yml
```

### Basic Configuration with API Key

The simplest configuration uses an API key from Kion:

```yaml
kion:
  url: https://kion.cloud.tamu.edu
  api_key: YOUR_API_KEY_HERE
  default_region: us-east-1
```

To get your API key:
1. Log into Kion at [kion.cloud.tamu.edu](https://kion.cloud.tamu.edu)
2. Click your username in the upper right
3. Select **API Keys**
4. Click **Create New API Key**
5. Copy the key and paste it into your `.kion.yml` file

### Adding Favorites

Favorites make it even faster to access frequently-used accounts. Add them to your `.kion.yml` file:

```yaml
kion:
  url: https://kion.cloud.tamu.edu
  api_key: YOUR_API_KEY_HERE
  default_region: us-east-1

favorites:
  - name: prod
    account: "111122223333"
    cloud_access_role: ReadOnly
    access_type: cli
  
  - name: dev
    account: "444455556666"
    cloud_access_role: Admin
    access_type: web
```

## Using the Kion CLI

Once installed and configured, you can start using the Kion CLI. Here are the most common workflows:

### Generating Short-Term Access Keys (STAK)

Generate temporary AWS credentials to use with the AWS CLI or other tools:

```powershell
# Interactive mode - you'll be prompted to select an account and role
kion stak

# Specify account and role directly
kion stak --account 111122223333 --car ReadOnly

# Use short flags for faster typing
kion s -a 111122223333 -c ReadOnly
```

This creates an authenticated subshell where environment variables are set with your temporary credentials. Any AWS CLI commands you run will use these credentials.

**Windows PowerShell Note:** The subshell created by `kion stak` will be another PowerShell session. When you're done, type `exit` to return to your original shell.

### Printing Credentials

Sometimes you need to see the credentials without creating a subshell:

```powershell
# Print credentials to the console
kion stak --print --account 111122223333 --car Admin

# Short form
kion s -p -a 111122223333 -c Admin
```

This outputs the AWS credentials in a format you can copy or use in scripts:

```
export AWS_ACCESS_KEY_ID=ASIA...
export AWS_SECRET_ACCESS_KEY=...
export AWS_SESSION_TOKEN=...
```

**For PowerShell**, you would set these differently:

```powershell
# Get credentials from Kion
$creds = kion stak --print --account 111122223333 --car Admin

# Parse and set environment variables in PowerShell
$env:AWS_ACCESS_KEY_ID = "value-from-output"
$env:AWS_SECRET_ACCESS_KEY = "value-from-output"
$env:AWS_SESSION_TOKEN = "value-from-output"
```

### Opening Cloud Consoles

Open an authenticated web console session directly:

```powershell
# Interactive mode - select account and role
kion console

# Direct access
kion console --account 111122223333 --car Admin

# Short form
kion con -a 111122223333 -c Admin
```

This opens your default browser with an authenticated session to the AWS (or Azure/GCP) console.

### Using Favorites

If you've configured favorites, accessing accounts becomes even simpler:

```powershell
# Access a favorite (type depends on access_type in config)
kion fav prod

# List all your favorites
kion fav list

# Force web access for a favorite
kion fav dev --web
```

### Running Commands with Temporary Credentials

Execute a single command with temporary credentials without entering a subshell:

```powershell
# Run an AWS CLI command
kion run --account 111122223333 --car Admin -- aws s3 ls

# Using a favorite
kion run --fav prod -- aws ec2 describe-instances
```

## PowerShell-Specific Tips

### Setting up AWS Credential Process

You can configure the AWS CLI to automatically use Kion to generate credentials:

1. Open or create `~\.aws\config` in your home directory
2. Add a profile that uses Kion as a credential process:

```ini
[profile kion-prod]
credential_process = C:\Program Files\Kion\kion.exe stak --credential-process --account 111122223333 --car ReadOnly

[profile kion-dev]
credential_process = C:\Program Files\Kion\kion.exe fav --credential-process dev
```

Now you can use these profiles with any AWS CLI command:

```powershell
aws s3 ls --profile kion-prod
```

The credentials are automatically generated and refreshed by Kion!

### Creating PowerShell Functions

Add these functions to your PowerShell profile (`$PROFILE`) for even faster access:

```powershell
# Quick access to your most-used account
function kion-prod {
    kion stak --account 111122223333 --car ReadOnly
}

# Open console quickly
function kion-prod-console {
    kion console --account 111122223333 --car ReadOnly
}

# List all favorites
function kion-list {
    kion fav list --verbose
}
```

After adding these and reloading your profile (`& $PROFILE`), you can simply type `kion-prod` to access your production environment.

### Using Environment Variables

Instead of a configuration file, you can use environment variables in PowerShell:

```powershell
# Set in your current session
$env:KION_URL = "https://kion.cloud.tamu.edu"
$env:KION_API_KEY = "your-api-key"

# Or add to your PowerShell profile for persistence
[Environment]::SetEnvironmentVariable("KION_URL", "https://kion.cloud.tamu.edu", "User")
[Environment]::SetEnvironmentVariable("KION_API_KEY", "your-api-key", "User")
```

## Common Workflows

### Scenario 1: Developer Working with AWS CLI

```powershell
# Start your work session
kion stak --account 111122223333 --car Developer

# Now all AWS CLI commands work with your temporary credentials
aws s3 ls
aws ec2 describe-instances
aws lambda list-functions

# When done, exit the subshell
exit
```

### Scenario 2: Infrastructure as Code with Terraform

```powershell
# Generate credentials and run Terraform
kion run --account 111122223333 --car Admin -- terraform apply

# Or use AWS credential process in your backend config
```

### Scenario 3: Quickly Checking Multiple Accounts

```powershell
# Check S3 buckets in production
kion run --fav prod -- aws s3 ls

# Check S3 buckets in development
kion run --fav dev -- aws s3 ls

# Check S3 buckets in staging
kion run --account 777788889999 --car ReadOnly -- aws s3 ls
```

## Troubleshooting

### "kion: command not found" or "kion is not recognized"

- Verify that Kion is in your PATH: `$env:Path -split ';' | Select-String Kion`
- Make sure you restarted PowerShell after modifying the PATH
- Try using the full path to the executable: `& "C:\Program Files\Kion\kion.exe" --version`

### "Unable to open browser" errors

- Make sure you have a default browser configured
- Try using `--saml-print-url` flag if using SAML authentication to copy the URL manually

### Credentials not working

- Check that your API key is valid (log into the Kion web interface)
- Verify your `.kion.yml` file is in your home directory: `Test-Path ~/.kion.yml`
- Try running with `--debug` flag for more information: `kion --debug stak`

### Cache issues

If you're experiencing stale credentials:

```powershell
# Clear the credential cache
kion util flush-cache
```

## Additional Resources

- **Official GitHub Repository:** [github.com/kionsoftware/kion-cli](https://github.com/kionsoftware/kion-cli)
- **Kion Support Center:** [support.kion.io](https://support.kion.io/)
- **Full CLI Documentation:** Available in the GitHub repository's README
- **Technology Services Support:** Contact aip@tamu.edu for TAMU-specific help

## Summary

The Kion CLI transforms how you interact with your cloud accounts, making access faster and more scriptable. For Windows and PowerShell users, the CLI integrates smoothly with your existing workflows once properly installed and configured. Start with simple commands like `kion stak` and `kion console`, then explore favorites and automation as you become more comfortable with the tool.

The investment in learning the CLI pays dividends in time saved and improved security through the use of short-term credentials. Happy cloud computing!
