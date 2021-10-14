-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/10/14 16:50:53                                                                                           
-------------------------------------------------------

---@class uiMachine
local uiMachine = class('uiMachine')

function uiMachine:ctor(lv)
    self.go = playPanel.go.transform:Find("Image" .. lv).gameObject;
    self.wheels = array2table(self.go.transform:Find("Image/Image"), RectTransform, false)
    --print(self.go);
end

return uiMachine
