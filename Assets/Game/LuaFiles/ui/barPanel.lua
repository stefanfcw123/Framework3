-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/9/18 9:54:28                                                                                           
-------------------------------------------------------

---@class barPanel
local barPanel = class('barPanel', ui)

function barPanel:init()
    self.tier = "PopUp"
    barPanel.super.init(self)
    self:show()
    uiActive(self.backButton, false)
    self:coinTextRefresh(string.format_foreign(data.money));
    addEvent(BACK_LOBBY, function()
        uiActive(self.backButton, false)
    end)
    addEvent(WILL_PLAY, function()
        uiActive(self.backButton)
    end)
end

function barPanel:backButtonAction()
    sendEvent(BACK_LOBBY)
end

--auto

function barPanel:ctor(go, tier)
    barPanel.super.ctor(self, go, tier)
    self.backButton = self.go.transform:Find("backButton"):GetComponent('Button');
    self.coinText = self.go.transform:Find("Image/coinText"):GetComponent('Text');

    self.backButton.onClick:AddListener(function()
        self:backButtonAction()
    end);

end

function barPanel:coinTextRefresh(t)
    self.coinText.text = t;
end

return barPanel
