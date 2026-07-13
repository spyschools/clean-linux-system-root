# 🧹 Clean Linux System — Root Edition

> **Cleaner tools for Linux Debian**
> Optimized for root-level system maintenance.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-Debian%20%7C%20Ubuntu-blue)](https://www.debian.org/)
[![Shell](https://img.shields.io/badge/shell-bash-89e051)](https://www.gnu.org/software/bash/)

---

## ✨ Features

- 🗂️ **Clean APT cache** — Free up space used by downloaded package files
- 🗑️ **Remove old config files** — Purge leftover configs from uninstalled packages
- 🐧 **Remove old kernels** — Keep only the kernels you need
- 🪣 **Empty every trash** — Wipe all trash directories system-wide

> ⚠️ **This is the Root Version** — Run from the root terminal.

---

## 🚀 Getting Started

Open a **root terminal** and run the following commands:

```bash
# Clone the repository
git clone https://github.com/spyschools/clean-linux-system-root.git

# Navigate into the directory
cd clean-linux-system-root

# Make the script executable
chmod +x *
```

---

## ▶️ Usage

### 🔍 Safe Mode (no deletion)
Preview what will be cleaned without making any changes:

```bash
./clean_system.sh --dry-run
```

### 🧹 Real Cleanup
Run the full cleanup:

```bash
./clean_system.sh
```

---

## 🏠 Home User Version

Looking for a non-root version for everyday home use?

👉 **[clean-linux-system](https://github.com/spyschools/clean-linux-system/)** — Tools for home Linux users

---

## 📋 Requirements

- Debian-based Linux distribution (Debian, Ubuntu, Linux Mint, etc.)
- Root or sudo access
- Bash shell

---

## ⚠️ Disclaimer

Always run `--dry-run` first to review what will be removed before performing the actual cleanup. Use at your own risk.

---

## 📄 License

This project is open source. Contributions and feedback are welcome!
