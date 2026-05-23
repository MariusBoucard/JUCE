#!/usr/bin/env bash
# ==============================================================================
#  BallzzyDsp Installer
#  Installs the VST3 plugin and standalone application on Linux
# ==============================================================================

set -euo pipefail

# ── Colours ───────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# ── Config (edit these to match your build output paths) ──────────────────────
PLUGIN_NAME="BallzzyDelay"
PLUGIN_SRC="./builds/Release/BallzzyDelay.vst3"          # path to your built .vst3 bundle
STANDALONE_SRC="./builds/Release/StandaloneApp/BallzzyDelay"           # path to your built standalone binary

PLUGIN_INSTALL_DIR="${HOME}/plugins/${PLUGIN_NAME}"
STANDALONE_INSTALL_DIR="${HOME}/.local/bin"
DESKTOP_ENTRY_DIR="${HOME}/.local/share/applications"

# ── Helpers ───────────────────────────────────────────────────────────────────
print_header() {
    echo ""
    echo -e "${CYAN}${BOLD}╔══════════════════════════════════════════╗${RESET}"
    echo -e "${CYAN}${BOLD}║        BallzzyDelay Installer v1.0         ║${RESET}"
    echo -e "${CYAN}${BOLD}╚══════════════════════════════════════════╝${RESET}"
    echo ""
}

info()    { echo -e "  ${CYAN}→${RESET}  $*"; }
success() { echo -e "  ${GREEN}✔${RESET}  $*"; }
warn()    { echo -e "  ${YELLOW}⚠${RESET}  $*"; }
error()   { echo -e "  ${RED}✖${RESET}  $*" >&2; }
die()     { error "$*"; exit 1; }

confirm() {
    local prompt="$1"
    local answer
    read -rp "$(echo -e "  ${YELLOW}?${RESET}  ${prompt} [Y/n]: ")" answer
    [[ -z "$answer" || "$answer" =~ ^[Yy]$ ]]
}

# ── Pre-flight checks ─────────────────────────────────────────────────────────
check_sources() {
    info "Checking build artefacts…"

    if [[ ! -e "$PLUGIN_SRC" ]]; then
        die "VST3 bundle not found: ${PLUGIN_SRC}
       Please run this installer from the directory containing your build output,
       or edit PLUGIN_SRC at the top of this script."
    fi

    if [[ ! -e "$STANDALONE_SRC" ]]; then
        die "Standalone binary not found: ${STANDALONE_SRC}
       Please run this installer from the directory containing your build output,
       or edit STANDALONE_SRC at the top of this script."
    fi

    success "Build artefacts found."
}

# ── Installation steps ────────────────────────────────────────────────────────
install_plugin() {
    info "Installing VST3 plugin to:  ${PLUGIN_INSTALL_DIR}"
    mkdir -p "${PLUGIN_INSTALL_DIR}"

    # Remove old version cleanly before copying
    rm -rf "${PLUGIN_INSTALL_DIR:?}/"*

    cp -r "${PLUGIN_SRC}" "${PLUGIN_INSTALL_DIR}/"
    success "VST3 plugin installed."
}

install_standalone() {
    info "Installing standalone app to:  ${STANDALONE_INSTALL_DIR}"
    mkdir -p "${STANDALONE_INSTALL_DIR}"

    cp "${STANDALONE_SRC}" "${STANDALONE_INSTALL_DIR}/${PLUGIN_NAME}"
    chmod +x "${STANDALONE_INSTALL_DIR}/${PLUGIN_NAME}"
    success "Standalone app installed."
}

create_desktop_entry() {
    info "Creating .desktop launcher…"
    mkdir -p "${DESKTOP_ENTRY_DIR}"

    cat > "${DESKTOP_ENTRY_DIR}/${PLUGIN_NAME}.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=${PLUGIN_NAME}
Comment=${PLUGIN_NAME} Audio Plugin (Standalone)
Exec=${STANDALONE_INSTALL_DIR}/${PLUGIN_NAME}
Icon=audio-x-generic
Terminal=false
Categories=AudioVideo;Audio;Music;
Keywords=audio;plugin;dsp;vst;
EOF

    # Let the desktop environment pick up the new entry
    if command -v update-desktop-database &>/dev/null; then
        update-desktop-database "${DESKTOP_ENTRY_DIR}" 2>/dev/null || true
    fi

    success ".desktop entry created."
}

add_to_path_hint() {
    # Warn if ~/.local/bin is not already in PATH
    if [[ ":$PATH:" != *":${STANDALONE_INSTALL_DIR}:"* ]]; then
        warn "${STANDALONE_INSTALL_DIR} is not in your PATH."
        echo ""
        echo -e "       Add this line to your ${BOLD}~/.bashrc${RESET} (or ~/.zshrc):"
        echo -e "       ${CYAN}export PATH=\"\$HOME/.local/bin:\$PATH\"${RESET}"
        echo ""
        echo -e "       Then reload your shell:  ${CYAN}source ~/.bashrc${RESET}"
        echo ""
    fi
}

# ── Uninstaller ───────────────────────────────────────────────────────────────
uninstall() {
    echo ""
    warn "Uninstalling ${PLUGIN_NAME}…"

    local removed=0

    if [[ -d "$PLUGIN_INSTALL_DIR" ]]; then
        rm -rf "${PLUGIN_INSTALL_DIR}"
        success "Removed plugin dir: ${PLUGIN_INSTALL_DIR}"
        removed=1
    fi

    if [[ -f "${STANDALONE_INSTALL_DIR}/${PLUGIN_NAME}" ]]; then
        rm -f "${STANDALONE_INSTALL_DIR}/${PLUGIN_NAME}"
        success "Removed standalone: ${STANDALONE_INSTALL_DIR}/${PLUGIN_NAME}"
        removed=1
    fi

    if [[ -f "${DESKTOP_ENTRY_DIR}/${PLUGIN_NAME}.desktop" ]]; then
        rm -f "${DESKTOP_ENTRY_DIR}/${PLUGIN_NAME}.desktop"
        success "Removed .desktop entry."
        removed=1
    fi

    if [[ $removed -eq 0 ]]; then
        info "Nothing to remove — ${PLUGIN_NAME} was not installed."
    else
        echo ""
        success "${PLUGIN_NAME} has been uninstalled."
    fi
    echo ""
    exit 0
}

# ── Summary ───────────────────────────────────────────────────────────────────
print_summary() {
    echo ""
    echo -e "${GREEN}${BOLD}  ✔  Installation complete!${RESET}"
    echo ""
    echo -e "  ${BOLD}VST3 plugin${RESET}  →  ${PLUGIN_INSTALL_DIR}/"
    echo -e "  ${BOLD}Standalone${RESET}   →  ${STANDALONE_INSTALL_DIR}/${PLUGIN_NAME}"
    echo -e "  ${BOLD}Launcher${RESET}     →  ${DESKTOP_ENTRY_DIR}/${PLUGIN_NAME}.desktop"
    echo ""
    echo -e "  Point your DAW's VST3 scan path to:"
    echo -e "  ${CYAN}${PLUGIN_INSTALL_DIR}${RESET}"
    echo ""
}

# ── Entry point ───────────────────────────────────────────────────────────────
main() {
    print_header

    # Handle --uninstall flag
    if [[ "${1:-}" == "--uninstall" ]]; then
        uninstall
    fi

    # Show what will happen and ask for confirmation
    echo -e "  This will install ${BOLD}${PLUGIN_NAME}${RESET} to:"
    echo -e "    • VST3 plugin  →  ${CYAN}${PLUGIN_INSTALL_DIR}/${RESET}"
    echo -e "    • Standalone   →  ${CYAN}${STANDALONE_INSTALL_DIR}/${PLUGIN_NAME}${RESET}"
    echo -e "    • App launcher →  ${CYAN}${DESKTOP_ENTRY_DIR}/${PLUGIN_NAME}.desktop${RESET}"
    echo ""

    confirm "Proceed with installation?" || { echo "  Aborted."; exit 0; }
    echo ""

    check_sources
    install_plugin
    install_standalone
    create_desktop_entry
    add_to_path_hint
    print_summary
}

main "$@"
