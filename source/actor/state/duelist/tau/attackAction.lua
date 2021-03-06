--[[
	desc: AttackAction, a state of base attack for Tau.
	author: SkyFvcker
	since: 2018-9-12
	alter: 2018-11-12
]]--

local _ASPECT = require("actor.service.aspect")
local _STATE = require("actor.service.state")

local _Base = require("actor.state.base")

---@class Actor.State.Duelist.Tau.AttackAction:Actor.State
---@field protected _skill Actor.Skill
---@field protected _stopTime milli
---@field protected _endTime milli
---@field protected _keyTick int
---@field protected _stopTick int
local _AttackAction = require("core.class")(_Base)

function _AttackAction:Ctor(data, ...)
    _Base.Ctor(self, data, ...)

    self._stopTime = data.stopTime
    self._keyTick = data.keyTick or 3
    self._stopTick = data.stopTick or self._keyTick - 1
end

function _AttackAction:NormalUpdate()
    local main = _ASPECT.GetPart(self._entity.aspect) ---@type Graphics.Drawable.Frameani
    local tick = main:GetTick()

    if (self._stopTime and tick == self._stopTick) then
        main:SetTime(self._stopTime)
    elseif (tick == self._keyTick) then
        self:OnKeyTick()
    elseif (self._endTime and tick == main:GetLength() - 1) then
        main:SetTime(self._endTime)
    end
    
    _STATE.AutoPlayEnd(self._entity.states, self._entity.aspect, self._nextState)
end

function _AttackAction:Enter(lateState, skill)
    _Base.Enter(self)

    self._skill = skill
end

function _AttackAction:OnKeyTick()
end

return _AttackAction