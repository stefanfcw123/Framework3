﻿-------------------------------------------------------
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

    local address = "";
    if Differences.Android() then
        if CHANEL == ANDROID_CHANEL.Google then
            address = "https://play.google.com/store/apps/details?id=" .. Application.identifier;
        elseif CHANEL == ANDROID_CHANEL.Amazon then
            address = "amzn://apps/android?p=" .. Application.identifier;
        end

    elseif Differences.IOS() then
        --todo 修改id
        local appId = 1493495077
        address = "itms-apps://itunes.apple.com/app/id" .. tostring(appId) .. "?action=write-review";
    end

    UnityEngine.Application.OpenURL(address);
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
