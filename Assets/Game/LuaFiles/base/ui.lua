-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/2/24 21:04:41                                                                                           
-------------------------------------------------------

---@class ui
local ui = class('ui')

function ui:ctor(go, tier)
    self.go = go;
    self.tier = tier
    self.is_show = false;
end

function ui:show()
    self.go:SetActive(true)
    self.is_show = true;
end

function ui:hide()
    self.go:SetActive(false)
    self.is_show = false;
end

function ui:init()
    root.set_tier(self.go, self.tier)
    self:hide();
end

function ui:over()
end

function ui:frame()
end

return sys;