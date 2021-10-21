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

function patternUI:init(spritePool)
    self.isStop = true;
    self.rect = self.transform:GetComponent(typeof(RectTransform));
    self.curY = self.rect.anchoredPosition.y;
    self.initY = self.curY;
    self.width = 200;
    self.height = 200;
    self.spinSpeed = 40;--这里不能超过图片高度

    self.spritePool = spritePool;
    --todo 这里图片数据每次进入都要重置
    self:randomSetImage()
end

function patternUI:GetPatternImage()
    return self.transform:GetComponent(typeof(Image));
end

function patternUI:GetPatternImageName()
    --return table.get_random_item(self.spritePool).name;
    return self:GetPatternImage().sprite.name;
end

function patternUI:randomSetImage()
    self:GetPatternImage() .sprite = table.get_random_item(self.spritePool);
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

--[[    if SPIN_QUICK then
        perCost = 0.1 / 2;
    end]]

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

    self.curY = self.curY - self.spinSpeed;
    if self.curY <= -400 then
        if not SPIN_QUICK then
            self:randomSetImage();
        end
        self.curY = 400;
    end

    self.rect.anchoredPosition = Vector2(self.rect.anchoredPosition.x, self.curY);


end

return patternUI
