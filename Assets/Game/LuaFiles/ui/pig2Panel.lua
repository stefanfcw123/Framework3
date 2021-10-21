-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/10/21 16:52:48                                                                                           
-------------------------------------------------------

---@class pig2Panel
local pig2Panel = class('pig2Panel', popui)

function pig2Panel:init()
    pig2Panel.super.init(self)
end

function pig2Panel:show()
    pig2Panel.super.show(self);
    self:pigTextRefresh("+" .. string.format_foreign(shop.getPigChip()))
end

--auto
   
function pig2Panel:ctor(go, tier)
    pig2Panel.super.ctor(self, go, tier)
	self.pigText=self.go.transform:Find("Image/Image (1)/pigText"):GetComponent('Text');
	
    
end
	
    function pig2Panel:pigTextRefresh(t)self.pigText.text=t;end
	    

return pig2Panel
