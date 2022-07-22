#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "Di3Z1E"
#define PLUGIN_VERSION "0.10"

#include <sourcemod>

public Plugin myinfo = 
{
	name = "Killing Event",
	author = PLUGIN_AUTHOR,
	description = "when player died/killed/kills - a msg will displayed on chat",
	version = PLUGIN_VERSION,
	url = ""
};

public OnPluginStart()
{
	HookEvent("player_death", player_death);
}

public Action:player_death(Handle:event, const String:name[], bool:dontBroadcast)
{

new client = GetClientOfUserId(GetEventInt(event, "userid"));
new attacker = GetClientOfUserId(GetEventInt(event, "attacker"));

new String:wep[22];
GetEventString(event, "weapon", wep, 22);

if(client == 0 || attacker == 0)
	{
		return Plugin_Continue;
	}

//cname = client name || aname = attacker name
new String:cname[32], String:aname[32];
GetClientName(client, cname, 32);
GetClientName(client, aname, 32);

if(client == attacker)
	{
		PrintToChatAll("\x06%s \x02Killed\x01 himself!", cname);
	} else {
		PrintToChatAll("\x06%s \x02killed\x01 \x06%s\x01 with %s!", cname, aname, wep);
			}
	return Plugin_Continue;
}