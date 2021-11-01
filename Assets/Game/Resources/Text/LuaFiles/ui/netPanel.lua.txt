-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/10/13 17:39:39                                                                                           
-------------------------------------------------------

---@class netPanel
local netPanel = class('netPanel', ui)

local rotateAdd = 0;
function netPanel:init()
    self.tier = "Guide"
    netPanel.super.init(self)
    addEvent(NET_PANEL, function(open)
        if open then
            self:show();
        else
            self:hide();
            rotateAdd = 0;
        end
    end)
    self.go:GetComponent("Image").color = getColor(0, 0, 0, 200);

    print("netPanel init")
end

function netPanel:frame()
    rotateAdd = rotateAdd + 1;
    self.rImage.transform.localEulerAngles = Vector3(0, 0, rotateAdd)
end

--auto

function netPanel:ctor(go, tier)
    netPanel.super.ctor(self, go, tier)
    self.rImage = self.go.transform:Find("rImage"):GetComponent('Image');
    self.lText = self.go.transform:Find("Image (1)/lText"):GetComponent('Text');


end

function netPanel:rImageRefresh(t)
    self.rImage.sprite = t;
end
function netPanel:lTextRefresh(t)
    self.lText.text = t;
end

return netPanel
