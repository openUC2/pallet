# rpi-imswitch-os

This is the standard operating system used on Raspberry Pi computers in openUC2 devices; we call it
"ImSwitch OS".

This repo is both the [Forklift](https://github.com/PlanktoScope/forklift) pallet for the OS, and
the automated build system for creating OS images which can be flasshed onto SD cards for booting
Raspberry Pi computers in the OS.

## Usage

### For developers

Once you've booted into the OS, from a terminal (either the Cockpit terminal or an SSH remote
session) you can run the following command to upgrade the local pallet to the latest commit on the
main branch:

```
forklift plt upgrade
```

If it gives you a warning that you may have changes in your local pallet which have not been
committed/pushed up to GitHub, but you're sure that you won't lose any important changes by wiping
your local pallet, then you should run:

```
forklift plt upgrade --force
```

To apply all changes in the upgraded local pallet (including changes to OS configuration files),
you should reboot. To immediately apply changes to Docker apps before you reboot, you can run:

```
sudo systemctl restart forklift-apply
```

If you are in an SSH session or you are in a GNU screen or byobu session in the Cockpit terminal,
the following command will also work instead as an equivalent substitute to the above command:

```
forklift stage apply
```

## Licensing

Any source code provided with this Forklift pallet is covered by the following information, except
where otherwise indicated (see also notes below on imported files & dependencies):

**Copyright openUC2 project contributors**

SPDX-License-Identifier: `MIT`

You can use the source code provided here under the
[MIT License](https://spdx.org/licenses/MIT.html).

### Imported Files & Dependencies

Forklift packages deployed by this pallet have their own software licenses, as specified in the
declaration files for those packages.
