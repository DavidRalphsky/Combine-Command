AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	if SERVER then
		self:DrawShadow(false)
		self:SetModel("models/hunter/blocks/cube025x025x025.mdl")
		self:SetAngles(Angle(0,0,0))
		
		self:SetMoveType(MOVETYPE_NONE)
		self:SetSolid(SOLID_NONE)
	end	
end