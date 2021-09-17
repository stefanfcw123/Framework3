-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/9/17 17:39:36                                                                                           
-------------------------------------------------------

---@class lobbyPanel
local lobbyPanel = class('lobbyPanel', ui)

local btns = {};

local function initButton(self)
    btns = array2table(self.CGameObject, Button);

    for i = 1, #btns do
        btns[i].onClick:AddListener(function()
            print("btn click " .. i)
        end)
    end
end

function lobbyPanel:init()
    lobbyPanel.super.init(self)
    self:show()
    initButton(self);
end




--auto

function lobbyPanel:ctor(go, tier)
    lobbyPanel.super.ctor(self, go, tier)
    self.CGameObject = self.go.transform:Find("Scroll View/Viewport/CGameObject").gameObject;


end

function lobbyPanel:CGameObjectSetParent(t)
    t.transform:SetParent(self.CGameObject.transform, false);
end

return lobbyPanel
