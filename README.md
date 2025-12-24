# papyloagentbot

Minimal static-site repository served by a tiny Node server for local development.

Run locally

1. Ensure Node.js (v16+) is installed.
2. Start the server:

```bash
npm start
# or to use a different port:
PORT=8080 npm start
```

This will serve the repository root and return `index.html` for `/`.

Files added by this setup:
- `package.json` — start script
- `server.js` — small static file server
- `.gitignore`

Open http://localhost:3000/ (or the port you set) in your browser.

Capacitor Android build (standalone APK)

This project can be wrapped with Capacitor to produce an Android APK that loads the local `index.html`.

Prerequisites:
- Node.js and `npm`
- Java JDK and Android SDK (Android Studio recommended)

Quick steps:

```bash
# 1. Install dependencies
npm install

# 2. Prepare web assets for Capacitor
npm run build:web

# 3. Initialize and add Android (first-time only)
npx cap init --web-dir=www PapyloAgentBot com.papyloagentbot.app
npx cap add android

# 4. Sync and open Android Studio
npm run cap:sync
npm run cap:open:android
```

In Android Studio open the `android` project, then build an APK (`Build > Build Bundle(s) / APK(s) > Build APK(s)`) or run via an attached device.

Advanced (command-line) unsigned release build:

```bash
cd android
./gradlew assembleRelease
# APK will be in app/build/outputs/apk/release/
```

If you want, I can attempt to run `npm install` and `npx cap add android` here — note that building the APK requires Android SDK and is not available in the dev container by default.