-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/9/26 14:39:58                                                                                           
-------------------------------------------------------


NET_TIMEOUT = 4;

TIP_SAVE = 2;
TIP_LEAVE = 0.5;

GIGITAL_SLOW = 1.5-- 数字缓动时间
POP_SLOW = 1 / 5
BTN_SCALE = 1 / 20;
FLY_DELAY = 0.035;

SECOND = 1;
MINUTE = SECOND * 60;
HOUR = MINUTE * 60;
DAY = HOUR * 24;
WEEK = DAY * 7;

LANGUAGE_KEY = "Chinese";

LOAD_QUICK = true;
GAPBONUS_QUICK = false;
LOGIN_QUICK = false;
PATTERNS_QUICK = false;
LOSE_QUICK = true;
SPIN_QUICK = false;-- todo 也许这里关联的太多了

R1 = 1.2;--旋转方面的时间
R2 = 0.4;
R3 = 0.2;
R4 = 1;--hold的检查时长

local rSpeed =2;
if SPIN_QUICK then
    R1 = R1 / rSpeed;
    R2 = R2 / rSpeed;
    R3 = R3 / rSpeed;
    R4 = R4 / rSpeed;
end