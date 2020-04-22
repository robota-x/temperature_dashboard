-- function upload_stats(endpoint, temperature, humidity, callback)
--     http.post(
--         endpoint,
--         nil,
--         'Hello friends',
--         callback
--     )
-- end

function upload_ambient_data(endpoint, temperature, humidity)
    print('this would upload ' .. temperature .. ' ' .. humidity .. ' to ' .. endpoint)
end