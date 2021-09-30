
-------------------------------------------------------                                                             
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/9/30 17:19:40                                                                                           
-------------------------------------------------------

---@class dailyPanel
local dailyPanel = class('dailyPanel',popui)

function dailyPanel:init()
    dailyPanel.super.init(self)
    print("dailyPanel init")
end

--auto
   
function dailyPanel:ctor(go, tier)
    dailyPanel.super.ctor(self, go, tier)
	
    
end
	
        

return dailyPanel
