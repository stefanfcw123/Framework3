-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/9/30 13:48:43                                                                                           
-------------------------------------------------------

---@class pigPanel
local pigPanel = class('pigPanel', popui)

function pigPanel:init()
    pigPanel.super.init(self)

    self:TotalPigChipRefresh();
    addEvent(SPIN_START, function()
        self:TotalPigChipRefresh();
    end)
    self:buyTextRefresh(string.format("Break Now For $%s", shop.pigDoller()))
end

function pigPanel:TotalPigChipRefresh()
    self:pigTextRefresh(string.format_foreign(shop.getPigChip()))
end

function pigPanel:buyButtonAction()
    sendEvent(SHOP_BUY, 7)
end

--auto

function pigPanel:ctor(go, tier)
    pigPanel.super.ctor(self, go, tier)
    self.pigText = self.go.transform:Find("Image/pigText"):GetComponent('Text');
    self.buyButton = self.go.transform:Find("Image/buyButton"):GetComponent('Button');
    self.buyText = self.go.transform:Find("Image/buyButton/buyText"):GetComponent('Text');

    self.buyButton.onClick:AddListener(function()
        self:buyButtonAction()
    end);

end

function pigPanel:pigTextRefresh(t)
    self.pigText.text = t;
end
function pigPanel:buyTextRefresh(t)
    self.buyText.text = t;
end

return pigPanel
