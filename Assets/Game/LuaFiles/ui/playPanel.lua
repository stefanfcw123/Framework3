-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/9/18 10:05:03                                                                                           
-------------------------------------------------------

---@class playPanel
local playPanel = class('playPanel', ui)
local curUI = nil;
function playPanel:init()
    playPanel.super.init(self)
    addEvent(WILL_PLAY, function(n)
        self:show()
        -- todo 这里让我卡了很久吐了
        --curUI = require("base.machine.slotsUI" .. tostring(n)).new(n);
        --  print("curUI", curUI)
    end)
    addEvent(BACK_LOBBY, function()
        self:hide()
    end)
    addEvent(SPIN_OVER, function(isWin, award)
        if isWin then
            DOTween                     .To(function(f)
                self:winTextRefresh(string.format_foreign(f))
            end, 0, award, GIGITAL_SLOW):OnComplete(function()
                save.addChip(award);
            end)
        end
    end)
    addEvent(SPIN_START, function()
        self:winTextRefresh(0)
    end)
    self:winTextRefresh(0)
    addEvent(LOAD_OVER, function()
        self:betTextRefresh2();
    end)
end

function playPanel:betTextRefresh2()
    self:betTextRefresh(string.format_foreign(slotsManage.getBet()));
end

function playPanel:reduceSuccess()
    randomSeed();
    sendEvent(SPIN_START)
end

function playPanel:spinButtonAction()
    local reduceSuccess = save.addChip(-slotsManage.getBet());
    if reduceSuccess then
        self:reduceSuccess();
    else
        -- todo Tip chip not enough
    end
end

function playPanel:tipButtonAction()
    guidePanel:show()
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
	self.tipButton=self.go.transform:Find("Image/tipButton"):GetComponent('Button');
	self.reduceButton=self.go.transform:Find("Image/Image/reduceButton"):GetComponent('Button');
	self.addButton=self.go.transform:Find("Image/Image/addButton"):GetComponent('Button');
	self.betText=self.go.transform:Find("Image/Image/betText"):GetComponent('Text');
	self.winText=self.go.transform:Find("Image/Image (1)/winText"):GetComponent('Text');
	self.spinButton=self.go.transform:Find("Image/spinButton"):GetComponent('Button');
	
    self.tipButton.onClick:AddListener(function()self:tipButtonAction()end);
	self.reduceButton.onClick:AddListener(function()self:reduceButtonAction()end);
	self.addButton.onClick:AddListener(function()self:addButtonAction()end);
	self.spinButton.onClick:AddListener(function()self:spinButtonAction()end);
	
end
	
    function playPanel:betTextRefresh(t)self.betText.text=t;end
	function playPanel:winTextRefresh(t)self.winText.text=t;end
	    

return playPanel
