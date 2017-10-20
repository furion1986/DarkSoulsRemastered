-- DS_GameScript
-- Author: KCucumber
-- DateCreated: 6/21/2017 9:38:27 PM
--------------------------------------------------------------
function UndeadResurrection(playerId)
	local pPlayer = Players[playerId];
	local playerUnits = pPlayer:GetUnits();
	local playerConfig = PlayerConfigurations[playerId];
	local capitalCity = pPlayer:GetCities():GetCapitalCity();
	local UDNumber = 0;
	local UDRNumber = 0;

	if pPlayer:IsMajor() and pPlayer:IsAlive() and capitalCity ~= nil then
		if playerConfig:GetCivilizationTypeName() == "CIVILIZATION_FIRELINK" then
		    for i, unit in playerUnits:Members() do
				local unitInfo = GameInfo.Units[unit:GetType()];
				if unitInfo.UnitType == "UNIT_UNDEAD" then
					UDNumber = UDNumber +1;
				end
			end
			if UDNumber < 6 then
				UDNumber = 5 - UDNumber;
				for i = 0, UDNumber, 1 do
					pPlayer:GetUnits():Create(GameInfo.Units["UNIT_UNDEAD"].Index, capitalCity:GetX(), capitalCity:GetY());
				end
			end
		end
	end
end
GameEvents.PlayerTurnStarted.Add(UndeadResurrection);
--------------------------------------------------------------
--function UndeadTeleport(playerId)
--	local pPlayer = Players[playerId];
--	local playerConfig = PlayerConfigurations[playerId];
--	local currentTurn = Game.GetCurrentGameTurn();

--	if (playerConfig:GetCivilizationTypeName() == "CIVILIZATION_FIRELINK" and currentTurn == 1) then
--		pPlayer:GetCulture():SetCivic(GameInfo.Civics["CIVIC_RAPID_DEPLOYMENT"].Index, true);
--		pPlayer:GetTechs():SetTech(GameInfo.Technologies["TECH_ADVANCED_FLIGHT"].Index, true);
--	end
--end
--GameEvents.PlayerTurnStarted.Add(UndeadTeleport);

function UndeadTeleport(playerId)
	local pPlayer = Players[playerId];
	local playerConfig = PlayerConfigurations[playerId];
	local currentTurn = Game.GetCurrentGameTurn();

	if pPlayer:IsMajor() and pPlayer:IsAlive() then
		if (playerConfig:GetCivilizationTypeName() == "CIVILIZATION_FIRELINK" and currentTurn ~= 1) then
			pPlayer:GetCulture():SetCivic(GameInfo.Civics["CIVIC_RAPID_DEPLOYMENT"].Index, true);
			pPlayer:GetTechs():SetTech(GameInfo.Technologies["TECH_ADVANCED_FLIGHT"].Index, true);
		end
	end
end
Events.PlayerEraChanged.Add(UndeadTeleport);
--------------------------------------------------------------
function ProjectGiveWeapon(playerId, cityID, projectIndex, buildingIndex, locX, locY, bCanceled)
	local pPlayer = Players[playerId];
	local playerConfig = PlayerConfigurations[playerId];
	local capitalCity = pPlayer:GetCities():GetCapitalCity();
	local projectInfo = GameInfo.Projects[projectIndex];
	local projectType = projectInfo.ProjectType;

	if (playerConfig:GetCivilizationTypeName() == "CIVILIZATION_FIRELINK") then
		if (projectType == "PROJECT_DRAGONSLAYER_SPEAR") then
			pPlayer:GetUnits():Create(GameInfo.Units["UNIT_DRAGONSLAYER_SPEAR"].Index, capitalCity:GetX(), capitalCity:GetY());
		end
		if (projectType == "PROJECT_DRAGON_TOOTH") then
			pPlayer:GetUnits():Create(GameInfo.Units["UNIT_DRAGON_TOOTH"].Index, capitalCity:GetX(), capitalCity:GetY());
		end
		if (projectType == "PROJECT_ABYSS_GREATSWORD") then
			pPlayer:GetUnits():Create(GameInfo.Units["UNIT_ABYSS_GREATSWORD"].Index, capitalCity:GetX(), capitalCity:GetY());
		end
		if (projectType == "PROJECT_ASTORAS_STRAIGHT_SWORD") then
			pPlayer:GetUnits():Create(GameInfo.Units["UNIT_ASTORAS_STRAIGHT_SWORD"].Index, capitalCity:GetX(), capitalCity:GetY());
		end
		if (projectType == "PROJECT_GOUGHS_GREATBOW") then
			pPlayer:GetUnits():Create(GameInfo.Units["UNIT_GOUGHS_GREATBOW"].Index, capitalCity:GetX(), capitalCity:GetY());
		end
		if (projectType == "PROJECT_GOLD_TRACER") then
			pPlayer:GetUnits():Create(GameInfo.Units["UNIT_GOLD_TRACER"].Index, capitalCity:GetX(), capitalCity:GetY());
		end
		if (projectType == "PROJECT_COVENANT_OF_ARTORIAS") then
			pPlayer:GetUnits():Create(GameInfo.Units["UNIT_COVENANT_OF_ARTORIAS"].Index, capitalCity:GetX(), capitalCity:GetY());
		end
	end
end
Events.CityProjectCompleted.Add( ProjectGiveWeapon );
--------------------------------------------------------------