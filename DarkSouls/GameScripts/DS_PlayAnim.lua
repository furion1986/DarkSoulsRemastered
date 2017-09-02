-- UI_3D Asset Animate and Attachment
-- Author: Furion
-- DateCreated: 8/9/2017 10:31:43 PM
--------------------------------------------------------------
include( "InstanceManager" );
include( "SupportFunctions" );
include( "Civ6Common" );

print("Loaded")

function GetDSUnitFlag(playerID:number, unitID:number)
	if m_UnitFlagInstances[playerID]==nil then
		return nil;
	end
	return m_UnitFlagInstances[playerID][unitID];
end

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
			SimUnitSystem.SetAnimationState(pUnit, "SPAWN");
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

function UpdateUndeadAttachment(pUnit)
	local iMemberCount = SimUnitSystem.GetVisMemberCount(pUnit);
	print(tostring(pUnit).." Member Count: "..iMemberCount);
	--Get all units in same tile
	local unitX = pUnit:GetX();
	local unitY = pUnit:GetY();
	local unitList:table = Units.GetUnitsInPlotLayerID(unitX, unitY, MapLayers.ANY);	
	
	--Loop through members of Undead Unit
	if iMemberCount > 0 then
		for j = 0, iMemberCount - 1, 1 do
			local unitVisArtState = SimUnitSystem.GetVisMemberArtState(pUnit, j);
			print("Getting member attachments...");
			if (unitVisArtState ~= nil) then
				local attName = unitVisArtState.Attachments[5].Name;
				local hasResinType = false;
				print("Undead VosArtState got... Attachment 5 is: "..attName);
				if unitList ~= nil then
					print("Plot has units...");
					for i, tUnit in ipairs(unitList) do
						local tUnitInfo:table = GameInfo.Units[tUnit:GetUnitType()];
						if (tUnitInfo.UnitType == "UNIT_GOLD_PINE_RESIN") or (tUnitInfo.UnitType == "UNIT_DARK_PINE_RESIN") or (tUnitInfo.UnitType == "UNIT_PALE_PINE_RESIN") then
							print("Pine Resin detected...");
							hasResinType = true;
							--break;
						end
						--Reseved for other equipments
					end
					--End looping through units in same plot
				end
				print(hasResinType);
				if (attName ~= "DS_Gold_Pine_Resin") and (hasResinType == true) then
					print("Swapping to Resin...");
					SimUnitSystem.ChangeVisMemberArtAttachment(pUnit, j, 4, 1);
				elseif (attName == "DS_Gold_Pine_Resin") and (hasResinType == false) then
					--Dame it!
					print("Swapping to No Resin...");
					SimUnitSystem.ChangeVisMemberArtAttachment(pUnit, j, 4, 1);	
				end
				--Unit has Vis Art State
			end
			--End looping through members
		end
		--Unit has member
	end		
	--End of function
end

----------Events----------
Events.UnitSelectionChanged.Add(OnUnitSelectionChanged);
Events.UnitAddedToMap.Add(SetUndeadAttachments);
Events.UnitEnterFormation.Add(OnEnterFormation);
Events.UnitExitFormation.Add(OnEnterFormation);
