-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/9/30 13:38:47                                                                                           
-------------------------------------------------------

---@class shop
local shop = class('shop')

local pigChip = 1200;
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
        save.addChip(shop.shopMessage(id)[1]);
    end
    if id == 7 then
        cs_coroutine.start(function()
            pig2Panel:show();
            coroutine.yield(WaitForSeconds(1.5))
            pig2Panel:closeAnim();
        end)
        save.addChip(shop.getPigChip())
    end
end

function shop.getPigChip()
    return pigChip;
end

function shop.addPigChip(val)
    pigChip = pigChip + val;
end

return shop
