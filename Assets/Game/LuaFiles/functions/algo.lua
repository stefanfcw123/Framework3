-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/9/16 17:47:03                                                                                           
-------------------------------------------------------
module(..., package.seeall);
local algo = class('algo')

function c()

end

function b()
    c();
end

function a()
    b();
end
a();

return algo
