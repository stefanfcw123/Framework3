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
    self.go:SetActive(false)
end

function ui:show()
    self.go:SetActive(true)
    self.is_show = true;
end

function ui:hide()
    self.go:SetActive(false)
    self.is_show = false;
    save.save();
end

function ui:init()
    root.set_tier(self.go, self.tier)

    local buttons = array2table(self.go, Button);
    for i, v in ipairs(buttons) do
        v.onClick:AddListener(function()
            audio.PlaySound("btnClick")
            v.transform:DOScale(0.85, BTN_SCALE):OnComplete(function()
                v.transform:DOScale(1, BTN_SCALE);
            end);
        end)
    end
end

function ui:over()
    self:hide()
end

function ui:frame()
end

return ui;