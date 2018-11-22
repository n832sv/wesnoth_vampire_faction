local generic_functions = {}

function generic_functions.sum_table_values(table) 
    local response = 0
    for str,val in pairs(table) do response = response + val end
    return response
end

function generic_functions.sum_array_values(t)
    local response = 0
    for index,value in ipairs(t) do 
        response = response + value
    end
    return response
end

function generic_functions.map(t, f) 
    local response = {}
    for index,value in ipairs(t) do
        table.insert(response, f(index,value))
    end
    return response
end

function generic_functions.for_each_index(t,f)
    for index,value in ipairs(t) do
        f(index,value)
    end
end

function generic_functions.for_each_key(t,f)
    for key, value in pairs(t) do
        f(key,value)
    end
end

function generic_functions.key_map(t,f) 
    local response = {}
    for key, value in pairs(t) do
        response[key] = f(key, value)
    end
    return response
end

function generic_functions.key_transform(t,f) 
    local response = {}
    for key_string,value in pairs(t) do
        local result = f(key_string,value)
        response[result.key] = result.value
    end
    return response
end

function generic_functions.array_table_transform (t,f) 
    local response = {}
    for index, value_literal in ipairs(t) do
        local result = f(index, value_literal)
        response[result.key] = result.value
    end
    return response
end

function generic_functions.sequence_generator(initial_value, f, length)
    local counter = 0
    local response = {}
    response[1] = initial_value
    while counter < length do
        counter = counter + 1
        response[counter + 1] = f(response[counter])
    end
    return response
end

               
function generic_functions.mutate_table(table, f)
  for index, value in ipairs(table) do table[index] = f(value, index) end
end

function generic_functions.populate_tables(count)
  local parent_table = {}
  for i = 1, count do
    table.insert(parent_table, {})
  end
  return parent_table
end

function generic_functions.another_sort_of_keys(t)
    local ordered_map = {}
    for k, v in pairs(t) do
        table.insert(ordered_map, k)
    end
    table.sort(ordered_map)
    return ordered_map
end

function generic_functions.table_aggregator_commutative_only(t, f)
    local aggregate = {}
    local container = {}
    local initialized = false
    local counter = 1
    for key,value in pairs(t) do
        if initialized == false then 
            aggregate[1] = key
            aggregate[2] = value
            initialized = true
        else 
            container[0] = f(aggregate[1], aggregate[2], key,value)
            for k,v in pairs(container[0]) do
                aggregate[1] = k
                aggregate[2] = v
            end
        end
    end
    return aggregate
end

function generic_functions.compose(f,g)
    return function(...) 
        return f(g(...)) 
    end
end 

function generic_functions.identity (x) 
    return x
end

function generic_functions.second_arg_identity(x,y)
    return y
end

function generic_functions.initialize_array(length, f)
    local response = {}
    for i=1, length do
        table.insert(response, f(i))
    end
    return response
end

function generic_functions.str_split (str) 
    local response = {}
    for chunk in utils.split(str) do
        table.insert(response, chunk)
    end
    return response
end

function generic_functions.zero ()
    return 0
end

function generic_functions.array_reverse (array)
    local response = generic_functions.initialize_array(#array, generic_functions.identity)
    for index,value in ipairs(array) do
        response[#array - index + 1] = value
    end
    return response
end        

function generic_functions.array_filter (array, f)
    local response = {}
    generic_functions.for_each_index(array, function (index,value) if f(index,value) == true then table.insert(response, value) end end)
    return response
end    

function generic_functions.array_count_to_array (t)
    local counter = map(t, generic_functions.second_arg_identity)
    local response = initialize_array(#t, generic_functions.zero)
    for_each_index(counter, function (i,v) generic_functions.for_each_index(counter, function (i2, v2) if v2 == v then response[i] = response[i] + 1 end end) end)
    return response
end

function generic_functions.array_match(t,value)
    local response = false
    generic_functions.for_each_index(t, function (i,v) if v == value then response = true end end)
    return response
end

function generic_functions.array_match_compare_function (t, value, f)
    local response = false
        generic_functions.for_each_index(t, function (i,v) if f(value, v) == true then response = true end end)
    return response
end

function generic_functions.array_cartesian_product (arr1, arr2) 
    local response = {}
    generic_functions.for_each_index(arr1, function (i,v) generic_functions.for_each_index(arr2, function (i2, v2) table.insert(response, { v , v2 }) end) end)
    return response
end
    
        
    
    
    

--[[
local function ordered_map_of_keys(t, predicate_function)
    local ordered_map = {}
    local symmetric_error = false
    local transitive_error = false -- no test
    local temporary = 0
    local counter = 1
    local counter_two = 1

    for key,value in pairs(t) do
        ordered_map[counter] = key
        counter = counter + 1
    end
    
    if #table < 2 return ordered_map end

    for index, val in ipairs(ordered_map) do
        counter_two = 1
        while counter_two < #t do
            if predicate_function(ordered_map[counter_two], ordered_map[counter_two + 1]) == true then
                if predicate_function(ordered_map[counter_two + 1], ordered_map[counter_two]) == true then symmetric_error = true end
                temporary = ordered_map[counter_two]
                ordered_map[counter_two] = ordered_map[counter_two + 1]
                ordered_map[counter_two + 1] = temporary
            else if predicate_function(ordered_map[counter_two], ordered_map[counter_two + 1]) == false and predicate_function(ordered_map[counter_two + 1], ordered_map[counter_two]) == false then symmetric_error = true end
            end
            counter_two = counter_two + 1         
        end
    end
    
    if symmetric_error == true then error("symmetric predicate function in ordered map") end
    return ordered_map
end
]]--

    

-- math functions

function generic_functions.normalized_gaussian_function(x,sigma,mu)
    return 1/((sigma * math.sqrt(2*math.pi)) * math.exp(-(((x-mu)^2)/(2*sigma^2))))
end

function generic_functions.gaussian_function(x,a,b,c) 
    return a * math.exp(-(((x-b)^2)/(2*c^2)))
end

function array_merge(t,t2)
    local response = {}
    generic_functions.for_each_index(t, function (i,v) table.insert(response,v) end)
    generic_functions.for_each_index(t2, function (i,v) table.insert(response,v) end)
    return response
end
        

function generic_functions.weighted_random(odds)
    local total = generic_functions.sum_array_values(odds)
    local normalized = generic_functions.map(odds, function(i,v) return v / total end)   
    local target = wesnoth.random()
    local sum = 0.0
    local counter = 1
    for index=1, #odds do
        sum = sum + normalized[counter]
        if target < sum then
            break
        end
        counter = counter + 1 
    end
    return counter
end

return generic_functions
 
