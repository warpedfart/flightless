"use strict";

const { ipcRenderer, contextBridge } = require("electron");

const sendWhitelist = new Set()
  .add("initialized")
  .add("fps")
  .add("openPage")
  .add("browser")
  .add("ownVideo")
  .add("presence")
  .add("printImage")
  .add("reloadGame")
  .add("reportError")
  .add("signupCompleted");

const receiveWhitelist = new Set()
  .add("flashVarsReady")
  .add("hud")
  .add("ownVideoReady")
  .add("browserSupported")
  .add("browserState")
  .add("removed");

contextBridge.exposeInMainWorld(
  "ipc", {
    sendToHost: (channel, ...args) => {
      if (sendWhitelist.has(channel)) {
        ipcRenderer.sendToHost(channel, ...args);
      }
    },
    on: (channel, listener) => {
      if (receiveWhitelist.has(channel)) {
        ipcRenderer.on(channel, listener);
      }
    }
  }
);

ipcRenderer.on("redirect-url", (event, url) => {
  console.log("REDIRECT");
});
