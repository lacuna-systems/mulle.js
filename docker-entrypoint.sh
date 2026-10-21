#!/bin/sh
# Write runtime configuration for the game, read by src/util/network.js.
# SERVER_ADDRESS is the WebSocket URL the browser connects to (e.g. wss://mulle.example.com/ws).
# When empty, the address baked in at build time (or the game's default) is used.
set -e
escaped=$(printf '%s' "${SERVER_ADDRESS:-}" | sed 's/\\/\\\\/g; s/"/\\"/g')
printf 'window.mulleConfig = { serverAddress: "%s" }\n' "$escaped" > /usr/local/apache2/htdocs/config.js
exec "$@"
