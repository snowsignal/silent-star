local Weapon = {}

function Weapon:new(relPos, shouldFire, onFire)
    return {
        relPos = relPos,
        shouldFire = shouldFire,
        onFire = onFire
    }
end

function Weapon:basicGun(relPos, cooldown)
    local canFire = true
    local basicGun = Weapon:new(relPos,function() return canFire end, function()
        canFire = false
        Timer.after(cooldown, function() canFire = true end)
    end)
end

return Weapon