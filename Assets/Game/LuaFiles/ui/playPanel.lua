-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/9/18 10:05:03                                                                                           
-------------------------------------------------------

---@class playPanel
local playPanel = class('playPanel', ui)

function playPanel:init()
    playPanel.super.init(self)
    addEvent(WILL_PLAY, function()
        self:show()
    end)
    addEvent(BACK_LOBBY, function()
        self:hide()
    end)
end

--auto

function playPanel:ctor(go, tier)
    playPanel.super.ctor(self, go, tier)


end

return playPanel
