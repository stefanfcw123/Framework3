-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/11/1 13:39:10                                                                                           
-------------------------------------------------------

---@class analysis
local analysis = class('analysis')

analysis.inChip = 0;
analysis.outChip = 0;

function analysis.init()
    print('analysis init')

end

function analysis.returnRate()
    print("inChip:", analysis.inChip, " outChip:", analysis.outChip)
    return analysis.inChip / analysis.outChip;
end

function analysis.getTargetReturnRate()
    return slotsManage.curMachine:getTargetReturnRate();
end

function analysis.addInChip(val)
    analysis.inChip = analysis.inChip + val;
end

function analysis.addOutChip(val)
    analysis.outChip = analysis.outChip + val;
end

return analysis
