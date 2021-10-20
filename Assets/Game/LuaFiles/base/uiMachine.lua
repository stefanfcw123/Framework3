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
    self.wheels = array2table(self.go.transform:Find("Image/Image"), RectTransform, false)
    self.bigPatternTableIns = {}
    print("uiMachine ctor")

    for i, v in ipairs(self.wheels) do
        local patternRects = array2table(v, RectTransform, false);
        local patternMonoTableIns = {}
        for i = 1, #patternRects do
            patternMonoTableIns[i] = patternRects[i]:GetComponent(typeof(CS.LuaMono)).TableIns;
        end
        self.bigPatternTableIns[i] = patternMonoTableIns;
    end

    self:loadAllSprite();
    self:randomSetAllPattern();

    --print(slotsManage.curMachine, " from uiMachine")
end

-- todo 也需要判断字符串是否含有trim()
function uiMachine:loadAllSprite()
    local arr = AF:LoadSprites(self.lv);

    self.sprites = {}
    for i = 1, arr.Length do
        local s = arr[i - 1];
        table.insert(self.sprites, s);
    end

    -- self.sprites[#self.sprites + 1] = AF:LoadSprite("Empty");
end

function uiMachine:getRandomSprite()
    local randomLuaIndex = math.random(#self.sprites);--产生[1-#self.sprites]之间的索引
    return self.sprites[randomLuaIndex];
end

function uiMachine:randomSetAllPattern()
    for i, v in ipairs(self.bigPatternTableIns) do
        for i2, v2 in ipairs(v) do
            v2:setImage(self:getRandomSprite(), self)
        end
    end
end

function uiMachine:rollAll()
    local s = cs_coroutine.start(function()
        for i, v in ipairs(self.wheels) do
            self:roll(i, true);
        end

        coroutine.yield(WaitForSeconds(1.2));

        for i, v in ipairs(self.wheels) do
            coroutine.yield(WaitForSeconds(1 / 2.5))
            self:roll(i, false)
        end

        local matrix = self:getMapPatterns();
        table.print_nest_arr(matrix)
    end)
end

-- todo 单元测试row和col要数据统一
-- todo 限定生成池，不要222，目前第一款游戏哦
function uiMachine:getMapPatterns(row, col)

    local bigT = {};
    for i, v in ipairs(self.bigPatternTableIns) do
        local t = {};
        for i2, v2 in ipairs(v) do
            if i2 ~= 1 then
                table.insert(t, v2:GetPatternImageName());
            end
        end
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
    for i, v in ipairs(self.bigPatternTableIns[index]) do
        if isStart then
            v:spinStart();
        else
            v:spinOver();
        end
    end
end

function uiMachine:spinStart()
    self:rollAll();
end

function uiMachine:spinOver()

end

return uiMachine
