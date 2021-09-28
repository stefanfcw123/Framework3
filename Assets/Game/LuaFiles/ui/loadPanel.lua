-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/9/17 16:43:55                                                                                           
-------------------------------------------------------

---@class loadPanel
local loadPanel = class('loadPanel', ui)

local pSpeed = 0.25;

function loadPanel:init()
    --print("loadPanel init")
    self.tier = "Guide"
    loadPanel.super.init(self)
    self:show()
    self.progressSlider.interactable = false;
    self.progressSlider.value = 0;

    if QUICK_LOAD then
        pSpeed = 1000;
    end
end

function loadPanel:frame()
    self.progressSlider.value = self.progressSlider.value + Time.deltaTime * pSpeed;
    if self.progressSlider.value >= 1 then
        sendEvent(LOAD_OVER)
        self:hide();
    end
end

function loadPanel:progressSliderAction(t)
    self:progressTextRefresh(string.percent(t))
end

--auto

function loadPanel:ctor(go, tier)
    loadPanel.super.ctor(self, go, tier)
    self.progressSlider = self.go.transform:Find("progressSlider"):GetComponent('Slider');
    self.progressText = self.go.transform:Find("progressSlider/progressText"):GetComponent('Text');

    self.progressSlider.onValueChanged:AddListener(function(t)
        self:progressSliderAction(t)
    end);

end

function loadPanel:progressTextRefresh(t)
    self.progressText.text = t;
end

return loadPanel
