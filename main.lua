require "targets"
require "player"

local GameConfig= {
    SPAWN_PERIOD = 0.7,
    SCORE_MULTIPLIER = 1,
    GAMETIME = 30,
    GAMETIME_MULTIPLIER = 1
}

math.randomseed(os.clock())

local activeTargets = {}

local player = Player:new()
player.timeToSpawn = GameConfig.SPAWN_PERIOD
player.gameTime = GameConfig.GAMETIME

local function destroyTarget(position)
    activeTargets[position], activeTargets[#activeTargets] = activeTargets[#activeTargets], activeTargets[position]
    table.remove(activeTargets, #activeTargets)
end


function love.update(dt)
    player.gameTime = player.gameTime - dt
    if(player.gameTime <= 0) then
        os.exit()
    end

    player.timeToSpawn =  player.timeToSpawn - dt
    if(player.timeToSpawn <= 0) then
        table.insert(activeTargets, TargetsList[love.math.random(1,#TargetsList)]:new())
        player.timeToSpawn = GameConfig.SPAWN_PERIOD
    end

    for i in ipairs(activeTargets) do
        if(activeTargets[i].move ~= nil) then
            activeTargets[i]:move(dt)
        end
        if(activeTargets[i].lifeTime <= 0) then
            if(activeTargets[i].targetType ~= "penalty") then
                player:resetStreak()
            end
            destroyTarget(i)
        elseif(player.buttonReleased and not activeTargets[i]:mouseInside() and love.mouse.isDown(1)) then
            player:resetStreak()
        elseif(player.buttonReleased and love.mouse.isDown(1) and activeTargets[i]:mouseInside()) then
            if(activeTargets[i].targetType == "penalty") then
                player:resetStreak()
            end
            player:registerDestroy(activeTargets[i].rewardPoints, activeTargets[i].rewardTime, activeTargets[i].targetType)
            destroyTarget(i)
        else
            activeTargets[i].lifeTime = activeTargets[i].lifeTime - dt
        end

    end
    player:fixButton()
end

function love.draw()
    love.graphics.setColor(1,1,1)
    love.graphics.print("Score\t" .. player.score ,0,0)
    love.graphics.print("Gametime\t" .. player.gameTime , 0, 10)
    love.graphics.print("Streak\t" .. player.targetStreak , 0, 20)
    
    for i in ipairs(activeTargets) do
        activeTargets[i]:draw()
    end
end

