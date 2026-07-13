#!/bin/bash
# Ubuntu/Linux System Cleanup Script with Safe Mode (--dry-run)
# Automatically performs cleanup of cache, logs, and unused packages

DRYRUN=false
if [[ "$1" == "--dry-run" ]]; then
    DRYRUN=true
    echo "[SAFE MODE] Showing files to be deleted without actually removing them."
fi

run_cmd() {
    if $DRYRUN; then
        echo "[SIMULATION] Would run: $*"
    else
        eval "$@"
    fi
}

echo "[INFO] Starting system cleanup..."

# 1. Clean systemd logs
echo "[INFO] Cleaning journalctl logs..."
if ! $DRYRUN; then
    journalctl --vacuum-time=5d
    journalctl --vacuum-size=1G
else
    echo "[SIMULATION] journalctl --vacuum-time=5d"
    echo "[SIMULATION] journalctl --vacuum-size=1G"
fi

# 2. Check running apt processes
echo "[INFO] Checking for running apt processes..."
ps aux | grep apt

# 3. Remove apt cache and locks
echo "[INFO] Removing apt cache and lock files..."
run_cmd "rm -f /var/cache/apt/pkgcache.bin"
run_cmd "rm -f /var/cache/apt/srcpkgcache.bin"
run_cmd "rm -f /var/lib/apt/lists/lock"
run_cmd "rm -f /var/cache/apt/archives/lock"
run_cmd "rm -rf /var/lib/apt/lists/*"
run_cmd "rm -f /var/lib/dpkg/lock-frontend"
run_cmd "rm -f /var/lib/dpkg/lock"

# 4. Reconfigure dpkg
echo "[INFO] Reconfiguring packages..."
if ! $DRYRUN; then
    dpkg --configure -a
else
    echo "[SIMULATION] dpkg --configure -a"
fi

# 5. Clear browser caches
echo "[INFO] Removing browser caches..."
run_cmd "rm -rf ~/.cache/mozilla/firefox/"
run_cmd "rm -rf ~/.cache/google-chrome/"
run_cmd "rm -rf ~/.mozilla/firefox/*.default-release/storage/*"
run_cmd "rm -rf ~/.mozilla/firefox/*.default-release/cache/*"
run_cmd "rm -rf ~/.config/google-chrome/Default/Cache/*"
run_cmd "rm -rf ~/.config/chromium/Default/Cache/*"

# 6. Clear trash, general cache, and thumbnails
echo "[INFO] Removing trash and cache..."
run_cmd "rm -rf ~/.local/share/Trash/* 2>/dev/null"
run_cmd "rm -rf ~/.cache/* 2>/dev/null"
run_cmd "rm -rf ~/.cache/thumbnails/* 2>/dev/null"

# 7. Clean temporary folders
echo "[INFO] Removing temporary files..."
run_cmd "rm -rf /tmp/*"
run_cmd "rm -rf /var/tmp/*"

# 8. Remove old logs
echo "[INFO] Removing old log files..."
run_cmd "rm -rf /var/log/*.gz /var/log/*.old"

# 9. Remove unused packages
echo "[INFO] Cleaning up unused packages..."
if ! $DRYRUN; then
    apt autoremove -y
    apt remove -y
    apt autoclean -y
    apt clean -y
    apt autopurge -y
    apt purge -y
else
    echo "[SIMULATION] apt autoremove -y"
    echo "[SIMULATION] apt remove -y"
    echo "[SIMULATION] apt autoclean -y"
    echo "[SIMULATION] apt clean -y"
    echo "[SIMULATION] apt autopurge -y"
    echo "[SIMULATION] apt purge -y"
fi

# 10. Bersihkan cache pip
echo "[INFO] Membersihkan cache pip3..."
run_cmd "pip3 cache purge"

# 11. Bersihkan ulang cache apt & folder cache umum (lapisan tambahan)
echo "[INFO] Membersihkan ulang cache apt dan folder cache..."
run_cmd "apt clean"
run_cmd "apt autoclean"
run_cmd "apt autoremove --purge -y"
run_cmd "rm -rf ~/.cache/* 2>/dev/null"
run_cmd "rm -rf /var/cache/* 2>/dev/null"

# 12. Hapus paket dengan status 'rc' (sudah dihapus tapi config-nya masih ada)
echo "[INFO] Menghapus sisa config paket berstatus 'rc'..."
if $DRYRUN; then
    RC_PKGS=$(dpkg -l | awk '/^rc/{print $2}')
    if [[ -n "$RC_PKGS" ]]; then
        echo "[SIMULATION] Would run: dpkg --purge $RC_PKGS"
    else
        echo "[SIMULATION] Tidak ada paket berstatus 'rc' untuk dipurge."
    fi
else
    RC_PKGS=$(dpkg -l | awk '/^rc/{print $2}')
    if [[ -n "$RC_PKGS" ]]; then
        dpkg --purge $RC_PKGS
    fi
fi

# 13. Bersihkan history shell (bash & zsh)
echo "[INFO] Membersihkan history shell..."
run_cmd "rm -f ~/.bash_history"
run_cmd "rm -f ~/.zsh_history"
if $DRYRUN; then
    echo "[SIMULATION] history -c && history -w (jika berjalan di shell interaktif)"
    echo "[SIMULATION] cat /dev/null > ~/.bash_history"
else
    # history -c/-w hanya valid di shell interaktif dengan HISTFILE ter-set;
    # skrip yang dijalankan via './script.sh' berjalan non-interaktif, jadi ini di-skip agar tidak error.
    if [[ -n "$HISTFILE" ]]; then
        history -c && history -w
    fi
    cat /dev/null > ~/.bash_history 2>/dev/null
fi

# 14. Reset daftar 'recently used' (recently-used.xbel)
echo "[INFO] Mereset daftar recently-used.xbel..."
run_cmd "rm -f ~/.local/share/recently-used.xbel"
run_cmd "touch ~/.local/share/recently-used.xbel"

echo "[DONE] System cleanup completed!"
