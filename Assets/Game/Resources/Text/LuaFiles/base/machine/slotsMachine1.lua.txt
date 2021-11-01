-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/10/14 13:36:19                                                                                           
-------------------------------------------------------

---@class slotsMachine1
local slotsMachine1 = class('slotsMachine1', require("base.machine"))

function slotsMachine1:ctor(lv)
    slotsMachine1.super.ctor(self, lv);
end

-- todo 后期这个方法挪到父亲类
function slotsMachine1:initMachineUI()
    self.machineUI = require("base.machine.slotsUI" .. tostring(self.lv)).new(self.lv);
    print(self.machineUI, "form slotsMachine1")
end

function slotsMachine1:spinStart()
    slotsMachine1.super.spinStart(self)
    self.machineUI:spinStart();
end

function slotsMachine1:spinOver()
    slotsMachine1.super.spinOver(self)
    self.machineUI:spinOver();
end

return slotsMachine1
