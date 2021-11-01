-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/9/22 13:58:15                                                                                           
-------------------------------------------------------

---@class buyPanel
local buyPanel = class('buyPanel', popui)

function buyPanel:init()
    buyPanel.super.init(self)
    local btns = array2table(self.pImage, Button, true, function(btn)
        local i = string.get_pure_number(btn.name)
        print("buyPanel btn clicked:", i)
        shop.buy(i + 1);--todo 后面待完善
    end);
    for i, v in ipairs(btns) do
        local t = v.transform:Find("titleText"):GetComponent("Text");
        local c = v.transform:Find("Image/costText"):GetComponent("Text");
        local message = shop.shopMessage(i);
        t.text = string.format_foreign(message[1]);
        c.text = "$" .. message[2];
        v.transform:Find("iconImage"):GetComponent("Image").sprite = AF:LoadSprite((6 - i + 1));
    end
end

--auto

function buyPanel:ctor(go, tier)
    buyPanel.super.ctor(self, go, tier)
    self.pImage = self.go.transform:Find("Image/pImage"):GetComponent('Image');


end

function buyPanel:pImageRefresh(t)
    self.pImage.sprite = t;
end

return buyPanel
