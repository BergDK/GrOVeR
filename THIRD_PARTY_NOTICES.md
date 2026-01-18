# Third-Party Notices

This project (GrOVeR) integrates and redistributes a number of third-party
open-source components.

The purpose of this file is to clearly document:
- which upstream projects are used,
- how they are used within GrOVeR,
- and which licenses apply.

This file is descriptive only.
The authoritative licensing terms are those found in the upstream repositories
and in the license texts included under `LICENSES/`.

---

## Boot and firmware-level components

### GNU GRUB
Used as the initial bootloader stage, primarily for legacy BIOS systems and as
a general compatibility fallback.

License: GNU General Public License version 3 (GPLv3).
See `LICENSES/GPL-3.0.txt`.

---

### OpenCorePkg / OpenDuetPkg (Acidanthera)
Used to provide an artificial UEFI environment (DUET) and, optionally, the
OpenCore UEFI bootloader layer.

License: BSD 3-Clause License.
See `LICENSES/BSD-3-Clause.txt`.

---

### EDK II (edk2 / TianoCore)
EDK II provides the underlying UEFI reference implementation used by many UEFI
projects, including DUET-based environments.

Licensing in EDK II is file-based and mixed, primarily BSD-style licenses.
See upstream file headers and `LICENSES/BSD-3-Clause.txt` for the standard text.

---

### rEFInd
Used as a UEFI boot manager providing a straightforward and configurable boot
selection interface.

License: GNU General Public License version 3 (GPLv3).
See `LICENSES/GPL-3.0.txt`.

---

### Ventoy
Used to enable direct booting of operating system installers from ISO files
stored on the DATA partition.

License: GNU General Public License version 3 (GPLv3).
See `LICENSES/GPL-3.0.txt`.

---

### shim
Optionally used as a Secure Boot first-stage loader on systems with Secure Boot
enabled.

License: GNU General Public License version 3 with additional exceptions.
See upstream documentation and the license text provided with shim.

---

## Runtime / userland components

### Alpine Linux
Used as a lightweight recovery and maintenance operating system.

Alpine Linux is a distribution composed of many packages, each under its own
license (commonly GPL, BSD, or MIT). There is no single license covering the
entire distribution.

Refer to Alpine Linux documentation and individual package metadata for details.

---

### Xorg
Used to provide a graphical display server within the Alpine runtime environment.

License: MIT / X11 License.
See `LICENSES/MIT.txt`.

---

### Xfce
Used as a lightweight desktop environment on top of Xorg.

License: GNU General Public License version 2 or later (GPL-2.0+).
See `LICENSES/GPL-2.0.txt`.

---

## General notes

- All third-party components remain the property of their respective authors.
- No upstream project is affiliated with, endorses, or supports GrOVeR.
- Redistribution of binaries may impose additional obligations depending on
  the specific licenses involved.

If you are unsure about license compliance in a specific scenario, consult the
upstream license texts or seek qualified legal advice.

