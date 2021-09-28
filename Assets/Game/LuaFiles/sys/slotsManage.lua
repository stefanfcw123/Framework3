-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/9/28 11:41:29                                                                                           
-------------------------------------------------------

---@class slotsManage
local slotsManage = class('slotsManage')

function slotsManage.init()
    print("slots init")
    addEvent(SPIN_START,function()
        print("slotsManage SPIN_START")
    end)
end

function slotsManage.getBet()
    return 50;
end

return slotsManage
