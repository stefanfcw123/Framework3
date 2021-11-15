-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/10/11 17:50:06                                                                                           
-------------------------------------------------------

---@class thingFly
local thingFly = class('thingFly')

function thingFly.fly(startPos)
    local flyNum = 14;
    local initPos = Vector3(startPos.x, startPos.y, 0);
    local finalPos = barPanel:coinImageWorldPosition()
    local flySpeed = 22.5;
    local secondOffset = 0.75;

    cs_coroutine.start(function()
        audio.PlaySound("CoinAnim");
        for i = 1, flyNum do
            coroutine.yield(WaitForSeconds(FLY_DELAY));
            local go = Spawn("flyGO");
            go.transform.position = initPos;
            local secondPos = Vector3(initPos.x + Random.insideUnitCircle.x * secondOffset, initPos.y + Random.insideUnitCircle.y * secondOffset, 0);
            local s = DOTween.Sequence();
            s:Append(go.transform:DOMove(secondPos, (Vector3.Distance(initPos, secondPos)) / flySpeed));
            s:Append(go.transform:DOMove(finalPos, (Vector3.Distance(secondPos, finalPos)) / flySpeed));
            s:OnComplete(function()
                Recycle(go);
                barPanel:coinImageBigSmall();
            end)
        end
    end)

end

function thingFly.pigFly()
    local flyNum = 8;
    local initPos = nil;
    local finalPos = barPanel:pigButtonWorldPosition();
    local offset = 1.35;

    cs_coroutine.start(function()
        for i = 1, flyNum do
            coroutine.yield(WaitForSeconds(0.1))
            local go = Spawn("flyGO"); --GameObject.Instantiate(AF:LoadEffect("flyGO"));
            initPos = Vector3(finalPos.x + Random.insideUnitCircle.x * offset, finalPos.y + Random.insideUnitCircle.y * offset, 0);
            go.transform.position = initPos;
            go.transform:DOMove(finalPos, 0.25):OnComplete(function()
                Recycle(go);-- UnityEngine.GameObject.Destroy(go);
            end)
        end
        barPanel:pigButtonBigSmall()
    end)
end

function thingFly.init()

    print("thingFly init")
end

return thingFly
