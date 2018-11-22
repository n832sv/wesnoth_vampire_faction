local helper = wesnoth.require("lua/helper.lua")
local on_event = wesnoth.require("on_event")

-- leader id = table of extra recruits
local recruits_table = {
    bloodlegacy_vampire_warrior_knight = { "bloodlegacy_vampire_swordswoman", "bloodlegacy_vampire_fighter", } , 
    bloodlegacy_vampire_fighter_guardian = { "bloodlegacy_vampire_shaman", "bloodlegacy_vampire_swordswoman", "bloodlegacy_human_sentinel", } , 
    bloodlegacy_vampire_freya = { "bloodlegacy_human_ranger", "bloodlegacy_vampire_rogue", } ,
    bloodlegacy_vampire_cabalist = { "bloodlegacy_vampire_rogue", "bloodlegacy_vampire_shaman", "bloodlegacy_human_ranger", } ,
    bloodlegacy_vampire_noble = { "bloodlegacy_vampire_rogue", "bloodlegacy_vampire_shaman",  "bloodlegacy_human_sentinel",  } ,
    bloodlegacy_vampire_onna_dame = { "bloodlegacy_vampire_onna", "bloodlegacy_vampire_rogue",  "bloodlegacy_vampire_noble", "bloodlegacy_vampire_tree",  } ,
};


local function for_each_key(t,f)
    for key, value in pairs(t) do
        f(key,value)
    end
end


on_event("prestart", function()
    for_each_key(recruits_table, function (key,value) 
        wesnoth.fire("allow_extra_recruit", { extra_recruit=value,  type=key, canrecruit=true })
    end)
end)
