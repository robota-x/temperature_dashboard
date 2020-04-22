local connection_failure_count = 0

function power_down()
    wifi.setmode(wifi.NULLMODE)
end

function connect_wifi(ssid, pass, ready_callback)
    if not (ssid and pass) then
        print('powering down due to missing credentials')

        power_down()
    end

    connection_failure_count = 0

    wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, disconnection_handler)
    wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, connection_success_handler)
    wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, get_ready_handler(ready_callback))
    
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

function get_ready_handler(ready_callback)
    return function(event)
        print('Ip received! ' .. event.IP)

        if ready_callback ~= nil then
            ready_callback(event)
        end
    end
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

print('wifi configured')
