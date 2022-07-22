#include <sourcemod>
#include <colors_csgo>

#define PLUGIN_VERSION "1.1"

public Plugin:myinfo =
{
	name = "[SM] Un-Warning System",
	author = "Di3Z1E",
	description = "Removing any warnings.",
	version = PLUGIN_VERSION,
	url = "https://steamcommunity.com/id/209039239/"
}

public OnPluginStart()
{
	LoadTranslations("common.phrases");
	//Change "ADMFLAG_CUSTOM1" to other flag if you wants too.
	RegAdminCmd("sm_unwarn", Command_Warn, ADMFLAG_RESERVATION, "sm_unwarn <Player> <Reason> [\x04Respawn\x01 - \x04UnMute\x01 - \x04UnGag\x01].");
	CreateConVar("warn_version", PLUGIN_VERSION, "Plugin Version", FCVAR_REPLICATED|FCVAR_NOTIFY);
}

public Action:Command_Warn(client,args)
{
	if(args<2)
	{
		if(IsValidClient(client))
		{
			PrintToChat(client, "[SM] \x10Usage\x01: sm_unwarn \x02<Player>\x01 <Reason> <Compensation>");
			PrintToChat(client, "[SM]Select one of the compensation! [\x04Respawn\x01 - \x04UnMute\x01 - \x04UnGag\x01]")
			
			return Plugin_Handled;
		}
	}

	/*----------Strings-------------*/
	new String:Reason[256];
	new String:Punish[128];
	
	/*-----------Decl's------------*/
	decl String:buffer[64];
	decl String:Player_Name[MAX_NAME_LENGTH];
	decl target_list[MAXPLAYERS];
	decl Player;
	decl bool:js;
	
	GetCmdArg(1, buffer, sizeof(buffer));
	
	if ((Player = ProcessTargetString(
			buffer,
			client,
			target_list,
			MAXPLAYERS,
			0,
			Player_Name,
			sizeof(Player_Name),
			js)) <= 0)
			{
			ReplyToTargetError(client, Player);
			{ return Plugin_Handled; }
			}
		
	GetCmdArg(2, Reason, sizeof(Reason));

	
	if(args==2)
	{
		PrintToChatAll(" \x10%s\x01 has been \x04Un-warned\x01 for \x02%s\x01.", Player_Name, Reason);
	}
	
	//you can set new punishs, just copy one block and edit it.
	//If you wish to change the the "Warning Message" from "Alert" to "Chat" change the PrintHintToAll to -> PrintToChatAll.
	//In chat "mode" you'll see colors.
	if(args>=3)
	{
		GetCmdArg(3, Punish, sizeof(Punish));
		
		if(StrEqual(Punish, "respawn", false))
		{
		PrintToChatAll(" \x10%s\x01 has been \x04Un-warned\x01 for \x02%s\x01 and has been revived.", Player_Name, Reason);
		ServerCommand("sm_respawn %s", buffer);
		}
			else if(StrEqual(Punish, "unmute", false))
		{
		PrintToChatAll(" \x10%s\x01 has been \x04Un-warned\x01 for \x02%s\x01 and  un-muted.", Player_Name, Reason);
		ServerCommand("sm_unmute %s 5", buffer);
		}
			else if(StrEqual(Punish, "ungag", false))
		{
		PrintToChatAll(" \x10%s\x01 has been \x06Un-warned\x01 for \x02%s\x01 and un-gaged.", Player_Name, Reason);
		ServerCommand("sm_ungag  %s", buffer);
		}
			else
		{
		PrintToChatAll(" \x10%s\x01 has been \x04Un-warned\x01 for \x02%s\x01.", Player_Name, Reason);
		}
}
	return Plugin_Handled;
}

public bool:IsValidClient(client)
{
	if(IsClientInGame(client) && (!IsFakeClient(client)))
	{
	return true;
		}else{
	return false;
	}
}