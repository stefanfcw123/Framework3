-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : $time$                                                                                           
-------------------------------------------------------

---@class MPanel
local MPanel = class('MPanel', ui)
local MPanelCS

function MPanel:init()
    MPanel.super.init(self)
    self:hide()
end
function MPanel:WButtonAction()
    print("woaini")
end
function MPanel:KKKToggleAction(t)
    print(t)
end
function MPanel:KKK2SliderAction(t)
    print("slider", t)
end
function MPanel:WDropdownAction(t)
    print("dropdown", t)
end

function MPanel:frame()
    print("mPanel fff")
end;
--auto

function MPanel:ctor(go, tier)
    MPanel.super.ctor(self, go, tier)
    MPanelCS = self.go:GetComponent('MPanel');
    self.BBkGameObject = self.go.transform:Find("BBkGameObject").gameObject;
    self.KKImage = self.go.transform:Find("KKImage"):GetComponent('Image');
    self.JText = self.go.transform:Find("JText"):GetComponent('Text');
    self.WDropdown = self.go.transform:Find("JText/WDropdown"):GetComponent('Dropdown');
    self.NiImage = self.go.transform:Find("JText/WDropdown/NiImage"):GetComponent('Image');
    self.WButton = self.go.transform:Find("WButton"):GetComponent('Button');
    self.KKK2Slider = self.go.transform:Find("KKK2Slider"):GetComponent('Slider');

    self.WDropdown.onValueChanged:AddListener(function(t)
        self:WDropdownAction(t)
    end);
    self.WButton.onClick:AddListener(function()
        self:WButtonAction()
    end);
    self.KKK2Slider.onValueChanged:AddListener(function(t)
        self:KKK2SliderAction(t)
    end);

end

function MPanel:BBkGameObjectSetParent(t)
    t.transform:SetParent(self.BBkGameObject.transform, false);
end
function MPanel:KKImageRefresh(t)
    self.KKImage.sprite = t;
end
function MPanel:JTextRefresh(t)
    self.JText.text = t;
end
function MPanel:NiImageRefresh(t)
    self.NiImage.sprite = t;
end

return MPanel
