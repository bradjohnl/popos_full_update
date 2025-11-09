# fullupdate
![Shell Script](https://img.shields.io/badge/Shell_Script-121011?style=for-the-badge&logo=gnu-bash&logoColor=white)
![CI/CD](https://img.shields.io/badge/CI%2FCD-Pending-yellow?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)

A comprehensive system update script for Debian/Ubuntu-based distributions (Ubuntu, Pop!_OS, Linux Mint, etc.) with conditional execution and safety features.

## Features
- **Config-driven updates** via `.fullupdate_config.yaml`
- **Timeshift snapshot** integration pre-update
- **Color-coded output** for better readability
- **Modular architecture** with dependency checks
- **Conditional execution** of update sections
- **Error handling** with clean exit codes

## Requirements
- `yq` (YAML processor): Install with:
  ```bash
  sudo apt install yq || sudo snap install yq
  ```

## Installation
```bash
git clone https://github.com/bradjohnl/popos_full_update.git
cd popos_full_update
chmod +x fullupdate
```

## Configuration
1. Edit `.fullupdate_config.yaml` to enable/disable sections:
```yaml
sections:
  apt: 
    enable: true
    autoclean: true
    autoremove: true
  fwupdmgr: true
  flatpak: 
    enable: true
    repair: true

timeshift:
  enable: true
  comment: "Pre-update snapshot"
  tags: [update, automated]
```

## Usage
```bash
# Run with default config
./fullupdate

# Run with custom config
./fullupdate -c /path/to/config.yaml

# Run specific sections only (apt, flatpak, git_repos)
./fullupdate -s apt,flatpak,git_repos

# Run all sections (overrides config)
./fullupdate -s all

# Skip all sections (only runs timeshift if enabled)
./fullupdate -s none

# Start from flatpak updates and run all subsequent components
./fullupdate -f flatpak

# Start from git_repos using environment variable
FULLUPDATE_FROM=git_repos ./fullupdate

# Use environment variables to control sections
FULLUPDATE_APT=0 FULLUPDATE_FLATPAK=1 ./fullupdate
```

### Command-line Options
- `-c CONFIG_FILE`: Path to custom config file (default: .fullupdate_config.yaml)
- `-s SECTIONS`: Comma-separated sections to run (overrides config). Available sections:
  - `apt`: APT package updates
  - `fwupdmgr`: Firmware updates
  - `flatpak`: Flatpak updates
  - `snap`: Snap updates
  - `vim_plugins`: Vim plugin updates
  - `git_repos`: Git repository updates
  - `all`: Run all sections
  - `none`: Skip all sections
- `-f START_FROM`: Start from this component and run all subsequent components:
  - `apt`: Start from APT updates
  - `fwupdmgr`: Start from firmware updates
  - `flatpak`: Start from Flatpak updates
  - `snap`: Start from Snap updates
  - `vim_plugins`: Start from Vim plugins
  - `git_repos`: Start from Git repositories
- `-h`: Show help message
- `-v`: Show version

### Environment Variables
You can control sections using environment variables:
- `FULLUPDATE_<SECTION>`: Control individual sections
  - Set to `1` or `true` to enable
  - Set to `0` or `false` to disable
- `FULLUPDATE_FROM`: Start from a specific component (same values as `-f` option)

Examples:
```bash
# Disable APT updates, enable Flatpak updates
FULLUPDATE_APT=0 FULLUPDATE_FLATPAK=1 ./fullupdate

# Start from flatpak updates
FULLUPDATE_FROM=flatpak ./fullupdate

# Start from git_repos and disable timeshift
FULLUPDATE_FROM=git_repos FULLUPDATE_TIMESHIFT=0 ./fullupdate
```

### Precedence Rules
1. Environment variables have highest precedence
2. Command-line options (`-s`, `-f`) come next
3. Config file settings are used last

## Troubleshooting
**Missing yq error**:  
Install yq via apt or snap as shown in Requirements section.

**Permission denied**:  
Ensure the script is executable: `chmod +x fullupdate`

**Config file not found**:  
The script will use default settings if no config is found.

## Roadmap
- [ ] AppImage update support
- [ ] Obsidian plugin updates
- [ ] CI/CD pipeline integration
- [x] Command-line section selection (v1.2)
- [x] Start from specific component (v1.3)

## Credits
Inspired by [Linux Installation Guides](https://mutschler.eu/linux/install-guides/pop-os-post-install/)
