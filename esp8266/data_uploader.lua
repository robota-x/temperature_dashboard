function upload_stats(endpoint, temperature, humidity, callback)
    http.post(
        endpoint,
        nil,
        'Hello friends',
        callback
    )
end