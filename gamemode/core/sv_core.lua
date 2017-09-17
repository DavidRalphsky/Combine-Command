util.AddNetworkString("callcanister")
util.AddNetworkString("calldropship")
util.AddNetworkString("gohere")
util.AddNetworkString("buildmine")
util.AddNetworkString("buildstructure")

local function CallCanister(ply,vec,ang,crabtype)
	local ent = ents.Create("env_headcrabcanister") 
	
	ent:SetPos(vec)
	ent:SetAngles(ang)
	ent:SetKeyValue("HeadcrabType",crabtype)
	ent:SetKeyValue("HeadcrabCount",5)
	ent:SetKeyValue("FlightSpeed",3000)
	ent:SetKeyValue("FlightTime",5)
	ent:SetKeyValue("Damage",80)
	ent:SetKeyValue("DamageRadius", math.random(300,512))
	ent:SetKeyValue("SmokeLifetime", math.random(5,10))
	ent:SetKeyValue("StartingHeight",100)
	ent:Spawn()
	ent:Input("FireCanister", ply, ply)
end

local defenses = {"cc_mortar"}
function GoHere(vec,units)
	print("Go here!")

	if table.Count(units) > 0 then
		for k, v in pairs(units) do
			print(v)
			
			if table.HasValue(defenses, v) then
				v:Attack(vec)
			end
			
			v:SetLastPosition(vec)
			v:SetSchedule(SCHED_FORCED_GO_RUN)
			v:SetNPCState(NPC_STATE_IDLE)
		end
	end
end

local function CallDropship(_vec,typ)
	print("Dropship")
	
	local vec = _vec + Vector(0,0,580) -- Correct for strider's height
	
	local path = ents.Create("path_track")
	path:SetName("cc_striderdroppath"..path:EntIndex())
	path:SetPos(vec)
	path:Spawn()
	path:Activate()

	local dropship = ents.Create("npc_combinedropship")
	dropship:SetPos(Vector(-704, 5000, -11270))
	dropship:SetKeyValue("CrateType",typ)
	
	if typ == 1 then
		dropship:AddFlags(2048)
		dropship:SetKeyValue("NPCTemplate","npc_combine_s")
		dropship:SetKeyValue("Dustoff","1")
		dropship:SetKeyValue("Squad Name","dropshipsquad"..dropship:EntIndex())
	end
	
	dropship:SetKeyValue("Target","cc_striderdroppath"..path:EntIndex())
	dropship:Spawn()
	dropship:Activate()
	
	timer.Create("cc_dropshipcheck"..dropship:EntIndex(), 5, 20, function()
		if IsValid(dropship) and dropship:GetPos():Distance(vec) < 100 then
			
			if typ == -1 then
				dropship:Fire("DropStrider")	
				timer.Simple(0.1, function() if IsValid(dropship) then dropship:Remove() end end)
			elseif typ == 1 then
				dropship:Fire("LandTakeCrate",5)
			end
			
			
			timer.Destroy("cc_dropshipcheck"..dropship:EntIndex())
		end
	end)
end

local function BuildMine(vec)
	local mine = ents.Create("combine_mine")
	mine:SetPos(vec+Vector(0,0,30))
	mine:Spawn()
	mine:Activate()
end

local function BuildStructure(vec,typ)
	if typ == 1 then
	
	elseif typ == 2 then
		local building = ents.Create("cc_barracks")
		building:SetPos(vec)
		building:Spawn()
	elseif typ == 3 then
	
	end
end

net.Receive("callcanister", function(_ply,_vec,_ang,_crabtype)
	CallCanister(net.ReadEntity(),net.ReadVector(),net.ReadAngle(),net.ReadInt(16))
end)

net.Receive("calldropship", function(vec,int)
	CallDropship(net.ReadVector(),net.ReadInt(16))
end)

net.Receive("gohere", function(vec,tbl)
	GoHere(net.ReadVector(),net.ReadTable())
end)

net.Receive("buildmine", function(vec)
	BuildMine(net.ReadVector())
end)

net.Receive("buildstructure", function(vec,int)
	BuildStructure(net.ReadVector(),net.ReadInt(16))
end)

-----------------

function GM:BarracksSpawn(typ)
	local barracks = ents.FindByClass("cc_barracks")[1]
	
	if IsValid(barracks) then
		barracks:SpawnUnits(typ)
	end
end

