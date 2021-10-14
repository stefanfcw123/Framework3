-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/10/14 13:33:20                                                                                           
-------------------------------------------------------

---@class machine
local machine = class('machine')

function machine:ctor()
    self.wheelNum = 3;
    self.wheelPatternNum = 3;
end

function machine:spin()
    print("machine:spin")
end

function machine:over()

end

return machine
