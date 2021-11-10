-------------------------------------------------------
-- author : sky_allen
--  email : 894982165@qq.com
--   time : 2021/10/14 13:36:19
-------------------------------------------------------

---@class slotsMachine2
local slotsMachine2 = class('slotsMachine2', require("base.machine"))

function slotsMachine2:ctor(lv)
    slotsMachine2.super.ctor(self, lv);
end

function slotsMachine2:initMachineUI()
    slotsMachine2.super.initMachineUI(self);
end

function slotsMachine2:spinStart()
    slotsMachine2.super.spinStart(self)
end

function slotsMachine2:spinOver()
    slotsMachine2.super.spinOver(self)
end

function slotsMachine2:nearMissCheck()
    local awardPool = { "s2", "s3", "s4" };
    slotsManage.SpritesNameCheck(awardPool);
    return awardPool;
end

function slotsMachine2:calculateNotWild(v)
    if self:allSameAward(v, "s4") then
        return 25;
    elseif self:allSameAward(v, "s3") then
        return 10;
    elseif self:allSameAward(v, "s2") then
        return 7.5;
    elseif self:allSameAward(v, "s1") then --todo 中奖的UI现在是不对的哦要解决
        return 5;
    elseif self:CountAward(v, "s4", 2) then
        return 5;
    elseif self:combinationAward(v, { "s1", "s2", "s3", "s4" }) then
        return 3;
    elseif self:allSameAward(v, "b3") then
        return 3;
    elseif self:allSameAward(v, "b2") then
        return 2;
    elseif self:allSameAward(v, "b1") then
        return 1;
    elseif self:combinationAward(v, { "b3", "s3" }) then
        return 1;
    elseif self:combinationAward(v, { "b2", "s2" }) then
        return 1;
    elseif self:combinationAward(v, { "b1", "s1" }) then
        return 1;
    elseif self:combinationAward(v, { "b1", "b2", "b3", "s1" }) then
        return 0.5;
    else
        return 0;
    end
end

return slotsMachine2
