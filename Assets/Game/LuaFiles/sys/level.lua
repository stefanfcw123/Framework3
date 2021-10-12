-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/10/11 13:21:26                                                                                           
-------------------------------------------------------

---@class level
local level = class('level')

local curLV = 0;

local function getExpByLevel(lv)
    return 10 ^ lv;
end

function level.curLV()
    return curLV;
end

function level.levelUpAward()
    return curLV * 100;
end

function level.gapBonusAward()
    local res = curLV * 500 + math.min(data.chip * 0.01, 1000);
    return integer10(res);
end

function level.init()
    print("level init")
    addEvent(SPIN_START, function()
        save.addLevelExp(5);
        barPanel:RefreshSlider(true);
    end)
    addEvent(LEVEL_UP, function()
        local award = level.levelUpAward();
        local callback = function()
            save.addChip(award);
            thingFly.fly(barPanel:levelAwardTipImageWorldPosition())
        end
        barPanel:levelAwardAnim(string.format_foreign(award), callback)
    end)
    curLV = level.getLevelMessage(data.levelExp);
end

function level.friendlyLevelMessage()
    local lv, exp = level.getLevelMessage(data.levelExp);
    local ratio = exp / getExpByLevel(lv);

    if curLV ~= lv then
        curLV = lv;
        sendEvent(LEVEL_UP)
    end

    return curLV, ratio;
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
