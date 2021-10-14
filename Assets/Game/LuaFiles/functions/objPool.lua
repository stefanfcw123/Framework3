-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/10/12 11:51:56                                                                                           
-------------------------------------------------------

---@class objPool
objPool = class('objPool')

local pool = class('pool')

function pool:ctor()
    self.objs = {};
end
-- todo 感觉时序有问题
function pool:spawn(name, func)
    local tempGo;
    if #self.objs == 0 then
        tempGo = UnityEngine.GameObject.Instantiate(AF:LoadEffect(name));
        tempGo.name = name;
    else
        tempGo = table.remove(self.objs, 1);
    end
    tempGo:SetActive(true)

    if func ~= nil then
        func(tempGo);
    end

    return tempGo;

end

function pool:recycle(obj, func)
    if func ~= nil then
        func(obj)
    end
    obj:SetActive(false);
    if not table.contains(self.objs, obj) then
        table.insert(self.objs, obj)
    end
end

local _pools = {}

function Spawn(name, func)
    if not table.contains_key(_pools, name) then
        local tempPool = pool.new();
        _pools[name] = tempPool;
    end

    return _pools[name]:spawn(name, func);
end

function Recycle(go, func)
    local name = go.name;
    if table.contains_key(_pools, name) then
        _pools[name]:recycle(go, func);
    end
end