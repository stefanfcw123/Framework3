-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/9/30 13:38:47                                                                                           
-------------------------------------------------------

---@class shop
local shop = class('shop')

local pigChip = 1200;

function shop.init()
    print("shop init")
    addEvent(SHOP_BUG, function()
        shop.buy();
    end)
    addEvent(SPIN_START, function()
        shop.addPigChip(slotsManage.getPig())
    end)
end

function shop.buy()
    print("shop.buy")
end

function shop.getPigChip()
    return pigChip;
end

function shop.addPigChip(val)
    pigChip = pigChip + val;
end

return shop
