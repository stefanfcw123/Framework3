
-------------------------------------------------------                                                             
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/9/17 16:43:55                                                                                           
-------------------------------------------------------

---@class loadPanel
local loadPanel = class('loadPanel',ui)

function loadPanel:init()
    print("loadPanel init")
    loadPanel.super.init(self)
    self:show()
end

--auto
   
function loadPanel:ctor(go, tier)
    loadPanel.super.ctor(self, go, tier)
	
    
end
	
        

return loadPanel
