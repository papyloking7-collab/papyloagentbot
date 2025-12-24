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