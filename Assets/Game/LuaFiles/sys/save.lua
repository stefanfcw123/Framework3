-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/9/10 16:12:24                                                                                           
-------------------------------------------------------
---@class save
local save = class("save");

function save.init()
    save.load();
    data = save.getData();
end

function save.getData()
    return save.player_data;
end

function save.save()
    local data_str = string.serialize(save.player_data);
    UnityEngine.PlayerPrefs.SetString("player_data", data_str);
end

function save.load()
    local data_str = UnityEngine.PlayerPrefs.GetString("player_data", "");
    if data_str == "" then
        save.player_data = {
            money = 1,
        }
    else
        save.player_data = string.unserialize(data_str);
    end
end

return save
