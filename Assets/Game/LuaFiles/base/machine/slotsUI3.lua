-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/10/14 16:52:15                                                                                           
-------------------------------------------------------

---@class slotsUI3
local slotsUI3 = class('slotsUI3', require("base.uiMachine"))

function slotsUI3:ctor(lv)
    slotsUI3.super.ctor(self, lv)
end

function slotsUI3:spinStart()
    slotsUI3.super.spinStart(self);
end

function slotsUI3:spinOver()
    slotsUI3.super.spinOver(self);
end

function slotsUI3:initWheels()

    local luaMonos = array2table(self.go.transform:Find("Image/Image"), RectTransform, false);
    self.wheels = {};
    local allSprites = self:loadAllSprite();
    local allSpritesNames = table.selectItems(allSprites, "name");
    slotsManage.SetAllSpritesNames(allSpritesNames);--设置这个仅仅是为了校验一下名字而已
    for i, v in ipairs(luaMonos) do
        local mono = v:GetComponent(typeof(CS.LuaMono));
        table.insert(self.wheels, mono.TableIns);
        local samePart = { "w3", "w4" };
        local SPPoolPart = nil;
        if i == 1 then
            SPPoolPart = self:partSPPoolRemoveSome(allSprites, samePart)
            self.SPPoolPartCommom = table.selectItems(table.copy(SPPoolPart), "name");
        elseif i == 2 then
            SPPoolPart = self:partSPPoolRemoveSome(allSprites, {})
        elseif i == 3 then
            SPPoolPart = self:partSPPoolRemoveSome(allSprites, samePart)
        end
        self.wheels[i]:init(SPPoolPart);
    end

    self.reSpinGo = self.go.transform:Find("Image/ReSpin").gameObject;
end

function slotsUI3:quickPatterns()
    return {
        { "w2", "w3", "em" },
        { "em", "w4", "em" },
        { "b1", "b1", "b3" },
    };
end
--[[        if totalBet == 6 or totalBet == 9 or totalBet == 12 then
            local isRespin = false; --curMachine:isReSpin(nearMissLineTable);--中间那条其实也是nearMiss判断那条
            if isRespin then
                coroutine.yield(WaitForSeconds(0.5));
                self:winShowLightBox(false);

                for i, v in ipairs(self.wheels) do
                    if i ~= curMachine:GetMidRow(matrix) then
                        self:roll(i, true);
                    end
                end
                coroutine.yield(WaitForSeconds(1))
                for i, v in ipairs(self.wheels) do
                    if i ~= curMachine:GetMidRow(matrix) then
                        self:roll(i, false, self:matrixChange(matrix));
                    end
                end
            end
        end]]

function slotsUI3:getPartCommon()
    return table.get_random_item(self.SPPoolPartCommom);
end

function slotsUI3:ReSpinDataSpecial()
    local one = nil;

    repeat
        one = self:getPartCommon();
    until (one ~= "w2");

    local firstEmpty = math.ratio(0.5);

    if firstEmpty then
        return "em", one;
    else
        return one, "em";
    end

end

function slotsUI3:getReSpinData(baseNum)
    local special1, special2 = self:ReSpinDataSpecial();

    local t = {
        ["b"] = {
            ["1"] = {
                [1] = {
                    [1] = 0,
                    [2] = 0,
                    [3] = 0,
                },
                [2] = {
                    [1] = 0,
                    [2] = 1,
                    [3] = 0,
                },
                [3] = {
                    [1] = 0,
                    [2] = 0,
                    [3] = 0,
                },
            },
        },
        ["a"] = {
            [1] = {
                [1] = self:getPartCommon(),
                [2] = self:getPartCommon(),
                [3] = self:getPartCommon(),
            },
            [2] = {
                [1] = special1,
                [2] = "w" .. baseNum,
                [3] = special2,
            },
            [3] = {
                [1] = self:getPartCommon(),
                [2] = self:getPartCommon(),
                [3] = self:getPartCommon(),
            },
        },
        ["c"] = tostring(baseNum),
    }
    return t;
end

function slotsUI3:getReSpinData2(baseSpinData)

    local special1, special2 = self:ReSpinDataSpecial();

    baseSpinData["a"][1][1] = self:getPartCommon();
    baseSpinData["a"][1][3] = self:getPartCommon();

    baseSpinData["a"][2][1] = special1;
    baseSpinData["a"][2][3] = special2;

    baseSpinData["a"][3][1] = self:getPartCommon();
    baseSpinData["a"][3][3] = self:getPartCommon();

    return baseSpinData;
end

function slotsUI3:rollAll()
    local matrixAboutTemp;
    local curMachine = slotsManage.curMachine;
    local isReSpin = false;
    local multiplicationNum = 3;--这里模式包括第一次总共多少次呢。

    if not WRITE_DATA_MODE then
        matrixAboutTemp = curMachine:getRandomMatrixAbout();

        local totalBet = table.sum(table.csv2table(matrixAboutTemp["c"]));

        local ratio = 0.2;
        if RESPIN_QUICK then
            ratio = 1;
        end

        print(totalBet, "totalBet,,,")

        local reSpinJudge = function(bNum)
            if (totalBet == (bNum * 3)) and math.ratio(ratio) then
                isReSpin = true;

                if isReSpin then
                    matrixAboutTemp = self:getReSpinData(bNum);
                end
            end
        end

        reSpinJudge(2);
        reSpinJudge(3);
        reSpinJudge(4);
    end

    local waitCost = 0.5;
    local s = cs_coroutine.start(function()
        rotate = true;

        if isReSpin then

            coroutine.yield(cs_coroutine.start(function()
                slotsManage.R2Change(R2)--改变时间这里应该对该修改的声音进行重置
                slotsManage.R1Change(R1 / 2)

                local matrix = nil;--一直都是直观的
                local matrixAbout = self:getReSpinData2(matrixAboutTemp);--这个里面保护图案还有其他信息
                if WRITE_DATA_MODE then
                    local tempMatrix;
                    local count = 0;
                    local WildPatterns;
                    repeat
                        self:randomSetImage();--把隐藏的也设置了但是没有关系
                        tempMatrix = self:getMapPatternNames();--从直观的地方获取名字
                        local mid = curMachine:fixedMatrixMidRow(tempMatrix);-- 冗余了但是没办法
                        WildPatterns = curMachine:WildPatterns(mid);
                        count = count + 1;
                    until ((#WildPatterns ~= 2));
                    --print("count:", count)
                    matrix = tempMatrix;
                else
                    matrix = matrixAbout["a"]--得到的是玩家直观的;
                end
                if PATTERNS_QUICK then
                    matrix = self:quickPatterns();
                end

                local nearMissLineTable = curMachine:fixedMatrixMidRow(matrix);--获取nearMiss那条线默认是中间条
                local nearMiss = (math.ratio(NEAR_MISS_RATIO)) and (curMachine:isNearMiss(nearMissLineTable));

                for i, v in ipairs(self.wheels) do
                    self:roll(i, true);
                end

                coroutine.yield(WaitForSeconds(R1 / 2))
                coroutine.yield(WaitForSeconds(slotsManage.R1));

                for i, v in ipairs(self.wheels) do
                    self:roll(i, false, self:matrixChange(matrix))
                    if i == self:nearMissOffset() then

                        --要转到第三个之前的时候
                        if nearMiss then
                            self:nearMissSuccess();
                            coroutine.yield(WaitForSeconds(R6))
                        else
                            coroutine.yield(WaitForSeconds(slotsManage.R2))
                        end
                    else
                        coroutine.yield(WaitForSeconds(slotsManage.R2))
                    end
                end

                local totalBet = nil;

                if WRITE_DATA_MODE then
                    totalBet = curMachine:calculateLines(matrix);
                else
                    totalBet = table.sum(table.csv2table(matrixAbout["c"]));
                end

                local isWin = (totalBet ~= 0);

                if not WRITE_DATA_MODE then
                    local hightBetLv = curMachine:HightBetLv(totalBet);
                    if hightBetLv ~= 0 then
                        playPanel:showHightWinImage(hightBetLv);
                        audio.PlaySound("CreditsRollUpHeightWin");
                    else
                        if isWin then
                            audio.PlaySound("CreditsRollUp");
                        end
                    end
                end

                sendEvent(SPIN_OVER, isWin, slotsManage.getTotalAward(totalBet))
                if isWin then
                    self:winShowLightBox(true);
                end

                local fixedWinAnimalDic = nil;
                if WRITE_DATA_MODE then
                    fixedWinAnimalDic = curMachine.fixedWinAnimalDic;--动画相关
                else
                    fixedWinAnimalDic = matrixAbout["b"];
                end

                if table.hash_count(fixedWinAnimalDic) > 0 then
                    self.awardAnimals = cs_coroutine.start(function()
                        while true do
                            for i, v in pairs(fixedWinAnimalDic) do
                                local completeMatrix = v;
                                self:lineAnim(tonumber(i), false);
                                for i1, v1 in ipairs(completeMatrix) do
                                    for i2, v2 in ipairs(v1) do
                                        if v2 == 1 then
                                            self.mapPatterns[i1][i2]:awardAnim();
                                        end
                                    end
                                end
                                coroutine.yield(WaitForSeconds(AWARD_ANIM_DELAY2));
                                self:lineAnim(tonumber(i), true);
                            end
                        end
                    end)
                end
            end))
            self.reSpinGo:SetActive(true);
            audio.PlaySound("sfx_respin");

            coroutine.yield(WaitForSeconds(waitCost));
            self.reSpinGo:SetActive(false);
            for i = 1, (multiplicationNum - 1) do
                self:stopAllAnimal(); -- 这里停止不冗余了
                coroutine.yield(cs_coroutine.start(function()
                    slotsManage.R2Change(R2)--改变时间这里应该对该修改的声音进行重置
                    slotsManage.R1Change(R1 / 2)

                    local matrix = nil;--一直都是直观的
                    local matrixAbout = self:getReSpinData2(matrixAboutTemp);--这个里面保护图案还有其他信息
                    if WRITE_DATA_MODE then
                        local tempMatrix;
                        local count = 0;
                        local WildPatterns;
                        repeat
                            self:randomSetImage();--把隐藏的也设置了但是没有关系
                            tempMatrix = self:getMapPatternNames();--从直观的地方获取名字
                            local mid = curMachine:fixedMatrixMidRow(tempMatrix);-- 冗余了但是没办法
                            WildPatterns = curMachine:WildPatterns(mid);
                            count = count + 1;
                        until ((#WildPatterns ~= 2));
                        --print("count:", count)
                        matrix = tempMatrix;
                    else
                        matrix = matrixAbout["a"]--得到的是玩家直观的;
                    end
                    if PATTERNS_QUICK then
                        matrix = self:quickPatterns();
                    end

                    local nearMissLineTable = curMachine:fixedMatrixMidRow(matrix);--获取nearMiss那条线默认是中间条
                    local nearMiss = (math.ratio(NEAR_MISS_RATIO)) and (curMachine:isNearMiss(nearMissLineTable));
                    local midRow = curMachine:GetMidRow(matrix);

                    audio.PlaySound("Music_Respin");
                    for i, v in ipairs(self.wheels) do
                        if i ~= midRow then
                            self.wheels[i]:showLightBox(true);
                            self:roll(i, true);
                        end
                    end

                    coroutine.yield(WaitForSeconds(2))
                    --[[                    coroutine.yield(WaitForSeconds(R1 / 2))
                                        coroutine.yield(WaitForSeconds(slotsManage.R1));]]

                    for i, v in ipairs(self.wheels) do

                        if i ~= midRow then
                            self:roll(i, false, self:matrixChange(matrix))
                            self.wheels[i]:showLightBox(false);
                        end

                        if i == self:nearMissOffset() then

                            --要转到第三个之前的时候
                            if nearMiss then
                                self:nearMissSuccess();
                                coroutine.yield(WaitForSeconds(R6))
                            else
                                coroutine.yield(WaitForSeconds(slotsManage.R2))
                            end
                        else
                            coroutine.yield(WaitForSeconds(slotsManage.R2))
                        end
                    end

                    local totalBet = nil;

                    if WRITE_DATA_MODE then
                        totalBet = curMachine:calculateLines(matrix);
                    else
                        totalBet = table.sum(table.csv2table(matrixAbout["c"]));
                    end

                    local isWin = (totalBet ~= 0);

                    if not WRITE_DATA_MODE then
                        local hightBetLv = curMachine:HightBetLv(totalBet);
                        if hightBetLv ~= 0 then
                            playPanel:showHightWinImage(hightBetLv);
                            audio.PlaySound("CreditsRollUpHeightWin");
                        else
                            if isWin then
                                audio.PlaySound("CreditsRollUp");
                            end
                        end
                    end

                    sendEvent(SPIN_OVER, isWin, slotsManage.getTotalAward(totalBet))
                    if isWin then
                        self:winShowLightBox(true);
                    end

                    local fixedWinAnimalDic = nil;
                    if WRITE_DATA_MODE then
                        fixedWinAnimalDic = curMachine.fixedWinAnimalDic;--动画相关
                    else
                        fixedWinAnimalDic = matrixAbout["b"];
                    end

                    if table.hash_count(fixedWinAnimalDic) > 0 then
                        self.awardAnimals = cs_coroutine.start(function()
                            while true do
                                for i, v in pairs(fixedWinAnimalDic) do
                                    local completeMatrix = v;
                                    self:lineAnim(tonumber(i), false);
                                    for i1, v1 in ipairs(completeMatrix) do
                                        for i2, v2 in ipairs(v1) do
                                            if v2 == 1 then
                                                self.mapPatterns[i1][i2]:awardAnim();
                                            end
                                        end
                                    end
                                    coroutine.yield(WaitForSeconds(AWARD_ANIM_DELAY2));
                                    self:lineAnim(tonumber(i), true);
                                end
                            end
                        end)
                    end
                end))
                coroutine.yield(WaitForSeconds(waitCost));
            end
        else
            coroutine.yield(cs_coroutine.start(function()
                slotsManage.R2Change(R2)--改变时间这里应该对该修改的声音进行重置
                slotsManage.R1Change(R1 / 2)

                local matrix = nil;--一直都是直观的
                local matrixAbout = matrixAboutTemp;--这个里面保护图案还有其他信息
                if WRITE_DATA_MODE then
                    local tempMatrix;
                    local count = 0;
                    local WildPatterns;
                    repeat
                        self:randomSetImage();--把隐藏的也设置了但是没有关系
                        tempMatrix = self:getMapPatternNames();--从直观的地方获取名字
                        local mid = curMachine:fixedMatrixMidRow(tempMatrix);-- 冗余了但是没办法
                        WildPatterns = curMachine:WildPatterns(mid);
                        count = count + 1;
                    until ((#WildPatterns ~= 2));
                    --print("count:", count)
                    matrix = tempMatrix;
                else
                    matrix = matrixAbout["a"]--得到的是玩家直观的;
                end
                if PATTERNS_QUICK then
                    matrix = self:quickPatterns();
                end

                local nearMissLineTable = curMachine:fixedMatrixMidRow(matrix);--获取nearMiss那条线默认是中间条
                local nearMiss = (math.ratio(NEAR_MISS_RATIO)) and (curMachine:isNearMiss(nearMissLineTable));

                for i, v in ipairs(self.wheels) do
                    self:roll(i, true);
                end

                coroutine.yield(WaitForSeconds(R1 / 2))
                coroutine.yield(WaitForSeconds(slotsManage.R1));

                for i, v in ipairs(self.wheels) do
                    self:roll(i, false, self:matrixChange(matrix))
                    if i == self:nearMissOffset() then

                        --要转到第三个之前的时候
                        if nearMiss then
                            self:nearMissSuccess();
                            coroutine.yield(WaitForSeconds(R6))
                        else
                            coroutine.yield(WaitForSeconds(slotsManage.R2))
                        end
                    else
                        coroutine.yield(WaitForSeconds(slotsManage.R2))
                    end
                end

                local totalBet = nil;

                if WRITE_DATA_MODE then
                    totalBet = curMachine:calculateLines(matrix);
                else
                    totalBet = table.sum(table.csv2table(matrixAbout["c"]));
                end

                local isWin = (totalBet ~= 0);

                if not WRITE_DATA_MODE then
                    local hightBetLv = curMachine:HightBetLv(totalBet);
                    if hightBetLv ~= 0 then
                        playPanel:showHightWinImage(hightBetLv);
                        audio.PlaySound("CreditsRollUpHeightWin");
                    else
                        if isWin then
                            audio.PlaySound("CreditsRollUp");
                        end
                    end
                end

                sendEvent(SPIN_OVER, isWin, slotsManage.getTotalAward(totalBet))
                if isWin then
                    self:winShowLightBox(true);
                end

                local fixedWinAnimalDic = nil;
                if WRITE_DATA_MODE then
                    fixedWinAnimalDic = curMachine.fixedWinAnimalDic;--动画相关
                else
                    fixedWinAnimalDic = matrixAbout["b"];
                end

                if table.hash_count(fixedWinAnimalDic) > 0 then
                    self.awardAnimals = cs_coroutine.start(function()
                        while true do
                            for i, v in pairs(fixedWinAnimalDic) do
                                local completeMatrix = v;
                                self:lineAnim(tonumber(i), false);
                                for i1, v1 in ipairs(completeMatrix) do
                                    for i2, v2 in ipairs(v1) do
                                        if v2 == 1 then
                                            self.mapPatterns[i1][i2]:awardAnim();
                                        end
                                    end
                                end
                                coroutine.yield(WaitForSeconds(AWARD_ANIM_DELAY2));
                                self:lineAnim(tonumber(i), true);
                            end
                        end
                    end)
                end
            end))
        end

        rotate = false;
        if auto then
            coroutine.yield(WaitForSeconds(R5));
            playPanel:spinButtonAction2()
        end
    end)
end

return slotsUI3
