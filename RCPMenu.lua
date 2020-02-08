local speed = 10.0
local menunoclip = false
local menunocliptoggle = 0
local menunocliptext = false

local speedentity = 0.002
local menumoveentity = false
local menumoveentitytoggle = 0

local speedfreecam = 0.02
local menufreecam = false
local menufreecamtoggle = 0

local menucoords = false

RegisterCommand('rcpcoords', function() 
    menucoords = not menucoords
end, false)

RegisterCommand('rcpnoclip', function() 
    if menunocliptoggle == 0 then
        menunoclip = true
        FreezeEntityPosition(PlayerPedId(),true)
        menunocliptoggle = 1
    elseif menunocliptoggle == 1 then
        menunoclip = false
        FreezeEntityPosition(PlayerPedId(),false)
        menunocliptoggle = 0
    end
end, false)

RegisterCommand('rcpentitymove', function() 
    if menumoveentitytoggle == 0 then
        menumoveentity = true
        FreezeEntityPosition(PlayerPedId(),true)
        menumoveentitytoggle = 1
    elseif menumoveentitytoggle == 1 then
        menumoveentity = false
        FreezeEntityPosition(PlayerPedId(),false)
        menumoveentitytoggle = 0
    end
end, false)

RegisterCommand('rcpfreecam', function() 
    if menufreecamtoggle == 0 then
        menufreecam = true
        FreezeEntityPosition(PlayerPedId(),true)
        menufreecamtoggle = 1
    elseif menufreecamtoggle == 1 then
        menufreecam = false
        FreezeEntityPosition(PlayerPedId(),false)
        menufreecamtoggle = 0
    end
end, false)

RegisterCommand('rcpentitygravityoff', function() 
    local entityhit = GetEntityInView()
    if ((entityhit == nil) or (entityhit == PlayerPedId())) then
        DrawText("No Model",0.5,0.05)
    else
        DrawText("Entity: ".. entityhit,0.5,0.55)
        SetEntityHasGravity(entityhit,true)
        FreezeEntityPosition(entityhit,true)
    end
end, false)

RegisterCommand('rcpentitygravityon', function() 
    local entityhit = GetEntityInView()
    if ((entityhit == nil) or (entityhit == PlayerPedId())) then
        DrawText("No Entity",0.5,0.05)
    else
        DrawText("Entity: ".. entityhit,0.5,0.55)
        SetEntityHasGravity(entityhit,false)
        FreezeEntityPosition(entityhit,false)
    end
end, false)

function waitTime()
    menunocliptext = not menunocliptext
    Wait(300)
    menunocliptext = not menunocliptext
end

CreateThread( function()
    while true do 
        Wait(0)
        if menunocliptext then
            local ped = PlayerPedId()
            ClearPedTasksImmediately(PlayerPedId(),false,false)
            if menunoclip then
                ClearPedTasksImmediately(PlayerPedId(),false,false)
                DrawText("NoClip Speed: "..speed,0.5,0.85)
                DrawText("Page Up + Scroll - Changes Speed by 10.0, Page Down + Scroll - Changes Speed by 0.1",0.5,0.90)
                DrawText("W/A/S/D - Move, Spacebar - Up, Shift - Down, Scroll Up - Increase Speed 1.0, Scroll Down - Decrease Speed 1.0",0.5,0.95)
            elseif menumoveentity then
                ClearPedTasksImmediately(PlayerPedId(),false,false)
                DrawText("Move Entity Speed: "..speedentity,0.5,0.85)
                DrawText("Page Up + Scroll - Changes Speed by 0.01, Page Down + Scroll - Changes Speed by 0.001",0.5,0.90)
                DrawText("W/A/S/D - Move, Spacebar - Up, Shift - Down, Scroll Up - Increase Speed 0.1, Scroll Down - Decrease Speed 0.1",0.5,0.95)
            else
                ClearPedTasksImmediately(PlayerPedId(),false,false)
                DrawText("FreeCam Speed: "..speedfreecam,0.5,0.85)
                DrawText("Page Up + Scroll - Changes Speed by 10.0, Page Down + Scroll - Changes Speed by 0.1, C/X - Zoom In/Out, Enter - Exits Cam",0.5,0.90)
                DrawText("W/A/S/D - Move, Spacebar - Up, Shift - Down, Scroll Up - Increase Speed 1.0, Scroll Down - Decrease Speed 1.0",0.5,0.95)
            end
        end
        if menucoords then
            ped = PlayerPedId()
            x,y,z = table.unpack(GetEntityCoords(ped))
            DrawText("Coordinates\n"..x.."\n"..y.."\n"..z,0.3,0.3)
        end
    end
end)

CreateThread( function()
    while true do 
        Wait(0)
        if menunoclip then
            ped = PlayerPedId()
            x,y,z = table.unpack(GetEntityCoords(ped))
            DrawText("Page Up + Scroll - Changes Speed by 10.0, Page Down + Scroll - Changes Speed by 0.1",0.5,0.90)
            DrawText("W/A/S/D - Move, Spacebar - Up, Shift - Down, Scroll Up - Increase Speed 1.0, Scroll Down - Decrease Speed 1.0",0.5,0.95)
            ClearPedTasksImmediately(ped,false,false)
            SetEntityHeading(ped,180.0)
            if speed < 1.0 then
                speed = 1.0
            end
            if IsControlPressed(0,0x446258B6) and IsControlPressed(0,0xD0842EDF) then --Page Up + Scroll Down
                speed = speed - 10.0
                waitTime()
            end

            if IsControlPressed(0,0x3C3DD371) and IsControlPressed(0,0xD0842EDF) then --Page Down + Scroll Down
                speed = speed - 0.1
                waitTime()
            end

            if IsControlPressed(0,0xD0842EDF) then --Scroll Down
                speed = speed - 1.0
                waitTime()
            end
            
            if IsControlPressed(0,0x446258B6) and IsControlPressed(0,0xF78D7337) then --Page Up + Scroll Up
                speed = speed + 10.0
                waitTime()
            end

            if IsControlPressed(0,0x3C3DD371) and IsControlPressed(0,0xF78D7337) then --Page Down + Scroll Up
                speed = speed + 0.1
                waitTime()
            end

            if IsControlPressed(0,0xF78D7337) then --Scroll Up
                speed = speed + 1.0
                waitTime()
            end

            if IsControlPressed(0,0x8FD015D8) then --W MoveUpOnly
                SetEntityCoords(ped,x,y+speed,z)
            end
            if IsControlPressed(0,0xD27782E3) then --S MoveDownOnly
                SetEntityCoords(ped,x,y-speed,z)
            end
            if IsControlPressed(0,0x7065027D) then --A MoveLeftOnly
                SetEntityCoords(ped,x-speed,y,z)
            end
            if IsControlPressed(0,0xB4E465B4) then --D MoveRightOnly
                SetEntityCoords(ped,x+speed,y,z)
            end
            if IsControlPressed(0,0x8FFC75D6) then --Shift Sprint
                SetEntityCoords(ped,x,y,z-speed)
            end
            if IsControlPressed(0,0xD9D0E1C0) then --Spacebar Jump
                SetEntityCoords(ped,x,y,z+speed)
            end
        end
    end
end)

function GetEntityInView()
    local coords = GetGameplayCamCoord()
    local forward_vector = RotAnglesToVec(GetGameplayCamRot(1))
    local rayhandle = StartShapeTestRay(coords, coords + (forward_vector * 10000.0), -1,nil,7)
    local retval,hit,endCoords,surfaceNormal,entityHit = GetShapeTestResult(rayhandle)
    if entityHit > 0 then
        return entityHit
    else
        return nil
    end
end

function RotAnglesToVec(rot) -- input vector3
    local z = math.rad(rot.z)
    local x = math.rad(rot.x)
    local num = math.abs(math.cos(x))
    return vector3(-math.sin(z) * num, math.cos(z) * num, math.sin(x))
end

CreateThread( function()
    while true do 
        Wait(0)
        if menumoveentity then
            local entityhit = GetEntityInView()
            if ((entityhit == nil) or (entityhit == PlayerPedId())) then
                ClearPedTasksImmediately(PlayerPedId(),false,false)
                DrawText("No Entity",0.5,0.05)
            else
                DrawText("Entity: ".. entityhit,0.5,0.05)
                ped = entityhit
                x,y,z = table.unpack(GetEntityCoords(ped))
                pitch,roll,yaw = table.unpack(GetEntityRotation(ped,0))
                DrawText("Page Up + Scroll - Changes Speed by 0.01, Page Down + Scroll - Changes Speed by 0.001",0.5,0.90)
                DrawText("W/A/S/D - Move, Spacebar - Up, Shift - Down, Scroll Up - Increase Speed 0.1, Scroll Down - Decrease Speed 0.1",0.5,0.95)
                FreezeEntityPosition(ped,true)
                ClearPedTasksImmediately(PlayerPedId(),false,false)
                
                if IsControlPressed(0,0x446258B6) and IsControlPressed(0,0xD0842EDF) then --Page Up + Scroll Down
                    speedentity = speedentity - 0.01
                    waitTime()
                end

                if IsControlPressed(0,0x3C3DD371) and IsControlPressed(0,0xD0842EDF) then --Page Down + Scroll Down
                    speedentity = speedentity - 0.001
                    waitTime()
                end

                if IsControlPressed(0,0xD0842EDF) then --Scroll Down
                    speedentity = speedentity - 0.1
                    waitTime()
                end

                if IsControlPressed(0,0x446258B6) and IsControlPressed(0,0xF78D7337) then --Page Up + Scroll Up
                    speedentity = speedentity + 0.01
                    waitTime()
                end

                if IsControlPressed(0,0x3C3DD371) and IsControlPressed(0,0xF78D7337) then --Page Down + Scroll Up
                    speedentity = speedentity + 0.001
                    waitTime()
                end

                if IsControlPressed(0,0xF78D7337) then --Scroll Up
                    speedentity = speedentity + 0.1
                    waitTime()
                end

                if IsControlPressed(0,0x8FD015D8) then --W MoveUpOnly
                    SetEntityCoords(ped,x,y+speedentity,z)
                end
                if IsControlPressed(0,0xD27782E3) then --S MoveDownOnly
                    SetEntityCoords(ped,x,y-speedentity,z)
                end
                if IsControlPressed(0,0x7065027D) then --A MoveLeftOnly
                    SetEntityCoords(ped,x-speedentity,y,z)
                end
                if IsControlPressed(0,0xB4E465B4) then --D MoveRightOnly
                    SetEntityCoords(ped,x+speedentity,y,z)
                end
                if IsControlPressed(0,0x8FFC75D6) then --Shift Sprint
                    SetEntityCoords(ped,x,y,z-speedentity)
                end
                if IsControlPressed(0,0xD9D0E1C0) then --Spacebar Jump
                    SetEntityCoords(ped,x,y,z+speedentity)
                end

                if IsControlPressed(0,0x6319DB71) then --Up Arrow
                    SetEntityRotation(ped,pitch,roll+speedentity,yaw,0,true)
                end
                if IsControlPressed(0,0x05CA7C52) then --Down Arrow
                    SetEntityRotation(ped,pitch,roll-speedentity,yaw,0,true)
                end
                if IsControlPressed(0,0xA65EBAB4) then --Left Arrow
                    SetEntityRotation(ped,pitch-speedentity,roll,yaw,0,true)
                end
                if IsControlPressed(0,0xDEB34313) then --Right Arrow
                    SetEntityRotation(ped,pitch+speedentity,roll,yaw,0,true)
                end
                if IsControlPressed(0,0xDE794E3E) then --Q
                    SetEntityRotation(ped,pitch,roll,yaw-speedentity,0,true)
                end
                if IsControlPressed(0,0x26E9DC00) then --Z
                    SetEntityRotation(ped,pitch,roll,yaw+speedentity,0,true)
                end
            end
        end
    end
end)

local fov_max = 90.0
local fov_min = 10.0
local zoomspeed = 10.0
local speed_lr = 8.0
local speed_ud = 8.0

local fov = (fov_max+fov_min)*0.5

CreateThread( function()
    while true do 
        Wait(0)
        if menufreecam then
            local pedx,pedy,pedz = table.unpack(GetEntityCoords(PlayerPedId()))
            local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
            SetCamCoord(cam,pedx,pedy,pedz)
            SetCamFov(cam, fov)
            RenderScriptCams(true, true, 500, true, true)
            while menufreecam do
                Wait(0)
                ClearPedTasksImmediately(PlayerPedId(),false,false)
                DrawText("Page Up + Scroll - Changes Speed by 10.0, Page Down + Scroll - Changes Speed by 0.1, C/X - Zoom In/Out, Enter - Exits Cam",0.5,0.90)
                DrawText("W/A/S/D - Move, Spacebar - Up, Shift - Down, Scroll Up - Increase Speed 1.0, Scroll Down - Decrease Speed 1.0",0.5,0.95)
                local x,y,z = table.unpack(GetCamCoord(cam))
                HandleCamera(cam)
                if speedfreecam < 0.01 then
                    speedfreecam = 0.01
                end
                if IsControlPressed(0,0x446258B6) and IsControlPressed(0,0xD0842EDF) then --Page Up + Scroll Down
                    speedfreecam = speedfreecam - 10.0
                    waitTime()
                end

                if IsControlPressed(0,0x3C3DD371) and IsControlPressed(0,0xD0842EDF) then --Page Down + Scroll Down
                    speedfreecam = speedfreecam - 0.1
                    waitTime()
                end

                if IsControlPressed(0,0xD0842EDF) then --Scroll Down
                    speedfreecam = speedfreecam - 1.0
                    waitTime()
                end
                
                if IsControlPressed(0,0x446258B6) and IsControlPressed(0,0xF78D7337) then --Page Up + Scroll Up
                    speedfreecam = speedfreecam + 10.0
                    waitTime()
                end

                if IsControlPressed(0,0x3C3DD371) and IsControlPressed(0,0xF78D7337) then --Page Down + Scroll Up
                    speedfreecam = speedfreecam + 0.1
                    waitTime()
                end

                if IsControlPressed(0,0xF78D7337) then --Scroll Up
                    speedfreecam = speedfreecam + 1.0
                    waitTime()
                end
                if IsControlPressed(0,0x8FD015D8) then --W MoveUpOnly
                    SetCamCoord(cam,x,y+speedfreecam,z)    
                end
                if IsControlPressed(0,0xD27782E3) then --S MoveDownOnly
                    SetCamCoord(cam,x,y-speedfreecam,z)
                    
                end
                if IsControlPressed(0,0x7065027D) then --A MoveLeftOnly
                    SetCamCoord(cam,x-speedfreecam,y,z)
                    
                end
                if IsControlPressed(0,0xB4E465B4) then --D MoveRightOnly
                    SetCamCoord(cam,x+speedfreecam,y,z)
                    
                end
                if IsControlPressed(0,0x8FFC75D6) then --Shift Sprint
                    SetCamCoord(cam,x,y,z-speedfreecam)
                    
                end
                if IsControlPressed(0,0xD9D0E1C0) then --Spacebar Jump
                    SetCamCoord(cam,x,y,z+speedfreecam)
                    
                end
                if IsControlPressed(0,0xC7B5340A) then --Escape Enter
                    menufreecam = false
                    FreezeEntityPosition(PlayerPedId(),false)
                    menufreecamtoggle = 0
                end
            end
            fov = (fov_max+fov_min)*0.5
            RenderScriptCams(false, true, 500, true, true)
            SetCamActive(cam, false)
            DetachCam(cam)
            DestroyCam(cam, true)
        end
    end
end)

function HandleCamera(cam)
    local zoomvalue = (1.0/(fov_max-fov_min))*(fov-fov_min)
    CheckInputRotation(cam, zoomvalue)
    HandleZoom(cam)
    local camHeading = GetGameplayCamRelativeHeading()
    local camPitch = GetGameplayCamRelativePitch()
    if camPitch < -70.0 then
        camPitch = -70.0
    elseif camPitch > 42.0 then
        camPitch = 42.0
    end
    camPitch = (camPitch + 70.0) / 112.0                    
    if camHeading < -180.0 then
        camHeading = -180.0
    elseif camHeading > 180.0 then
        camHeading = 180.0
    end
    camHeading = (camHeading + 180.0) / 360.0
end

function DrawText(text,x,y)
    SetTextScale(0.35,0.35)
    SetTextColor(255,255,255,255)--r,g,b,a
    SetTextCentre(true)--true,false
    SetTextDropshadow(1,0,0,0,200)--distance,r,g,b,a
    SetTextFontForCurrentCommand(0)
    DisplayText(CreateVarString(10, "LITERAL_STRING", text), x, y)
end

function CheckInputRotation(cam, zoomvalue)
    local rightAxisX = GetDisabledControlNormal(0, 0xA987235F) -- Cursor X Axis
    local rightAxisY = GetDisabledControlNormal(0, 0xD2047988) -- Cursor Y Axis
    local rotation = GetCamRot(cam, 2)
    if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
        new_z = rotation.z + rightAxisX*-1.0*(speed_ud)*(zoomvalue+0.1)
        new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(speed_lr)*(zoomvalue+0.1)), -89.5)
        SetCamRot(cam, new_x, 0.0, new_z, 2)
    end
end

function HandleZoom(cam)
    if IsControlJustPressed(0,0x9959A6F0) then --C
        fov = math.max(fov - zoomspeed, fov_min)
    end
    if IsControlJustPressed(0,0x8CC9CD42) then --X
        fov = math.min(fov + zoomspeed, fov_max)
    end
    local current_fov = GetCamFov(cam)
    if math.abs(fov-current_fov) < 0.1 then
        fov = current_fov
    end
    SetCamFov(cam, current_fov + (fov - current_fov)*0.05)
end