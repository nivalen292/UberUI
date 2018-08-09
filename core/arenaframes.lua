local addon, ns = ...
uui_ArenaFrames = {}

local uui_ArenaFrames = CreateFrame("Frame")
local _, instanceType = IsInInstance()
uui_ArenaFrames:RegisterEvent("ADDON_LOADED")
uui_ArenaFrames:RegisterEvent("PLAYER_ENTERING_WORLD")
uui_ArenaFrames:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS")
uui_ArenaFrames:SetScript("OnEvent", function(self, event, addon)
	if not (IsAddOnLoaded("Shadowed Unit Frames")) then
		uui_ArenaFrames_Color(uuidb.miscframes.arenaframes)
	end
end)

function uui_ArenaFrames_Color(color)
	if not (color) then
		color = uuidb.miscframes.arenaframescolor
	end
	if event == "ARENA_PREP_OPPONENT_SPECIALIZATIONS" or (event == "PLAYER_ENTERING_WORLD" and instanceType == "arena") then
		for i,v in pairs({
			ArenaPrepFrame1Texture,
			ArenaPrepFrame2Texture,
			ArenaPrepFrame3Texture,
			ArenaPrepFrame4Texture,
			ArenaPrepFrame5Texture,
			ArenaPrepFrame1SpecBorder,
			ArenaPrepFrame2SpecBorder,
			ArenaPrepFrame3SpecBorder,
			ArenaPrepFrame4SpecBorder,
			ArenaPrepFrame5SpecBorder,
		}) do
	        --if (UnitIsConnected(v.unit)) and uuidb.targetframe.colortargett then
			--	uui_General_ClassColored(v, v.unit)
			--else
				v:SetVertexColor(color.r, color.g, color.b, color.a)
			--end
		end
	end
	if IsAddOnLoaded("Blizzard_ArenaUI") then
		for i,v in pairs({
			ArenaEnemyFrame1Texture,
			ArenaEnemyFrame2Texture,
			ArenaEnemyFrame3Texture,
			ArenaEnemyFrame4Texture,
			ArenaEnemyFrame5Texture,
			ArenaEnemyFrame1SpecBorder,
			ArenaEnemyFrame2SpecBorder,
			ArenaEnemyFrame3SpecBorder,
			ArenaEnemyFrame4SpecBorder,
			ArenaEnemyFrame5SpecBorder,
			ArenaEnemyFrame1PetFrameTexture,
			ArenaEnemyFrame2PetFrameTexture,
			ArenaEnemyFrame3PetFrameTexture,
			ArenaEnemyFrame4PetFrameTexture,
			ArenaEnemyFrame5PetFrameTexture,
	    }) do
			--if (UnitIsConnected(v.unit)) and uuidb.targetframe.colortargett then
			--	uui_General_ClassColored(v, v.unit)
			--else
				v:SetVertexColor(color.r, color.g, color.b, color.a)
			--end
	    end
	end
end