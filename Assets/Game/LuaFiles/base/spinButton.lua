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

local isDown = false;
local timer = 0;
local targetTime = 1
local auto;

function spinButton:Start()
    self.img = self.transform:GetComponent(typeof(Image));
    local btn = self.transform:GetComponent("Button");
    btn.onClick:RemoveAllListeners();

end

function spinButton:longPress()
    if not auto then
        auto = true; --todo 这里的循环是要等待所以携程结束
        self:setImg("auto");
    else
    end
    --print("long press")
end

function spinButton:Update()
    if isDown then
        timer = timer + Time.deltaTime;
        if timer >= targetTime then
            self:longPress();
            timer = 0;
        end
    else
        timer = 0;
    end
end

function spinButton:OnPointerClick(eventData)
end

function spinButton:OnPointerDown(eventData)
    isDown = true;

    if not auto then
        self:setImg("spin2");
        playPanel:spinButtonAction2()
    else
        auto = false;
        self:setImg("spin2")
    end

end

function spinButton:OnPointerUp(eventData)
    isDown = false;

    if not auto then
        self:setImg("spin1");
    else
    end

end

return spinButton
