-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/10/20 18:40:19                                                                                           
-------------------------------------------------------

---@class spinButton
local spinButton = class('spinButton')

function spinButton:setImg(name)
    self.img.sprite = AF:LoadSprite(name);
end

function spinButton:Start()
    self.img = self.transform:GetComponent(typeof(Image));

    self:setImg("spin1");
end

function spinButton:OnPointerClick(eventData)
end

function spinButton:OnPointerDown(eventData)
    self:setImg("spin2");
end

function spinButton:OnPointerUp(eventData)
    self:setImg("spin1");
end

return spinButton
