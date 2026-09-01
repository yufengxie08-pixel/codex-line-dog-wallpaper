# Security

This project does not modify the signed Codex application bundle. It validates the official OpenAI signing identity before using the Node.js runtime bundled with the app. The Chrome DevTools Protocol endpoint is bound to `127.0.0.1` and the injector verifies that the listening process belongs to the signed Codex app.

Please report security issues privately through the repository owner's GitHub profile rather than opening a public issue with sensitive details.
