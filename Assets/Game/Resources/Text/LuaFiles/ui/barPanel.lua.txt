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
    self.levelSlider.interactable = false;
    self.backButtonImage = self.backButton:GetComponent("Image");

    addEvent(BACK_LOBBY, function()
        self.backButtonImage .sprite = AF:LoadSprite("exit");
        SetActive(self.videoButton, true);
        SetActive(self.gapBonusButton, true);
    end)
    addEvent(WILL_PLAY, function()
        self.backButtonImage.sprite = AF:LoadSprite("dt");
        SetActive(self.videoButton);
        SetActive(self.gapBonusButton);
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
        local canGapBonus = c1 <= 0 and true or false;
        local gapBonusAward = level.gapBonusAward();
        if canGapBonus then
            self.gapBonusButton.interactable = true;
            self:gapBonusTipTextRefresh(("collect Bonus:"):upper())
            self:gapBonusTextRefresh(string.format_foreign(gapBonusAward));
            self:gapBonusButtonAnim();
        else
            self.gapBonusButton.interactable = false;
            self:gapBonusTipTextRefresh(("hourly Bonus:"):upper())
            self:gapBonusTextRefresh(CS.TimeHelper.GetTimeSpanFormat(c1));
        end
    end)

    save.addChip(0);

    self:RefreshSlider(false);

    self:adTextRefresh(string.format_foreign(ad.getChip()))
end

function barPanel:videoButtonAction()
    ad.playVideo();
end

function barPanel:gapBonusButtonAnim()
    local totalCost = 0.6;
    local offset = 35;
    local rect = self.gapBonusButton:GetComponent("RectTransform");
    local s = DOTween.Sequence();
    s:Append(rect:DOAnchorPosY(offset, totalCost / 2):SetRelative(true));
    s:Append(rect:DOAnchorPosY(-offset, totalCost / 2):SetRelative(true):SetEase(Ease.OutBounce));
end

function barPanel:gapBonusButtonAction()
    sendEvent(GET_GAP_BONUS)
    print(" barPanel gapBonusButtonAction click")
    timeManage.SendTIME_STAMP();
    thingFly.fly(self:gapBonusButtonWorldPosition())
end

function barPanel:videoButtonWorldPosition()
    return self:worldPosition(self.videoButton);
end

function barPanel:gapBonusButtonWorldPosition()
    return self:worldPosition(self.gapBonusButton);
end

function barPanel:pigButtonBigSmall()
    self:bigSmall(self.pigButton.transform, 0.5);
end

function barPanel:coinImageBigSmall()
    self:bigSmall(self.coinImage.transform, FLY_DELAY / 2);
end

function barPanel:levelAwardTipImageWorldPosition()
    return self:worldPosition(self.levelAwardTipImage);
end

function barPanel:pigButtonWorldPosition()
    return self:worldPosition(self.pigButton);
end

function barPanel:coinImageWorldPosition()
    return self:worldPosition(self.coinImage);
end

function barPanel:RefreshSlider(needAnim)
    local lv, ratio = level.friendlyLevelMessage();
    self:levelTextRefresh(lv);
    self:level2TextRefresh(lv);
    if not needAnim then
        self.levelSlider.value = ratio;
    else
        DOTween.To(function(f)
            self.levelSlider.value = f;
        end, self.levelSlider.value, ratio, GIGITAL_SLOW);

        thingFly.pigFly()
    end

end

function barPanel:levelAwardAnim(awardTipText, callback)
    local rect = self.levelAwardTipImage:GetComponent("RectTransform");
    self:levelAwardTipTextRefresh(awardTipText)
    local s = DOTween.Sequence();
    local perDistance = 460;
    local perCost = TIP_LEAVE;

    s:Append(rect:DOAnchorPosY(-perDistance, perCost):SetRelative(true));
    s:AppendInterval(TIP_SAVE / 2);
    s:AppendCallback(function()
        callback();
    end);
    s:AppendInterval(TIP_SAVE / 2);
    s:Append(rect:DOAnchorPosY(perDistance, perCost):SetRelative(true));
end

function barPanel:levelSliderAction(t)
end

function barPanel:setButtonAction()
    settingPanel:show();
end

function barPanel:backButtonAction()
    local isFight = self.backButtonImage.sprite.name == "dt";
    if isFight then
        if not rotate then
            curtainPanel:fade(function()
                audio.RecoverMusic();
                sendEvent(BACK_LOBBY)
            end)
        end
    else
        UnityEngine.Application.Quit();
        print("application quit")
    end
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
    self.pigButton = self.go.transform:Find("pigButton"):GetComponent('Button');
    self.buyButton = self.go.transform:Find("buyButton"):GetComponent('Button');
    self.levelSlider = self.go.transform:Find("levelSlider"):GetComponent('Slider');
    self.levelText = self.go.transform:Find("levelSlider/Image (1)/levelText"):GetComponent('Text');
    self.levelAwardTipImage = self.go.transform:Find("levelSlider/levelAwardTipImage"):GetComponent('Image');
    self.levelAwardTipText = self.go.transform:Find("levelSlider/levelAwardTipImage/levelAwardTipText"):GetComponent('Text');
    self.level2Text = self.go.transform:Find("levelSlider/levelAwardTipImage/level2Text"):GetComponent('Text');
    self.setButton = self.go.transform:Find("setButton"):GetComponent('Button');
    self.gapBonusButton = self.go.transform:Find("gapBonusButton"):GetComponent('Button');
    self.gapBonusTipText = self.go.transform:Find("gapBonusButton/gapBonusTipText"):GetComponent('Text');
    self.gapBonusText = self.go.transform:Find("gapBonusButton/gapBonusText"):GetComponent('Text');
    self.videoButton = self.go.transform:Find("videoButton"):GetComponent('Button');
    self.adText = self.go.transform:Find("videoButton/adText"):GetComponent('Text');

    self.backButton.onClick:AddListener(function()
        self:backButtonAction()
    end);
    self.pigButton.onClick:AddListener(function()
        self:pigButtonAction()
    end);
    self.buyButton.onClick:AddListener(function()
        self:buyButtonAction()
    end);
    self.levelSlider.onValueChanged:AddListener(function(t)
        self:levelSliderAction(t)
    end);
    self.setButton.onClick:AddListener(function()
        self:setButtonAction()
    end);
    self.gapBonusButton.onClick:AddListener(function()
        self:gapBonusButtonAction()
    end);
    self.videoButton.onClick:AddListener(function()
        self:videoButtonAction()
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
function barPanel:level2TextRefresh(t)
    self.level2Text.text = t;
end
function barPanel:gapBonusTipTextRefresh(t)
    self.gapBonusTipText.text = t;
end
function barPanel:gapBonusTextRefresh(t)
    self.gapBonusText.text = t;
end
function barPanel:adTextRefresh(t)
    self.adText.text = t;
end

return barPanel
