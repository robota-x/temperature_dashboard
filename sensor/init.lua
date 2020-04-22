print('power up, starting main.lua in 2000ms')
require('main')

tmr.create():alarm(2000, tmr.ALARM_SINGLE, main)
