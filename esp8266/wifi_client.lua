local connection_failure_count = 0

function power_down()
    wifi.setmode(wifi.NULLMODE)
end

function connect_wifi(ssid, pass)
    if not (ssid and pass) then
        print('powering down due to missing credentials')
        power_down()
    end

    connection_failure_count = 0
    print('Connecting with credentials: ' .. ssid .. ' ' .. pass)
    wifi.setmode(wifi.STATION)
    wifi.sta.config({
        ssid=ssid,
        pwd=pass,
        save=false
    })
end

function connection_success_handler(event)
    print('Connected to AP! ' .. event.SSID)
    connection_failure_count = nil
end

function ip_acquired_handler(event)
    print('Ip received! ' .. event.IP)
end

function disconnection_handler(event)
    print('WIFI disconnected! ' .. event.reason)
    if event.reason == wifi.eventmon.reason.ASSOC_LEAVE then return end --the station has disassociated from a previously connected AP

    connection_failure_count = connection_failure_count + 1

    if connection_failure_count >= 10 then
        print('powering down due to excessive consecutive failures')
        power_down()
    end
end

wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, connection_success_handler)
wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, ip_acquired_handler)
wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, disconnection_handler)

-- connect_wifi(credential_reader())
print('wifi configured')
