-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/9/28 11:41:29                                                                                           
-------------------------------------------------------

---@class slotsManage
local slotsManage = class('slotsManage')

function slotsManage.init()
    print("slots init")
    addEvent(SPIN_START, function()
        slotsManage.Spin();
    end)
    addEvent(SPIN_OVER,function()
        print("slotsManage SPIN_OVER")
    end)
end

function slotsManage.Spin()
    print("slotsManage SPIN_START")
    print("Slots spin will over!")
    sendEvent(SPIN_OVER);
end

function slotsManage.getWin()

end

function slotsManage.getBet()
    return 50;
end

function slotsManage.getPig()
    return slotsManage.getBet() * 0.1;
end

return slotsManage
