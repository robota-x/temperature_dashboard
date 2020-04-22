function upload_ambient_data(endpoint, api_token, temperature, humidity, callback)
    print('uploading: ' .. temperature .. 'C ' .. humidity .. '% to ' .. endpoint)

    local auth_header = 'Authorisation: Bearer ' .. api_token .. '\r\n'
    local payload = temperature .. ' ' .. humidity
    http.post(
        endpoint,
        auth_header,
        payload,
        callback
    )
end