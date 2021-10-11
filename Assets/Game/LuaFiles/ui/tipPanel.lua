-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/9/30 15:30:53                                                                                           
-------------------------------------------------------

---@class tipPanel
local tipPanel = class('tipPanel', ui)

function tipPanel:createTip(t)
    self:show();
    local go = GameObject.Instantiate(AF:LoadEffect("tipImage"));
    self:tipGameObjectSetParent(go.transform);
    go.transform:Find("Text"):GetComponent("Text").text = t;
    local rect = go:GetComponent(typeof(CS.UnityEngine.RectTransform));

    local s = DOTween.Sequence();
    s:Append(rect:DOScale(0, 0));
    s:Append(rect:DOScale(1, POP_SLOW));
    s:AppendInterval(TIP_SAVE);
    s:Append(rect:DOAnchorPosY(600, TIP_LEAVE):SetRelative(true));
    s:OnComplete(function()
        GameObject.Destroy(go);
    end)

end

function tipPanel:init()
    self.tier = "Guide"
    tipPanel.super.init(self)
    print("tipPanel init")

    addEvent(TIP_MESSAGE, function(i)
        self:createTip(i);
    end)
end

function tipPanel:frame()
    if self.tipGameObject.transform.childCount == 0 then
        self:hide();
    end
end

--auto

function tipPanel:ctor(go, tier)
    tipPanel.super.ctor(self, go, tier)
    self.tipGameObject = self.go.transform:Find("tipGameObject").gameObject;


end

function tipPanel:tipGameObjectSetParent(t)
    t.transform:SetParent(self.tipGameObject.transform, false);
end

return tipPanel
