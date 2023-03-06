require "movements"

local PARAMETERS = {
    WIDTH_MAX = 100,
    WIDTH_MIN = 50,
    HEIGHT_MAX = 100,
    HEIGHT_MIN = 50,
    LIFETIME_MAX = 4,
    LIFETIME_MIN = 3,
    MOVESPEED_MAX = 100,
    MOVESPEED_MIN = 100,
    REWARD_POINTS = 1,
    REWARD_TIME = 1,
    REWARD_MULTIPLIER = 3
    
}

TargetsList = {}

function Extended (child, parent)
    setmetatable(child, {__index  = parent})
end


local DefaultTarget = {}
function DefaultTarget:new()
    local obj = {}
        obj.width = love.math.random(PARAMETERS.WIDTH_MIN, PARAMETERS.WIDTH_MAX)
        obj.height  = love.math.random(PARAMETERS.HEIGHT_MIN, PARAMETERS.HEIGHT_MAX)
        obj.x = love.math.random(0, love.graphics.getPixelWidth() - obj.width)
        obj.y = love.math.random(0, love.graphics.getPixelHeight() - obj.height)
        obj.lifeTime = love.math.random(PARAMETERS.LIFETIME_MIN, PARAMETERS.LIFETIME_MAX)
        obj.rewardPoints = PARAMETERS.REWARD_POINTS
        obj.rewardTime = PARAMETERS.REWARD_TIME
        obj.color = {1,1,1}
        obj.targetType = "default"
    self.__index = self
    setmetatable(obj, self)

    return obj
end

function DefaultTarget:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function DefaultTarget:mouseInside()
    local entryByX = love.mouse.getX() <= (self.width + self.x) and love.mouse.getX() >= self.x
    local entryByY = love.mouse.getY() <= (self.height + self.y) and love.mouse.getY() >= self.y

    return (entryByX and entryByY)
end

function DefaultTarget:ReadyToDestroy()
    return self.lifeTime <= 0 or (love.mouse.isDown(1) and self:mouseInside()) or (love.mouse.isDown(1) and not self:mouseInside())
end


MovableTarget = {}
function MovableTarget:new()
    local obj = DefaultTarget:new()
        obj.rewardPoints = obj.rewardPoints * PARAMETERS.REWARD_MULTIPLIER
        obj.rewardTime = obj.rewardTime * PARAMETERS.REWARD_MULTIPLIER
        obj.speedMultiplierX = math.random(PARAMETERS.MOVESPEED_MIN, PARAMETERS.MOVESPEED_MAX)
        obj.speedMultiplierY = math.random(PARAMETERS.MOVESPEED_MIN, PARAMETERS.MOVESPEED_MAX)
        obj.axis = love.math.random(0,2)
        obj.easingType = love.math.random(1, #EasingTypes)
        obj.directionX = love.math.random(0,1) == 0 and -1 or 1
        obj.directionY = love.math.random(0,1) == 0 and -1 or 1
        obj.easingValue = 0
        obj.color = {1,1,0}
        obj.targetType = "movable"

    self.__index = self
    setmetatable(obj, self)

    return obj
end



function MovableTarget:move(dt)
    self.easingValue = self.easingValue + dt

    if(self.axis == 0) then
        self.x = self.x - EasingTypes[self.easingType](self.easingValue) * self.directionX * self.speedMultiplierX * dt
    elseif(self.axis == 1) then
        self.y = self.y - EasingTypes[self.easingType](self.easingValue) * self.directionY * self.speedMultiplierY * dt
    else
        self.x = self.x - EasingTypes[self.easingType](self.easingValue) * self.directionX  * self.speedMultiplierX * dt
        self.y = self.y - EasingTypes[self.easingType](self.easingValue) * self.directionY  * self.speedMultiplierY * dt
    end 

    if (self.x <= 0 or self.x + self.width >= love.graphics.getPixelWidth()) then
        self.directionX = self.directionX * -1
    elseif (self.y <= 0 or self.y + self.height >= love.graphics.getPixelHeight()) then
        self.directionY = self.directionY * -1
    end
end

BonusTarget = {}
function BonusTarget:new()
    local obj = MovableTarget:new()
        obj.isBonus = true
        obj.rewardPoints = 5
        obj.color = {0,1,1}
        obj.targetType = "bonus"

    self.__index = self
    setmetatable(obj, self)

    return obj
end


PenaltyTarget = {}
function  PenaltyTarget:new()
    local obj = MovableTarget:new()
        obj.rewardPoints = obj.rewardPoints * -1
        obj.rewardTime = obj.rewardTime * -1
        obj.color = {1,0,0}
        obj.isPenalty = true
        obj.targetType = "penalty"
        
    self.__index = self
    setmetatable(obj, self)

    return obj
end


Extended(MovableTarget, DefaultTarget)
Extended(BonusTarget, MovableTarget)
Extended(PenaltyTarget, MovableTarget)


table.insert(TargetsList, DefaultTarget)
table.insert(TargetsList, MovableTarget)
table.insert(TargetsList, PenaltyTarget)
table.insert(TargetsList, BonusTarget)
