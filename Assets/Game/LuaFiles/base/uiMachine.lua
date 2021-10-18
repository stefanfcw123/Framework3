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

function uiMachine:loadAllSprite()
    local arr = AF:LoadSprites(self.lv);

    self.sprites = {}
    for i = 1, arr.Length do
        self.sprites[i] = arr[i - 1];
    end
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

        for i, v in ipairs(self.wheels) do
            coroutine.yield(WaitForSeconds(1.3))
            self:roll(i, false)
        end
    end)

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
