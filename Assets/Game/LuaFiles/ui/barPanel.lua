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
    self.levelSlider.interactable = false;

    addEvent(BACK_LOBBY, function()
        uiActive(self.backButton, false)
    end)
    addEvent(WILL_PLAY, function()
        uiActive(self.backButton)
    end)
    addEvent(CHIP_CHANGE, function(n1, n2)
        DOTween.To(function(f)
            self:coinTextRefresh(string.format_foreign(f));
        end, n1, n2, GIGITAL_SLOW);
    end)

    save.addChip(0);

end

function barPanel:levelSliderAction(t)
end

function barPanel:setButtonAction()
    settingPanel:show();
end

function barPanel:backButtonAction()
    sendEvent(BACK_LOBBY)
end

function barPanel:buyButtonAction()
    buyPanel:show()
end

--auto
   
function barPanel:ctor(go, tier)
    barPanel.super.ctor(self, go, tier)
	self.backButton=self.go.transform:Find("backButton"):GetComponent('Button');
	self.coinText=self.go.transform:Find("Image/coinText"):GetComponent('Text');
	self.buyButton=self.go.transform:Find("buyButton"):GetComponent('Button');
	self.setButton=self.go.transform:Find("setButton"):GetComponent('Button');
	self.levelSlider=self.go.transform:Find("levelSlider"):GetComponent('Slider');
	
    self.backButton.onClick:AddListener(function()self:backButtonAction()end);
	self.buyButton.onClick:AddListener(function()self:buyButtonAction()end);
	self.setButton.onClick:AddListener(function()self:setButtonAction()end);
	self.levelSlider.onValueChanged:AddListener(function(t)self:levelSliderAction(t)end);
	
end
	
    function barPanel:coinTextRefresh(t)self.coinText.text=t;end
	    

return barPanel
