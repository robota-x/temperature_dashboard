function upload_data(temperature, humidity, callback)
    http.post(
        UPLOAD_ENDPOINT,
        nil,
        'Hello friends',
        function(code, data) return callback() end
    )
end