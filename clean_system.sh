#!/usr/bin/env bash

# ==================================================
# clean_system.sh
# Linux System Cleaner
# Author : Spy Schools - Fariz Azhari
# Version: 06.2026
# ==================================================

set +e

GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
BLUE="\e[34m"
RESET="\e[0m"

echo -e "${BLUE}"
echo "==============================================="
echo "        Linux System Cleaner v6.0"
echo "==============================================="
echo -e "${RESET}"

# Check if the script is running as root
if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}Please run this script using sudo.${RESET}"
    echo "Example:"
    echo "sudo bash clean_system.sh"
    exit 1
fi

run() {
    echo -e "\n${YELLOW}>> $1${RESET}"
    eval "$2"
}

echo -e "${GREEN}Starting system cleanup...${RESET}"

########################################
# System Journal
########################################

run "Cleaning journal logs older than 5 days..." \
"journalctl --vacuum-time=5d"

run "Limiting journal size to 1 GB..." \
"journalctl --vacuum-size=1G"

########################################
# APT Package Manager
########################################

run "Checking APT processes..." \
"ps aux | grep apt"

run "Removing APT package cache..." \
"rm -f /var/cache/apt/pkgcache.bin"

run "Removing APT source cache..." \
"rm -f /var/cache/apt/srcpkgcache.bin"

run "Removing APT lock files..." \
"rm -f /var/lib/apt/lists/lock"

run "Removing APT archive lock..." \
"rm -f /var/cache/apt/archives/lock"

run "Removing DPKG frontend lock..." \
"rm -f /var/lib/dpkg/lock-frontend"

run "Removing DPKG lock..." \
"rm -f /var/lib/dpkg/lock"

run "Removing APT package lists..." \
"rm -rf /var/lib/apt/lists/*"

run "Reconfiguring DPKG..." \
"dpkg --configure -a"

########################################
# Go Cache
########################################

if command -v go >/dev/null 2>&1; then
    run "Cleaning Go module cache..." \
    "go clean -modcache"

    run "Removing Go module directory..." \
    "rm -rf \$HOME/go/pkg/mod"

    run "Removing Go build cache..." \
    "rm -rf \$HOME/.cache/go-build"
fi

########################################
# Node.js
########################################

run "Removing all node_modules directories..." \
"find \$HOME -type d -name node_modules -prune -exec rm -rf {} + 2>/dev/null"

run "Removing package-lock.json files..." \
"find \$HOME -type f -name package-lock.json -delete 2>/dev/null"

run "Removing NPM cache..." \
"rm -rf \$HOME/.npm"

########################################
# Python
########################################

if command -v pip3 >/dev/null 2>&1; then
    run "Cleaning pip cache..." \
    "pip3 cache purge"
fi

########################################
# Web Browsers
########################################

run "Removing Google Chrome cache..." \
"rm -rf \$HOME/.cache/google-chrome/ \$HOME/.config/google-chrome/"

run "Removing Mozilla Firefox cache..." \
"rm -rf \$HOME/.cache/mozilla/firefox/ \$HOME/.mozilla/firefox/"

run "Removing Chromium cache..." \
"rm -rf \$HOME/.cache/chromium/ \$HOME/.config/chromium/"

########################################
# User Cache
########################################

run "Emptying Trash..." \
"rm -rf \$HOME/.local/share/Trash/*"

run "Removing user cache..." \
"rm -rf \$HOME/.cache/*"

run "Removing thumbnail cache..." \
"rm -rf \$HOME/.cache/thumbnails/*"

########################################
# Temporary Files
########################################

run "Cleaning /tmp directory..." \
"rm -rf /tmp/*"

run "Cleaning /var/tmp directory..." \
"rm -rf /var/tmp/*"

########################################
# System Logs
########################################

run "Removing old log files..." \
"rm -f /var/log/*.gz /var/log/*.old"

########################################
# APT Cleanup
########################################

run "Running apt clean..." \
"apt clean"

run "Running apt autoclean..." \
"apt autoclean"

run "Running apt autoremove..." \
"apt autoremove --purge -y"

run "Removing system cache..." \
"rm -rf /var/cache/*"

run "Purging residual package configurations..." \
"dpkg --purge \$(dpkg -l | awk '/^rc/{print \$2}')"

run "Running apt autopurge..." \
"apt autopurge -y"

########################################
# Recent Files
########################################

run "Clearing recently used files list..." \
"rm -f \$HOME/.local/share/recently-used.xbel && touch \$HOME/.local/share/recently-used.xbel"

########################################
# Shell History
########################################

run "Removing Bash history..." \
"rm -f \$HOME/.bash_history"

run "Removing Zsh history..." \
"rm -f \$HOME/.zsh_history"

run "Clearing current shell history..." \
"history -c"

run "Saving empty history..." \
"history -w"

echo
echo -e "${GREEN}"
echo "=============================================="
echo "     System Cleanup Completed Successfully!"
echo "=============================================="
echo -e "${RESET}"