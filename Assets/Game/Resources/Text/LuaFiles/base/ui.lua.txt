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
    --self.canvas = self.go:AddComponent(typeof(Canvas));
end

function ui:show()
    self.go:SetActive(true)
    self.is_show = true;

    --[[    if not self.canvas.overrideSorting then
            self.canvas.overrideSorting = true;
            self.canvas.sortingOrder = self.go.transform.parent:GetSiblingIndex();
        end]]
end

function ui:hide()
    self.go:SetActive(false)
    self.is_show = false;
    save.save();
end

function ui:init()
    root.set_tier(self.go, self.tier)
    self.bImage = self.go:GetComponent("Image");
    self.bImage.color = getColor(255, 255, 255, 255);

    local buttons = array2table(self.go, Button, true);
    for i, v in ipairs(buttons) do
        v.onClick:AddListener(function()
            audio.PlaySound("btnClick")
            v.transform:DOScale(0.85, BTN_SCALE):OnComplete(function()
                v.transform:DOScale(1, BTN_SCALE);
            end);
        end)
    end


end

function ui:bigSmall(transform, perCost)
    transform:DOScale(1.15, perCost):OnComplete(function()
        transform:DOScale(1, perCost);
    end)
end

function ui:worldPosition(uiElement)
    local v3 = uiElement.transform.position;
    return Vector3(v3.x, v3.y, 0);
end

function ui:over()
    self:hide()
end

function ui:frame()

end

return ui;