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
    elseif self:allSameAward(v, "s1") then
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

function slotsMachine2:initRowCol()
    self.wheelNum = 4;--有几个轮子就有几列
    self.wheelPatternNum = 3;--每个轮子有几个图案就有几行
end

function slotsMachine2:getLineNumberMatrix()
    self.LineNumberMatrix = {};
    local m = self.LineNumberMatrix;

    m["1"] = {
        { 0, 0, 0, 0 },
        { 1, 1, 1, 1 },
        { 0, 0, 0, 0 },
    }
end

function slotsMachine2:mainWhetherWinning(finalPatterns, argTableKeys)
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

        local ratioBefore = self:calculateNotWild(NotWildPatternTable);
        local ratioAfter = 0;

        if ratioBefore ~= 0 then
            ratioAfter = self:wildBaseRatio(wildPatternTable);
        end
        ratio = ratioBefore * ratioAfter;

        animalData = {};
        for i1, v1 in ipairs(v) do
            if (v1 == "s4") or string.match(v1, "w") then
                animalData[i1] = true;
            else
                animalData[i1] = false;
            end
        end

        winAnimalRowFill(ratioBefore == 5 and (table.countItems(animalData, function(item)
            return item == true
        end) > 1));

        --[[        if wildCount > 0 then
                    if self:knightAward(v, "w5", "w2") then
                        ratio = 1000;
                        winAnimalRowFill();

                    elseif self:knightAward(v, "w4", "w2") then
                        ratio = 400;
                        winAnimalRowFill();

                    elseif self:knightAward(v, "w3", "w2") then
                        ratio = 300;
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
                end]]

        table.insert(resRatio, ratio);
        print("machine perRatio:", ratio, ratioBefore, ratioAfter);
    end
    return resRatio;
end

return slotsMachine2
