-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/9/30 13:48:43                                                                                           
-------------------------------------------------------

---@class pigPanel
local pigPanel = class('pigPanel', popui)

function pigPanel:init()
    pigPanel.super.init(self)
    self:pigTextRefresh(string.format_foreign(shop.getPigChip()))
    --todo There refresh will it be outdated?
    addEvent(SPIN_START,function()
        self:pigTextRefresh(string.format_foreign(shop.getPigChip()))
    end)
end

function pigPanel:buyButtonAction()
    sendEvent(SHOP_BUY)
    -- todo  Buy success clear cache!
end

--auto

function pigPanel:ctor(go, tier)
    pigPanel.super.ctor(self, go, tier)
    self.buyButton = self.go.transform:Find("Image/buyButton"):GetComponent('Button');
    self.pigText = self.go.transform:Find("Image/pigText"):GetComponent('Text');

    self.buyButton.onClick:AddListener(function()
        self:buyButtonAction()
    end);

end

function pigPanel:pigTextRefresh(t)
    self.pigText.text = t;
end

return pigPanel
