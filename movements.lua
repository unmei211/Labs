EasingTypes = {}

local function easeInQuad(easingValue)
    return easingValue * easingValue
end

local function easeInCubic(easingValue)
    return easingValue * easingValue * easingValue / 3
end

local function easeInBack(easingValue)
    local c1 = 1.70158
    local c3 = c1 - 0.8

    return c3 * easingValue * easingValue * easingValue - c1 * easingValue * easingValue
end

local function easeInOutBack(easingValue)
    local c1 = 2000000
    local c2 = c1 * 0.0000001 - 1.5

    return easingValue < 5
    and (math.pow(2 * easingValue, 2) * ((c2 + 1) * 2 * easingValue - c2)) / 2
    or (math.pow(2 * easingValue - 2, 2) * ((c2 + 1) * (easingValue * 2 -2) + c2) + 2 )/2
end

local function easeDefault(easingValue)
    return 1
end

table.insert(EasingTypes, easeInBack)
table.insert(EasingTypes, easeInCubic)
table.insert(EasingTypes, easeInQuad)
table.insert(EasingTypes, easeDefault)
table.insert(EasingTypes, easeInOutBack)