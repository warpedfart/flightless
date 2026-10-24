# Flight client
Desktop client for the Flight AJ Classic private server.

# Disclaimer
Flight is an unofficial fan project. It is not affiliated with, endorsed by or connected to WildWorks, Inc. or Animal Jam. Animal Jam and Animal Jam Classic are trademarks of WildWorks, Inc.

**Takedown procedure: WildWorks, Inc. or its authorized representatives may request the removal of content, or of Flight as a whole, by writing to legal@burrow.moe. Upon verification of authority, the request will be carried out promptly.**

# Running it
Electron is too large for this repository, so fetch it once first:

- Linux: `./setup.sh`, then `./run.sh`
- Windows: double-click `setup.bat`, then `run.bat`

The setup scripts download Electron 11.5.0 from Electron's GitHub releases and verify its checksum. To build installers, run `npm install` in `installer/` and then `tools/build.sh` (it expects Electron in place, so run the setup first).
