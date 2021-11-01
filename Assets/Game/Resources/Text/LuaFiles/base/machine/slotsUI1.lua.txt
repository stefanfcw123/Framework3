-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/10/14 16:52:15                                                                                           
-------------------------------------------------------

---@class slotsUI1
local slotsUI1 = class('slotsUI1', require("base.uiMachine"))

function slotsUI1:ctor(lv)
    slotsUI1.super.ctor(self, lv)
end

function slotsUI1:spinStart()
    slotsUI1.super.spinStart(self);
end

function slotsUI1:spinOver()
    slotsUI1.super.spinOver(self);
end

return slotsUI1
