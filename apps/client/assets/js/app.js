import 'phoenix_html'

import socket from './socket'
import { roundToMultiple } from './utils'

const { clientWidth, clientHeight } = document.getElementById('app')
const $canvas = document.getElementById('canvas')
const $ctx = $canvas.getContext('2d')

const RATE = 210
const SCALE = 10
const WIDTH = roundToMultiple(clientWidth, SCALE)
const HEIGHT = roundToMultiple(clientHeight, SCALE)

function getPixelRatio (ctx) {
  const devicePixelRatio = window.devicePixelRatio || 1
  const backingStoreRatio = ctx.webkitBackingStorePixelRatio ||
    ctx.mozBackingStorePixelRatio ||
    ctx.msBackingStorePixelRatio ||
    ctx.oBackingStorePixelRatio ||
    ctx.backingStorePixelRatio || 1

  return devicePixelRatio / backingStoreRatio
}

function setupCanvas (canvas, ctx, width, height) {
  const ratio = getPixelRatio(ctx)

  canvas.width = width * ratio
  canvas.height = height * ratio
  canvas.style.width = `${width}px`
  canvas.style.height = `${height}px`
  ctx.fillStyle = 'rgb(0, 0, 0)'
  ctx.scale(ratio, ratio)
}

function initUniverse (channel) {
  channel.push('init', {
    width: WIDTH / SCALE,
    height: HEIGHT / SCALE
  })
  setInterval(() => channel.push('tick'), RATE)
}

function render ({cells}) {
  $ctx.clearRect(0, 0, $canvas.width, $canvas.height)
  cells.forEach(({x, y, state}) => {
    $ctx.fillRect(x * SCALE, y * SCALE, SCALE, SCALE)
  })
}

function setupChannel () {
  const channel = socket.channel('universe:default', {})

  channel.join()
    .receive('ok', initUniverse.bind(null, channel))
    .receive('error', console.log.bind(null, 'error:channel'))

  channel.on('cells', render)
}

setupCanvas($canvas, $ctx, WIDTH, HEIGHT)
setupChannel()
