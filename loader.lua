local game_id = globals.game_id()

http.get("https://raw.githubusercontent.com/kylosilly/blehblah/refs/heads/main/scripts/"..game_id..".lua", function(v)
    local success, results = loadstring(v)()
    if success then
        results()
    else
        print(results)
    end
end)
