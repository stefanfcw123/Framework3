-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/9/28 11:41:29                                                                                           
-------------------------------------------------------

---@class slotsManage
local slotsManage = class('slotsManage')

local betLv = 1;
local maxLv = 4;
local minLv = 1;

function slotsManage.init()
    print("slots init")
    addEvent(SPIN_START, function()
        slotsManage.Spin();
    end)
    addEvent(SPIN_OVER, function()
        print("slotsManage SPIN_OVER")
    end)
end

function slotsManage.Spin()
    print("slotsManage SPIN_START")
    print("Slots spin will over!")
    for i = 1, 1000 do
        local isWin = slotsManage.isWin();
        print(isWin)
    end

    sendEvent(SPIN_OVER);
end

function slotsManage.isWin()
    local randomVal = math.random();
    local res = randomVal >= 0.5 and true or false;
    return res;
end

function slotsManage.changeBetLv(n)
    if n == 1 then
        if betLv < maxLv then
            betLv = betLv + 1;
        end
    else
        if betLv > minLv then
            betLv = betLv - 1;
        end
    end
    playPanel:betTextRefresh2()
end

function slotsManage.getWin()

end

-- todo 解决当前bet缓存问题，不然是非常不好的设计，玩家误以为有bug
function slotsManage.getBet()
    -- todo 取整要整50呢？
    local liteChip = data.chip * 0.1;
    local baseNum = 50;
    local perLite = math.max(baseNum, liteChip / maxLv);
    local chipAbout = betLv * perLite;
    local lvAbout = baseNum * level.curLV() + chipAbout * 0.1;
    local res = chipAbout + lvAbout;
    local intRes = integer10(res);
    --print("curLv", level.curLV(), "chipAbout", chipAbout, "lvAbout", lvAbout);
    return intRes
end

function slotsManage.getPig()
    -- todo 也许注意取整呢
    return slotsManage.getBet() * 0.1;
end

return slotsManage
