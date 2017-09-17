AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	if SERVER then
		self:SetModel("models/hunter/blocks/cube025x025x025.mdl")
		self:SetAngles(Angle(0,0,0))
		self:SetPos(self:GetPos()-Vector(0,0,200))
		
		for i=1,14 do -- walls
			local prop = ents.Create("prop_physics")
			prop:SetModel("models/props_combine/combine_barricade_tall01a.mdl")
			
			if i < 8 then
				prop:SetPos(self:LocalToWorld(Vector(45,(62*i)-100,0)))
				prop:SetAngles(self:GetAngles())
			else
				prop:SetPos(self:LocalToWorld(Vector(-45,(62*i)-533.8,0)))
				prop:SetAngles(self:LocalToWorldAngles(Angle(0,180,0)))
			end
			prop:Spawn()
			prop:SetParent(self)
			
			prop:SetMoveType(MOVETYPE_NONE)
		end
		
		self:SetMoveType(MOVETYPE_NONE)
		self:SetSolid(SOLID_NONE)
		
		timer.Create("ccbrksbuild"..self:EntIndex(), 1, 10, function()
			if IsValid(self) then
				self:SetPos(self:GetPos()+Vector(0,0,20))
				
				self.Active = self.Active + 1
			end		
		end)
	end	
	self.Active = 0
end

function ENT:SpawnUnits(typ)
	if self.Active == 10 then
		if typ == 1 then
			local npc = ents.Create("npc_metropolice")
			npc:SetPos(self:GetPos())
			npc:Spawn()
			npc:Give("weapon_pistol")
			npc:SetLastPosition(self:LocalToWorld(Vector(0,550,0)))
			npc:SetSchedule(SCHED_FORCED_GO_RUN)
			npc:SetNPCState(NPC_STATE_NONE)
		elseif typ == 2 then
			local npc = ents.Create("npc_combine_s")
			npc:SetPos(self:GetPos())
			npc:Spawn()
			npc:Give("weapon_ar2")
			npc:SetLastPosition(self:LocalToWorld(Vector(0,550,0)))
			npc:SetSchedule(SCHED_FORCED_GO_RUN)
			npc:SetNPCState(NPC_STATE_COMBAT)
		end
	end
end