import {Socket} from 'phoenix'

const socket = new Socket('/socket')
socket.connect()

let channel = socket.channel('universe:default', {})
channel.join()
  .receive('ok', resp => { console.log('Joined successfully', resp) })
  .receive('error', resp => { console.log('Unable to join', resp) })

channel.on('cells', payload => {
  console.log(payload)
})

setTimeout(() => {
  channel.push('init', {width: 100, height: 100})
}, 500)

export default socket
