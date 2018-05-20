print('power up, starting main.lua in 2000ms')

function init_job()
    dofile('main.lua')
end

tmr.create():alarm(2000, tmr.ALARM_SINGLE, init_job)
