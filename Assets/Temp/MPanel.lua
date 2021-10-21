-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : $time$                                                                                           
-------------------------------------------------------

---@class MPanel
local MPanel = class('MPanel', ui)
local MPanelCS

function MPanel:init()
    MPanel.super.init(self)
    self:show()

    --[[
    print(Time.time,1);
    local go = GameObject.Find("Cube");
    cs_coroutine.start(function()
        coroutine.yield(go.transform:DOLocalMoveY(3, 1):SetSpeedBased():OnComplete(function()
            print(Time.time,2);
        end):WaitForCompletion());
        print(Time.time,3)
    end)
    ]]

    --[[    local s = DOTween.Sequence();
        s:AppendInterval(3);
        local t = self.go.transform:DOMoveX(10,3);
        s:Append(t);
        s:AppendInterval(1);
        local t2 =self.go.transform:DOMoveX(-10,3);
        s:Append(t2);
        s:OnComplete(function()
            print("all over")
        end)]]

    --[[    local cs_coroutine = (require 'functions.cs_coroutine')
        local cs_coroutine2 = (require 'functions.cs_coroutine')
        local cs_coroutine3 = (require 'functions.cs_coroutine')
        print(cs_coroutine, cs_coroutine2, cs_coroutine3);
        local a = cs_coroutine.start(function()
            print('coroutine a started')

            coroutine.yield(cs_coroutine.start(function()
                print('coroutine b stated inside cotoutine a')
                coroutine.yield(CS.UnityEngine.WaitForSeconds(1))
                print('i am coroutine b')
            end))
            print('coroutine b finish')

            while true do
                coroutine.yield(CS.UnityEngine.WaitForSeconds(1))
                print('i am coroutine a')
            end
        end)

        cs_coroutine.start(function()
            print('stop coroutine a after 5 seconds')
            coroutine.yield(CS.UnityEngine.WaitForSeconds(5))
            cs_coroutine.stop(a)
            print('coroutine a stoped')
        end)]]

end

function MPanel:WButtonAction()
    print("woaini")
end
function MPanel:KKKToggleAction(t)
    print(t)
end
function MPanel:KKK2SliderAction(t)
    print("slider", t)
end
function MPanel:WDropdownAction(t)
    print("dropdown", t)
end

function MPanel:frame()
end;
--auto

function MPanel:ctor(go, tier)
    MPanel.super.ctor(self, go, tier)
    MPanelCS = self.go:GetComponent('MPanel');
    self.BBkGameObject = self.go.transform:Find("BBkGameObject").gameObject;
    self.KKImage = self.go.transform:Find("KKImage"):GetComponent('Image');
    self.JText = self.go.transform:Find("JText"):GetComponent('Text');
    self.WDropdown = self.go.transform:Find("JText/WDropdown"):GetComponent('Dropdown');
    self.NiImage = self.go.transform:Find("JText/WDropdown/NiImage"):GetComponent('Image');
    self.WButton = self.go.transform:Find("WButton"):GetComponent('Button');
    self.KKK2Slider = self.go.transform:Find("KKK2Slider"):GetComponent('Slider');

    self.WDropdown.onValueChanged:AddListener(function(t)
        self:WDropdownAction(t)
    end);
    self.WButton.onClick:AddListener(function()
        self:WButtonAction()
    end);
    self.KKK2Slider.onValueChanged:AddListener(function(t)
        self:KKK2SliderAction(t)
    end);

end

function MPanel:BBkGameObjectSetParent(t)
    t.transform:SetParent(self.BBkGameObject.transform, false);
end
function MPanel:KKImageRefresh(t)
    self.KKImage.sprite = t;
end
function MPanel:JTextRefresh(t)
    self.JText.text = t;
end
function MPanel:NiImageRefresh(t)
    self.NiImage.sprite = t;
end

return MPanel
