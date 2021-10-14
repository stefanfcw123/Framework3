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
local curBet = 0;
local curMachine = nil;

function slotsManage.init()
    print("slots init")
    addEvent(SPIN_START, function()
        slotsManage.Spin();
    end)
    addEvent(SPIN_OVER, function()
        print("slotsManage SPIN_OVER")
        curMachine:over()
    end)
    addEvent(LOAD_OVER, function()
        slotsManage.setBet()
    end)
    addEvent(WILL_PLAY, function(i)
        curMachine = require("base.machine.slotsMachine" .. tostring(i)).new();
        print("curMachine", curMachine)
    end)
end

function slotsManage.Spin()
    print("slotsManage SPIN_START")
    print("Slots spin will over!")

    curMachine:spin();

    local isWin = slotsManage.isWin();
    local winAward = 2000;
    if isWin then
        print("Slots win")
    else
        print("Slots lose")
    end

    sendEvent(SPIN_OVER, isWin, winAward);
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
    slotsManage.setBet();
    playPanel:betTextRefresh2()
end

function slotsManage.getWin()

end

function slotsManage.setBet()
    -- todo 取整要整50呢？
    local liteChip = data.chip * 0.1;
    local baseNum = 50;
    local perLite = math.max(baseNum, liteChip / maxLv);
    local chipAbout = betLv * perLite;
    local lvAbout = baseNum * level.curLV() + chipAbout * 0.1;
    local res = chipAbout + lvAbout;
    local intRes = integer10(res);
    --print("curLv", level.curLV(), "chipAbout", chipAbout, "lvAbout", lvAbout,"initRes",intRes);
    curBet = intRes;
end

function slotsManage.getBet()
    return curBet;
end

function slotsManage.getPig()
    -- todo 也许注意取整呢
    return slotsManage.getBet() * 0.1;
end

return slotsManage
