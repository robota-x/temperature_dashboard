dofile('config.lua')

require('ambient_read')
require('wifi_client')
require('data_uploader')

-- local temp, hum = ambient_read(DHT22_PIN)
-- print('temp: ' .. temp .. ' humidity: ' .. hum)

function upload_callback(status, body, headers)
    print('upload callback')

    if status then
        print(status)
    end 
    if body then
        print(body)
    end 
    if headers then
        print(headers)
    end
end

function success_hand(event)
    print('outer success' .. event.IP .. ' : ' .. event.gateway)

    upload_stats(UPLOAD_ENDPOINT, 14, 24, upload_callback)
end

-- upload_stats(UPLOAD_ENDPOINT, 14, 24, upload_callback)

connect_wifi(WIFI_SSID, WIFI_PASSWORD, success_hand)

-- print('now sleeping 10 seconds')
-- node.dsleep(10 * 1000000, 4)
