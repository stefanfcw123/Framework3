-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/10/14 13:33:20                                                                                           
-------------------------------------------------------

---@class machine
local machine = class('machine')

function machine:ctor(lv)
    self:initBaseData(lv);

    self:initRowCol();

    self:getLineNumberMatrix();--初始化中奖线池

    self:addMatrixs({ 1, 2 })--中奖线池添加

    self:initWriteDatas();
end

function machine:initWriteDatas()
    if not WRITE_DATA_MODE then
        local str = AF:LoadLuaDatas(self.lv);
        self.writeDatas = string.unserialize(str);
    else
        self.writeDatas = {};
    end
end

function machine:initBaseData(lv)
    self.lv = lv;
    self.matrixTable = {};--装中奖的线矩阵的
    self.winningPatterns = {};--装中奖的图案用的
end

function machine:initRowCol()
    self.wheelNum = 3;--有几个轮子就有几列
    self.wheelPatternNum = 3;--每个轮子有几个图案就有几行
end

function machine:addMatrixs(t)
    self.addMatrixArgTable = t;

    assert(table.all(t, function(item)
        return type(item) == "number"
    end));
    assert(table.isIncreasing(t));

    for i, v in ipairs(t) do
        self:addMatrix(self.LineNumberMatrix[tostring(v)]);
    end
end

function machine:getLineNumberMatrix()
    self.LineNumberMatrix = {};
    local m = self.LineNumberMatrix;

    m["1"] = {
        { 0, 0, 0 },
        { 1, 1, 1 },
        { 0, 0, 0 },
    }

    m["2"] = {
        { 1, 1, 1 },
        { 0, 0, 0 },
        { 0, 0, 0 },
    }

    m["3"] = {
        { 0, 0, 0 },
        { 0, 0, 0 },
        { 1, 1, 1 },
    }

    m["4"] = {
        { 1, 0, 0 },
        { 0, 1, 0 },
        { 0, 0, 1 },
    }

    m["5"] = {
        { 0, 0, 1 },
        { 0, 1, 0 },
        { 1, 0, 0 },
    }

    m["6"] = {
        { 0, 1, 0 },
        { 0, 0, 0 },
        { 1, 0, 1 },
    }

    m["7"] = {
        { 1, 0, 1 },
        { 0, 0, 0 },
        { 0, 1, 0 },
    }

    m["8"] = {
        { 0, 1, 0 },
        { 1, 0, 1 },
        { 0, 0, 0 },
    }

    m["9"] = {
        { 0, 0, 0 },
        { 1, 0, 1 },
        { 0, 1, 0 },
    }

    for i, v in pairs(m) do
        for i1, v1 in ipairs(v) do
            for i2, v2 in ipairs(v1) do
                assert((v2 == 1) or (v2 == 0))
            end
        end
    end
end

function machine:dealWithLevelData(keyArr)

    local f = function(str)
        local res = {};
        res = string.split(str, ",")
        return res;
    end

    local data = self.levelData[1];
    local strArr = {};
    local weightArr = {};
    local checkArr = {};
    local checkArr2 = {};
    for i, v in pairs(data) do
        if string.starts_with(i, "arr") then
            local index = string.get_pure_number(i) + 1;
            if string.value_of(i, #i) == "w" then
                weightArr[index] = int(v * 1000000);
                table.insert(checkArr, index);
            else
                strArr[index] = f(v);
                table.insert(checkArr2, index);
            end
        end
    end
    assert(#weightArr == #strArr);
    assert(#checkArr == #checkArr2);
    table.sort(checkArr);
    table.sort(checkArr2)
    assert(table.isIncreasing(checkArr, true), "请检查配置表是否严格的递增1")
    assert(table.isIncreasing(checkArr2, true), "请检查配置表是否严格的递增1")

    local tempKeyArr = {}
    for i, v in ipairs(strArr) do
        for i2, v2 in ipairs(v) do
            table.insert(tempKeyArr, tonumber(v2));
        end
    end

    assert(table.contentsEqual(keyArr, tempKeyArr));--keyArr是来自数据表，tempKeyArr来自配置表
    assert(table.isIncreasing(tempKeyArr) == true)

    -- table.print_arr(weightArr)
    -- table.print_nest_arr(strArr)
    local w = weight.new(weightArr, strArr);
    self.weights = w;

    self:setTargetReturnRate(weightArr, strArr)
    self:hightBetsDivision(tempKeyArr)
end

function machine:hightBetsDivision(tempKeyArr)
    local hightBets = table.division(table.division(tempKeyArr, 2)[2], 3);
    self.hightBetLevel1 = hightBets[1];
    self.hightBetLevel2 = hightBets[2];
    self.hightBetLevel3 = hightBets[3];
    table.print_arr(self.hightBetLevel1, "lv1");
    table.print_arr(self.hightBetLevel2, "lv2");
    table.print_arr(self.hightBetLevel3, "lv3");
end

function machine:setTargetReturnRate(weightArr, strArr)
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
end

function machine:HightBetLv(bet)
    local betLv = 0;
    if table.contains(self.hightBetLevel1, bet) then
        betLv = 1;
    elseif table.contains(self.hightBetLevel2, bet) then
        betLv = 2
    elseif table.contains(self.hightBetLevel3, bet) then
        betLv = 3;
    end
    return betLv;
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
    --[[    print('-----------start')
        table.print_arr(randomKeys);
        print("key", key)
        table.print_nest_arr(res);
        print('-----------end')]]
    return res;
end

function machine:fixedMatrixMidRow(t)
    -- 这里只是最终图案的中间，所以调换了旋转方向也无所谓
    local mid = int((#t / 2));
    return t[mid + 1];
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
    --根据计算线得到计算的图案
    --todo 这里如果有向上的线上的线，要改变遍历方式

    local finalPatterns = finalPatterns;

    local fL = #finalPatterns;
    local f1L = #finalPatterns[1];
    assert(fL == self.wheelPatternNum);
    assert(f1L == self.wheelNum);
    local argTableKeys = {}--提出有哪些是已经中了奖的线了。

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
        local argTableItem = tostring(self.addMatrixArgTable[_]);
        table.insert(argTableKeys, argTableItem);
    end

    table.print_arr(argTableKeys, B);
    return self:whetherWinning(finalPatterns, argTableKeys);
end

--todo 不适配超过3个轮子的
function machine:knightAward(t, princess, knight)
--[[    local temp = slotsManage.SpritesNameCheck(princess, knight);
    if temp then
        table.print_arr(temp, "牛牛牛牛牛")
    end]]

    if t[1] == knight and t[2] == princess and t[3] == knight then
        return true;
    end
    return false;
end

function machine:allSameAward(t, samePattern)
    slotsManage.SpritesNameCheck(samePattern);

    for i, v in ipairs(t) do
        if v ~= samePattern then
            return false;
        end
    end
    return true;
end

function machine:isNearMiss(t)
    local awardPool = { "s1", "s2", "s3", "s4", "w2", "w3", "w4", "w5" };
    slotsManage.SpritesNameCheck(awardPool);

    local temp = {};
    for i, v in ipairs(t) do
        if i ~= #t then
            table.insert(temp, v);
        end
    end

    return self:combinationAward(temp, awardPool);
end

-- 这个讲究顺序，而且必须是满个数呢，呵呵最好别动，bug有一半是为了优雅改出来的
function machine:combinationAward(t, awardPool)
    slotsManage.SpritesNameCheck(awardPool);

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
    --从每一行提出wild和非wild
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
    --每一行不是wild的判断中奖
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
    --从每一行提取wild基础赔率
    local res = 1;
    for i, v in ipairs(wildPatternTable) do
        local num = tonumber(string.value_of(v, 2));
        assert(#tostring(num) == 1, "More than 10 bet");
        res = res * num;
    end
    return res;
end

function machine:fixedCopyV(copyV, NotWildPatternTable)
    --把每一行wild随机替换成非wild的
    -- 这里是设置wild
    local animalData = {};
    for i, v in ipairs(copyV) do
        if isWildItem(v) then
            copyV[i] = table.get_random_item(NotWildPatternTable);
            animalData[i] = true;
        else
            animalData[i] = false;
        end
    end
    return animalData;
end

function machine:winAnimalRowBoolean()
    --获取每一行默认的动画参数
    local res = {};
    for i = 1, self.wheelNum do
        res[i] = true;
    end
    return res;
end
-- 如果有单独不是方法的不要漏了去checkRight,
-- todo 这里如果都确定倍率了不应该再计算了真是的,但是我暂时先不动了
function machine:whetherWinning(finalPatterns, argTableKeys)
    --根据图案获得中奖倍率
    local resRatio = 0;
    self.winAnimalDic = {};
    local winAnimalDic = self.winAnimalDic;
    for i, v in ipairs(self.winningPatterns) do
        local ratio = 0;
        local wildPatternTable, NotWildPatternTable = self:WildPatterns(v);
        local wildCount = #wildPatternTable;
        local argTableKey = argTableKeys[i];
        local animalData = nil;

        local winAnimalRowFill = function(needAnimalData)
            --todo 一般来讲没有wild都是全部显示，但是有例外下个模式会有问题
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

        end

        resRatio = resRatio + ratio;
        print("machine perRatio:", ratio);
    end

    -- print("machine totalRatio:", resRatio)
    -- table.print_nest_arr(finalPatterns)
    if WRITE_DATA_MODE then
        self:addData(resRatio, finalPatterns, false);--真实写注意不要覆盖了，我感觉会很麻烦，如果覆盖了
    end

    return resRatio;
end

function machine:addData(resRatio, finalPatterns, realWrite)
    --如果是写入模式，添加到data池里，后面统一写入
    local datas = self.writeDatas;
    local key = tostring(resRatio);
    if not table.contains_key(datas, key) then
        local t = {}
        table.insert(t, finalPatterns);
        datas[key] = t;
    else
        table.insert(datas[key], finalPatterns);
    end
    if realWrite then
        self:dataWrite();
    end
end

function machine:dataWrite()
    print("machine dataWrite")
    local datas = self.writeDatas;
    CS.IOHelpLua.CreateLevelDatas(self.lv, string.serialize(datas));
end

function machine:getBetsByWriteDatas()
    --获取倍率数组来自于writeDatas
    local t = {}
    --这里i其实key注意
    for i, v in pairs(self.writeDatas) do
        table.insert(t, tonumber(i));
    end
    table.sort(t);
    table.print_arr(t, B);
    return t;
end

function machine:printDatas()
    print("---------Start-----------")
    for i, v in pairs(self.writeDatas) do
        print(string.format("DatasItem %sBet:", i))
        for i2, v2 in ipairs(v) do
            print("DatasItemPerMatrix:")
            -- table.print_nest_arr(v2)
        end
    end
    print("---------End-----------")
end

function machine:spinStart()
    self.levelData = require("data.Level" .. self.lv .. slotsManage.GetConfigEnum());
    self:dealWithLevelData(self:getBetsByWriteDatas());

    self.machineUI:spinStart();
end

function machine:spinOver()
    table.clear(self.winningPatterns)

    self.machineUI:spinOver();
end

function machine:initMachineUI()
    self.machineUI = require("base.machine.slotsUI" .. tostring(self.lv)).new(self.lv);
    print(self.machineUI, "form slotsMachine" .. self.lv);
end

return machine
