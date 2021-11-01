-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/10/13 18:42:21                                                                                           
-------------------------------------------------------

---@class guidePanel
local guidePanel = class('guidePanel', popui)

function guidePanel:init()
    guidePanel.super.init(self)
    print("guidePanel init")
end

--auto

function guidePanel:ctor(go, tier)
    guidePanel.super.ctor(self, go, tier)


end

return guidePanel
