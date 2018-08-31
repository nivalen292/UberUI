local addon, ns = ...
arenaframes = {}

local arenaframes = CreateFrame("Frame")
arenaframes:RegisterEvent("ADDON_LOADED")
arenaframes:RegisterEvent("PLAYER_ENTERING_WORLD")
arenaframes:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS")
arenaframes:RegisterEvent("ARENA_OPPONENT_UPDATE")
arenaframes:SetScript("OnEvent", function(self, event, addon)
	if not (IsAddOnLoaded("Shadowed Unit Frames")) then
		if uuidb.general.customcolor or uuidb.general.classcolorframes then
			self:Color(uuidb.general.customcolorval)
			self:Prep(uuidb.general.customcolorval)
		else
			self:Color()
			self:Prep()
		end
	end
end)

function arenaframes:Color(color)
	if not (color) then
		color = uuidb.miscframes.arenaframescolor
	end

	if IsAddOnLoaded("Blizzard_ArenaUI") and not (IsAddOnLoaded("Shadowed Unit Frames")) then
		for i,v in pairs({
 			ArenaEnemyFrame1Texture,
			ArenaEnemyFrame2Texture,
			ArenaEnemyFrame3Texture,
			ArenaEnemyFrame4Texture,
			ArenaEnemyFrame1SpecBorder,
			ArenaEnemyFrame2SpecBorder,
			ArenaEnemyFrame3SpecBorder,
			ArenaEnemyFrame4SpecBorder
        }) do
        	if uuidb.general.colorarenat then
        		if string.find(v:GetName(), "EnemyFrame1") and UnitIsConnected("arena1") then
        			local colors = RAID_CLASS_COLORS[select(2, UnitClass("arena1"))]
        			v:SetVertexColor(colors.r, colors.g, colors.b)
        		elseif string.find(v:GetName(), "EnemyFrame2") and UnitIsConnected("arena2") then
        			local colors = RAID_CLASS_COLORS[select(2, UnitClass("arena2"))]
        			v:SetVertexColor(colors.r, colors.g, colors.b)
        		elseif string.find(v:GetName(), "EnemyFrame3") and UnitIsConnected("arena3") then
        			local colors = RAID_CLASS_COLORS[select(2, UnitClass("arena3"))]
        			v:SetVertexColor(colors.r, colors.g, colors.b)
        		elseif string.find(v:GetName(), "EnemyFrame4") and UnitIsConnected("arena4") then
        			local colors = RAID_CLASS_COLORS[select(2, UnitClass("arena4"))]
        			v:SetVertexColor(colors.r, colors.g, colors.b)
        		else
        			v:SetVertexColor(.05, .05, .05)
        		end
        	else
				v:SetVertexColor(.05, .05, .05)
			end
		end
		for _,v in pairs({
			ArenaEnemyFrame1PetFrameTexture,
			ArenaEnemyFrame2PetFrameTexture,
			ArenaEnemyFrame3PetFrameTexture,
			}) do
				v:SetVertexColor(.05,.05,.05)
		end
	--elseif event == "ARENA_PREP_OPPONENT_SPECIALIZATIONS" or (event == "PLAYER_ENTERING_WORLD" and instanceType == "arena") then
	--	for i,v in pairs({
	--		ArenaPrepFrame1Texture,
	--		ArenaPrepFrame2Texture,
	--		ArenaPrepFrame3Texture,
	--		ArenaPrepFrame1SpecBorder,
	--		ArenaPrepFrame2SpecBorder,
	--		ArenaPrepFrame3SpecBorder,
	--	}) do
	--		v:SetVertexColor(.05, .05, .05)
	--    end 		
	end 
end

function arenaframes:Prep(color)
	if not (color) then
		color = uuidb.miscframes.arenaframescolor
	end
	local _, instanceType = IsInInstance()
	if IsAddOnLoaded("Blizzard_ArenaUI") and instanceType == "arena" then
		for i,v in pairs({
			ArenaPrepFrame1Texture,
			ArenaPrepFrame2Texture,
			ArenaPrepFrame3Texture,
			ArenaPrepFrame1SpecBorder,
			ArenaPrepFrame2SpecBorder,
			ArenaPrepFrame3SpecBorder,
		}) do
			if uuidb.general.colorarenat then
        		if string.find(v:GetName(), "PrepFrame1") and UnitIsConnected("arena1") then
        			local colors = RAID_CLASS_COLORS[select(2, UnitClass("arena1"))]
        			v:SetVertexColor(colors.r, colors.g, colors.b)
        		elseif string.find(v:GetName(), "PrepFrame2") and UnitIsConnected("arena2") then
        			local colors = RAID_CLASS_COLORS[select(2, UnitClass("arena2"))]
        			v:SetVertexColor(colors.r, colors.g, colors.b)
        		elseif string.find(v:GetName(), "PrepFrame3") and UnitIsConnected("arena3") then
        			local colors = RAID_CLASS_COLORS[select(2, UnitClass("arena3"))]
        			v:SetVertexColor(colors.r, colors.g, colors.b)
        		else
        			v:SetVertexColor(.05, .05, .05)
        		end
        	else
				v:SetVertexColor(.05, .05, .05)
			end
		end
	end
end

UberUI.arenaframes = arenaframes