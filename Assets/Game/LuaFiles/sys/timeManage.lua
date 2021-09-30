-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/9/28 16:28:06                                                                                           
-------------------------------------------------------

---@class timeManage
local timeManage = class('timeManage')

local gapBonusInterval;

local function nowTimeStamp()
    return math.floor(CS.TimeHelper.GetNowTimeStamp());
end

function timeManage.init()
    print("timeManage init")

    if GAPBONUS_QUICK then
        gapBonusInterval = MINUTE;
    else
        gapBonusInterval = HOUR;
    end

    addEvent(LOAD_OVER, function()
        timeManage.startSendTimeStamp();
    end)
    addEvent(GET_GAP_BONUS, function()
        data.gapBonusStamp = nowTimeStamp()
        save.save();
    end)

end

function timeManage.startSendTimeStamp()
    local cs_coroutine = (require 'functions.cs_coroutine');
    cs_coroutine.start(function()
        while true do
            timeManage.SendTIME_STAMP();
            coroutine.yield(CS.UnityEngine.WaitForSeconds(1))
        end
    end)
end

function timeManage.SendTIME_STAMP()
    local osTime = nowTimeStamp();
    sendEvent(TIME_STAMP, gapBonusInterval - (osTime - data.gapBonusStamp))
    --print(osTime, data.gapBonusStamp, gapBonusInterval - (osTime - data.gapBonusStamp))
end

function timeManage.canGapBonus(residueTimeStamp)
    if residueTimeStamp <= 0 then
        return true;
    end
    return false;
end

return timeManage