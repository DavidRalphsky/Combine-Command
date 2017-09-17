function GM:PlayerInitialSpawn(ply)
	ply:SetTeam(1)
end

function GM:PlayerSpawn(ply)
	ply:CrosshairDisable()
	ply:StripAmmo()
	ply:StripWeapons()
	ply:KillSilent()
	ply:SetObserverMode(OBS_MODE_ROAMING)
	ply:SetPos(Vector(0,0,0))
	ply:SetEyeAngles(Angle(45,-135,0))
end

local speed = 0.0005 * FrameTime()
local rightleft = 5
function GM:PlayerTick(ply, mv)
	if ply:Team() == 1 then
		if (mv:KeyDown(IN_SPEED)) then speed = 0.005 * FrameTime() end
		
		ply:SetPos(Vector(0,0,9000))
		return true
	end
	return false
end

function GM:PlayerDeath(vic,wep,kill)
	if vic:Team() == 1 then return end
end

function GM:PlayerDeathThink(ply)
	if ply:Team()==1 then return 
	
	else ply:Spawn() end
end

function GM:OnPlayerChangedTeam(ply,old,new)
	print("WHY ISNT THIS EVER CALLED PABAGMOLBDSGDSG")
end

function GM:PlayerNoclip(ply)
	return false
end

function GM:CanPlayerSuicide(ply)
	return false
end