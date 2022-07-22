#pragma semicolon 1

#include <sourcemod>
#include <colors_csgo>

#define PLUGIN_VERSION "1.0"
#define PREFIX " \x10[המחתרת]\x01"

public Plugin myinfo =
{
	name = "Warning System",
	author = "Di3Z1E",
	description = "Warning System.",
	version = PLUGIN_VERSION,
	url = "https://steamcommunity.com/id/209039239/"
}

public OnPluginStart()
{
	RegAdminCmd("sm_warn", Command_Warn, ADMFLAG_RESERVATION, "sm_warn <target> <Reason> [slay / slap / mute / gag].");
	CreateConVar("warn_version", PLUGIN_VERSION, "Plugin Version", FCVAR_REPLICATED|FCVAR_NOTIFY);
}

public Action Command_Warn(int client, int args)
{
	if(args<2 && IsValidClient(client))
	{
		PrintToChat(client, "%s \x06Usage\x01: sm_warn \x02<player>\x01 <Reason>. \n#OPTIONAL [\x02slay / slap / mute / gag\x01]", PREFIX);
		return Plugin_Handled;
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
	
	if((Player = ProcessTargetString(buffer, client, target_list, MAXPLAYERS, 0, Player_Name, sizeof(Player_Name), js)) <= 0)
	{
		ReplyToTargetError(client, Player);
		return Plugin_Handled; 
	}
		
	GetCmdArg(2, Reason, sizeof(Reason));

	if(args==2 && IsValidClient(client))
	{
		PrintToChatAll("%s Player \x02%s\x01 has been \x06warned\x01 for \x02%s\x01.", PREFIX, Player_Name, Reason);
	}
	
	//you can set new Punishs, just copy one block and edit it.
	if(args>=3 && IsValidClient(client))
	{
		GetCmdArg(3, Punish, sizeof(Punish));
		
		if(StrEqual(Punish, "slay", false))
		{
			PrintToChatAll("%s Player \x02%s\x01 has been \x06warned\x01 for \x02%s\x01 and was slain.", PREFIX, Player_Name, Reason);
			ServerCommand("sm_slay %s", buffer);
		}
		else if(StrEqual(Punish, "slap", false))
		{
			PrintToChatAll("%s Player \x02%s\x01 has been \x06warned\x01 for \x02%s\x01 and was slapped.", PREFIX, Player_Name, Reason);
			ServerCommand("sm_slap %s", buffer);
		}
		else if(StrEqual(Punish, "mute", false))
		{
			PrintToChatAll("%s Player \x02%s\x01 has been \x06warned\x01 for \x02%s\x01 and received a voice mute for 5 min.", PREFIX, Player_Name, Reason);
			ServerCommand("sm_mute %s 5 %s", buffer, Reason);
		}
		else if(StrEqual(Punish, "gag", false))
		{
			PrintToChatAll("%s Player \x02%s\x01 has been \x06warned\x01 for \x02%s\x01 and received a chat gag for 5 min.", PREFIX, Player_Name, Reason);
			ServerCommand("sm_gag  %s 5 %s", buffer, Reason);
		}
		else
		{
			PrintToChatAll("%s Player \x02%s\x01 has been \x06warned\x01 for \x02%s\x01.", PREFIX, Player_Name, Reason);
		}
	}
	return Plugin_Handled;
}

stock bool IsValidClient(int client)
{
	if(IsClientInGame(client) && (!IsFakeClient(client)))
	{
		return true;
	}
	else
	{
		return false;
	}
}
