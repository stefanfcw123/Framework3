-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/10/20 10:00:06                                                                                           
-------------------------------------------------------

---@class wheelUI
local wheelUI = class('wheelUI')

function wheelUI:Start()
    --  print("wheelUI")
end

function wheelUI:init(spritePool)
    local height = self.transform.parent:GetComponent(typeof(RectTransform)).rect.height;
    local perHeight = height / slotsManage.curMachine:PatternWheelNumber();
    print(height, perHeight)
    self.patterns = {};
    local t = self.transform:Find("Image");
    local luaMonos = array2table(t, RectTransform, false);
    self.perHeight = perHeight;
    self.luaMonos = luaMonos;
    self.LightBox = self.transform:Find("LightBox").gameObject;

    for i, v in ipairs(luaMonos) do
        table.insert(self.patterns, v:GetComponent(typeof(CS.LuaMono)).TableIns);
        self.patterns[i]:init(spritePool, self.perHeight, self, self:GetPosFirst(), self:GetPosSecond())
    end

    -- print("first",self:GetPosFirst());
    --  print("second",self:GetPosSecond());
end

-- todo 如果有向上的运动，这里需要验证是否通用
function wheelUI:GetPos(index)
    local len = #self. luaMonos;
    local minIndex = len / 2;
    local offset = minIndex - index;
    return self.perHeight * offset;
end

function wheelUI:GetPosFirst()
    local res = self:GetPos(#self.luaMonos);
    return res;
end

--todo 如果增加反向运转模式，这里就会错
function wheelUI:GetPosSecond()
    return self:GetPos(0);
end

function wheelUI:randomSetImage()
    for i, v in ipairs(self.patterns) do
        v:randomSetImage();
    end
end

function wheelUI:getPatterns()
    local res = {}

    for i, v in ipairs(self.patterns) do
        -- todo 如果增加反向运转模式，这里就会错
        if i ~= 1 then
            table.insert(res, v)
        end
    end

    return res;
end

function wheelUI:showLightBox(show)
    self.LightBox:SetActive(show);
end

function wheelUI:SetImageByName(names)
    --[[    print(self.transform.gameObject.name)
         table.print_arr(names);]]
    for i, v in ipairs(self.patterns) do
        if i ~= 1 then
            --手动设置第一张是不需要设置的
            v:SetImageByName(names[i - 1])--依次设置所以要减1，因为是从第二张图片开始的
        end
    end
end

function wheelUI:spinStart()
    for i, v in ipairs(self.patterns) do
        v:spinStart();
    end
end

function wheelUI:spinOver()
    for i, v in ipairs(self.patterns) do
        v:spinOver();
    end
end

return wheelUI
