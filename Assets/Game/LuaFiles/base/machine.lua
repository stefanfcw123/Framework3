-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/10/14 13:33:20                                                                                           
-------------------------------------------------------

---@class machine
local machine = class('machine')

function machine:ctor(lv)
    self.lv = lv;
    self.wheelNum = 3;
    self.wheelPatternNum = 3;
end

function machine:spinStart()
end

function machine:spinOver()
end

return machine
