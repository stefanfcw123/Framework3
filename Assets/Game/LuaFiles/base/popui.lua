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
    self.go:GetComponent("Image").color = getColor(0, 0, 0, 100);
    self.main = self.go.transform:Find("Image");
    local closeBtn = self.main:Find("Button"):GetComponent("Button");
    closeBtn.onClick:AddListener(function()
        self:hide();
    end)
end

function popui:GetAnim()
    local s = DOTween.Sequence();
    s:SetEase(Tweening.Ease.OutBounce)
    local t1 = self.main:DOScale(0.5, 0);
    local t2 = self.main:DOScale(1, POP_SLOW);
    s:Append(t1);
    s:Append(t2);
    s:OnComplete(function()
        --print("popui s is complete!")
    end)
    return s;
end

function popui:show()
    popui.super.show(self);
    self:GetAnim()
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
