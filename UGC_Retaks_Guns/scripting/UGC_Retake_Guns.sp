#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <cstrike>
#include <autoexecconfig>
#include <clientprefs>
#include <retakes>

#pragma semicolon 1
#pragma newdecls required

#define FULL_ROUND 1
#define FORCE_ROUND 2
#define PISTOL_ROUND 3
#define DEAGLE_ROUND 4

bool g_bIsLateLoad = false;
bool g_bSniper[MAXPLAYERS + 1] = false;
bool g_bIsCT[MAXPLAYERS + 1] = false;

Handle g_hPrimary_CT = null;
Handle g_hSecondary_CT = null;
Handle g_hSMG_CT = null;
Handle g_hPrimary_T = null;
Handle g_hSecondary_T = null;
Handle g_hSMG_T = null;
Handle g_hSniper = null;

ConVar gc_bPlugin;
ConVar gc_iMode;
ConVar gc_iPistolChance;
ConVar gc_iForceChance;
ConVar gc_iDeagleChance;
ConVar gc_iPistolRounds;
ConVar gc_iForceRounds;
ConVar gc_iMolotov_T;
ConVar gc_iSmoke_T;
ConVar gc_iFlash_T;
ConVar gc_iHEgrenade_T;
ConVar gc_iMolotov_CT;
ConVar gc_iSmoke_CT;
ConVar gc_iFlash_CT;
ConVar gc_iHEgrenade_CT;
ConVar gc_iAWP_MinCT;
ConVar gc_iAWP_MinT;
ConVar gc_iScout_MinCT;
ConVar gc_iScout_MinT;
ConVar gc_iAWP_T;
ConVar gc_iAWP_CT;
ConVar gc_iScout_T;
ConVar gc_iScout_CT;
ConVar gc_iFullMoney;
ConVar gc_iPistolMoney;
ConVar gc_iForceMoney;
ConVar gc_bBombsite;
ConVar gc_iOrder;
ConVar gc_bKevlar;
ConVar gc_bHelm;
//ConVar gc_bDefuser;
ConVar gc_bRevolver;
ConVar gc_bDeagle;

int g_iRoundType;
int g_iHEgrenade_CT = 0;
int g_iHEgrenade_T = 0;
int g_iFlashbang_CT = 0;
int g_iFlashbang_T = 0;
int g_iSmokegrenade_CT = 0;
int g_iSmokegrenade_T = 0;
int g_iMolotov_CT = 0;
int g_iMolotov_T = 0;
int g_iAWP_CT = 0;
int g_iAWP_T = 0;
int g_iScout_CT = 0;
int g_iScout_T = 0;
int g_iRounds_Pistol = 0;
int g_iRounds_Force = 0;

char g_sPrimary_CT[MAXPLAYERS + 1][24];
char g_sSecondary_CT[MAXPLAYERS + 1][24];
char g_sSMG_CT[MAXPLAYERS + 1][24];
char g_sPrimary_T[MAXPLAYERS + 1][24];
char g_sSecondary_T[MAXPLAYERS + 1][24];
char g_sSMG_T[MAXPLAYERS + 1][24];
char g_sBombSite[16];
char g_sRoundType[64];

public Plugin myinfo =
{
	name = "UGC_Retake_Guns",
	author = "splewie, edited by Di3Z1E",
	description = "Retakes weapon allocator, re-edited by Di3Z1E",
	version = "1.01",
	url = "https://steamcommunity.com/id/Di3Z1E/"
};

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err)
{
	g_bIsLateLoad = late;

	return APLRes_Success;
}

public void OnPluginStart()
{
	LoadTranslations("UGC_Retake_Guns.phrases");

	RegConsoleCmd("sm_weapon", Command_Weapons, "open the weapon menu");
	RegConsoleCmd("sm_awp", Command_AWP, "open the AWP menu");

	AutoExecConfig_SetFile("UGC_Retake_Guns", "sourcemod/retakes");
	AutoExecConfig_SetCreateFile(true);

	gc_bPlugin = AutoExecConfig_CreateConVar("mywa_enable", "1", "0 - disabled, 1 - enable plugin", _, true, 0.0, true, 1.0);

	gc_iMode = AutoExecConfig_CreateConVar("mywa_rounds_chance", "1", "0 - chance / 1- rounds", _, true, 0.0, true, 1.0);

	gc_iPistolChance = AutoExecConfig_CreateConVar("mywa_chance_pistol", "20", "percent chance a round will be a pistol round (mywa_rounds_chance 0)", _, true, 0.0);
	gc_iForceChance = AutoExecConfig_CreateConVar("mywa_chance_force", "30", "percent chance a round will be a force round (mywa_rounds_chance 0)", _, true, 0.0);
	gc_iDeagleChance = AutoExecConfig_CreateConVar("mywa_chance_deagle", "5", "percent chance a round will be a deagle round (mywa_rounds_chance 0)", _, true, 0.0);

	gc_iPistolRounds = AutoExecConfig_CreateConVar("mywa_rounds_pistol", "5", "how many round will be pistol round (mywa_rounds_chance 1)", _, true, 0.0);
	gc_iForceRounds = AutoExecConfig_CreateConVar("mywa_rounds_force", "5", "how many round will be force round (mywa_rounds_chance 1)", _, true, 0.0);

	gc_iFullMoney = AutoExecConfig_CreateConVar("mywa_money_full", "16000", "money for weapons and equipment on fullbuy round", _, true, 0.0);
	gc_iPistolMoney = AutoExecConfig_CreateConVar("mywa_money_pistol", "800", "money for weapons and equipment on pistol round", _, true, 0.0);
	gc_iForceMoney = AutoExecConfig_CreateConVar("mywa_money_force", "2400", "money for weapons and equipment on forcebuy round", _, true, 0.0);

	gc_iAWP_MinT = AutoExecConfig_CreateConVar("mywa_awp_min_t", "1", "min number of player in terrorist team before AWP is available for T", _, true, 1.0);
	gc_iScout_MinT = AutoExecConfig_CreateConVar("mywa_scout_min_t", "1", "min number of player in terrorist team before scout is available for T", _, true, 1.0);
	gc_iAWP_T = AutoExecConfig_CreateConVar("mywa_awp_t", "1", "max number of AWPs for terrorist team / 0 - no AWPs", _, true, 0.0);
	gc_iScout_T = AutoExecConfig_CreateConVar("mywa_scout_t", "1", "max number of scouts for terrorist team in force rounds/ 0 - no scouts", _, true, 0.0);
	gc_iMolotov_T = AutoExecConfig_CreateConVar("mywa_molotov_t", "3", "max number of molotovs for terrorist team / 0 - no molotovs", _, true, 0.0);
	gc_iSmoke_T = AutoExecConfig_CreateConVar("mywa_smoke_t", "2", "max number of smokegrenades for terrorist team / 0 - no smokegrenades", _, true, 0.0);
	gc_iFlash_T = AutoExecConfig_CreateConVar("mywa_flash_t", "3", "max number of flashbangs for terrorist team / 0 - no flashbangs", _, true, 0.0);
	gc_iHEgrenade_T = AutoExecConfig_CreateConVar("mywa_he_t", "2", "max number of HEgrenades for terrorist team / 0 - no HEgrenades", _, true, 0.0);

	gc_iAWP_MinCT = AutoExecConfig_CreateConVar("mywa_awp_min_ct", "1", "min number of player in counter-terrorist team before AWP is available for CT", _, true, 1.0);
	gc_iScout_MinCT = AutoExecConfig_CreateConVar("mywa_scout_min_ct", "1", "min number of player in counter-terrorist team before scout is available for CT", _, true, 1.0);
	gc_iAWP_CT = AutoExecConfig_CreateConVar("mywa_awp_ct", "1", "max number of AWPs for counter-terrorist team / 0 - no AWPs", _, true, 0.0);
	gc_iScout_CT = AutoExecConfig_CreateConVar("mywa_scout_ct", "1", "max number of scouts for counter-terrorist team in force rounds/ 0 - no scouts", _, true, 0.0);
	gc_iMolotov_CT = AutoExecConfig_CreateConVar("mywa_molotov_ct", "1", "max number of molotovs for counter-terrorist team / 0 - no molotovs", _, true, 0.0);
	gc_iSmoke_CT = AutoExecConfig_CreateConVar("mywa_smoke_ct", "2", "max number of smokegrenades for counter-terrorist team / 0 - no smokegrenades", _, true, 0.0);
	gc_iFlash_CT = AutoExecConfig_CreateConVar("mywa_flash_ct", "3", "max number of flashbangs for counter-terrorist team / 0 - no flashbangs", _, true, 0.0);
	gc_iHEgrenade_CT = AutoExecConfig_CreateConVar("mywa_he_ct", "2", "max number of HEgrenades for counter-terrorist team / 0 - no HEgrenades", _, true, 0.0);

	gc_iOrder = AutoExecConfig_CreateConVar("mywa_buy_order", "0", "order to buy the equipments / 0 - random, 1 - 1st grenades 2nd armor & kit, 2 - 1st armor & kit 2nd grenades ", _, true, 0.0, true, 2.0);

	gc_bKevlar = AutoExecConfig_CreateConVar("mywa_kevlar", "1", "0 - disabled, 1 - enable kevlar", _, true, 0.0, true, 1.0);
	gc_bHelm = AutoExecConfig_CreateConVar("mywa_helm", "1", "0 - disabled, 1 - enable helm", _, true, 0.0, true, 1.0);
	//gc_bDefuser = AutoExecConfig_CreateConVar("mywa_defuser", "1", "0 - disabled, 1 - enable defuser", _, true, 0.0, true, 1.0);

	gc_bDeagle = AutoExecConfig_CreateConVar("mywa_deagle", "1", "0 - disabled, 1 - enable deagle for pistol & fullbuy rounds", _, true, 0.0, true, 1.0);
	gc_bRevolver = AutoExecConfig_CreateConVar("mywa_revolver", "0", "0 - disabled, 1 - enable revolver for pistol & fullbuy rounds", _, true, 0.0, true, 1.0);

	gc_bBombsite = AutoExecConfig_CreateConVar("mywa_bombsite", "0", "0 - disabled, 1 - enable bombsite notifications", _, true, 0.0, true, 1.0);

	AutoExecConfig_ExecuteFile();
	AutoExecConfig_CleanFile();

	HookEvent("round_start", Event_RoundStart, EventHookMode_Pre);
	HookEvent("bomb_planted", Event_BombPlanted, EventHookMode_Post);
	HookEvent("player_spawn", OnPlayerSpawnEvent);

	g_hPrimary_CT = RegClientCookie("MyWA - Primary CT", "", CookieAccess_Private);
	g_hSecondary_CT = RegClientCookie("MyWA - Secondary CT", "", CookieAccess_Private);
	g_hSMG_CT = RegClientCookie("MyWA MG - CT", "", CookieAccess_Private);
	g_hPrimary_T = RegClientCookie("MyWA - Primary T", "", CookieAccess_Private);
	g_hSecondary_T = RegClientCookie("MyWA - Secondary T", "", CookieAccess_Private);
	g_hSMG_T = RegClientCookie("MyWA - SMG T", "", CookieAccess_Private);
	g_hSniper = RegClientCookie("MyWA - Sniper", "", CookieAccess_Private);

	if (g_bIsLateLoad)
	{
		for (int i = 1; i <= MaxClients; i++)
		{
			if (!IsClientInGame(i))
				continue;

			OnClientConnected(i);

			if (!AreClientCookiesCached(i))
				continue;

			OnClientCookiesCached(i);
		}

		g_bIsLateLoad = false;
	}
}

public void OnAllPluginsLoaded()
{
	DisablePlugin("retakes_pistolallocator");
	DisablePlugin("retakes_standardallocator");
	DisablePlugin("retakes_ziksallocator");
	DisablePlugin("retakes_gdk_allocator");
	DisablePlugin("gunmenu");
}

public void OnClientConnected(int client)
{
	Format(g_sPrimary_CT[client], sizeof(g_sPrimary_CT), "weapon_m4a1");
	Format(g_sSecondary_CT[client], sizeof(g_sSecondary_CT), "weapon_usp_silencer");
	Format(g_sSMG_CT[client], sizeof(g_sSMG_CT), "weapon_ump45");
	Format(g_sPrimary_T[client], sizeof(g_sPrimary_T), "weapon_ak47");
	Format(g_sSecondary_T[client], sizeof(g_sSecondary_T), "weapon_glock");
	Format(g_sSMG_T[client], sizeof(g_sSMG_T), "weapon_ump45");
	g_bSniper[client] = false;
}

public void OnClientCookiesCached(int client)
{
	if (IsFakeClient(client))
		return;

	char sBuffer[24];

	GetClientCookie(client, g_hPrimary_CT, sBuffer, sizeof(sBuffer));
	if (strlen(sBuffer) > 5)
	{
		Format (g_sPrimary_CT[client], sizeof(g_sPrimary_CT), sBuffer);
	}
	GetClientCookie(client, g_hSecondary_CT, sBuffer, sizeof(sBuffer));
	if (strlen(sBuffer) > 5)
	{
		Format (g_sSecondary_CT[client], sizeof(g_sSecondary_CT), sBuffer);
	}
	GetClientCookie(client, g_hSMG_CT, sBuffer, sizeof(sBuffer));
	if (strlen(sBuffer) > 5)
	{
		Format (g_sSMG_CT[client], sizeof(g_sSMG_CT), sBuffer);
	}
	GetClientCookie(client, g_hPrimary_T, sBuffer, sizeof(sBuffer));
	if (strlen(sBuffer) > 5)
	{
		Format (g_sPrimary_T[client], sizeof(g_sPrimary_T), sBuffer);
	}
	GetClientCookie(client, g_hSecondary_T, sBuffer, sizeof(sBuffer));
	if (strlen(sBuffer) > 5)
	{
		Format (g_sSecondary_T[client], sizeof(g_sSecondary_T), sBuffer);
	}
	GetClientCookie(client, g_hSMG_T, sBuffer, sizeof(sBuffer));
	if (strlen(sBuffer) > 5)
	{
		Format (g_sSMG_T[client], sizeof(g_sSMG_T), sBuffer);
	}
	GetClientCookie(client, g_hSniper, sBuffer, sizeof(sBuffer));
	if (sBuffer[0] != '\0')
	{
		g_bSniper[client] = view_as<bool>(StringToInt(sBuffer));
	}
}

public void OnPluginEnd()
{
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsClientInGame(i))
			continue;

		OnClientDisconnect(i);
	}
}

public void OnClientDisconnect(int client)
{
	if (IsFakeClient(client))
		return;

	SetClientCookie(client, g_hPrimary_CT, g_sPrimary_CT[client]);
	SetClientCookie(client, g_hSecondary_CT, g_sSecondary_CT[client]);
	SetClientCookie(client, g_hSMG_CT, g_sSMG_CT[client]);
	SetClientCookie(client, g_hPrimary_T, g_sPrimary_T[client]);
	SetClientCookie(client, g_hSecondary_T, g_sSecondary_T[client]);
	SetClientCookie(client, g_hSMG_T, g_sSMG_T[client]);
	SetClientCookie(client, g_hSniper, g_bSniper[client] ? "1" : "0");
}

public void OnMapEnd()
{
	g_iRounds_Pistol = 0;
	g_iRounds_Force = 0;
}

public Action OnClientSayCommand(int client, const char[] command, const char[] args)
{
	if (!gc_bPlugin.BoolValue)
		return Plugin_Continue;

	static char sCommands[][] = {"weapons", "!weapons", ".weapons", "weapon", ".weapon", "buy", "!buy", ".buy"};

	for (int i = 0; i < sizeof(sCommands); i++)
	{
		if (strcmp(args[0], sCommands[i], false) == 0)
		{
			Menu_Primary(client);

			break;
		}
	}

	return Plugin_Continue;
}

public Action OnPlayerSpawnEvent(Event e, const char[] name, bool dontBroadcast)
{
    int client = GetClientOfUserId(GetEventInt(e, "userid"));
    int team = GetClientTeam(client);
    
    if(IsValidClient(client) && team == 3)
    {
		if(GetEntProp(client, Prop_Send, "m_bHasDefuser"))
		{
        	return Plugin_Handled;
		}
		SetEntProp(client, Prop_Send, "m_bHasDefuser", 1);
    }
    return Plugin_Handled;
}

public void Retakes_OnGunsCommand(int client)
{
	if (!gc_bPlugin.BoolValue)
		return;

	if (!IsValidClient(client))
		return;

	Menu_Primary(client);
}

public Action Command_Weapons(int client, int args)
{
	if (!gc_bPlugin.BoolValue)
		return Plugin_Handled;

	if (!IsValidClient(client))
		return Plugin_Handled;

	Menu_Primary(client);

	return Plugin_Handled;
}

public Action Command_AWP(int client, int args)
{
	if (!gc_bPlugin.BoolValue)
		return Plugin_Handled;

	if (!IsValidClient(client))
		return Plugin_Handled;

	Menu_AWP(client);

	return Plugin_Handled;
}

public void Event_BombPlanted(Event event, const char[] name, bool dontBroadcast)
{
	if(!gc_bBombsite.BoolValue)
		return;

	PrintCenterTextAll("<font face='Arial' size='20'</font>Retake on site:<font face='Arial' color='#66BB6A' size='500'>%s</font>\n\t<font face='Arial' color='#DDBB2A' size='40'><b>         %s</b></font>", g_sBombSite, g_sRoundType);
	//PrintCenterTextAll("<font face='Arial' size='20'</font>Retake on site:<font face='Arial' color='#66BB6A' size='40'> %s</font>\n\t<font face='Arial' color='#DDBB2A' size='40'><b>%s</b></font>", g_sBombSite, g_sRoundType);
}

public void Event_RoundStart(Event event, const char[] name, bool dontBroadcast)
{
	if (!gc_bPlugin.BoolValue || !Retakes_Live())
		return;

	if (gc_iMode.BoolValue)
	{
		if (g_iRounds_Pistol < gc_iPistolRounds.IntValue)
		{
			g_iRounds_Pistol++;

			g_iRoundType = PISTOL_ROUND;
			Format(g_sRoundType, sizeof(g_sRoundType), "%t", "Pistol Round");
		}
		else if (g_iRounds_Force < gc_iForceRounds.IntValue)
		{
			g_iRounds_Force++;

			g_iRoundType = FORCE_ROUND;
			Format(g_sRoundType, sizeof(g_sRoundType), "%t", "Force Buy Round");
		}
		else
		{
			g_iRoundType = FULL_ROUND;
			Format(g_sRoundType, sizeof(g_sRoundType), "%t", "Full Buy Round");
		}

		EquipAllPlayerWeapon();

		return;
	}

	int iRound = GetRandomInt(1, 100);
	if (iRound <= gc_iPistolChance.IntValue)
	{
		g_iRoundType = PISTOL_ROUND;
		Format(g_sRoundType, sizeof(g_sRoundType), "%t", "Pistol Round");

		EquipAllPlayerWeapon();

		return;
	}

	iRound = GetRandomInt(1, 100);
	if (iRound <= gc_iDeagleChance.IntValue)
	{
		g_iRoundType = DEAGLE_ROUND;
		Format(g_sRoundType, sizeof(g_sRoundType), "%t", "Deagle Round");

		EquipAllPlayerWeapon();

		return;
	}

	iRound = GetRandomInt(1, 100);
	if (iRound <= gc_iForceChance.IntValue)
	{
		g_iRoundType = FORCE_ROUND;
		Format(g_sRoundType, sizeof(g_sRoundType), "%t", "Force Buy Round");
	}
	else
	{
		g_iRoundType = FULL_ROUND;
		Format(g_sRoundType, sizeof(g_sRoundType), "%t", "Full Buy Round");
	}

	EquipAllPlayerWeapon();
}

void EquipAllPlayerWeapon()
{
	g_iHEgrenade_CT = 0;
	g_iHEgrenade_T = 0;
	g_iFlashbang_CT = 0;
	g_iFlashbang_T = 0;
	g_iSmokegrenade_CT = 0;
	g_iSmokegrenade_T = 0;
	g_iMolotov_CT = 0;
	g_iMolotov_T = 0;
	g_iAWP_CT = 0;
	g_iAWP_T = 0;
	g_iScout_CT = 0;
	g_iScout_T = 0;

	ShowInfo();

	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i, true, false))
			continue;

		EquipWeapons(i);
	}
}

void ShowInfo()
{
	PrintToServer("[Retake] %t %s", "Round Type", g_sRoundType);
	Retakes_MessageToAll("%t %s", "Now is", g_sRoundType);

	if(!gc_bBombsite.BoolValue)
		return;

	Bombsite site = Retakes_GetCurrrentBombsite();

	if (site == BombsiteA)
	{
		Format(g_sBombSite, sizeof(g_sBombSite), "%t", "A-A-A");
	}
	else if (site == BombsiteB)
	{
		Format(g_sBombSite, sizeof(g_sBombSite), "%t", "B-B-B");
	}

	//CreateTimer (0.7, Timer_ShowInfo);
}

/*public Action Timer_ShowInfo(Handle timer)
{
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i))
			continue;

		PrintHintText(i, "<font face='Arial' size='20'</font>Retake on site:<font face='Arial' color='#66BB6A' size='40'> %s</font>\n\t<font face='Arial' color='#DDBB2A' size='40'><b>%s</b></font>", g_sBombSite, g_sRoundType);
	}
}*/

void Menu_Primary(int client)
{
	char sBuffer[255];
	Menu menu = new Menu(Handler_Primary);

	if (GetClientTeam(client) == CS_TEAM_CT)
	{
		Format(sBuffer, sizeof(sBuffer), "Choose Rifle For CT Rifle Round");
		menu.AddItem("weapon_m4a1", "M4A1");
		menu.AddItem("weapon_m4a1_silencer", "M4A1-S");
		menu.AddItem("weapon_aug", "AUG");
		g_bIsCT[client] = true;
	}
	else if (GetClientTeam(client) == CS_TEAM_T)
	{
		Format(sBuffer, sizeof(sBuffer), "Choose Rifle For T Rifle Round");
		menu.AddItem("weapon_ak47", "AK-47");
		menu.AddItem("weapon_sg556", "SG 553");
		g_bIsCT[client] = false;
	}
	else
	{
		Format(sBuffer, sizeof(sBuffer), "%t", "You need to be in a team");
		Retakes_Message(client, sBuffer);
	}

	menu.SetTitle(sBuffer);
	menu.ExitButton = true;

	menu.Display(client, MENU_TIME_FOREVER);
}

void Menu_Secondary(int client)
{
	char sBuffer[255];
	Menu menu = new Menu(Handler_Secondary);

	if (g_bIsCT[client])
	{
		Format(sBuffer, sizeof(sBuffer), "Choose Pistol For CT Pistol Round");
		menu.AddItem("weapon_usp_silencer", "USP-S");
		menu.AddItem("weapon_hkp2000", "P2000");
		menu.AddItem("weapon_fiveseven", "Five-SeveN");
	}
	else if (!g_bIsCT[client])
	{
		Format(sBuffer, sizeof(sBuffer), "Choose Pistol For T Pistol Round");
		menu.AddItem("weapon_glock", "Glock-18");
		menu.AddItem("weapon_tec9", "Tec-9");

	}

	if (gc_bDeagle.BoolValue)
	{
	menu.AddItem("weapon_deagle", "Desert Eagle");
	}

	if (gc_bRevolver.BoolValue)
	{
		menu.AddItem("weapon_revolver", "Revolver");
	}

	menu.AddItem("weapon_cz75a", "CZ75-Auto");
	menu.AddItem("weapon_p250", "P250");

	menu.SetTitle(sBuffer);
	menu.ExitButton = true;

	menu.Display(client, MENU_TIME_FOREVER);
}

void Menu_SMG(int client)
{
	char sBuffer[255];
	Menu menu = new Menu(Handler_SMG);

	menu.AddItem("weapon_ump45", "UMP-45");
	menu.AddItem("weapon_mp5sd", "MP5-SD");

	if (g_bIsCT[client])
	{
		Format(sBuffer, sizeof(sBuffer), "%t\n", "Choose Guns For CT Force Round");
		menu.AddItem("weapon_famas", "FAMAS");
		menu.AddItem("weapon_mp9", "MP9");
		
	}
	else if (!g_bIsCT[client])
	{
		Format(sBuffer, sizeof(sBuffer), "Choose Guns For T Force Round");
		menu.AddItem("weapon_galilar", "Galil AR");	
		menu.AddItem("weapon_mac10", "Mac-10");
		
	}

	menu.SetTitle(sBuffer);
	menu.ExitButton = true;

	menu.Display(client, MENU_TIME_FOREVER);
}

public void Menu_AWP(int client)
{
	char sBuffer[255];
	Menu menu = new Menu(Handler_AWP);

	Format(sBuffer, sizeof(sBuffer), "%t", "Yes");
	menu.AddItem("1", sBuffer);
	Format(sBuffer, sizeof(sBuffer), "%t", "No");
	menu.AddItem("0", sBuffer);

	Format(sBuffer, sizeof(sBuffer), "%t", "Allow Sniper");

	menu.SetTitle(sBuffer);
	menu.Display(client, MENU_TIME_FOREVER);
}

public int Handler_Primary(Menu menu, MenuAction action, int client, int selection)
{
	if (action == MenuAction_Select)
	{
		char sBuffer[24];

		menu.GetItem(selection, sBuffer, sizeof(sBuffer));

		if (g_bIsCT[client])
		{
			Format (g_sPrimary_CT[client], sizeof(g_sPrimary_CT), sBuffer);
		}
		else if(!g_bIsCT[client])
		{
			Format (g_sPrimary_T[client], sizeof(g_sPrimary_T), sBuffer);
		}

		Menu_Secondary(client);
	}
}

public int Handler_Secondary(Menu menu, MenuAction action, int client, int selection)
{
	if (action == MenuAction_Select)
	{
		char sBuffer[24];

		menu.GetItem(selection, sBuffer, sizeof(sBuffer));

		if (g_bIsCT[client])
		{
			Format (g_sSecondary_CT[client], sizeof(g_sSecondary_CT), sBuffer);
		}
		else if(!g_bIsCT[client])
		{
			Format (g_sSecondary_T[client], sizeof(g_sSecondary_T), sBuffer);
		}

		Menu_SMG(client);
	}
}

public int Handler_SMG(Menu menu, MenuAction action, int client, int selection)
{
	if (action == MenuAction_Select)
	{
		char sBuffer[24];

		menu.GetItem(selection, sBuffer, sizeof(sBuffer));

		if (g_bIsCT[client])
		{
			Format (g_sSMG_CT[client], sizeof(g_sSMG_CT), sBuffer);

			if (gc_iAWP_CT.BoolValue || gc_iScout_CT.BoolValue)
			{
				Menu_AWP(client);
			}
		}
		else if(!g_bIsCT[client])
		{
			Format (g_sSMG_T[client], sizeof(g_sSMG_T), sBuffer);

			if (gc_iAWP_T.BoolValue || gc_iScout_T.BoolValue)
			{
				Menu_AWP(client);
			}
		}
	}
}

public int Handler_AWP(Menu menu, MenuAction action, int client, int selection)
{
	if (action == MenuAction_Select)
	{
		char sBuffer[24];

		menu.GetItem(selection, sBuffer, sizeof(sBuffer));

		if (strcmp(sBuffer, "1") == 0)
		{
			g_bSniper[client] = true;
		}
		else
		{
			g_bSniper[client] = false;
		}

		Retakes_Message(client, "%t", "Weapons next round");
	}
}

void EquipWeapons(int client)
{
	if (!IsValidClient(client, true, false))
		return;

	if (!gc_bPlugin.BoolValue || !Retakes_Live())
		return;

	int iMoney = 0;
	StripPlayerWeapons(client);

	SetEntProp(client, Prop_Send, "m_ArmorValue", 0);
	SetEntProp(client, Prop_Send, "m_bHasHelmet", 0);
	//SetEntProp(client, Prop_Send, "m_bHasDefuser", 0);

	if (g_iRoundType == FULL_ROUND)
	{
		iMoney = gc_iFullMoney.IntValue;

		if (GetClientTeam(client) == CS_TEAM_CT)
		{
			int iRandom = GetRandomInt(1, 3);
			if (iRandom == 1 && g_bSniper[client] && gc_iAWP_MinCT.IntValue <= GetPlayerCount(true, CS_TEAM_CT))
			{
				
				if (g_iAWP_CT < gc_iAWP_CT.IntValue)
				{
					GivePlayerItem(client, "weapon_awp");
					iMoney -= GetWeaponPrice("weapon_awp");
					g_iAWP_CT++;
				}
				else
				{
					GivePlayerItem(client, g_sPrimary_CT[client]);
					iMoney -= GetWeaponPrice(g_sPrimary_CT[client]);
				}
			}
			else
			{
				GivePlayerItem(client, g_sPrimary_CT[client]);
				iMoney -= GetWeaponPrice(g_sPrimary_CT[client]);
			}

			GivePlayerItem(client, g_sSecondary_CT[client]);
			iMoney -= GetWeaponPrice(g_sSecondary_CT[client]);
		}
		else if (GetClientTeam(client) == CS_TEAM_T)
		{
			int iRandom = GetRandomInt(1, 3);
			if (iRandom == 1 && g_bSniper[client] && gc_iAWP_MinT.IntValue <= GetPlayerCount(true, CS_TEAM_T))
			{
				if (g_iAWP_T < gc_iAWP_T.IntValue)
				{
					GivePlayerItem(client, "weapon_awp");
					iMoney -= GetWeaponPrice("weapon_awp");
					g_iAWP_T++;
				}
				else
				{
					GivePlayerItem(client, g_sPrimary_T[client]);
					iMoney -= GetWeaponPrice(g_sPrimary_T[client]);
				}
			}
			else
			{
				GivePlayerItem(client, g_sPrimary_T[client]);
				iMoney -= GetWeaponPrice(g_sPrimary_T[client]);
			}

			GivePlayerItem(client, g_sSecondary_T[client]);
			iMoney -= GetWeaponPrice(g_sSecondary_T[client]);
		}
	}
	else if (g_iRoundType == PISTOL_ROUND)
	{
		iMoney = gc_iPistolMoney.IntValue;

		if (GetClientTeam(client) == CS_TEAM_CT)
		{
			GivePlayerItem(client, g_sSecondary_CT[client]);
			iMoney -= GetWeaponPrice(g_sSecondary_CT[client]);
		}
		else if (GetClientTeam(client) == CS_TEAM_T)
		{
			GivePlayerItem(client, g_sSecondary_T[client]);
			iMoney -= GetWeaponPrice(g_sSecondary_T[client]);
		}
	}
	else if (g_iRoundType == FORCE_ROUND)
	{
		iMoney = gc_iForceMoney.IntValue;

		if (GetClientTeam(client) == CS_TEAM_CT)
		{
			int iRandom = GetRandomInt(1, 3);
			if (iRandom == 1 && g_bSniper[client] && gc_iScout_MinCT.IntValue <= GetPlayerCount(true, CS_TEAM_CT))
			{
				if (g_iScout_CT < gc_iScout_CT.IntValue)
				{
					GivePlayerItem(client, "weapon_ssg08");
					iMoney -= GetWeaponPrice("weapon_ssg08");
					g_iScout_CT++;
				}
				else
				{
					GivePlayerItem(client, g_sSMG_CT[client]);
					iMoney -= GetWeaponPrice(g_sSMG_CT[client]);
				}
			}
			else
			{
				GivePlayerItem(client, g_sSMG_CT[client]);
				iMoney -= GetWeaponPrice(g_sSMG_CT[client]);
			}

			if (StrEqual(g_sSecondary_CT[client], "weapon_hkp2000"))
			{
				GivePlayerItem(client, "weapon_hkp2000");
			}
			else
			{
				GivePlayerItem(client, "weapon_usp_silencer");
			}
		}
		else if (GetClientTeam(client) == CS_TEAM_T)
		{
			int iRandom = GetRandomInt(1, 3);
			if (iRandom == 1 && g_bSniper[client] && gc_iScout_MinT.IntValue <= GetPlayerCount(true, CS_TEAM_T))
			{
				if (g_iScout_T < gc_iScout_T.IntValue)
				{
					GivePlayerItem(client, "weapon_ssg08");
					iMoney -= GetWeaponPrice("weapon_ssg08");
					g_iScout_T++;
				}
				else
				{
					GivePlayerItem(client, g_sSMG_T[client]);
					iMoney -= GetWeaponPrice(g_sSMG_T[client]);
				}
			}
			else
			{
				GivePlayerItem(client, g_sSMG_T[client]);
				iMoney -= GetWeaponPrice(g_sSMG_T[client]);
			}

			GivePlayerItem(client, "weapon_glock");
		}
	}
	else if (g_iRoundType == DEAGLE_ROUND)
	{
		if (GetClientTeam(client) == CS_TEAM_CT)
		{
			GivePlayerItem(client, "weapon_knife");

			/*if (gc_bDefuser.BoolValue)
			{
				SetEntProp(client, Prop_Send, "m_bHasDefuser", 1);
			}*/
		}
		else if (GetClientTeam(client) == CS_TEAM_T)
		{
			GivePlayerItem(client, "weapon_knife_t");
		}

		GivePlayerItem(client, "weapon_deagle");

		if (!gc_bKevlar.BoolValue)
			return;

		SetEntProp(client, Prop_Send, "m_ArmorValue", 100);

		if (!gc_bHelm.BoolValue)
			return;

		SetEntProp(client, Prop_Send, "m_bHasHelmet", 1);

		return;
	}

	int iOrder;
	if (gc_iOrder.IntValue == 0)
	{
		iOrder = GetRandomInt(1, 2);
	}
	else if (gc_iOrder.IntValue == 1)
	{
		iOrder = 1;
	}
	else
	{
		iOrder = 2;
	}

	if (iOrder == 1)
	{
		GiveNades(client, iMoney, iOrder);
	}
	else
	{
		GiveArmorKit(client, iMoney, iOrder);
	}
}

void GiveArmorKit(int client, int money, int order)
{
	if (gc_bKevlar.BoolValue && gc_bHelm.BoolValue && money >= 1000)
	{
		SetEntProp(client, Prop_Send, "m_ArmorValue", 100);
		SetEntProp(client, Prop_Send, "m_bHasHelmet", 1);
		money -= 1000;
	}
	else if (gc_bKevlar.BoolValue && money >= 650)
	{
		SetEntProp(client, Prop_Send, "m_ArmorValue", 100);
		money -= 650;
	}

	/*if (gc_bDefuser.BoolValue && GetClientTeam(client) == CS_TEAM_CT && (money >= 400))
	{
		SetEntProp(client, Prop_Send, "m_bHasDefuser", 1);
		money -= 400;
	}*/

	if (order == 2)
	{
		GiveNades(client, money, order);
	}
}

void GiveNades(int client, int money, int order)
{
	int iRandom = GetRandomInt(1, 4);

	if (GetClientTeam(client) == CS_TEAM_T)
	{
		GivePlayerItem(client, "weapon_knife_t");

		if (iRandom == 1)
		{
			if (g_iMolotov_T < gc_iMolotov_T.IntValue && money >= 400)
			{
				GivePlayerItem(client, "weapon_molotov");
				money -= 400;
				g_iMolotov_T++;
			}
			else
			{
				iRandom = GetRandomInt(2, 4);
			}
		}
		else if (iRandom == 2)
		{
			if (g_iSmokegrenade_T < gc_iSmoke_T.IntValue && money >= 300)
			{
				GivePlayerItem(client, "weapon_smokegrenade");
				money -= 300;
				g_iSmokegrenade_T++;
			}
			else
			{
				iRandom = GetRandomInt(3, 4);
			}
		}
		else if (iRandom == 3)
		{
			if (g_iHEgrenade_T < gc_iHEgrenade_T.IntValue && money >= 300)
			{
				GivePlayerItem(client, "weapon_hegrenade");
				money -= 300;
				g_iHEgrenade_T++;
			}
			else
			{
				iRandom = 4;
			}
		}
		else if (iRandom == 4)
		{
			if (g_iFlashbang_T < gc_iFlash_T.IntValue && money >= 200)
			{
				GivePlayerItem(client, "weapon_flashbang");
				money -= 200;
				g_iFlashbang_T++;
			}
		}
	}
	else if (GetClientTeam(client) == CS_TEAM_CT)
	{
		GivePlayerItem(client, "weapon_knife");
		
		if (iRandom == 1)
		{
			if (g_iMolotov_CT < gc_iMolotov_CT.IntValue && money >= 600)
			{
				GivePlayerItem(client, "weapon_incgrenade");
				money -= 400;
				g_iMolotov_CT++;
			}
			else
			{
				iRandom = GetRandomInt(2, 4);
			}
		}
		else if (iRandom == 2)
		{
			if (g_iSmokegrenade_CT < gc_iSmoke_CT.IntValue && money >= 300)
			{
				GivePlayerItem(client, "weapon_smokegrenade");
				money -= 300;
				g_iSmokegrenade_CT++;
			}
			else
			{
				iRandom = GetRandomInt(3, 4);
			}
		}
		else if (iRandom == 3)
		{
			if (g_iHEgrenade_CT < gc_iHEgrenade_CT.IntValue && money >= 300)
			{
				GivePlayerItem(client, "weapon_hegrenade");
				money -= 300;
				g_iHEgrenade_CT++;
			}
			else
			{
				iRandom = 4;
			}
		}
		else if (iRandom == 4)
		{
			if (g_iFlashbang_CT < gc_iFlash_CT.IntValue && money >= 200)
			{
				GivePlayerItem(client, "weapon_flashbang");
				money -= 200;
				g_iFlashbang_CT++;
			}
		}
	}

	if (order == 1)
	{
		GiveArmorKit(client, money, order);
	}
}

void StripPlayerWeapons(int client)
{
	int iWeapon;
	for (int i = 0; i <= 3; i++)
	{
		if ((iWeapon = GetPlayerWeaponSlot(client, i)) != -1)
		{
			RemovePlayerItem(client, iWeapon);
			AcceptEntityInput(iWeapon, "Kill");
		}
	}
	if ((iWeapon = GetPlayerWeaponSlot(client, CS_SLOT_GRENADE)) != -1)
	{
		RemovePlayerItem(client, iWeapon);
		AcceptEntityInput(iWeapon, "Kill");
	}
}

bool IsValidClient(int client, bool bots = true, bool dead = true)
{
	if (client <= 0)
		return false;

	if (client > MaxClients)
		return false;

	if (!IsClientInGame(client))
		return false;

	if (IsFakeClient(client) && !bots)
		return false;

	if (IsClientSourceTV(client))
		return false;

	if (IsClientReplay(client))
		return false;

	if (!IsPlayerAlive(client) && !dead)
		return false;

	return true;
}

int GetPlayerCount(bool alive = false, int team = -1)
{
	int i, iCount = 0;

	for (i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i,_, !alive))
			continue;

		if (team != -1 && GetClientTeam(i) != team)
			continue;

		iCount++;
	}

	return iCount;
}

void DisablePlugin(char[] plugin)
{
	char sPath[64];
	BuildPath(Path_SM, sPath, sizeof(sPath), "plugins/%s.smx", plugin);
	if (FileExists(sPath))
	{
		char sNewPath[64];
		BuildPath(Path_SM, sNewPath, sizeof(sNewPath), "plugins/disabled/%s.smx", plugin);

		ServerCommand("sm plugins unload %s", plugin);

		if (FileExists(sNewPath))
		{
			DeleteFile(sNewPath);
		}
		RenameFile(sNewPath, sPath);

		LogMessage("%s was unloaded and moved to %s to avoid conflicts", sPath, sNewPath);
	}
}

int GetWeaponPrice(char[] weapon)
{
	if (StrEqual(weapon, "weapon_m4a1"))
		return 3100;

	else if (StrEqual(weapon, "weapon_m4a1_silencer"))
		return 3100;

	else if (StrEqual(weapon, "weapon_famas"))
		return 2250;

	else if (StrEqual(weapon, "weapon_aug"))
		return 3300;

	else if (StrEqual(weapon, "weapon_galilar"))
		return 2000;

	else if (StrEqual(weapon, "weapon_ak47"))
		return 2700;

	else if (StrEqual(weapon, "weapon_sg556"))
		return 3000;

	else if (StrEqual(weapon, "weapon_awp"))
		return 4750;

	else if (StrEqual(weapon, "weapon_ssg08"))
		return 1700;

	else if (StrEqual(weapon, "weapon_bizon"))
		return 1400;

	else if (StrEqual(weapon, "weapon_p90"))
		return 2350;

	else if (StrEqual(weapon, "weapon_ump45"))
		return 1200;

	else if (StrEqual(weapon, "weapon_mp7"))
		return 1700;

	else if (StrEqual(weapon, "weapon_mp5sd"))
		return 1500;
		
	else if (StrEqual(weapon, "weapon_mp9"))
		return 1250;

	else if (StrEqual(weapon, "weapon_mac10"))
		return 1050;

	else if (StrEqual(weapon, "weapon_deagle"))
		return 700;

	else if (StrEqual(weapon, "weapon_revolver"))
		return 700;

	else if (StrEqual(weapon, "weapon_cz75a"))
		return 500;

	else if (StrEqual(weapon, "weapon_p250"))
		return 300;

	else if (StrEqual(weapon, "weapon_tec9"))
		return 500;

	else if (StrEqual(weapon, "weapon_glock"))
		return 0;

	else if (StrEqual(weapon, "weapon_usp_silencer"))
		return 0;

	else if (StrEqual(weapon, "weapon_hkp2000"))
		return 0;

	else if (StrEqual(weapon, "weapon_fiveseven"))
		return 500;

	else if (StrEqual(weapon, "weapon_sawedoff"))
		return 1200;

	else if (StrEqual(weapon, "weapon_mag7"))
		return 1800;

	else if (StrEqual(weapon, "weapon_elite"))
		return 500;

	else if (StrEqual(weapon, "weapon_hegrenade"))
		return 300;

	else if (StrEqual(weapon, "weapon_flashbang"))
		return 200;

	else if (StrEqual(weapon, "weapon_smokegrenade"))
		return 300;

	else if (StrEqual(weapon, "weapon_molotov"))
		return 400;

	else if (StrEqual(weapon, "weapon_incgrenade"))
		return 650;

	return 0;
}