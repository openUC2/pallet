# rpi-imswitch-os

This is the standard operating system used on Raspberry Pi computers in openUC2 devices; we call it
"ImSwitch OS".

This repo is both the [Forklift](https://github.com/PlanktoScope/forklift) pallet for the OS, and
the automated build system for creating OS images which can be flasshed onto SD cards for booting
Raspberry Pi computers in the OS.

## Usage

These are usage instructions for developers.

### Integrating changes in ImSwitch

1. Commit and push your changes to the [openUC2/ImSwitch](https://github.com/openUC2/ImSwitch) repo.

2. Wait for GitHub Actions to finish automatically building a new Docker container image from your
   commit.

3. Open <https://github.com/orgs/openUC2/packages/container/package/imswitch-noqt> and find the
   tagged image version (e.g.
   [sha-0c335c4](https://github.com/orgs/openUC2/packages/container/imswitch-noqt/557815319?tag=sha-0c335c4))
   corresponding to the commit you just pushed (e.g.
   [0c335c4](https://github.com/openUC2/ImSwitch/commit/0c335c4a0383a7feb75dff531706de7397402140))

4. In this repo, manually edit the
   [deployments/imswitch.pkg/compose.yml](./deployments/imswitch.pkg/compose.yml)
   file's `services.imswitch-noqt.image` value, which should be of format
   `ghcr.io/openuc2/imswitch-noqt:{something}`, to replace `{something}` (which may look like
   `sha-0c335c4` or like `sha-0c335c4@sha256:{a very long hash}`) with the tagged image version
   (e.g. `sha:0c335c4`). The result should look something like:

   ```
   image: ghcr.io/openuc2/imswitch-noqt:sha-0c335c4
   ```

   If the ImSwitch container image you want to use is the most-recently-built container image in any
   branch of the openUC2/ImSwitch repo, then
   you could instead just manually trigger a run of this repo's
   [updatecli-compose action](https://github.com/openUC2/rpi-imswitch-os/actions/workflows/updatecli-compose.yml)
   and then merge the pull request which that action should create. This way, you wouldn't have to
   manually edit any files.

5. Commit and push your changes to this repo.

Now you are ready to deploy these changes as an OS update to your machine running ImSwitch OS.

### Deploying an OS update to your machine

1. Once you've booted your machine into ImSwitch OS, from a terminal (either the Cockpit terminal or
   an SSH remote session) you can run the following command to upgrade the local pallet to the
   latest commit on the main branch:

   ```
   forklift plt upgrade
   ```

   If it gives you a warning that you may have changes in your local pallet which have not been
   committed/pushed up to GitHub, but you're sure that you won't lose any important changes by
   wiping your local pallet, then you should run:

   ```
   forklift plt upgrade --force
   ```

2. To apply all changes in the upgraded local pallet (including changes to OS configuration files),
   you should reboot.

   To immediately apply changes to Docker apps before you reboot, you can run:

   ```
   sudo systemctl restart forklift-apply
   ```

   If you are in an SSH session or you are in a GNU screen or byobu session in the Cockpit terminal,
   the following command will also work instead as an equivalent substitute to the above command:

   ```
   forklift stage apply
   ```

### Migrating from [openUC2/pallet]

The pallet in this repo used to be called `github.com/openUC2/pallet`. On machines deployed with
older versions of this OS (i.e. versions built by the now-archived
[openUC2/imswitch-os](https://github.com/openUC2/imswitch-os) repo), you should run the following
command before running any `forklift plt upgrade` commands:

```
forklift plt set-upgrade-query github.com/openUC2/rpi-imswitch-os@main
```

Then, your next OS upgrade will need to be done using the following command:

```
forklift plt upgrade --allow-downgrade --force
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
