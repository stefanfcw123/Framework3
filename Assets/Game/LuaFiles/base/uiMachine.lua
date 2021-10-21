-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/10/14 16:50:53                                                                                           
-------------------------------------------------------

---@class uiMachine
local uiMachine = class('uiMachine')

-- todo 后面采用动态生成的话，可以节省很多制造广告UI的时间，是非常值得的后面一定要搞起来
function uiMachine:ctor(lv)
    self.lv = lv;
    self.go = playPanel.go.transform:Find("Image" .. self.lv).gameObject;
    self.go:GetComponent("Image").sprite = AF:LoadSprite("bg" .. self.lv);
    local luaMonos = array2table(self.go.transform:Find("Image/Image"), RectTransform, false);
    self.wheels = {};
    local allSprites = self:loadAllSprite();

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

-- todo 也需要判断字符串是否含有trim()
function uiMachine:loadAllSprite()
    local arr = AF:LoadSprites(self.lv);

    local res = {}
    for i = 1, arr.Length do
        local s = arr[i - 1];
        table.insert(res, s);
    end
    table.insert(res, AF:LoadSprite("Empty"))

    return res;
end

function uiMachine:rollAll()

    local s = cs_coroutine.start(function()

        if SPIN_QUICK then
            self:randomSetImage();
        end

        for i, v in ipairs(self.wheels) do
            self:roll(i, true);
        end

        coroutine.yield(WaitForSeconds(R1));

        for i, v in ipairs(self.wheels) do
            self:roll(i, false)
            coroutine.yield(WaitForSeconds(R2))
        end

        local matrix = self:getMapPatterns();
        if PATTERNS_QUICK then
            matrix = {
                { "b1", "b1", "w2" },
                { "w2", "w5", "w2" },
                { "w2", "b1", "b1" },
            }
        end
        local bet = slotsManage.curMachine:calculateLines(matrix);

        --todo 验证快速动画过程中金币会少加吗？
        sendEvent(SPIN_OVER, bet ~= 0, slotsManage.getTotalAward(bet))
        -- print(Time.time, "over")

        if auto then
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

-- todo 单元测试row和col要数据统一
-- todo 限定生成池，不要222，目前第一款游戏哦
function uiMachine:getMapPatterns(row, col)

    local bigT = {};
    for i, v in ipairs(self.wheels) do
        local t = v:getPatterns();
        table.insert(bigT, t);
    end

    local normalT = {
        {},
        {},
        {},
    }

    for i, v in ipairs(bigT) do
        for i2, v2 in ipairs(v) do
            normalT[i2][i] = v2;
        end
    end

    return normalT;
end

function uiMachine:roll(index, isStart)
    local wheel = self.wheels[index];
    if isStart then
        wheel:spinStart();
    else
        wheel:spinOver();
    end
end

function uiMachine:spinStart()
    self:rollAll();
end

function uiMachine:spinOver()

end

return uiMachine
