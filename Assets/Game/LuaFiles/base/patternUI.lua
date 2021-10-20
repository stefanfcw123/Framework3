-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/10/18 11:03:39                                                                                           
-------------------------------------------------------

---@class patternUI
local patternUI = class('patternUI')

function patternUI:ctor()
    --  print("ctor")
end

function patternUI:Start()
    self.isStop = true;
    self.rect = self.transform:GetComponent(typeof(RectTransform));
    self.curY = self.rect.anchoredPosition.y;
    self.initY = self.curY;
end

function patternUI:GetPatternImage()
    return self.transform:GetComponent(typeof(Image));
end

function patternUI:GetPatternImageName()
    return self:GetPatternImage().sprite.name;
end

function patternUI:setImage(s, uiInstance)
    self:GetPatternImage() .sprite = s;
    self.uiInstance = uiInstance;
    -- print(self.uiInstance, "form patternUI")
end

function patternUI:spinStart()
    self.isStop = false;
    --  print("spinStart")
end

function patternUI:spinOver()
    self.isStop = true;

    self.rect.anchoredPosition = Vector2(self.rect.anchoredPosition.x, self.initY);

    local s = DOTween.Sequence()
    local offset = 30
    local perCost = 0.1;
    s:Append(self.rect:DOAnchorPosY(-offset, perCost):SetRelative(true))
    s:Append(self.rect:DOAnchorPosY(offset, perCost):SetRelative(true))
    s:OnComplete(function()
        -- print("over")
    end)
end

function patternUI:Update()

    if self.isStop then
        return ;
    end

    self.curY = self.curY - 33;
    if self.curY <= -400 then
        self:setImage(self.uiInstance:getRandomSprite(), self.uiInstance);
        self.curY = 400;
    end
    self.rect.anchoredPosition = Vector2(self.rect.anchoredPosition.x, self.curY);

end

return patternUI
