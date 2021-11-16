-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/9/17 17:39:36                                                                                           
-------------------------------------------------------

---@class lobbyPanel
local lobbyPanel = class('lobbyPanel', ui)

local btns = {};

local function initButton(self)
    btns = array2table(self.CGameObject, Button, true);
    for i = 1, #btns do
        btns[i]:GetComponent("Image").sprite = AF:LoadSprite("l" .. i);
        btns[i].transform:Find("Image"):GetComponent("Image").sprite = AF:LoadSprite("l" .. i);

        btns[i].onClick:AddListener(function()
            local curLv = level.curLV();
            local needLv = level.needLv(i);
            local isOpen = curLv >= needLv;

            if LOCK_QUICK then
                isOpen = true
            end

            if isOpen then
                self:btnAnimal(i);
                cs_coroutine.start(function()
                    if LEVEL_QUICK then
                        coroutine.yield(WaitForSeconds(QUICK_TIME));
                    else
                        coroutine.yield(WaitForSeconds(LOBBY_BTN));
                    end

                    local f = function()
                        audio.PauseMusic();
                        playPanel:showLvChild(i)
                        sendEvent(WILL_PLAY, i);
                        print(" lobbyPanel btn click " .. i)
                    end

                    curtainPanel:fade(function()
                        f();
                    end)
                end)
            else
                audio.PlaySound("ui_locked");
                tipPanel:createTip("未解锁，需要到达等级" .. level.locks[i]);
                print("This level is lock !")
            end
        end)


    end
end

function lobbyPanel:btnAnimal(i)
    local img = btns[i].transform:Find("Image"):GetComponent("Image");
    local s = DOTween.Sequence();

    s:Append(img.transform:DOScale(0.5, LOBBY_BTN):SetRelative(true))
    s:Insert(0, img:DOFade(0, LOBBY_BTN));
    s:OnComplete(function()
        img.transform:DOScale(-0.5, 0):SetRelative(true)
        img:DOFade(1, 0)
    end)
end

function lobbyPanel:init()
    lobbyPanel.super.init(self)
    initButton(self);
    addEvent(WILL_PLAY, function()
        self:hide()
    end)
    addEvent(BACK_LOBBY, function()
        self:show()
    end)
    addEvent(LOAD_OVER, function()
        self:show();
    end)
end

--auto

function lobbyPanel:ctor(go, tier)
    lobbyPanel.super.ctor(self, go, tier)
    self.CGameObject = self.go.transform:Find("Scroll View/Viewport/CGameObject").gameObject;


end

function lobbyPanel:CGameObjectSetParent(t)
    t.transform:SetParent(self.CGameObject.transform, false);
end

return lobbyPanel
