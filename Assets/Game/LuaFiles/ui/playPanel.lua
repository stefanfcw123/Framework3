-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/9/18 10:05:03                                                                                           
-------------------------------------------------------

---@class playPanel
local playPanel = class('playPanel', ui)

function playPanel:init()
    playPanel.super.init(self)
    addEvent(WILL_PLAY, function()
        self:show()
    end)
    addEvent(BACK_LOBBY, function()
        self:hide()
    end)
    addEvent(SPIN_OVER, function()
        self:betTextRefresh2();
    end)
    self:betTextRefresh2();
    self:winTextRefresh(0)

end

function playPanel:betTextRefresh2()
    self:betTextRefresh(string.format_foreign(slotsManage.getBet()));
end

function playPanel:spinButtonAction()
    local reduceSuccess = save.addChip(-slotsManage.getBet());
    if reduceSuccess then
        sendEvent(SPIN_START)
    else
        -- todo Tip chip not enough
    end
end

function playPanel:tipButtonAction()

end

function playPanel:reduceButtonAction()
    slotsManage.changeBetLv(-1)
end

function playPanel:addButtonAction()
    slotsManage.changeBetLv(1);
end

--auto

function playPanel:ctor(go, tier)
    playPanel.super.ctor(self, go, tier)
    self.betText = self.go.transform:Find("Image/GameObject/Image/betText"):GetComponent('Text');
    self.winText = self.go.transform:Find("Image/GameObject/Image (1)/winText"):GetComponent('Text');
    self.spinButton = self.go.transform:Find("Image/GameObject/spinButton"):GetComponent('Button');
    self.tipButton = self.go.transform:Find("Image/GameObject/tipButton"):GetComponent('Button');
    self.reduceButton = self.go.transform:Find("Image/GameObject/reduceButton"):GetComponent('Button');
    self.addButton = self.go.transform:Find("Image/GameObject/addButton"):GetComponent('Button');

    self.spinButton.onClick:AddListener(function()
        self:spinButtonAction()
    end);
    self.tipButton.onClick:AddListener(function()
        self:tipButtonAction()
    end);
    self.reduceButton.onClick:AddListener(function()
        self:reduceButtonAction()
    end);
    self.addButton.onClick:AddListener(function()
        self:addButtonAction()
    end);

end

function playPanel:betTextRefresh(t)
    self.betText.text = t;
end
function playPanel:winTextRefresh(t)
    self.winText.text = t;
end

return playPanel
