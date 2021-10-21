-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/9/18 15:22:41                                                                                           
-------------------------------------------------------

---@class popui
local popui = class('popui', ui)

function popui:init()
    self.tier = "AlwaysInFront";
    popui.super.init(self)
    self.bg = self.go:GetComponent("Image");
    self.bg.color = getColor(0, 0, 0, 100);
    self.main = self.go.transform:Find("Image");
    self. canvasGroup = self.main.gameObject:AddComponent(typeof(CanvasGroup));
    self. closeBtn = self.main:Find("Button"):GetComponent("Button");
    self. closeBtn.onClick:AddListener(function()
        self:closeAnim();
    end)
end

function popui:closeAnim()
    self.bg:DOFade(0, 0)
    local s = DOTween.Sequence();
    s:Append(self.main:DOScale(0, POP_SLOW));
    s:Insert(0, self.canvasGroup:DOFade(0, POP_SLOW));
    s:OnComplete(function()
        self:hide();
    end)
end

function popui:GetAnim()
    local firstScale = 0.5 --math.random() > 0.5 and 1.5 or 0.5;
    local secondScale = 1;
    local s = DOTween.Sequence();
    s:SetEase(Tweening.Ease.OutBounce)
    local t0 = self.canvasGroup:DOFade(1, 0);
    local t1 = self.main:DOScale(firstScale, 0);
    local t2 = self.main:DOScale(secondScale, POP_SLOW);
    s:Append(t0);
    s:Append(t1);
    s:Append(t2);
    s:OnComplete(function()
        --print("popui is complete!")
    end)
    return s;
end

function popui:show()
    popui.super.show(self);
    self:GetAnim()
    self.bg:DOFade(0, 0);
    self.bg:DOFade(100 / 255, POP_SLOW)
    --[[    if self.mainAnim and self.mainAnim:IsPlaying() then
            self.mainAnim:Complete();
        end]]
end

function popui:hide()
    popui.super.hide(self);
end

--auto

function popui:ctor(go, tier)
    popui.super.ctor(self, go, tier)
end

return popui
