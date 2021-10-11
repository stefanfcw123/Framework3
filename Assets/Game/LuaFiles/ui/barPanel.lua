-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/9/18 9:54:28                                                                                           
-------------------------------------------------------

---@class barPanel
local barPanel = class('barPanel', ui)

function barPanel:init()
    self.tier = "PopUp"
    barPanel.super.init(self)
    uiActive(self.backButton, false)
    self.levelSlider.interactable = false;

    addEvent(BACK_LOBBY, function()
        uiActive(self.backButton, false)
    end)
    addEvent(WILL_PLAY, function()
        uiActive(self.backButton)
    end)
    addEvent(CHIP_CHANGE, function(n1, n2, needAnim)
        if needAnim then
            DOTween.To(function(f)
                self:coinTextRefresh(string.format_foreign(f));
            end, n1, n2, GIGITAL_SLOW);
        else
            self:coinTextRefresh(string.format_foreign(n2));
        end
    end)
    addEvent(LOAD_OVER, function()
        self:show();
    end)
    addEvent(TIME_STAMP, function(c1)
        local canGapBonus = timeManage.canGapBonus(c1);
        if canGapBonus then
            self.gapBonusButton.interactable = true;
            self:gapBonusTextRefresh(localize(1));
        else
            self.gapBonusButton.interactable = false;
            self:gapBonusTextRefresh(CS.TimeHelper.GetTimeSpanFormat(c1));
        end
    end)

    save.addChip(0);

    self:RefreshSlider(false);
    print(self:coinImageWorldPosition())
end

function barPanel:coinImageWorldPosition()
    local v3 = self.coinImage.transform.position;
    return Vector2(v3.x, v3.y);
end

function barPanel:RefreshSlider(needAnim)
    local lv, ratio = level.friendlyLevelMessage();
    self:levelTextRefresh(lv);
    if not needAnim then
        self.levelSlider.value = ratio;
    else
        DOTween.To(function(f)
            self.levelSlider.value = f;
        end, self.levelSlider.value, ratio, GIGITAL_SLOW);
    end

end

function barPanel:levelAwardAnim(awardTipText, callback)
    local rect = self.levelAwardTipImage:GetComponent("RectTransform");
    self:levelAwardTipTextRefresh(awardTipText)
    local s = DOTween.Sequence();
    local perDistance = 260;
    local perCost = TIP_LEAVE;

    s:Append(rect:DOAnchorPosY(-perDistance, perCost):SetRelative(true));
    s:AppendInterval(TIP_SAVE / 2);
    s:AppendCallback(function()
        callback();
    end);
    s:AppendInterval(TIP_SAVE / 2);
    s:Append(rect:DOAnchorPosY(perDistance, perCost):SetRelative(true));
end

function barPanel:gapBonusButtonAction()
    sendEvent(GET_GAP_BONUS)
    print(" barPanel gapBonusButtonAction click")
    timeManage.SendTIME_STAMP();
end

function barPanel:levelSliderAction(t)
end

function barPanel:setButtonAction()
    settingPanel:show();
end

function barPanel:backButtonAction()
    sendEvent(BACK_LOBBY)
end

function barPanel:buyButtonAction()
    buyPanel:show()
end

function barPanel:pigButtonAction()
    pigPanel:show()
end

--auto

function barPanel:ctor(go, tier)
    barPanel.super.ctor(self, go, tier)
    self.backButton = self.go.transform:Find("backButton"):GetComponent('Button');
    self.coinText = self.go.transform:Find("Image/coinText"):GetComponent('Text');
    self.coinImage = self.go.transform:Find("Image/coinImage"):GetComponent('Image');
    self.buyButton = self.go.transform:Find("buyButton"):GetComponent('Button');
    self.levelSlider = self.go.transform:Find("levelSlider"):GetComponent('Slider');
    self.levelText = self.go.transform:Find("levelSlider/Image (1)/levelText"):GetComponent('Text');
    self.levelAwardTipImage = self.go.transform:Find("levelSlider/levelAwardTipImage"):GetComponent('Image');
    self.levelAwardTipText = self.go.transform:Find("levelSlider/levelAwardTipImage/levelAwardTipText"):GetComponent('Text');
    self.pigButton = self.go.transform:Find("pigButton"):GetComponent('Button');
    self.setButton = self.go.transform:Find("setButton"):GetComponent('Button');
    self.gapBonusButton = self.go.transform:Find("gapBonusButton"):GetComponent('Button');
    self.gapBonusText = self.go.transform:Find("gapBonusButton/gapBonusText"):GetComponent('Text');

    self.backButton.onClick:AddListener(function()
        self:backButtonAction()
    end);
    self.buyButton.onClick:AddListener(function()
        self:buyButtonAction()
    end);
    self.levelSlider.onValueChanged:AddListener(function(t)
        self:levelSliderAction(t)
    end);
    self.pigButton.onClick:AddListener(function()
        self:pigButtonAction()
    end);
    self.setButton.onClick:AddListener(function()
        self:setButtonAction()
    end);
    self.gapBonusButton.onClick:AddListener(function()
        self:gapBonusButtonAction()
    end);

end

function barPanel:coinTextRefresh(t)
    self.coinText.text = t;
end
function barPanel:coinImageRefresh(t)
    self.coinImage.sprite = t;
end
function barPanel:levelTextRefresh(t)
    self.levelText.text = t;
end
function barPanel:levelAwardTipImageRefresh(t)
    self.levelAwardTipImage.sprite = t;
end
function barPanel:levelAwardTipTextRefresh(t)
    self.levelAwardTipText.text = t;
end
function barPanel:gapBonusTextRefresh(t)
    self.gapBonusText.text = t;
end

return barPanel
