PlayerConfig = {
    STREAK_MULTIPLIER = 0.5,
    STREAK_START = 4
}

local function streakMultiplier(targetStreak)
    return targetStreak < PlayerConfig.STREAK_START and 0 or targetStreak * PlayerConfig.STREAK_MULTIPLIER / 2
end

Player = {}
function Player:new()
    local obj = {}
        obj.score = 0
        obj.gameTime = 0
        obj.timeToSpawn = 0
        obj.targetStreak = 0
        obj.buttonReleased = true
    self.__index = self
    setmetatable(obj, self)

    return obj
end

function Player:shoot()
    
end

function Player:resetStreak()
    self.targetStreak = 0
end

function Player:fixButton()
    if(not love.mouse.isDown(1)) then
        self.buttonReleased = true
    else
        self.buttonReleased = false
    end
end

function Player:registerDestroy(rewardScore, rewardTime, targetType)
    self.targetStreak = self.targetStreak + 1

    if(targetType == "penalty") then
        self.targetStreak = 0
    end
    
    self.score = self.score + rewardScore + streakMultiplier(self.targetStreak)
    self.gameTime = self.gameTime + rewardTime
end

