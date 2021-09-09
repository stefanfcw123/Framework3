-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/9/2 16:17:39                                                                                           
-------------------------------------------------------

---@class root
root = class('root')

local canvasT = GameObject.Find("Game/Canvas"):GetComponent(typeof(Transform));
local uis = {}
local systems = {}

function root:ctor()

end

function root.set_tier(go, tier)
    local p = canvasT:Find(tier);
    go.transform:SetParent(p, false);
end

function root:Awake()
    self:init();
end

function root:Update()

    for i, v in pairs(systems) do
        v:frame()
    end

    for i, v in pairs(uis) do
        if v.is_show then
            v:frame()
        end
    end
end

function root:init()
    root.add_ui("MPanel");
end

function root.add_sys(name)
end

function root.add_ui(name)
    local go = af:loadGameObject(name);
    local go2 = UnityEngine.GameObject.Instantiate(go);
    go2.name = name;
    local ui_class = require("ui." .. name);
    local ui_ins = ui_class.new(go2, "Default");
    ui_ins:init();
    table.insert(uis, ui_ins);
end

return root
