local units     = {}
local _units    = {}
local origin    = Vector(0,0,0)
local forback   = 0
local rightleft = 0
local vert      = 0
local modifier  = 0
local pts		= 1500
local menuopen  = false
local x1        = false
local x2        = false
local y1        = false
local y2        = false
local z1        = false
local z2        = false

function GM:CalcView(ply, origin, angle, fov)
	if ply:Team() == 1 or ply:Team() == 2 then
		gui.EnableScreenClicker(true)
		local view      = {}
		
		if !input.IsMouseDown(MOUSE_FIRST) and !menuopen then
			if ply:KeyDown(IN_SPEED)	         then modifier  = 10                   else modifier = 4 end		
			if ply:KeyDown(IN_FORWARD)   and !x1 then forback   = forback - modifier   end
			if ply:KeyDown(IN_BACK)      and !x2 then forback   = forback + modifier   end
			if ply:KeyDown(IN_MOVERIGHT) and !y1 then rightleft = rightleft + modifier end
			if ply:KeyDown(IN_MOVELEFT)  and !y2 then rightleft = rightleft - modifier end
			if ply:KeyDown(IN_DUCK)      and !z1 then vert      = vert - modifier      end
			if ply:KeyDown(IN_JUMP)      and !z2 then vert      = vert + modifier      end
		end
		
		if ply:EyeAngles().y == -135 then origin = origin + (Vector(forback,forback,1500+vert) + Vector(-rightleft,rightleft,0))   end
		if ply:EyeAngles().y == -45  then origin = origin + (Vector(-forback,forback,1500+vert) + Vector(-rightleft,-rightleft,0)) end
		if ply:EyeAngles().y == 45   then origin = origin + (Vector(-forback,-forback,1500+vert) + Vector(rightleft,-rightleft,0))   end
		if ply:EyeAngles().y == 135  then origin = origin + (Vector(forback,-forback,1500+vert) + Vector(rightleft,rightleft,0))   end
		
		view.origin = origin
		ply.origin  = origin
		
		-- TODO: Make this not shit --
		if util.QuickTrace(view.origin,Vector(-1,-1,0)*100).Hit then forback = forback+1      x1 = true else x1 = false end
		if util.QuickTrace(view.origin,Vector(1,1,0)*100).Hit   then forback = forback-1      x2 = true else x2 = false end
		if util.QuickTrace(view.origin,Vector(-1,1,0)*100).Hit  then rightleft = rightleft-10 y1 = true else y1 = false end
		if util.QuickTrace(view.origin,Vector(1,-1,0)*100).Hit  then rightleft = rightleft+10 y2 = true else y2 = false end
		if util.QuickTrace(view.origin,Vector(0,0,-1)*500).Hit  then vert = vert+10           z1 = true else z1 = false end
		if util.QuickTrace(view.origin,Vector(0,0,1)*100).Hit   then vert = vert-10           z2 = true else z2 = false end
		------------------------------

		return view 
	end
end

----------------------------------
local nextCall = 0
local function Acknowledge(tbl) -- ALSO TODO use calcview to make separate gm: isometric league-esque
	if nextCall > CurTime() then return end 

	if table.Count(units) > 0 then
		local mlines = {"npc/metropolice/vo/responding2.wav","npc/metropolice/vo/copy.wav"}
		local clines = {"npc/combine_soldier/vo/copy.wav","npc/combine_soldier/vo/reportingclear.wav","npc/combine_soldier/vo/bearing.wav"}
		local slines = {"npc/strider/striderx_alert5.wav"}
		local rlines = {"npc/roller/mine/rmine_blip1.wav","npc/roller/mine/rmine_chirp_quest1.wav"}
		local hlines = {"npc/ministrider/alert4.wav","npc/ministrider/hunter_foundenemy2.wav","npc/ministrider/hunter_foundenemy3.wav"}
		local glines = {"npc/combine_gunship/ping_search.wav"}
	
		local lines = {mlines,clines,clines,slines,rlines,hlines,glines}
		local classes = {"npc_metropolice", "npc_combine_s", "npc_helicopter", "npc_strider", "npc_rollermine", "npc_hunter", "npc_combinegunship"}
		local class = table.Random(units):GetClass()
		
		local line = table.Random(lines[table.KeyFromValue(classes,class)])
		
		surface.PlaySound(line)
		nextCall = CurTime()+SoundDuration(line)
	end
end

local function MovingCall(tbl)
	if nextCall > CurTime() then return end 
	
	if table.Count(tbl) > 0 then
		local mlines = {"npc/metropolice/vo/affirmative.wav","npc/metropolice/vo/affirmative2.wav","npc/metropolice/vo/converging.wav"}
		local clines = {"npc/combine_soldier/vo/affirmative2.wav","npc/combine_soldier/vo/weaponsoffsafeprepforcontact.wav","npc/combine_soldier/vo/readyweapons.wav"}
		local slines = {"npc/strider/striderx_alert6.wav"}
		local rlines = {"npc/roller/mine/rmine_tossed1.wav"}
		local hlines = {"npc/ministrider/hunter_flank_announce1.wav","npc/ministrider/hunter_idle2.wav","npc/ministrider/hunter_idle3.wav"}
		local glines = {"npc/combine_gunship/gunship_moan.wav"}
	
		local lines = {mlines,clines,clines,slines,rlines,hlines,glines}
		local classes = {"npc_metropolice", "npc_combine_s", "npc_helicopter", "npc_strider", "npc_rollermine", "npc_hunter", "npc_combinegunship"}
		local class = table.Random(tbl):GetClass()
		
		local line = table.Random(lines[table.KeyFromValue(classes,class)])
		
		surface.PlaySound(line)
		nextCall = CurTime()+SoundDuration(line)
	end
end

local function Fail()
	LocalPlayer():PrintMessage(HUD_PRINTTALK, "Insufficient funds.")
end

local function CallCanister(vec,crabtype)
	if crabtype == 0 then
		if pts < 500 then Fail() return end
	elseif crabtype == 1 then
		if pts < 550 then Fail() return end
	elseif crabtype == 2 then
		if pts < 600 then Fail() return end
	end

	local ang = (LocalPlayer().origin-vec):Angle()

	local ghostcanister = ClientsideModel("models/props_combine/headcrabcannister01b.mdl")
	ghostcanister:SetRenderMode(RENDERMODE_TRANSALPHA)
	ghostcanister:SetSequence("idle_open")
	ghostcanister:SetColor(Color(255,255,255,200))
	ghostcanister:SetPos(vec)
	ghostcanister:SetAngles(ang)
	
	timer.Simple(5.5, function() ghostcanister:Remove() end)
	
	net.Start("callcanister") 
		net.WriteEntity(LocalPlayer()) 
		net.WriteVector(vec)
		net.WriteAngle(ang)
		net.WriteInt(crabtype,2) 
	net.SendToServer()
end

local function CallStrider(vec)
	if pts < 1000 then Fail() end
	
	net.Start("calldropship") 
		net.WriteVector(vec) 
		net.WriteInt(-1,16) 
	net.SendToServer()
end

local function BuildMine(vec)
	if pts < 50 then Fail() end
	
	net.Start("buildmine") 
		net.WriteVector(vec) 
	net.SendToServer()
end


local function BuildStructure(vec,typ)
	if typ == 1 then -- HQ
		net.Start("buildstructure") 
			net.WriteVector(vec) 
			net.WriteInt(1,16) 
		net.SendToServer()
	elseif typ == 2 then -- Barracks
		net.Start("buildstructure") 
			net.WriteVector(vec) 
			net.WriteInt(2,16) 
		net.SendToServer()
	elseif typ == 3 then -- Helipad
	
	end

end
----------------------------------
local posunits        = {}
local originx,originy = 0,0
local newx,newy       = 0,0
local pass       	  = false
function GM:HUDPaint()
	if !IsValid(LocalPlayer()) then return end
	
	if LocalPlayer():Team() == 1 then
			
		surface.SetFont("Trebuchet24")
		surface.SetTextColor(255, 255, 255, 255)
		surface.SetTextPos(70, 70)
		surface.DrawText("Construction Points: "..tostring(pts))
	
		if LocalPlayer():Team() == 1 then	
			posunits        = {"npc_metropolice", "npc_combine_s", "npc_helicopter", "npc_strider", "cc_mortar", "npc_rollermine", "npc_hunter", "npc_combinegunship"}
		else
			posunits        = {"npc_citizen", "npc_vortigaunt"}
		end	
		
		if input.IsMouseDown(MOUSE_FIRST) then	
			if !pass then -- Save first mousepos for selection
				pass = true 
				originx,originy  = gui.MousePos()
				--units = {}
			end
			
			menuopen = false	
			local newx,newy   = gui.MousePos()
			local worldpos    = util.QuickTrace(LocalPlayer().origin, gui.ScreenToVector(originx,originy)*16384, LocalPlayer()).HitPos
			local worldendpos = util.QuickTrace(LocalPlayer().origin, gui.ScreenToVector(gui.MousePos()) *16384, LocalPlayer()).HitPos
 
			surface.DisableClipping(true)
			surface.SetDrawColor(255, 255, 255, 255)

			for i=1,3 do
				surface.DrawOutlinedRect(originx + i, originy + i, newx-originx - i * 2, newy-originy - i * 2)
			end

			for k, v in pairs(ents.GetAll()) do
				if v:IsNPC() and table.HasValue(posunits,v:GetClass()) then
					_units[#_units+1] = v:LocalToWorld(v:OBBCenter()):ToScreen() -- Find pos on screen
					
					for l, h in pairs(_units) do -- Get everything on screen
						if ((originx < h.x and h.x < newx) or (originx > h.x and h.x > newx)) and ((originy < h.y and h.y < newy) or (originy > h.y and h.y > newy)) then							
							if table.Count(units) > 0 then
								for j, p in pairs(units) do -- Make sure we don't already have it selected
									if !table.HasValue(units,v) then
										units[#units+1] = v
									end
								end
							else units[#units+1] = v end
						
						elseif table.HasValue(units, v) then
							table.RemoveByValue(units,v)
						end
					end
				end
			end
		else
			if pass then 			
				Acknowledge(units)
				pass = false 
			end
		end
		
		if(input.IsMouseDown(MOUSE_RIGHT)) then
			menuopen = true
			ShowUnitMenu(gui.MousePos())
		end
	end
	
	if table.Count(units) > 0 then -- hp bar/name
		for k, v in pairs(units) do
			if IsValid(v) and table.HasValue(posunits, v:GetClass()) then 
				cam.Start3D()
					render.SetMaterial(Material("sprites/splodesprite"))
					render.DrawSprite(v:GetPos()+Vector(0,0,100),32,32,Color(255,255,255,255))
				cam.End3D()
			end
		end
	end
end

function ShowUnitMenu(posx,posy)
	local worldpos = util.QuickTrace(LocalPlayer().origin, gui.ScreenToVector(posx,posy)*16384, LocalPlayer()).HitPos
	local copy = table.Copy(units)
	
	local m                           = DermaMenu()
	local gohere                      = m:AddOption("Go Here", function() MovingCall(copy)
																		  net.Start("gohere") 
																			net.WriteVector(worldpos) 
																			net.WriteTable(copy) 
																		  net.SendToServer() end)
																		  
																		  gohere:SetIcon("icon16/arrow_up.png")
			
			
	m:AddSpacer()
	
	local buildingsSub, buildingOption  = m:AddSubMenu("Build Structures") buildingOption:SetIcon("icon16/add.png")
	local buildHQ                       = buildingsSub:AddOption("Build HQ - 1000 Pts", function() BuildStructure(worldpos,1) end)
	local buildBarracks                 = buildingsSub:AddOption("Build Barracks - 300 Pts", function() BuildStructure(worldpos,2) end)
	local buildHelipad                  = buildingsSub:AddOption("Build Helipad - 700 Pts", function() BuildStructure(worldpos,3) end)
	
	local defensesSub, defenseOption  = m:AddSubMenu("Build Defenses") defenseOption:SetIcon("icon16/add.png")
	local buildMine                   = defensesSub:AddOption("Build Mine - 50 Pts", function() BuildMine(worldpos) end)
	
	local supportSub, supportOption   = m:AddSubMenu("Supports") supportOption:SetIcon("icon16/comment.png")
	
	local callStrider                 = supportSub:AddOption("Request Strider - 1000 Pts", function() CallStrider(worldpos) end)
	
	-- Headcrab Canister	
	local canisterSub, canisterOption = supportSub:AddSubMenu("Request Headcrab Canister")
	local callCanister                = canisterSub:AddOption( "Normal - 500 pts", function() CallCanister(worldpos,0) end)
	local callCanister2               = canisterSub:AddOption("Fast - 550 pts", function() CallCanister(worldpos,1) end)
	local callCanister3               = canisterSub:AddOption("Poison - 600 pts", function() CallCanister(worldpos,2) end)
	

	m:Open(posx,posy)
end
