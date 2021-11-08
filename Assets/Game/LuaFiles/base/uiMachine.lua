-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/10/14 16:50:53                                                                                           
-------------------------------------------------------

---@class uiMachine
local uiMachine = class('uiMachine')

-- 尽量用动态生成UI减少工作时间
function uiMachine:ctor(lv)
    self.lv = lv;
    self.go = playPanel.go.transform:Find("Image" .. self.lv).gameObject;
    self.go:GetComponent("Image").sprite = AF:LoadSprite("bg" .. self.lv);
    local luaMonos = array2table(self.go.transform:Find("Image/Image"), RectTransform, false);
    self.wheels = {};
    local allSprites = self:loadAllSprite();
    local allSpritesNames = table.selectItems(allSprites, "name");
    slotsManage.SetAllSpritesNames(allSpritesNames);

    for i, v in ipairs(luaMonos) do
        table.insert(self.wheels, v:GetComponent(typeof(CS.LuaMono)).TableIns);
        local resSp = nil;
        if i == 1 then
            resSp = self:fixedAllSprite(allSprites, { "w3", "w4", "w5" })
        elseif i == 2 then
            resSp = self:fixedAllSprite(allSprites, { "w2" })
        elseif i == 3 then
            resSp = self:fixedAllSprite(allSprites, { "w3", "w4", "w5" })
        end
        -- print(#resSp)

        self.wheels[i]:init(resSp);
    end

    self.mapPatterns = self:getMapPatterns();

    --[[    local nameT = self:getMapPatternNames();
        table. print_nest_arr(nameT);]]
    print("uiMachine ctor")
end

function uiMachine:fixedAllSprite(allSprites, fT)
    local sp = table.copy(allSprites);

    for i, v in ipairs(fT) do
        local sv, si = table.find(sp, function(item)
            return item.name == v
        end)
        if si == nil then
            error("Don't find!")
        else
            table.remove(sp, si);
        end
    end
    return sp;
end

function uiMachine:SetImageByName(nameLists)
    for i, v in ipairs(self.wheels) do
        v:SetImageByName(nameLists[i]);
    end
end

function uiMachine:loadAllSprite()
    local arr = AF:LoadSprites(self.lv);

    local res = {}
    for i = 1, arr.Length do
        local s = arr[i - 1];
        table.insert(res, s);
        assert(string.haveEmpty(s.name) == false, "The image name have empty char!");
    end
    table.insert(res, AF:LoadSprite("Empty"))

    return res;
end

function uiMachine:rollAll()
    local s = cs_coroutine.start(function()
        rotate = true;

        slotsManage.R2Change(R2)
        slotsManage.R1Change(R1 / 2)

        local mC = self:matrixChange(slotsManage.curMachine:getRandomMatrix())
        local matrix = self:matrixChange(mC);
        local lineTable = slotsManage.curMachine:fixedMatrixMidRow(matrix);
        local nearMiss = (math.ratio(NEAR_MISS_RATIO)) and (slotsManage.curMachine:isNearMiss(lineTable));

        for i, v in ipairs(self.wheels) do
            self:roll(i, true);
        end

        coroutine.yield(WaitForSeconds(R1 / 2))
        coroutine.yield(WaitForSeconds(slotsManage.R1));

        for i, v in ipairs(self.wheels) do
            self:roll(i, false, mC)

            if i == (#self.wheels - 1) then
                if nearMiss then
                    coroutine.yield(WaitForSeconds(slotsManage.R2 * 3))
                    print("nearMiss")
                else
                    coroutine.yield(WaitForSeconds(slotsManage.R2))
                end
            else
                coroutine.yield(WaitForSeconds(slotsManage.R2))
            end
        end

        if WRITE_DATA_MODE then
            -- todo 下次写入还需要验证下这里对不对
            self:randomSetImage();
            matrix = self:getMapPatternNames();
        end

        if PATTERNS_QUICK then
            matrix = {
                { "s3", "w4", "b3" },
                { "w2", "w3", "w2" },
                { "s2", "b2", "b2" },
            }
        end

        local bet = slotsManage.curMachine:calculateLines(matrix);

        local hightBetLv = slotsManage.curMachine:HightBetLv(bet);
        if hightBetLv ~= 0 then
            playPanel:showHightWinImage(hightBetLv);
        end
        -- print("playPanel:showHightWinImage", hightBetLv)

        sendEvent(SPIN_OVER, bet ~= 0, slotsManage.getTotalAward(bet))
        -- print(Time.time, "over")

        local winAnimalDic = slotsManage.curMachine.winAnimalDic;
        if table.hash_count(winAnimalDic) > 0 then
            --print(B)
            self.awardAnimals = cs_coroutine.start(function()

                while true do
                    for i, v in pairs(winAnimalDic) do
                        local winAnimal = table.copy(v);
                        local completeMatrix = table.copyMatrix(slotsManage.curMachine.LineNumberMatrix[i]);

                        --todo 遍历矩阵 machine:calculateLines的方式务必保持一致
                        for i1, v1 in ipairs(completeMatrix) do
                            for i2, v2 in ipairs(v1) do
                                if completeMatrix[i1][i2] == 1 then
                                    local rmVal = table.removeFirst(winAnimal);
                                    completeMatrix[i1][i2] = rmVal and 1 or 0;
                                end
                            end
                        end

                        assert(#winAnimal == 0);
                        --table.print_nest_arr(completeMatrix);
                        for i1, v1 in ipairs(completeMatrix) do
                            for i2, v2 in ipairs(v1) do
                                if v2 == 1 then
                                    self.mapPatterns[i1][i2]:awardAnim();
                                end
                            end
                        end
                        --print("---------------------")
                        coroutine.yield(WaitForSeconds(AWARD_ANIM_DELAY2));
                    end
                end
            end)
           -- print(B)
        end

        rotate = false;

        -- print("auto", auto)
        if auto then
            coroutine.yield(WaitForSeconds(0.33));
            playPanel:spinButtonAction2()
        else
        end
    end)
end

function uiMachine:randomSetImage()
    for i, v in ipairs(self.wheels) do
        v:randomSetImage();
    end
end

function uiMachine:getMapPatterns()
    local bigT = {};
    for i, v in ipairs(self.wheels) do
        local t = v:getPatterns();
        table.insert(bigT, t);
    end

    return self:matrixChange(bigT);
end

function uiMachine:getMapPatternNames()
    local res = {};
    for i, v in ipairs(self.mapPatterns) do
        res[i] = {};
        for i1, v1 in ipairs(v) do
            res[i][i1] = v1:GetPatternImageName();
        end
    end
    return res;
end

function uiMachine:matrixChange(matrix)
    local res = {};

    for i, v in ipairs(matrix) do
        res[i] = {};
    end

    for i, v in ipairs(matrix) do
        for i2, v2 in ipairs(v) do
            res[i2][i] = v2;
        end
    end

    return res;
end

function uiMachine:roll(index, isStart, mC)
    local wheel = self.wheels[index];
    if isStart then
        wheel:spinStart();
    else
        wheel:spinOver();
        wheel:SetImageByName(mC[index]);
    end
end

function uiMachine:spinStart()
    if self.awardAnimals then
        cs_coroutine.stop(self.awardAnimals);
    end

    self:rollAll();
end

function uiMachine:spinOver()

end

return uiMachine
