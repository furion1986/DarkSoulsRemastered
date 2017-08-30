-- UI_3D Asset Animate and Attachment
-- Author: Furion
-- DateCreated: 8/9/2017 10:31:43 PM
--------------------------------------------------------------
include( "InstanceManager" );
include( "SupportFunctions" );
include( "Civ6Common" );

print("Loaded")

function OnUnitSelectionChanged(playerID, unitId, locationX, locationY, locationZ, isSelected, isEditable)
	if (isSelected) then
		local pPlayer = Players[playerID];
		local pUnit = pPlayer:GetUnits():FindID(unitId);
		local unitInfo = GameInfo.Units[pUnit:GetUnitType()];
		if (unitInfo.UnitType == "UNIT_UNDEAD" or unitInfo.UnitType == "UNIT_UNDEAD_RANGE") then
			--print("Unit selected, type is: " .. unitInfo.UnitType .. "ID is: " .. tostring(pUnit));
			--local iCurrentAnimState = SimUnitSystem.GetAnimationState(pUnit);
			if (unitInfo.UnitType == "UNIT_UNDEAD") then
				UpdateUndeadAttachment(pUnit);
			end
			--SimUnitSystem.SetAnimationState(pUnit, "SPAWN");
		end
	end
end

function SetUndeadAttachments(playerID, unitID)
	local pPlayer = Players[playerID];
	local unit = UnitManager.GetUnit(playerID, unitID);
	if unit then
		local unitType = GameInfo.Units[unit:GetUnitType()];
		--Check if unit type is Undead
		if unitType.UnitType == "UNIT_UNDEAD" then
			print("Undead added to map, checking attachments...");
			UpdateUndeadAttachment(unit);
		end
		--Done updating Undead Unit members
	end
	--unit isn't nil
end

function OnEnterFormation(playerID1, unitID1, playerID2, unitID2)
	local pPlayer = Players[playerID1];
	if (pPlayer ~= nil) then
		local pUnit1 = pPlayer:GetUnits():FindID(unitID1);
		local pUnit2 = pPlayer:GetUnits():FindID(unitID2);
		if (pUnit1 ~= nil) and (pUnit2 ~= nil) then
			local unitType1 = GameInfo.Units[pUnit1:GetUnitType()];
			local unitType2 = GameInfo.Units[pUnit2:GetUnitType()];
			--Check if unit type is Undead
			if unitType1.UnitType == "UNIT_UNDEAD" then
				UpdateUndeadAttachment(pUnit1);
			end
			if unitType2.UnitType == "UNIT_UNDEAD" then
				UpdateUndeadAttachment(pUnit2);
			end
		end
	end
end

function UpdateUndeadAttachment(unit)
	print(unit);
	local unitX = unit:GetX();
	local unitY = unit:GetY();
	local unitList:table = Units.GetUnitsInPlotLayerID(unitX, unitY, MapLayers.ANY);
	if unitList ~= nil then
		print("Undead is stacking with some units...");
		for i, pUnit in ipairs(unitList) do
			local unitInfo:table = GameInfo.Units[pUnit:GetUnitType()];
			local iMemberCount = SimUnitSystem.GetVisMemberCount(unit);
			print("Stack "..tostring(i)..": "..unitInfo.UnitType.." Member Count: "..iMemberCount);
			for j = 0, iMemberCount - 1, 1 do
				local unitVisArtState = SimUnitSystem.GetVisMemberArtState(unit, j);
				print("Getting member attachments...");
				if (unitVisArtState ~= nil) then
					print("Undead VosArtState got...");
					local attName = nil;
					if unitInfo.UnitType == "UNIT_GOLD_PINE_RESIN" then
						attName = unitVisArtState.Attachments[5].Name;
						print("Gold Pine Resin detected..."..attName);
						--repeat
							SimUnitSystem.ChangeVisMemberArtAttachment(unit, j, 4, 1);
							attName = unitVisArtState.Attachments[5].Name;
						--until (attName == "DS_Gold_Pine_Resin")
						return;
					else
						attName = unitVisArtState.Attachments[5].Name;
						print("Nothing detected, use default..."..attName);
						--repeat
							SimUnitSystem.ChangeVisMemberArtAttachment(unit, j, 4, 1);
							attName = unitVisArtState.Attachments[5].Name;
							print("Attachment Changed to..."..attName);
						--until (attName == "DS_No_Equipment")
					end
					--End Switching Attachments
				end
				--Unit has Vis Art State
			end
			--End looping through members
		end
		--End looping through units in same tile
	else
		print("Nothing in same tile, use default...");
		for j = 0, iMemberCount - 1, 1 do
			local unitVisArtState = SimUnitSystem.GetVisMemberArtState(unit, j);
			attName = unitVisArtState.Attachments[5].Name;
			print("Getting member attachments..."..attName);
			--repeat
				SimUnitSystem.ChangeVisMemberArtAttachment(unit, j, 4, 1);
				attName = unitVisArtState.Attachments[5].Name;
			--until (attName == "DS_No_Equipment")
		end
	end
	--unitList isn't nil
end

----------Events----------
Events.UnitSelectionChanged.Add(OnUnitSelectionChanged);
--Events.UnitAddedToMap.Add(SetUndeadAttachments);
--Events.UnitEnterFormation.Add(OnEnterFormation);
--Events.UnitExitFormation.Add(OnEnterFormation);