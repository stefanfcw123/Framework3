-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/9/30 13:38:47                                                                                           
-------------------------------------------------------

---@class shop
local shop = class('shop')

local pigChipBase = 1200;
local pigChipAdd = 0;

local pigDoller = 1.99;

local shopMessages = {
    { 25000000, 99.99 },
    { 9500000, 49.99 },
    { 3000000, 19.99 },
    { 1300000, 9.99 },
    { 540000, 4.99 },
    { 200000, 1.99 },
}

function shop.init()
    print("shop init")
    addEvent(SHOP_BUY, function(n)
        shop.buy(n);
    end)
    addEvent(SPIN_START, function()
        shop.addPigChip(slotsManage.getPig())
    end)
end

function shop.pigDoller()
    return pigDoller;
end

function shop.shopMessage(id)
    return shopMessages[id];
end

function shop.buy(id)
    print("shop.buy")
    if id < 7 then
        audio.PlaySound("CreditsRollUp");
        save.addChip(shop.shopMessage(id)[1]);
    end
    if id == 7 then
        --todo 等真的回调
        cs_coroutine.start(function()
            pig2Panel:show();
            coroutine.yield(WaitForSeconds(1.5))
            pig2Panel:closeAnim();
        end)
        audio.PlaySound("CreditsRollUp");
        save.addChip(shop.getPigChip())
        pigChipAdd = 0;
        pigPanel:TotalPigChipRefresh()
    end
end

function shop.getPigChip()
    return pigChipBase + pigChipAdd;
end

function shop.addPigChip(val)
    pigChipAdd = pigChipAdd + val;
end

return shop
