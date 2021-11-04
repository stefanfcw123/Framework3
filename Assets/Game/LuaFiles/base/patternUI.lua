-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/10/18 11:03:39                                                                                           
-------------------------------------------------------

---@class patternUI
local patternUI = class('patternUI')

function patternUI:ctor()
end

function patternUI:Start()

end

function patternUI:init(spritePool, pH, wheelUI, first, second)
    self.isStop = true;
    self.rect = self.transform:GetComponent(typeof(RectTransform));

    self.wheelUI = wheelUI;
    self:setHeight(pH);
    self:setAnchoredPositionY(self.wheelUI:GetPos(string.get_pure_number(self.transform.gameObject.name)))

    self.curY = self.rect.anchoredPosition.y;
    self.initY = self.curY;
    self.spinSpeed = pH / 4;--这里不能超过规定高度

    self.spritePool = spritePool;
    self:randomSetImage()

    self.first = first;
    self.second = second;
    self.uiEffect = self.transform:Find("Image"):GetComponent(typeof(CS.Coffee.UIEffects.UIEffect))
    -- print("f,s", self.first, self.second);
end

function patternUI:setHeight(number)
    local v2 = Vector2(200, number);
    self.rect.sizeDelta = v2;
end

function patternUI:GetPatternImage()
    return self.transform:Find("Image"):GetComponent(typeof(Image));
end

function patternUI:GetPatternImageName()
    --return table.get_random_item(self.spritePool).name;
    return self:GetPatternImage().sprite.name;
end

function patternUI:SetImageByName(name)
    local s = nil;
    for i, v in ipairs(self.spritePool) do
        if v.name == name then
            s = v;
            break ;
        end
    end
    if s == nil then
        error("The sprite don't find in self.spritePool")
    end

    self:SetImage(s);
end

function patternUI:SetImage(s)
    self:GetPatternImage() .sprite = s;
    self:GetPatternImage():SetNativeSize();
    self:GetPatternImage().transform.localScale = Vector3.one * 0.6;
end

function patternUI:randomSetImage()
    self:SetImage(table.get_random_item(self.spritePool))
end

function patternUI:spinStart()
    self.isStop = false;
    self.uiEffect.blurFactor = 1;
    --  print("spinStart")
end

function patternUI:spinOver()
    self.isStop = true;
    self.uiEffect.blurFactor = 0;

    self.rect.anchoredPosition = Vector2(self.rect.anchoredPosition.x, self.initY);

    local s = DOTween.Sequence()
    local offset = 60

    s:Append(self.rect:DOAnchorPosY(-offset, R3 / 2):SetRelative(true))
    s:Append(self.rect:DOAnchorPosY(offset, R3 / 2):SetRelative(true))
    --[[    s:OnComplete(function()
            print(Time.time, "gird")
        end)]]
end

function patternUI:setAnchoredPositionY(f)
    self.rect.anchoredPosition = Vector2(self.rect.anchoredPosition.x, f);
end

-- todo 偏移起来不能够统一不知道为啥，暂时不想处理了
function patternUI:Update()
    if self.isStop then
        return ;
    end

    if SPIN_QUICK then
        return ;
    end

    self.curY = self.curY - self.spinSpeed;
    if self.curY <= self.first then
        self:randomSetImage();
        self.curY = self.second;
    end

    self:setAnchoredPositionY(self.curY)
end

return patternUI
