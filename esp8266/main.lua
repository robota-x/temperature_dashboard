dofile('wifi_off.lua')

require('ambient_read')
local temp, hum = ambient_read(1)
print('temp: ' .. temp .. ' humidity: ' .. hum)

require('wifi_client')
local ssid, pass = credential_reader()
connect_wifi(ssid, pass)

-- print('now sleeping 10 seconds')
-- node.dsleep(10 * 1000000, 4)
