"use strict";

// electron-builder's settings for the linux packages (the windows wizard is
// flight.nsi). tools/build.sh hands over the staged app, the electron to use
// and where to put the result.
const path = require("path");

const root = path.join(__dirname, "..");
const flash = path.join(root, "flash");

module.exports = {
  appId: "software.burrow.client",
  productName: "Flight",
  copyright: "",
  electronVersion: "11.5.0",
  electronDist: process.env.BURROW_ELECTRON,
  directories: {app: process.env.BURROW_APP, output: process.env.BURROW_OUT},
  // the client finds flash beside its own folder (app/main.js), so no asar
  asar: false,
  npmRebuild: false,
  nodeGypRebuild: false,
  publish: null,
  // the .deb and .rpm want a homepage and a maintainer; the server's address
  // stands in when the build was given one
  extraMetadata: {
    // the package's name in apt and dnf
    name: "flight",
    homepage: process.env.BURROW_HOMEPAGE || "https://ajfeetpics.art",
    author: {name: "Flight", email: "burrow@burrow.moe"},
    desktopName: "flight.desktop",
  },

  // burrow:// links, from the account page's "Sign in with the Flight
  // client" (the .desktop file's MimeType; app/main.js asks for them too)
  protocols: [{name: "Flight", schemes: ["burrow"]}],

  linux: {
    target: [{target: "AppImage", arch: ["x64"]}, {target: "deb", arch: ["x64"]}, {target: "rpm", arch: ["x64"]}],
    icon: path.join(root, "app", "icon.png"),
    category: "Game",
    maintainer: "Flight",
    synopsis: "The client for the Flight server",
    description: "The client for Flight, an AJ Classic private server.",
    executableName: "flight",
    // the 2019 flash plugin cannot start inside chromium's sandbox on linux
    executableArgs: ["--no-sandbox"],
    extraResources: [{from: flash, to: "flash", filter: ["libpepflashplayer.so", "manifest.json"]}],
  },
  appImage: {artifactName: "Flight-x86_64.AppImage"},
  deb: {artifactName: "flight_amd64.deb"},
  rpm: {artifactName: "flight.x86_64.rpm"},
};
