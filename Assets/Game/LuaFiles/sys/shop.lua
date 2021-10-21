-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/9/30 13:38:47                                                                                           
-------------------------------------------------------

---@class shop
local shop = class('shop')

local pigChip = 1200;
local doller = 1.99;

function shop.init()
    print("shop init")
    addEvent(SHOP_BUY, function(n)
        shop.buy(n);
    end)
    addEvent(SPIN_START, function()
        shop.addPigChip(slotsManage.getPig())
    end)
end

function shop.doller()
    return doller;
end

function shop.buy(id)
    print("shop.buy")
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
