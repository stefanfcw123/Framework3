-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/10/14 16:52:15                                                                                           
-------------------------------------------------------

---@class slotsUI1
local slotsUI1 = class('slotsUI1', require("base.uiMachine"))

function slotsUI1:ctor(lv)
    slotsUI1.super.ctor(self, lv)
    print(#self.wheels, "slotsUI1")
    --print(#self.wheels);
end

return slotsUI1
