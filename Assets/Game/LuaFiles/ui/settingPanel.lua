-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/9/18 15:32:13                                                                                           
-------------------------------------------------------

---@class settingPanel
local settingPanel = class('settingPanel', popui)

local function setToggleState(enable, toggle)
    if enable then
        toggle.isOn = true;
    else
        toggle.isOn = false;
    end
end

function settingPanel:init()
    settingPanel.super.init(self)

    setToggleState(data._soundEnable, self.soundToggle);
    setToggleState(data._musicEnable, self.musicToggle);
end

function settingPanel:buyButtonAction(t)
    print("setting buyButton")
    buyPanel:show()
end

function settingPanel:soundToggleAction(t)
    data._soundEnable = t;
end

function settingPanel:musicToggleAction(t)
    data._musicEnable = t;
    audio.switchMusic();
end

--auto

function settingPanel:ctor(go, tier)
    settingPanel.super.ctor(self, go, tier)
    self.soundToggle = self.go.transform:Find("Image/soundToggle"):GetComponent('Toggle');
    self.musicToggle = self.go.transform:Find("Image/musicToggle"):GetComponent('Toggle');
    self.buyButton = self.go.transform:Find("Image/buyButton"):GetComponent('Button');

    self.soundToggle.onValueChanged:AddListener(function(t)
        self:soundToggleAction(t)
    end);
    self.musicToggle.onValueChanged:AddListener(function(t)
        self:musicToggleAction(t)
    end);
    self.buyButton.onClick:AddListener(function()
        self:buyButtonAction()
    end);

end

return settingPanel
