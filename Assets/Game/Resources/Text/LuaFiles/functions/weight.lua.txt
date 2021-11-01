-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/9/16 10:02:53                                                                                           
-------------------------------------------------------

---@class weight
local weight = class('weight')

function weight:ctor(weight, items)
    assert_true(#weight == #items);

    self.weightDic = {};
    self.items = items;
    self.sum = 0;

    local first = 0;
    local second = 0;

    local len = #weight;
    for i = 1, len do
        local arr = {}
        first = second;
        second = weight[i] + first;

        arr[1] = first;
        arr[2] = second;

        self. weightDic[i] = arr;
    end

    self.sum = self.weightDic[len][2];
end

function weight:GetItemByNumber()

    local number = math.random(1, self.sum)

    local key = self:GetAccordWithKey(number)
    return self.items[key];
end;

function weight:GetAccordWithKey(randomNumber)
    for i, v in pairs(self.weightDic) do
        local arr = v;
        if randomNumber > arr[1] and randomNumber <= arr[2] then
            return i;
        end
    end
    error("key is error");
end

return weight
