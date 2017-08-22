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
			print("Unit selected, type is: " .. unitInfo.UnitType .. "ID is: " .. tostring(pUnit));
			--local iCurrentAnimState = SimUnitSystem.GetAnimationState(pUnit);
			SimUnitSystem.SetAnimationState(pUnit, "SPAWN");
		end
	end
end
Events.UnitSelectionChanged.Add(OnUnitSelectionChanged);