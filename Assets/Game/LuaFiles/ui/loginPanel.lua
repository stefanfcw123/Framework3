-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/10/13 14:42:51                                                                                           
-------------------------------------------------------

---@class loginPanel
local loginPanel = class('loginPanel', popui)

--todo 动画细节的完善
function loginPanel:init()
    loginPanel.super.init(self)
    print("loginPanel init")

    self:dayTextRefresh(timeManage.loginDayNum());
    self:baseChipTextRefresh(string.format_foreign(timeManage.loginBonus()));
    self:multipleChipTextRefresh(timeManage.loginMultiple());
    DOTween.To(function(f)
        self:chipTextRefresh(string.format_foreign(f))
    end, 0, timeManage.loginTotalBonus(), GIGITAL_SLOW)

    self.closeBtn.onClick:AddListener(function()
        thingFly.fly(self:worldPosition(self.closeBtn))
        timeManage.collectAward()
    end)
end

--auto

function loginPanel:ctor(go, tier)
    loginPanel.super.ctor(self, go, tier)
    self.dayText = self.go.transform:Find("Image/dayText"):GetComponent('Text');
    self.baseChipText = self.go.transform:Find("Image/baseChipText"):GetComponent('Text');
    self.multipleChipText = self.go.transform:Find("Image/multipleChipText"):GetComponent('Text');
    self.chipText = self.go.transform:Find("Image/chipText"):GetComponent('Text');


end

function loginPanel:dayTextRefresh(t)
    self.dayText.text = t;
end
function loginPanel:baseChipTextRefresh(t)
    self.baseChipText.text = t;
end
function loginPanel:multipleChipTextRefresh(t)
    self.multipleChipText.text = t;
end
function loginPanel:chipTextRefresh(t)
    self.chipText.text = t;
end

return loginPanel
