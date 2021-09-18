-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/9/2 16:17:39                                                                                           
-------------------------------------------------------

require("functions.functions");
require("functions.kit");
sys = require("base.sys")
ui = require("base.ui")
popui = require("base.popui")
---@class root
root = class('root')
---@type event
event = require("functions.event")
---@type save
save = nil;
---@type audio
audio = nil;
---@type lobbyPanel
lobbyPanel = nil;
---@type barPanel
barPanel = nil;
---@type playPanel
playPanel = nil;
---@type settingPanel
settingPanel = nil;
GameGo = GameObject.Find("Game");
data = nil;

GIGITAL_SLOW = 1-- 数字缓动时间
POP_SLOW = 0.3;

WILL_PLAY = "WILL_PLAY"
BACK_LOBBY = "BACK_LOBBY"
CHIP_CHANGE = "CHIP_CHANGE"
container = {};
function addEvent(event_type, callback)
    if container[event_type] == nil then
        local callbacks = {};
        table.insert(callbacks, callback);
        container[event_type] = callbacks;
    else
        local callbacks = container[event_type];
        table.insert(callbacks, callback);
    end
end;
function delEvent(event_type, callback)
    if container[event_type] == nil then
        error("The event type is nil");
    else
        local callbacks = container[event_type];
        for i, v in ipairs(callbacks) do
            if v == callback then
                table.remove(callbacks, i);
                break ;
            end
        end
    end
end
function sendEvent(event_type, ...)
    local callbacks = container[event_type];

    for i, v in ipairs(callbacks) do
        v(...)
    end
end

local canvasT = GameGo.transform:Find("Canvas");
local uis = {}
local systems = {}

function root:Start()
    self:init();
end

function root:Update()

    if UnityEngine.Input.GetKeyDown(UnityEngine.KeyCode.C) then
        --save.addChip(1000);
        settingPanel:show();
    end

    for i, v in pairs(systems) do
        if v.frame then
            v.frame()
        end
    end
    for i, v in pairs(uis) do
        if v.is_show then
            v:frame()
        end
    end
end

-- todo 检查C#相关的待办事项
function root:init()
    print "root init"
    math.randomseed(tostring(os.time()):reverse():sub(1, 7));
    save = root.add_sys("save");
    audio = root.add_sys("audio");
    local loadPanel = root.add_ui("loadPanel");
    lobbyPanel = root.add_ui("lobbyPanel");
    barPanel = root.add_ui("barPanel");
    playPanel = root.add_ui("playPanel")
    settingPanel = root.add_ui("settingPanel");
    loadPanel:over()
end

function root.set_tier(go, tier)
    local p = canvasT:Find(tier);
    go.transform:SetParent(p, false);
end

function root.add_sys(name)
    local ins = require("sys." .. name)
    table.insert(systems, ins);
    ins.init()
    return ins;
end

function root.add_ui(name)
    local go = AF:LoadPanel(name);
    local go2 = UnityEngine.GameObject.Instantiate(go);
    go2.name = name;
    local ui_class = require("ui." .. name);
    local ui_ins = ui_class.new(go2, "Default");
    ui_ins:init();
    table.insert(uis, ui_ins);
    return ui_ins;
end

return root;