-- import settings
dofile('config.lua')

-- import functionality helpers
require('ambient_read')
require('wifi_client')
require('data_uploader')


function deep_sleep()
    node.dsleep(CYCLE_INTERVAL_SECONDS * 1000000)
end

function save_ambient_data()
    print('in save_ambient_data')
    local temperature, humidity = ambient_read(DHT22_PIN)
    print(temperature, humidity)
    upload_ambient_data(UPLOAD_ENDPOINT, temperature, humidity, deep_sleep)
end

function main()
    print('initialising wifi')
    connect_wifi(WIFI_SSID, WIFI_PASSWORD, save_ambient_data)
end
