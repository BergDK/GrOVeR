#!/bin/sh
set -eu

log() { printf '%s\n' "[grover-hook] $*"; }

PRIMARY_UID="1000"
PRIMARY_GID="1000"
DEFAULT_NAME="grover"
DEFAULT_SHELL="/bin/bash"

# Detect existing UID1000 user (restore-safe: name may be anything)
uid1000_name="$(getent passwd "$PRIMARY_UID" | awk -F: '{print $1}' || true)"

if [ -n "${uid1000_name:-}" ]; then
  PRIMARY_USER="$uid1000_name"
  log "Found existing UID ${PRIMARY_UID} user: ${PRIMARY_USER} (restore-safe). Will NOT create ${DEFAULT_NAME}."
else
  PRIMARY_USER="$DEFAULT_NAME"
  log "No UID ${PRIMARY_UID} user found. Ensuring ${PRIMARY_USER} exists with UID/GID ${PRIMARY_UID}/${PRIMARY_GID}."

  # Ensure primary group exists
  if ! getent group "$PRIMARY_GID" >/dev/null 2>&1; then
    if ! getent group "$PRIMARY_USER" >/dev/null 2>&1; then
      log "Creating group ${PRIMARY_USER} with GID ${PRIMARY_GID}."
      groupadd -g "$PRIMARY_GID" "$PRIMARY_USER"
    else
      # Group name exists but not with our desired GID; create a numeric group if needed
      log "Group name ${PRIMARY_USER} exists. Creating numeric group GID ${PRIMARY_GID} as ${PRIMARY_USER}-gid${PRIMARY_GID}."
      groupadd -g "$PRIMARY_GID" "${PRIMARY_USER}-gid${PRIMARY_GID}"
    fi
  fi

  # If a user named grover exists with different UID, do NOT rename/migrate here (avoid risky edits)
  if getent passwd "$PRIMARY_USER" >/dev/null 2>&1; then
    cur_uid="$(id -u "$PRIMARY_USER")"
    if [ "$cur_uid" != "$PRIMARY_UID" ]; then
      log "User ${PRIMARY_USER} exists but has UID ${cur_uid} (wanted ${PRIMARY_UID}). Not modifying to avoid conflicts."
      log "Please resolve manually OR delete that user from persistence if this is unintended."
      exit 0
    fi
  else
    # Create user with fixed UID/GID
    log "Creating user ${PRIMARY_USER} UID ${PRIMARY_UID}."
    useradd -m -u "$PRIMARY_UID" -g "$PRIMARY_GID" -s "$DEFAULT_SHELL" "$PRIMARY_USER" || true
    # Ensure home exists
    [ -d "/home/$PRIMARY_USER" ] || mkdir -p "/home/$PRIMARY_USER"
    chown -R "$PRIMARY_UID:$PRIMARY_GID" "/home/$PRIMARY_USER" || true
  fi

  # Add to common groups if they exist (safe no-ops)
  for g in sudo wheel audio video plugdev netdev docker kvm libvirt lpadmin dip sambashare wireshark; do
    if getent group "$g" >/dev/null 2>&1; then
      usermod -aG "$g" "$PRIMARY_USER" || true
    fi
  done
fi

log "Primary user resolved as: ${PRIMARY_USER} (UID ${PRIMARY_UID}). Configuring autologin."

# --- Autologin configuration (best-effort, idempotent) ---

# LightDM
if command -v lightdm >/dev/null 2>&1 || [ -d /etc/lightdm ]; then
  mkdir -p /etc/lightdm/lightdm.conf.d
  cat > /etc/lightdm/lightdm.conf.d/99-grover-autologin.conf <<EOF
[Seat:*]
autologin-user=${PRIMARY_USER}
autologin-user-timeout=0
EOF
  log "Configured LightDM autologin for ${PRIMARY_USER}."
fi

# GDM (gdm3)
if [ -f /etc/gdm3/custom.conf ] || [ -d /etc/gdm3 ]; then
  mkdir -p /etc/gdm3
  # Ensure keys exist (append if missing)
  if ! grep -q '^AutomaticLoginEnable=' /etc/gdm3/custom.conf 2>/dev/null; then
    printf '\n[daemon]\nAutomaticLoginEnable=True\nAutomaticLogin=%s\n' "$PRIMARY_USER" >> /etc/gdm3/custom.conf
  else
    sed -i "s/^AutomaticLoginEnable=.*/AutomaticLoginEnable=True/" /etc/gdm3/custom.conf || true
    if grep -q '^AutomaticLogin=' /etc/gdm3/custom.conf; then
      sed -i "s/^AutomaticLogin=.*/AutomaticLogin=${PRIMARY_USER}/" /etc/gdm3/custom.conf || true
    else
      printf 'AutomaticLogin=%s\n' "$PRIMARY_USER" >> /etc/gdm3/custom.conf
    fi
  fi
  log "Configured GDM autologin for ${PRIMARY_USER}."
fi

# SDDM
if [ -d /etc/sddm.conf.d ] || command -v sddm >/dev/null 2>&1; then
  mkdir -p /etc/sddm.conf.d
  cat > /etc/sddm.conf.d/99-grover-autologin.conf <<EOF
[Autologin]
User=${PRIMARY_USER}
Relogin=true
EOF
  log "Configured SDDM autologin for ${PRIMARY_USER}."
fi

# LXDM
if [ -f /etc/lxdm/lxdm.conf ] || command -v lxdm >/dev/null 2>&1; then
  mkdir -p /etc/lxdm
  if [ -f /etc/lxdm/lxdm.conf ]; then
    if grep -q '^autologin=' /etc/lxdm/lxdm.conf; then
      sed -i "s/^autologin=.*/autologin=${PRIMARY_USER}/" /etc/lxdm/lxdm.conf || true
    else
      printf '\nautologin=%s\n' "$PRIMARY_USER" >> /etc/lxdm/lxdm.conf
    fi
  else
    printf 'autologin=%s\n' "$PRIMARY_USER" > /etc/lxdm/lxdm.conf
  fi
  log "Configured LXDM autologin for ${PRIMARY_USER}."
fi

log "Done."
exit 0

