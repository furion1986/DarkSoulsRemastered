-- DS_StopMusicControl
-- Author: Furion
-- DateCreated: 8/31/2017 10:57:18 PM
--------------------------------------------------------------

--Stop Music on Retire, Restart, Load or Exit to Main Menu

function OnUIExitGame()
	UI.PlaySound("Stop_Music_FIRELINK");
end

function OnPlayerDefeatStopMusic( player, defeat, eventID)
	print("Defeat Event Activated.");
	UI.PlaySound("Stop_Music_FIRELINK");
end

function OnTeamVictoryStopMusic(team, victory, eventID)
	print("Victory Event Activated.");
	UI.PlaySound("Stop_Music_FIRELINK");
end

function OnLoadScreenClose()
	UI.PlaySound("Play_Music_FIRELINK");
end

function OnLoadGame()
	Events.LoadScreenClose.Add(OnLoadScreenClose);
end
----------Events----------
Events.LeaveGameComplete.Add(OnUIExitGame);
Events.PlayerDefeat.Add(OnPlayerDefeatStopMusic);
Events.TeamVictory.Add(OnTeamVictoryStopMusic);
--Events.LoadScreenContentReady.Add(OnUIExitGame);
Events.LoadComplete.Add(OnLoadGame);