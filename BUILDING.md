# Building Flight

## Run from source
1. `./setup.sh` (Linux) or `setup.bat` (Windows) downloads Electron 11.5.0 and checks its checksum.
2. `./run.sh` or `run.bat`.

## Flash plugin
Flight needs a Pepper Flash plugin from before Adobe's January 2021 shut-off (32.0.0.330). Adobe no longer distributes it, so this repository carries copies in `flash/`:

- `libpepflashplayer.so` (Linux) and `manifest.json`
- `pepflashplayer.dll` (Windows)
- `PepperFlashPlayer.plugin` (macOS)

To use a plugin kept elsewhere, set `AJ_FLASH_PLUGIN` to its path, or pass `--flash <path>` to `tools/build-mac.sh`.

## Installers
- Everything: `cd installer && npm install`, then `tools/fetch-electron.sh linux windows`.
- Linux (AppImage, deb, rpm): `tools/build.sh linux`. Needs `rpmbuild` (`sudo pacman -S rpm-tools`, or `rpm` on Debian).
- Windows (`Flight-Setup.exe`): `tools/build.sh windows`. Needs WSL or `wine` to stamp the icon with `tools/bin/rcedit-x64.exe`.
- macOS (`Flight-macos.dmg`): `tools/build-mac.sh`, on a Mac.
- `--server <url>` bakes a server address into the build (`http://127.0.0.1:8080` to try one locally).

Output goes to `dist/`, along with `RELEASES` and `SHA256SUMS`.

## Client updates
`tools/make-update.js` signs `app/` and writes the update plus `latest.json` into the server's `client-updates/` folder (default `~/ajc-private-server/client-updates`, change with `--out`).

1. Raise `version` in `app/package.json`.
2. Create the signing key once: `mkdir -p ~/.config/burrow && openssl genpkey -algorithm ed25519 -out ~/.config/burrow/update-key.pem`. Keep it private. Installed clients only accept updates signed by the key whose public half is in `app/updater.js`, so a new key means putting its public key there (`openssl pkey -in key.pem -pubout`) and shipping a new installer.
3. `tools/make-update.js`, then commit and push the server.
