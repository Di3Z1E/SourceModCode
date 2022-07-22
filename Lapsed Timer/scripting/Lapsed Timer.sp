#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "Di3Z1E"
#define PLUGIN_VERSION "1.00"

#include <sourcemod>


public Plugin myinfo = 
{
	name = "[SM] Timer",
	author = PLUGIN_AUTHOR,
	description = "Basic Timer for players",
	version = PLUGIN_VERSION,
	url = "https://steamcommunity.com/id/209039239/"
};

public void OnClientPutInServer(int client)
{
    CreateTimer(5.0, Timer_Callback, GetClientUserId(client), TIMER_REPEAT); 
}


bool bExtra = false;

public Action Timer_Callback(Handle timer, any userid)
{
    int client = GetClientOfUserId(userid);
    
    if (!client)
    {
        return Plugin_Stop;
    }
    PrintToChat(client, "[SM] You've been online for \x06%s\x01  30 mintues!", bExtra? "extra" : "");
    ServerCommand("sm_givecredits %s 1", client);
    
    if(!bExtra)
        bExtra = true;
        
    return Plugin_Continue;
}