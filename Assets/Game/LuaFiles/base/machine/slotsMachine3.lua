-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/10/14 13:36:19                                                                                           
-------------------------------------------------------

---@class slotsMachine3
local slotsMachine3 = class('slotsMachine3', require("base.machine"))

function slotsMachine3:ctor(lv)
    slotsMachine3.super.ctor(self, lv);
end

function slotsMachine3:initMachineUI()
    slotsMachine3.super.initMachineUI(self);
end

function slotsMachine3:spinStart()
    slotsMachine3.super.spinStart(self)
end

function slotsMachine3:spinOver()
    slotsMachine3.super.spinOver(self)
end

function slotsMachine3:nearMissCheck()
    local awardPool = { "s2", "w2", "w3", "w4" };
    slotsManage.SpritesNameCheck(awardPool);
    return awardPool;
end

--[[function slotsMachine3:isReSpin(midT)
    local haveEmpty = false;
    local wildCount = 0;
    for i, v in ipairs(midT) do
        if v == "em" then
            haveEmpty = true;
        end

        if string.value_of(v, 1) == "w" then
            wildCount = wildCount + 1;
        end
    end

    return haveEmpty and wildCount == 1;
end]]

function slotsMachine3:calculateNotWild(v)
    --每一行不是wild的判断中奖
    if self:allSameAward(v, "s2") then
        return 25;
    elseif self:allSameAward(v, "s1") then
        return 15;
    elseif self:allSameAward(v, "s2") then
        return 12;
    elseif self:allSameAward(v, "b3") then
        return 10;
    elseif self:allSameAward(v, "b2") then
        return 5;
    elseif self:allSameAward(v, "b1") then
        return 3;
    elseif self:combinationAward(v, { "b1", "s1" }) then
        return 3;
    elseif self:combinationAward(v, { "b1", "b2", "b3", "s1" }) then
        return 2;
    else
        return 0;
    end
end

function slotsMachine3:mainWhetherWinning(finalPatterns, argTableKeys)
    --根据图案获得中奖倍率
    local resRatio = {};
    self.winAnimalDic = {};
    local winAnimalDic = self.winAnimalDic;--key是第几线而已呢
    for i, v in ipairs(self.winningPatterns) do
        local ratio = 0;
        local wildPatternTable, NotWildPatternTable = self:WildPatterns(v);
        local wildCount = #wildPatternTable;
        local argTableKey = argTableKeys[i];
        local animalData = nil;

        local winAnimalRowFill = function(needAnimalData)

            if needAnimalData == nil then
                needAnimalData = false;
            end

            if ratio ~= 0 then
                if needAnimalData then
                    winAnimalDic[argTableKey] = animalData;
                else
                    winAnimalDic[argTableKey] = self:winAnimalRowBoolean();
                end
            end
        end

        if wildCount > 0 then
            if self:knightAward(v, "w4", "w2") then
                ratio = 1000;
                winAnimalRowFill();

            elseif self:knightAward(v, "w3", "w2") then
                ratio = 300;
                winAnimalRowFill();

            elseif self:allSameAward(v, "w2") then
                ratio = 200;
                winAnimalRowFill();

            elseif (wildCount == 1) or (wildCount == 2) then
                local baseRatio = self:wildBaseRatio(wildPatternTable);
                local copyV = table.copy(v);
                animalData = self:fixedCopyV(copyV, NotWildPatternTable);

                local addRatio;
                local fixedCalculateNotWild = self:calculateNotWild(copyV);
                if fixedCalculateNotWild ~= 0 then
                    addRatio = fixedCalculateNotWild;
                else
                    addRatio = 1;
                end

                ratio = baseRatio * addRatio;
                winAnimalRowFill(addRatio == 1);

            else
                ratio = 0;
                winAnimalRowFill();

            end
        else
            ratio = self:calculateNotWild(v);
            winAnimalRowFill();
        end

        table.insert(resRatio, ratio);
        print("machine perRatio:", ratio);
    end
    return resRatio;
end

return slotsMachine3
