#pragma semicolon 1

#define PLUGIN_AUTHOR "Di3Z1E"
#define PLUGIN_VERSION "1.00"

#include <sourcemod>

new Handle:h_Enabled = INVALID_HANDLE;
new Handle:h_Sound = INVALID_HANDLE;

public Plugin myinfo = 
{
	name = "Player Joiend The Server Sound!",
	author = PLUGIN_AUTHOR,
	description = "When player joined the server, custom sound will be heared in the game",
	version = PLUGIN_VERSION,
	url = ""
};

public OnPluginStart ()
{
h_Enabled = CreateConVar("sm_joinsound", "1", "Enable sounds when player joins. 1 = Enable.", FCVAR_NOTIFY | FCVAR_DONTRECORD);
h_Sound = CreateConVar("sm_joinssoundname", "NONE", "USE .MP3 OR .WAV | Set the name of the sound to play when the client joins.", FCVAR_NOTIFY | FCVAR_DONTRECORD);
AutoExecConfig(true, "JoinSoundsConfig.cfg");
}

public OnClientPutInServer(client)
{
	new IsEnabled = GetConVarInt(h_Enabled);
	if(IsEnabled == 1)
	{
		new String:SName[99];
		GetConVarString(h_Sound, SName, sizeof(SName));
		
		if (StrEqual(SName, "NONE") || StrEqual(SName, "NONE"));
			{
				PrintToServer("[eServ] No sound was selected!");	
			}else{
				for (new i = 1; 1 < GetMaxClients();i++)
						{
						if(IsClientInGame(i)) && IsClientConnected(i))	
						}
							{
								ClientCommand(i, "play %s", SName);
							}
						}
	}
}