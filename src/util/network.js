/**
 * MulleNet
 * @module network
 */

class MulleNet {
  constructor (game) {
    this.game = game
  }

  connect () {
    if (this.connected) {
      console.error('Already connected')
      return false
    }

    var address = process.env.NODE_ENV !== 'production' ? this.game.mulle.networkDevServer : this.game.mulle.networkServer

    // Runtime config (config.js, written by the Docker entrypoint) takes precedence over the build-time address
    var serverAddress = window.mulleConfig?.serverAddress || process.env.SERVER_ADDRESS || 'ws://' + address

    console.log('[network]', 'connect', serverAddress)
    this.socket = new WebSocket(serverAddress)

    // launch on connect
    this.socket.addEventListener('open', (event) => {
      console.log('[network]', 'connected')
    })

    this.socket.addEventListener('close', (event) => {
      console.warn('[network]', 'disconnected', event)
      this.socket = null
    })

    this.socket.addEventListener('message', (msg) => {
      var msg = JSON.parse(event.data)

      if (msg.error) {
        alert(msg.error)
      }

      if (msg.message) {
        alert(msg.message)
      }
    })
  }

  disconnect () {
    this.socket.close()
  }

  send (data) {
    if (!this.socket) return false

    if (this.socket.readyState !== WebSocket.OPEN) {
      console.debug('[network]', 'offline', data)
      return false
    }

    console.debug('[network]', 'send', data)

    this.socket.send(JSON.stringify(data))
  }

  get connected () {
    return this.socket && this.socket.readyState === WebSocket.OPEN
  }
}

export default MulleNet
