function upload_ambient_data(endpoint, api_token, temperature, humidity, callback)
    print('uploading: ' .. temperature .. 'C ' .. humidity .. '% to ' .. endpoint)

    local auth_header = 'Authorisation: Bearer ' .. api_token .. '\r\n'
    http.post(
        endpoint,
        auth_header,
        'Hello friends',
        callback
    )
end