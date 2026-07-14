#!/usr/bin/env bash

###############################################################################
# File    : clean_system.sh
# Author  : Spy Schools - Fariz Azhari
# Purpose : Linux System Cleaner
###############################################################################

set +e

echo "==========================================="
echo "        Linux System Cleaner"
echo "==========================================="
echo ""

# Pastikan dijalankan sebagai root
if [[ $EUID -ne 0 ]]; then
    echo "Jalankan menggunakan sudo:"
    echo "sudo ./clean_system.sh"
    exit 1
fi

echo "[1/14] Membersihkan Journal Log..."
journalctl --vacuum-time=5d
journalctl --vacuum-size=1G

echo ""
echo "[2/14] Mengecek proses APT..."
ps aux | grep apt

echo ""
echo "[3/14] Menghapus lock APT & cache..."
rm -f /var/cache/apt/pkgcache.bin
rm -f /var/cache/apt/srcpkgcache.bin
rm -f /var/lib/apt/lists/lock
rm -f /var/cache/apt/archives/lock
rm -f /var/lib/dpkg/lock-frontend
rm -f /var/lib/dpkg/lock

echo ""
echo "[4/14] Membersihkan daftar repository..."
rm -vf /var/lib/apt/lists/*
rm -rf /var/lib/apt/lists/*

echo ""
echo "[5/14] Memperbaiki package yang rusak..."
dpkg --configure -a

echo ""
echo "[6/14] Membersihkan cache Go..."
go clean -modcache 2>/dev/null
rm -rf "$HOME/go/pkg/mod"
rm -rf "$HOME/.cache/go-build"

echo ""
echo "[7/14] Membersihkan cache NodeJS..."
rm -rf node_modules
rm -f package-lock.json
rm -rf "$HOME/.npm"

echo ""
echo "[8/14] Membersihkan cache Python..."
pip3 cache purge 2>/dev/null

echo ""
echo "[9/14] Membersihkan cache Browser..."
rm -rf "$HOME/.cache/google-chrome/"
rm -rf "$HOME/.config/google-chrome/"

rm -rf "$HOME/.cache/mozilla/firefox/"
rm -rf "$HOME/.mozilla/firefox/"

rm -rf "$HOME/.cache/chromium/"
rm -rf "$HOME/.config/chromium/"

echo ""
echo "[10/14] Membersihkan Trash & Cache User..."
rm -rf "$HOME/.local/share/Trash/"*
rm -rf "$HOME/.cache/"*
rm -rf "$HOME/.cache/thumbnails/"*

echo ""
echo "[11/14] Membersihkan Temporary Files..."
rm -rf /tmp/*
rm -rf /var/tmp/*

echo ""
echo "[12/14] Membersihkan Log Lama..."
rm -rf /var/log/*.gz
rm -rf /var/log/*.old

echo ""
echo "[13/14] Membersihkan Package APT..."
apt clean
apt autoclean
apt autoremove --purge -y
apt autopurge -y

rm -rf "$HOME/.cache/"*
rm -rf /var/cache/*

echo ""
echo "Menghapus paket konfigurasi sisa..."
dpkg --purge $(dpkg -l | awk '/^rc/{print $2}') 2>/dev/null

echo ""
echo "[14/14] Membersihkan Riwayat..."
rm -f "$HOME/.local/share/recently-used.xbel"
touch "$HOME/.local/share/recently-used.xbel"

rm -f "$HOME/.bash_history"
rm -f "$HOME/.zsh_history"

history -c
history -w

echo ""
echo "==========================================="
echo "      System Cleanup Selesai"
echo "==========================================="
echo ""
echo "Disarankan menjalankan:"
echo "sudo apt update"
echo "sudo apt upgrade"
echo ""