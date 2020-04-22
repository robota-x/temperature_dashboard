function ambient_read(comm_pin)
    local status, temperature, humidity = dht.read(comm_pin)
    if status ~= 0 then
        return -100, -100
    else
        return temperature, humidity
    end
end
