-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/10/22 10:33:58                                                                                           
-------------------------------------------------------

---@class ad
local ad = class('ad')

local chip = 3000;

function ad.init()
    print('ad init')
end

function ad.getChip()
    return chip;
end

function ad.playVideo()
    print("play video")
    save.addChip(ad.getChip())
    thingFly.fly(barPanel:videoButtonWorldPosition())
end

return ad
