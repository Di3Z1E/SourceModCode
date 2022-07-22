#pragma semicolon 1 
#define PLUGIN_VERSION "1.00"
#define PLUGIN_AUTHOR "Di3Z1E" 
#define PREFIX " \x10[המחתרת]\x01"

#include <sourcemod>
#include <colors_csgo>

#pragma newdecls required

public Plugin myinfo = 
{
	name = "Headshot Only", 
	author = PLUGIN_AUTHOR, 
	description = "Allowing Players To Vote For Only Headshot Mode.", 
	version = PLUGIN_VERSION, 
	url = "https://steamcommunity.com/id/Di3Z1E/"
};

public void OnPluginStart()
{
	RegConsoleCmd("sm_hs", Command_HS, "Run vote for Headshot only mode.");
}

public Action Command_HS(int client, int args)
{
	if (IsVoteInProgress())
	{
		PrintToChat(client, " \x10[המחתרת]\x01 Retry when no vote is on progress!");
		return Plugin_Handled;
	}
	DoVoteMenu();
	return Plugin_Handled;
}

void DoVoteMenu()
{
	Menu menu = new Menu(Handle_HS);
	menu.SetTitle("Toggle headshot mode only?");
	menu.AddItem("", "On");
	menu.AddItem("", "Off");
	menu.ExitButton = false;
	menu.DisplayVoteToAll(60);
}

public int Handle_HS(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_End)
	{
		delete menu;
	}
	else if (action == MenuAction_VoteEnd)
	{
		if (param1 == 0)
		{
			if (GetConVarBool(FindConVar("mp_damage_headshot_only")) == false)
			{
				SetConVarBool(FindConVar("mp_damage_headshot_only"), true);
				PrintToChatAll(" \x10[המחתרת]\x01 Headshot mode is toggled on!.");
			}
			else
			{
				PrintToChatAll(" \x10[המחתרת]\x01 Headshot mode is already toggled on.");
			}
		}
		else
		{
			if (GetConVarBool(FindConVar("mp_damage_headshot_only")) == true)
			{
				SetConVarBool(FindConVar("mp_damage_headshot_only"), false);
				PrintToChatAll(" \x10[המחתרת]\x01 Headshot mode is toggled off!.");
			}
			else
			{
				PrintToChatAll(" \x10[המחתרת]\x01 Headshot mode already toggled off.");
			}
		}
	}
} 