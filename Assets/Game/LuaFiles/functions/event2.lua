
-------------------------------------------------------                                                             
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/9/26 14:37:47                                                                                           
-------------------------------------------------------

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