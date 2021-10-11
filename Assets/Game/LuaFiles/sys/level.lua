-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/10/11 13:21:26                                                                                           
-------------------------------------------------------

---@class level
local level = class('level')

local function getExpByLevel(lv)
    return 10 ^ lv;
end

function level.init()
    print("level init")
end

function level.friendlyLevelMessage(totalExp)
    local lv, exp = level.getLevelMessage(totalExp);
    local ratio = exp / getExpByLevel(lv);
    return lv, ratio;
end

function level.getLevelMessage(totalExp)
    local baseLevel = 1;

    while (true)
    do
        local nextLevelExp = getExpByLevel(baseLevel);
        if (totalExp - nextLevelExp) >= 0 then
            totalExp = totalExp - nextLevelExp;
            baseLevel = baseLevel + 1;
        else
            break
        end
    end

    return baseLevel, totalExp;

end

return level
