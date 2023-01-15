local RSGCore = exports['rsg-core']:GetCoreObject()
local roundtemp = 0

local ClothesCats = {
    0x9925C067, --hat
    0x2026C46D, --shirt
    0x1D4C528A, -- pants
    0x777EC6EF, -- boots 
    0xE06D30CE, -- coat
    0x662AC34, --open coat
    0xEABE0032, --gloves 
    0x485EE834, --vest
    0xAF14310B, -- poncho
}

-- check ped clothes
Citizen.CreateThread(function()
    while true do
        Wait(1500)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local temp = Citizen.InvokeNative(0xB98B78C3768AF6E0,coords.x,coords.y,coords.z)
        roundtemp = foo(temp)
        
        for k,v in pairs(ClothesCats) do
            local IsWearingClothes = Citizen.InvokeNative(0xFB4891BD7578CDC1 ,PlayerPedId(), v)
            if IsWearingClothes then 
                roundtemp = roundtemp + 1
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(5)
        DrawTxt("ID:"..tonumber(GetPlayerServerId(PlayerId())), 0.02, 0.95, 0.4, 0.4, true, 255, 255, 255, 255, true, 10000)
    end
end)

-- local PlayerId = GetPlayerServerId(PlayerId())
Citizen.CreateThread(function()
    while true do
        Wait(5)
        if tonumber(roundtemp) <= 0 then
            DrawTxt(""..tonumber(roundtemp).."°c", 0.06, 0.95, 0.4, 0.4, true, 50, 72, 255, 255, true, 10000)
        elseif tonumber(roundtemp) < 3 then 
            DrawTxt(""..tonumber(roundtemp).."°c", 0.06, 0.95, 0.4, 0.4, true, 3, 231, 255, 255, true, 10000)
        elseif tonumber(roundtemp) then
            DrawTxt(""..tonumber(roundtemp).."°c", 0.06, 0.95, 0.4, 0.4, true, 255, 255, 255, 255, true, 10000)
        end
    end
end)

---damage, effects
Citizen.CreateThread(function()
    while true do
        Wait(5000)
        ped = PlayerPedId()
        health = GetEntityHealth(ped)
        coords = GetEntityCoords(ped)
        if tonumber(roundtemp) <= -8 then
            SetEntityHealth(ped,health  - 5)
        elseif tonumber(roundtemp) <= -6 then
            SetEntityHealth(ped,health  - 2)
        elseif tonumber(roundtemp) <= -4 then
            SetEntityHealth(ped,health  - 1)
        end
        if health > 0 and health < 50 and tonumber(roundtemp) > 0 then 
            SetEntityHealth(ped,health  - 1)
            PlayPain(ped, 9, 1, true, true)
            Citizen.InvokeNative(0x4102732DF6B4005F, "MP_Downed", 0, true) -- AnimpostfxPlay
        else
            if Citizen.InvokeNative(0x4A123E85D7C4CA0B, "MP_Downed") then -- AnimpostfxIsRunning
                Citizen.InvokeNative(0xB4FD7446BAB2F394, "MP_Downed") -- AnimpostfxStop
            end
        end
    end
end)

function foo(n)
    return string.format("%.1f", n / 10^8)
end

function DrawTxt(str, x, y, w, h, enableShadow, col1, col2, col3, a, centre)
    local str = CreateVarString(10, "LITERAL_STRING", str, Citizen.ResultAsLong())
    SetTextScale(w, h)
    SetTextColor(math.floor(col1), math.floor(col2), math.floor(col3), math.floor(a))
    SetTextCentre(centre)
    if enableShadow then 
		SetTextDropshadow(1, 0, 0, 0, 255) 
	end
    Citizen.InvokeNative(0xADA9255D, 10);
    DisplayText(str, x, y)
end