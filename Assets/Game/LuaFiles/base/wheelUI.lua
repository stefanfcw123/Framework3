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
    self.patterns = {};
    local luaMonos = array2table(self.transform, RectTransform, false);

    for i, v in ipairs(luaMonos) do
        table.insert(self.patterns, v:GetComponent(typeof(CS.LuaMono)).TableIns);
        self.patterns[i]:init(spritePool)
    end
end

function wheelUI:randomSetImage()
    for i, v in ipairs(self.patterns) do
        v:randomSetImage();
    end
end

function wheelUI:getPatterns()
    local res = {}

    for i, v in ipairs(self.patterns) do
        -- todo 后期换了长宽这里1就会是错误的
        if i ~= 1 then
            table.insert(res, v:GetPatternImageName())
        end
    end

    return res;
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
