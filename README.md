# mulle.js

Mulle.js is an attempt to recreate a wonderful game from the past and bring it to modern platforms, and fix some issues along the way.

You need to own the original release of Mulle Meck Bygger Bilar to use Mulle.js.

## Linux
Install dependencies
* **Arch Linux:** `sudo pacman -S python python-pip ffmpeg imagemagick nodejs npm`
* **Debian/Ubuntu:** `sudo apt install python3 python3-pip ffmpeg imagemagick nodejs npm optipng`

Python
`sudo pip3 install -r requirements.txt`

Extract assets
```
python3 extract_iso.py [path to iso]
```

You can then generate and start the Mulle.js website, and access it at http://localhost:8080/
```
npm install
npm run build
npm start
```

## Windows
Install dependencies  
Download and install Python3 from https://www.python.org/downloads/  
Download and install imagemagick from https://www.imagemagick.org/script/download.php choose ffmpeg as option during installation

`pip3 install PyTexturePacker pydub bitstring`

Mount Mulle Meck Bygger Bilar ISO  
`python3 extract.py <mounted dir>`

You can then generate and start the Mulle.js website, and access it at http://localhost:8080/
```
npm install
npm run build
npm start
```
## Docker Compose
Download the game ISO for your language (`no`, `sv`, `da`, `fi` or `nl`; requires `pip install requests pyyaml`):
```
python3 build_scripts/build.py sv download-only
```

Build and start the game and the multiplayer server:
```
docker compose up --build
```
The game is served at http://localhost:8080/ and the multiplayer server listens on ws://localhost:8765.
Set `GAME_LANG`, `WEB_PORT`, `SERVER_PORT` or `SERVER_ADDRESS` in the environment or in a `.env` file to override the defaults.
`SERVER_ADDRESS` is the WebSocket URL the browser connects to. The web container writes it to `config.js` on start,
so it can be changed without rebuilding the image.

## Kubernetes (Helm)
Images and the Helm chart are published to GitHub Packages by the workflows in `.github/workflows`:
* `ghcr.io/lacuna-systems/mulle-js:<lang>` (one image per language)
* `ghcr.io/lacuna-systems/mulle-js-server:latest`
* `oci://ghcr.io/lacuna-systems/charts/mulle-js`

```
helm install mulle oci://ghcr.io/lacuna-systems/charts/mulle-js \
  --set web.language=sv --set ingress.enabled=true --set ingress.host=mulle.example.com
```
With ingress enabled, the server is exposed at `/ws` on the same host and the game is configured to connect to it
(`wss://` when `ingress.tls` is set). Set `web.serverAddress` to point the game at a different server.
See `charts/mulle-js/values.yaml` for all options.

## Releasing
Run the **Release** workflow from the Actions tab on `master` and choose `patch`, `minor` or `major` (or enter an explicit version).
It bumps the version in `package.json`, `package-lock.json` and the Helm chart (chart version = app version), commits and tags `vX.Y.Z`,
creates a GitHub release and then starts the image and chart publish workflows on that tag. Released images are tagged
`<lang>-X.Y.Z` (web) and `X.Y.Z` (server), and the chart is published as version `X.Y.Z`.

[![JavaScript Style Guide](https://cdn.rawgit.com/standard/standard/master/badge.svg)](https://github.com/standard/standard)
