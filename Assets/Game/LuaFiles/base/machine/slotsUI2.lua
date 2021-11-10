-------------------------------------------------------
-- author : sky_allen
--  email : 894982165@qq.com
--   time : 2021/10/14 16:52:15
-------------------------------------------------------

---@class slotsUI2
local slotsUI2 = class('slotsUI2', require("base.uiMachine"))

function slotsUI2:ctor(lv)
    slotsUI2.super.ctor(self, lv)
end

function slotsUI2:spinStart()
    slotsUI2.super.spinStart(self);
end

function slotsUI2:spinOver()
    slotsUI2.super.spinOver(self);
end

function slotsUI2:initWheels()
    local luaMonos = array2table(self.go.transform:Find("Image/Image"), RectTransform, false);
    self.wheels = {};
    local allSprites = self:loadAllSprite();
    local allSpritesNames = table.selectItems(allSprites, "name");
    slotsManage.SetAllSpritesNames(allSpritesNames);--设置这个仅仅是为了校验一下名字而已
    for i, v in ipairs(luaMonos) do
        table.insert(self.wheels, v:GetComponent(typeof(CS.LuaMono)).TableIns);
        local SPPoolPart = nil;
        local wilds = { "w2", "w4", "w10", "w25" };
        if i == 1 then
            SPPoolPart = self:partSPPoolRemoveSome(allSprites,wilds )
        elseif i == 2 then
            SPPoolPart = self:partSPPoolRemoveSome(allSprites,wilds)
        elseif i == 3 then
            SPPoolPart = self:partSPPoolRemoveSome(allSprites,wilds)
        end
        self.wheels[i]:init(SPPoolPart);
    end
end

return slotsUI2
