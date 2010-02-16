---------------------------------------------------------------------------------
-- Copyright (C) 2010 Tiago Katcipis <tiagokatcipis@gmail.com>
-- Copyright (C) 2010 Paulo Pizarro  <paulo.pizarro@gmail.com>
-- 
-- @author Paulo Pizarro  <paulo.pizarro@gmail.com>
-- @author Tiago Katcipis <tiagokatcipis@gmail.com>

-- This file is part of LuaNotify.

-- LuaNotify is free software: you can redistribute it and/or modify
-- it under the terms of the GNU Lesser General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.

-- LuaNotify is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU Lesser General Public License for more details.

-- You should have received a copy of the GNU Lesser General Public License
-- along with Luasofia.  If not, see <http://www.gnu.org/licenses/>.
---------------------------------------------------------------------------------
module(..., package.seeall)

-----------------------------------------------------
-- Class attributes and methods goes on this table --
-----------------------------------------------------
local OrderedSet = {}

------------------------------------
-- Metamethods goes on this table --
------------------------------------
local OrderedSet_mt = { __index = OrderedSet, __metatable = "protected" }


--------------------------
-- Constructor function --
--------------------------

function new ()
    local object = {}
    -- set the metatable of the new object as the OrderedSet_mt table (inherits OrderedSet).
    setmetatable(object, OrderedSet_mt)

    -- create all the instance state data.
    object.data          = {}
    object.data_position = {}
    object.first         = 1 
    object.last          = 0
    return object
end

---------------------------
-- Class private methods --
---------------------------
local function refresh_first(self)
    while(self.first <= self.last) do
        if(self.data[self.first]) then
            return true
        end
        self.first = self.first + 1
    end
end


--------------------------
-- Class public methods --
--------------------------
function OrderedSet:is_empty()
    return self.first > self.last
end

function OrderedSet:push_front(data)
    if(self.data_position[data]) then
        return
    end
    self.first = self.first - 1
    self.data[self.first]    = data
    self.data_position[data] = self.first
end

function OrderedSet:push_back(data)
    if(self.data_position[data]) then
        return
    end
    self.last = self.last + 1
    self.data[self.last]     = data
    self.data_position[data] = self.last
end

function OrderedSet:get_iterator()
    local first = self.first
    local function iterator()
        while(first <= self.last) do
            local data = self.data[first]
            first = first + 1
            if(data) then
                return data
            end
        end    
    end 
    return iterator
end

function OrderedSet:remove(data)
    if(not self.data_position[data]) then
        return 
    end
    self.data[self.data_position[data]] = nil
    self.data_position[data]            = nil
    refresh_first(self)
end
