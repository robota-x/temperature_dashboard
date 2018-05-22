require('ambient_read')
require('wifi_client')

local temp, hum = ambient_read(DHT22_PIN)
print('temp: ' .. temp .. ' humidity: ' .. hum)

connect_wifi(WIFI_SSID, WIFI_PASSWORD)

-- print('now sleeping 10 seconds')
-- node.dsleep(10 * 1000000, 4)
