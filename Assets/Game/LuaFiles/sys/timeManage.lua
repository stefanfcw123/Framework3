-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/9/28 16:28:06                                                                                           
-------------------------------------------------------

---@class timeManage
local timeManage = class('timeManage')

local gapBonusInterval;
local loginInterval;

local function nowTimeStamp()
    return math.floor(CS.TimeHelper.GetNowTimeStamp());
end

local loginMaxLv = 7;
function timeManage.init()
    print("timeManage init")

    if GAPBONUS_QUICK then
        gapBonusInterval = 35;
    else
        gapBonusInterval = HOUR;
    end

    if LOGIN_QUICK then
        loginInterval = 5;
    else
        loginInterval = DAY;
    end

    addEvent(LOAD_OVER, function()
        timeManage.startSendTimeStamp();
        if data.loginLv < loginMaxLv then
            timeManage.showLogin()
        end
    end)
    addEvent(GET_GAP_BONUS, function()
        data.gapBonusStamp = nowTimeStamp()
        save.save();
        save.addChip(level.gapBonusAward());
    end)
    --login = require("base.login").new();
end

function timeManage.collectAward()
    data.loginLv = data.loginLv + 1;
    data.loginStamp = nowTimeStamp();
    save.addChip(timeManage.loginTotalBonus());
    save.save();
end

function timeManage.loginDayNum()
    return data.loginLv + 1;
end

function timeManage.loginBonus()
    return 500;
end

function timeManage.loginMultiple()
    return timeManage.loginDayNum() * 1;
end

function timeManage.loginTotalBonus()
    return timeManage.loginBonus() * timeManage.loginMultiple();
end

function timeManage.showLogin()
    local stampFixed = loginInterval - (nowTimeStamp() - data.loginStamp);
    local isShow = stampFixed <= 0 and true or false;

    if isShow then
        loginPanel:show();
    end
end

function timeManage.startSendTimeStamp()
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

return timeManage
