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
        --print("will paly1")
    end)
    addEvent(BACK_LOBBY, function()
        --  playPanel:closeAuto();
        self:hide()
    end)
    addEvent(SPIN_OVER, function(isWin, award)
        if WRITE_DATA_MODE then
            return ;
        end

        if isWin then
            DOTween                     .To(function(f)
                local fStr = string.format_foreign(f)
                self:winTextRefresh(fStr)
                self:hightWinTextRefresh(fStr);
            end, 0, award, GIGITAL_SLOW):OnComplete(function()
                cs_coroutine.start(function()
                    coroutine.yield(WaitForSeconds(0.25));
                    if self.hightWinImage.gameObject.activeInHierarchy then
                        if math.ratio(0.02) then
                            evaluatePanel:show();
                        end
                    end
                    self.hightWinImage.gameObject:SetActive(false);
                end)
            end);
            if LOSE_QUICK then
                return ;
            end
            save.addChip(award)
            analysis.addInChip(award);

        end
        self:ReturnRateTextRefresh("实际返还率:" .. analysis.returnRate());
        self:targetReturnRateTextRefresh("理论返还率:" .. analysis.getTargetReturnRate());
        self:ConfigEnumTextRefresh("当前配置是:" .. slotsManage.GetConfigEnum());


    end)
    addEvent(SPIN_START, function()
        self:winTextRefresh(0)
    end)
    self:winTextRefresh(0)
    addEvent(LOAD_OVER, function()
        self:betTextRefresh2();
    end)

    if ANALYSIS then
        self.TipGameObject:SetActive(true);
    else
        self.TipGameObject:SetActive(false);
    end

    self.hightWinImage.gameObject:SetActive(false);
end

function playPanel:betTextRefresh2()
    self:betTextRefresh(string.format_foreign(slotsManage.getBet()));
end

function playPanel:reduceSuccess()
    randomSeed();
    sendEvent(SPIN_START)
end

function playPanel:showHightWinImage(lv)
    self.hightWinImage.gameObject:SetActive(true);
    self.hightWinImage.gameObject.transform:DOShakeScale(1, 0.1, 8, 80);
    local sp = AF:LoadSprite("winLv" .. lv);
    self:hightWinImageRefresh(sp);
end

function playPanel:hideHightWinImage()
    self.hightWinImage.gameObject:SetActive(false);
end

function playPanel:spinButtonAction2()
    --print("spinButtonAction2")
    local reduceSuccess;

    if WRITE_DATA_MODE then
        reduceSuccess = true;
    else
        local b = slotsManage.getBet();
        reduceSuccess = save.addChip(-b);
        analysis.addOutChip(b);
    end

    if reduceSuccess then
        self:reduceSuccess();
    else
        self:closeAuto();
        buyPanel:show();
    end
    return reduceSuccess;
end

function playPanel:closeAuto()
    -- 不知道为啥self.spinButton为nil了  但是这里我用不到了
    if auto then
        auto = false;
        self.spinButton:GetComponent("Image").sprite = AF:LoadSprite("spin1");
    end
end

function playPanel:spinButtonAction()
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
    self.tipButton = self.go.transform:Find("Image/tipButton"):GetComponent('Button');
    self.reduceButton = self.go.transform:Find("Image/Image/reduceButton"):GetComponent('Button');
    self.addButton = self.go.transform:Find("Image/Image/addButton"):GetComponent('Button');
    self.betText = self.go.transform:Find("Image/Image/betText"):GetComponent('Text');
    self.winText = self.go.transform:Find("Image/Image (1)/winText"):GetComponent('Text');
    self.spinButton = self.go.transform:Find("Image/spinButton"):GetComponent('Button');
    self.TipGameObject = self.go.transform:Find("TipGameObject").gameObject;
    self.ReturnRateText = self.go.transform:Find("TipGameObject/ReturnRateText"):GetComponent('Text');
    self.targetReturnRateText = self.go.transform:Find("TipGameObject/targetReturnRateText"):GetComponent('Text');
    self.ConfigEnumText = self.go.transform:Find("TipGameObject/ConfigEnumText"):GetComponent('Text');
    self.hightWinImage = self.go.transform:Find("hightWinImage"):GetComponent('Image');
    self.hightWinText = self.go.transform:Find("hightWinImage/hightWinText"):GetComponent('Text');

    self.tipButton.onClick:AddListener(function()
        self:tipButtonAction()
    end);
    self.reduceButton.onClick:AddListener(function()
        self:reduceButtonAction()
    end);
    self.addButton.onClick:AddListener(function()
        self:addButtonAction()
    end);
    self.spinButton.onClick:AddListener(function()
        self:spinButtonAction()
    end);

end

function playPanel:betTextRefresh(t)
    self.betText.text = t;
end
function playPanel:winTextRefresh(t)
    self.winText.text = t;
end
function playPanel:TipGameObjectSetParent(t)
    t.transform:SetParent(self.TipGameObject.transform, false);
end
function playPanel:ReturnRateTextRefresh(t)
    self.ReturnRateText.text = t;
end
function playPanel:targetReturnRateTextRefresh(t)
    self.targetReturnRateText.text = t;
end
function playPanel:ConfigEnumTextRefresh(t)
    self.ConfigEnumText.text = t;
end
function playPanel:hightWinImageRefresh(t)
    self.hightWinImage.sprite = t;
end
function playPanel:hightWinTextRefresh(t)
    self.hightWinText.text = t;
end

return playPanel
