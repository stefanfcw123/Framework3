-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/9/10 16:12:24                                                                                           
-------------------------------------------------------
---@class save
local save = class("save");

function save.init()
    save.load();
end

function save.addLevelExp(exp)
    data.levelExp = data.levelExp + exp;
end

function save.addChip(n)
    local success;
    if n >= 0 then
        success = true;
    else
        if (data.chip + n) >= 0 then
            success = true;
        else
            success = false;
        end
    end

    if success then
        if n >= 0 then
            sendEvent(CHIP_CHANGE, data.chip, data.chip + n, true);
        else
            sendEvent(CHIP_CHANGE, data.chip, data.chip + n, false);
        end
        data.chip = data.chip + n;
    end

    return success;
end

function save.save()
    local data_str = string.serialize(data);
    UnityEngine.PlayerPrefs.SetString("player_data", data_str);
end

function save.load()
    local data_str = UnityEngine.PlayerPrefs.GetString("player_data", "");
    if data_str == "" then
        data = {
            chip = 10000,
            _musicEnable = true,
            _soundEnable = true,
            gapBonusStamp = 0,
            loginStamp = 0,
            loginLv = 0,
            levelExp = 9,
        }
    else
        data = string.unserialize(data_str);
    end
end

return save
