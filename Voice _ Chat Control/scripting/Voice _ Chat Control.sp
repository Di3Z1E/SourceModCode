#define PLUGIN_AUTHOR "Di3Z1E"
#define PLUGIN_VERSION "1.00"
#define PREFIX "\x10[המחתרת]\x01"


#include <sourcemod>
#include <colors_csgo>


public Plugin myinfo = 
{
	name = "Admin Tools", 
	author = PLUGIN_AUTHOR, 
	description = "Gives the Admins more control in the server.", 
	version = PLUGIN_VERSION, 
	url = "https://steamcommunity.com/id/Di3Z1E/"
};

public void OnPluginStart()
{
	RegAdminCmd("sm_fexec", ClientFakeExec, ADMFLAG_RCON);
	RegAdminCmd("sm_cc", ClearChat, ADMFLAG_CHAT, "Clear Chat");
	RegAdminCmd("sm_scc", SuperClearChat, ADMFLAG_CHAT, "Super Clean + Rules Display");
	RegAdminCmd("sm_dv", DisableVoice, ADMFLAG_CONFIG, "Closing the voice chat.");
	RegAdminCmd("sm_av", ActivateVoice, ADMFLAG_CONFIG, "Opening the voice chat.");
	
	LoadTranslations("common.phrases");
}


public Action:ClientFakeExec(int client, int args)
{
	if (args < 2)
	{
		ReplyToCommand(client, " ");
		return Plugin_Handled;
	}
	
	decl String:arg[65], String:cmd[192];
	GetCmdArg(1, arg, sizeof(arg));
	GetCmdArg(2, cmd, sizeof(cmd));
	
	decl String:target_name[MAX_TARGET_LENGTH];
	decl target_list[MAXPLAYERS], target_count, bool:tn_is_ml;
	
	if ((target_count = ProcessTargetString(
				arg, 
				client, 
				target_list, 
				MAXPLAYERS, 
				0, 
				target_name, 
				sizeof(target_name), 
				tn_is_ml)) <= 0)
	{
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}
	
	for (new i = 0; i < target_count; i++)
	{
		PerformFakeExec(client, target_list[i], cmd);
	}
	
	return Plugin_Handled;
}

stock PerformFakeExec(client, target, const String:cmd[])
{
	FakeClientCommandEx(target, cmd);
}


public Action ClearChat(int client, int args)
{
	for (int i = 0; i < 200; i++)
	{
		PrintToChatAll("\n ");
	}
	
	PrintToChatAll(" %s The \x02Admin\x01 cleared the chat.", PREFIX);
	PrintToChatAll(" %s \x07Dont spam or break the rules\x01!", PREFIX);
	
	return Plugin_Handled;
}


public Action SuperClearChat(int client, int args)
{
	for (int i = 0; i < 200; i++)
	{
		PrintToChatAll("\n ");
	}
	PrintToChatAll(" %s The \x02Admin\x01 cleared the chat.", PREFIX);
	PrintToChatAll(" %s \x07Dont spam or break the rules\x01!", PREFIX);
	PrintToChatAll(" %s Rules \x06Displayed\x01 for \x07everyone\x01. ", PREFIX);
	ServerCommand("sm_fexec @all sm_rules");
	
	return Plugin_Handled;
}


public Action DisableVoice(int client, int args)
{
	PrintToChatAll(" %s The \x02Admin\x01 shut down the voice channel.", PREFIX);
	PrintToChatAll(" %s The voice chat will comeback when the admin decide.", PREFIX);
	ServerCommand("sm_rcon sv_voiceenable 0");
	
	return Plugin_Handled;
}


public Action ActivateVoice(int client, int args)
{
	PrintToChatAll(" %s The \x02Admin\x01 \x06activate\x01 back the voice channel.", PREFIX);
	PrintToChatAll(" %s The voice chat \x06turned on\x01, \x0Bplease behave\x01.", PREFIX);
	ServerCommand("sm_rcon sv_voiceenable 1");
	
	return Plugin_Handled;
}


stock bool IsValidClient(int client)
{
	if (IsClientInGame(client) && (!IsFakeClient(client)))
	{
		return true;
	}
	else {
		return false;
	}
}