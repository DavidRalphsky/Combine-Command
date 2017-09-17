AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	if SERVER then
		self:DrawShadow(false)
		self:SetModel("models/props_combine/combine_mortar01a.mdl")
		self:SetPos(self:GetPos()-Vector(0,0,200))
		self:SetAngles(Angle(0,0,0))
		
		self:SetMoveType(MOVETYPE_NONE)					
	
		timer.Create("ccmortrbuild"..self:EntIndex(), 1, 10, function()
			if IsValid(self) then
				self:SetPos(self:GetPos()+Vector(0,0,20))
			end		
		end)
	end
end

function ENT:Attack(vec)
	print("attack")
end