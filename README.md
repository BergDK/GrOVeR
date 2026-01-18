# GrOVeR

**GrOVeR** is a modular boot platform designed to combine multiple well-known
open-source boot technologies into a single, coherent, and reproducible setup.

The name **GrOVeR** is an acronym acknowledging the core technologies used:

- **Gr** — **GRUB**
- **O** — **OpenCore**
- **Ve** — **Ventoy**
- **R** — **rEFInd**

The name is intended as technical recognition of these projects.
It does **not** imply affiliation with or endorsement by any upstream authors.

## Design Rationale

GrOVeR is a modular boot platform created to address a practical need:
a single, portable solution capable of booting **anything, everywhere** —
on both legacy BIOS and modern UEFI systems.

The project is designed to serve multiple real-world use cases:

- A permanent reusable boot device for personal systems
- A troubleshooting and repair toolkit
- A multipurpose USB device usable without carrying a laptop
- A multi-OS installation medium

GrOVeR is intentionally designed as a **boot Swiss‑army knife**.

### Boot Infrastructure Choices

**GRUB** is used as the first-stage bootloader due to its exceptional hardware
compatibility and maturity. Both BIOS and UEFI variants are used under the same
GNU GRUB project and licensing.

**OpenCorePkg**, together with **OpenDuetPkg**, is used to create a controlled,
artificial UEFI environment and to provide a strong, well-maintained UEFI
bootloader independent of OEM firmware limitations.

**Ventoy** enables direct installation and booting from ISO images placed on the
DATA partition, reducing rebuild complexity.

**rEFInd** provides a clean, customizable UEFI boot manager with clear visual
selection and flexible chainloading.

**shimx64** is optionally used to enable Secure Boot compatibility where required.

### Runtime Environment

**Alpine Linux**, combined with **Xorg** and **XFCE**, provides a lightweight,
user-friendly runtime environment for troubleshooting, diagnostics, downloads,
and light interactive work.

GrOVeR uses persistent storage for Alpine Linux configuration and system state.
A dedicated download directory resides on the DATA partition to separate user data
from boot infrastructure.

Users should be aware that excessive write activity may increase USB media wear.
GrOVeR is intended for targeted operational use, not continuous heavy workloads.

## Credits and Acknowledgements

This project is made possible by the following upstream projects:

- GNU GRUB (GPLv3+)
- OpenCorePkg / OpenDuetPkg by Acidanthera (BSD-style)
- EDK2 (BSD-style)
- rEFInd (GPL/BSD mix)
- Ventoy (GPLv3)
- shim (GPLv3 with exception)
- Alpine Linux (various libre licenses)
- Xorg (MIT/X11)
- XFCE (GPLv2+)

All third‑party components remain under their respective original licenses.
GrOVeR is an independent downstream project and is not affiliated with or
endorsed by any upstream project.

## Licensing

Original scripts, configuration, and documentation authored for GrOVeR are
licensed separately under the MIT License. See the LICENSE file for details.
Third‑party licenses are preserved in the LICENSES directory.
