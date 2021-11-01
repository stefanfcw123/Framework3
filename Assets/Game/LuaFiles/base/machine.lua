-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/10/14 13:33:20                                                                                           
-------------------------------------------------------

---@class machine
local machine = class('machine')

function machine:ctor(lv)
    self.lv = lv;
    self.wheelNum = 3;--col
    self.wheelPatternNum = 3;--row
    self.matrixTable = {};
    self:addMatrix(
            {
                { 0, 0, 0 },
                { 1, 1, 1 },
                { 0, 0, 0 },
            }
    );
    self.winningPatterns = {};
    if not SPIN_QUICK then
        local str = AF:LoadLuaDatas(self.lv);
        self.writeDatas = string.unserialize(str);
    else
        self.writeDatas = {};
    end


    --print("levelDatalen", #self.levelData)
end
local weightFixed = 1000000;
function machine:dealWithLevelData(keyArr)

    local f = function(str)
        local res = {};
        res = string.split(str, ",")
        return res;
    end

    local data = self.levelData[1];
    local strArr = {};
    local weightArr = {};
    for i, v in pairs(data) do
        if string.starts_with(i, "arr") then
            local index = string.get_pure_number(i) + 1;
            local isW;
            if string.value_of(i, #i) == "w" then
                isW = true;
                weightArr[index] = int(v * weightFixed);
            else
                isW = false;
                strArr[index] = f(v);
            end
        end
    end
    assert(#weightArr == #strArr);

    local items = 0;
    for i, v in ipairs(weightArr) do
        local avgBet = table.average(table.conversion(strArr[i]));
        local betWeight = weightArr[i];
        local item = avgBet * betWeight;
        -- print("MachineItem", avgBet, betWeight)
        items = items + item;
    end
    self.targetReturnRate = items / table.sum(weightArr);
    print("targetReturnRate:", self.targetReturnRate, " ");

    local otherKeyArr = {}
    for i, v in ipairs(strArr) do
        for i2, v2 in ipairs(v) do
            table.insert(otherKeyArr, tonumber(v2));
        end
    end

    assert(table.contentsEqual(keyArr, otherKeyArr));
    -- table.print_arr(weightArr)
    -- table.print_nest_arr(strArr)
    local w = weight.new(weightArr, strArr);
    self.weights = w;
end

function machine:getTargetReturnRate()
    return self.targetReturnRate;
end

function machine:getWeightItem()
    local res = self.weights:GetItemByNumber();
    return res;
end

function machine:getRandomMatrix()
    local randomKeys = self:getWeightItem();
    local key = table.get_random_item(randomKeys);
    local res = table.get_random_item(self.writeDatas[key]);
    -- print('-----------start')
    --table.print_arr(randomKeys);
    --  print("key", key)
    --table.print_nest_arr(res);
    --   print('-----------end')
    return res;
end

function machine:WheelNumber()
    return self.wheelNum;
end

function machine:PatternWheelNumber()
    return self.wheelPatternNum;
end

function machine:addMatrix(m)
    assert(#m == self.wheelPatternNum);
    for i, v in ipairs(m) do
        assert(#v == self.wheelNum);
    end
    table.insert(self.matrixTable, m);
end

function machine:calculateLines(finalPatterns)
    --todo 验证这里有没有从左向右的bug，刚想了下也许后面的模式有问题


    local finalPatterns = finalPatterns;

    local fL = #finalPatterns;
    local f1L = #finalPatterns[1];
    assert(fL == self.wheelPatternNum);
    assert(f1L == self.wheelNum);

    for _, v in ipairs(self.matrixTable) do
        local tempPatterns = {};
        local matrix = v;
        for i = 1, fL do
            for j = 1, f1L do
                local item = matrix[i][j];
                if item == 1 then
                    table.insert(tempPatterns, finalPatterns[i][j])
                end
            end
        end
        table.insert(self.winningPatterns, tempPatterns);
    end

    return self:whetherWinning(finalPatterns);
end

function machine:knightAward(t, princess, knight)
    if t[1] == knight and t[2] == princess and t[3] == knight then
        return true;
    end
    return false;
end

function machine:allSameAward(t, samePattern)
    for i, v in ipairs(t) do
        if v ~= samePattern then
            return false;
        end
    end
    return true;
end

--todo 后面还有限制个数比如2的写法，是否可以自洽
function machine:combinationAward(t, awardPool)
    for i, v in ipairs(t) do
        if not table.contains(awardPool, v) then
            return false;
        end
    end
    return true;
end

local function isWildItem(str)
    return string.value_of(str, 1) == "w";
end

function machine:WildPatterns(t)
    local wildRes = {};
    local NotWildRes = {};
    for i, v in ipairs(t) do
        if isWildItem(v) then
            table.insert(wildRes, v);
        else
            table.insert(NotWildRes, v);
        end
    end
    return wildRes, NotWildRes;
end

function machine:calculateNotWild(v)
    if self:allSameAward(v, "s4") then
        return 20;
    elseif self:allSameAward(v, "s3") then
        return 15;
    elseif self:allSameAward(v, "s2") then
        return 12;
    elseif self:allSameAward(v, "s1") then
        return 10;
    elseif self:combinationAward(v, { "s1", "s2", "s3", "s4" }) then
        return 8;
    elseif self:allSameAward(v, "b3") then
        return 6;
    elseif self:allSameAward(v, "b2") then
        return 5;
    elseif self:combinationAward(v, { "b1", "s1" }) then
        return 4;
    elseif self:combinationAward(v, { "b1", "b2", "b3", "s1" }) then
        return 2;
    else
        return 0;
    end
end

function machine:wildBaseRatio(wildPatternTable)
    local res = 1;
    for i, v in ipairs(wildPatternTable) do
        local num = tonumber(string.value_of(v, 2)); --todo 警惕单个有超过10倍的出现
        res = res * num;
    end
    return res;
end

function machine:fixedCopyV(copyV, NotWildPatternTable)
    for i, v in ipairs(copyV) do
        if isWildItem(v) then
            copyV[i] = table.get_random_item(NotWildPatternTable);
        end
    end
end

function machine:whetherWinning(finalPatterns)
    local resRatio = 0;
    for i, v in ipairs(self.winningPatterns) do
        local ratio = 0;
        local wildPatternTable, NotWildPatternTable = self:WildPatterns(v);
        local wildCount = #wildPatternTable;

        if wildCount > 0 then
            if self:knightAward(v, "w5", "w2") then
                ratio = 1000;
            elseif self:knightAward(v, "w4", "w2") then
                ratio = 400;
            elseif self:knightAward(v, "w3", "w2") then
                ratio = 300;
            elseif (wildCount == 1) or (wildCount == 2) then
                local baseRatio = self:wildBaseRatio(wildPatternTable);
                local copyV = table.copy(v);
                self:fixedCopyV(copyV, NotWildPatternTable);

                local addRatio;
                local fixedCalculateNotWild = self:calculateNotWild(copyV);
                if fixedCalculateNotWild ~= 0 then
                    addRatio = fixedCalculateNotWild;
                else
                    addRatio = 1;
                end

                ratio = baseRatio * addRatio;
            else
                ratio = 0;
            end
        else
            ratio = self:calculateNotWild(v);
        end

        resRatio = resRatio + ratio;
        print("machine perRatio:", ratio);
    end

    print("machine totalRatio:", resRatio)

    --table.print_nest_arr(finalPatterns)
    if SPIN_QUICK then
        self:addData(resRatio, finalPatterns);
    end

    return resRatio;
end

function machine:addData(resRatio, finalPatterns)
    local datas = self.writeDatas;
    local key = tostring(resRatio);
    if not table.contains_key(datas, key) then
        local t = {}
        table.insert(t, finalPatterns);
        datas[key] = t;
    else
        table.insert(datas[key], finalPatterns);
    end


    -- self:dataWrite();
end

function machine:printDatas2()
    local t = {}
    for i, v in pairs(self.writeDatas) do
        table.insert(t, tonumber(i));
    end
    table.sort(t);
    return t;
end

function machine:printDatas()
    print("---------Datas-----------")
    for i, v in pairs(self.writeDatas) do
        print(string.format("DatasItem %sBet:", i))
        for i2, v2 in ipairs(v) do
            print("DatasItemPerMatrix:")
            -- table.print_nest_arr(v2)
        end
    end
    print("---------Datas-----------")
end

function machine:dataWrite()
    print("machine dataWrite")
    local datas = self.writeDatas;
    CS.IOHelpLua.CreateLevelDatas(self.lv, string.serialize(datas));
end

function machine:spinStart()
    self.levelData = require("data.Level" .. self.lv .. slotsManage.GetConfigEnum());
    self:dealWithLevelData(self:printDatas2());
end

function machine:spinOver()
    table.clear(self.winningPatterns)
end

return machine
