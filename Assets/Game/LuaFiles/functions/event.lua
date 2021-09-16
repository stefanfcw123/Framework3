-------------------------------------------------------
-- author : sky_allen                                                                                                                  
--  email : 894982165@qq.com      
--   time : 2021/9/16 10:04:12                                                                                           
-------------------------------------------------------

---@class event
local event = class('event')

event.container = {};

function event.add_listener(event_type, callback)
    if event.container[event_type] == nil then
        local callbacks = {};
        table.insert(callbacks, callback);
        event.container[event_type] = callbacks;
    else
        local callbacks = event.container[event_type];
        table.insert(callbacks, callback);
    end
end;

function event.remove_listener(event_type, callback)
    if event.container[event_type] == nil then
        error("The event type is nil");
    else
        local callbacks = event.container[event_type];
        for i, v in ipairs(callbacks) do
            if v == callback then
                table.remove(callbacks, i);
                break ;
            end
        end
    end
end

function event.broadcast(event_type, ...)
    local callbacks = event.container[event_type];

    for i, v in ipairs(callbacks) do
        v(...)
    end
end

return event
