-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/10/22 18:17:19                                                                                           
-------------------------------------------------------

---@class evaluatePanel
local evaluatePanel = class('evaluatePanel', popui)

function evaluatePanel:init()
    evaluatePanel.super.init(self)
end

function evaluatePanel:submitButtonAction()
    print("submit")
    --todo 走各种渠道的逻辑呢
end

--auto

function evaluatePanel:ctor(go, tier)
    evaluatePanel.super.ctor(self, go, tier)
    self.submitButton = self.go.transform:Find("Image/submitButton"):GetComponent('Button');

    self.submitButton.onClick:AddListener(function()
        self:submitButtonAction()
    end);

end

return evaluatePanel
