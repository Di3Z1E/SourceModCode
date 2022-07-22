#define PLUGIN_AUTHOR "Di3Z1E"
#define PLUGIN_VERSION "0.00"
#define PREFIX " \x10 [המחתרת]\x01"
#define MENU_PREFIX "Event Manager"
#define Vote_Event "Start_Event"

#include <sourcemod>
#include <sdktools>
#include <colors_csgo>
#include <sdkhooks>

public Plugin myinfo = 
{
	name = "Event Manager", 
	author = PLUGIN_AUTHOR, 
	description = "Mange the events by the admins", 
	version = PLUGIN_VERSION, 
	url = "https://steamcommunity.com/id/Di3Z1E/"
};

public void OnPluginStart()
{
	RegAdminCmd("sm_event", Manger_Menu, ADMFLAG_ROOT, "Menu for the event manger");
}

public Action Manger_Menu(int client, int args)
{
	Event_Manger_Menu(client);
	return Plugin_Handled;
}

public Action Event_Manger_Menu(int client)
{
	Menu menu = new Menu(Event_Manger_Menu_Handler);
	menu.SetTitle("ישאר טירפת :: %s\n \n ", MENU_PREFIX);
	menu.AddItem("1", "העבצה תורשפא");
	menu.AddItem("2", "םילכ");
	
	menu.ExitButton = true;
	menu.Display(client, 0);
	
	return Plugin_Handled;
}

public Event_Manger_Menu_Handler(Handle classhandle, MenuAction action, int client, int Position)
{
	if (action == MenuAction_Select)
	{
		new String:Item[32];
		GetMenuItem(classhandle, Position, Item, sizeof(Item));
		
		if (StrEqual(Item, "1"))
			RunVoteForEvent(client);
		
		if (StrEqual(Item, "2"))
			Tools(client);
		
	}
	else if (action == MenuAction_End)
		CloseHandle(classhandle);
}

public Action RunVoteForEvent(int client)
{
	Menu menu = new Menu(RunVoteForEvent_Handler);
	menu.SetTitle("טנוויא רובע העבצה לחתה :: %s\n \n ", MENU_PREFIX);
	menu.AddItem("1", "וישכע העבצה לחתה");
	menu.AddItem("2", "העבצה לטב");
	
	menu.Display(client, 0);
	menu.ExitBackButton = true;
	menu.ExitButton = true;
	return Plugin_Handled;
}

public RunVoteForEvent_Handler(Handle classhandle, MenuAction action, int client, int Position)
{
	if (action == MenuAction_Select)
	{
		new String:Item[32];
		GetMenuItem(classhandle, Position, Item, sizeof(Item));
		
		if (StrEqual(Item, "1"))
			ServerCommand("sm_vote %s", Vote_Event);
		
		if (StrEqual(Item, "2"))
			ServerCommand("sm_cancelvote");
		
	}
	else if (action == MenuAction_End)
		CloseHandle(classhandle);
}

public Action Tools(int client)
{
	Menu menu = new Menu(Tools_Handler);
	menu.SetTitle("םילכ :: %s\n \n ", MENU_PREFIX);
	menu.AddItem("1", "Freeze: CT/TT/ALL");
	menu.AddItem("2", "Drug: CT/TT/ALL");
	menu.AddItem("3", "Godmode: CT/TT/ALL");
	menu.AddItem("4", "Noclip: CT/TT/ALL");
	menu.AddItem("5", "Set HP: CT/TT/ALL");
	menu.AddItem("6", "Blind: CT/TT/ALL");
	menu.AddItem("7", "Respawn: CT/TT/ALL");
	menu.AddItem("8", "Disarm: CT/TT/ALL");
	menu.AddItem("9", "Speed: CT/TT/ALL");
	
	menu.Display(client, 0);
	menu.ExitBackButton = true;
	menu.ExitButton = true;
	return Plugin_Handled;
}

public Tools_Handler(Handle classhandle, MenuAction action, int client, int Position)
{
	if (action == MenuAction_Select)
	{
		new String:Item[32];
		GetMenuItem(classhandle, Position, Item, sizeof(Item));
			
		if (StrEqual(Item, "1"))
			Freeze(client);
		
		if (StrEqual(Item, "2"))
			Drugs(client);
		
		if (StrEqual(Item, "3"))
			God(client);
		
		if (StrEqual(Item, "4"))
			NoClip(client);
		
		if (StrEqual(Item, "5"))
			SetHP(client);
			
		if (StrEqual(Item, "6"))
			Blind(client);
			
		if (StrEqual(Item, "7"))
			Respawn(client);
			
		if (StrEqual(Item, "8"))
			Disarm(client);
			
		if (StrEqual(Item, "9"))
			Speed(client);
		
	}
	else if (action == MenuAction_End)
		CloseHandle(classhandle);
}

///////////////////////////Freeze////////////////////////////

public Action Freeze(int client)
{
	Menu menu = new Menu(Freeze_Handler);
	menu.SetTitle("Freeze :: %s\n \n ", MENU_PREFIX);
	menu.AddItem("1", "CT");
	menu.AddItem("2", "TT");
	menu.AddItem("3", "All");
	
	menu.Display(client, 0);
	menu.ExitBackButton = true;
	menu.ExitButton = true;
	return Plugin_Handled;
}

public Freeze_Handler(Handle classhandle, MenuAction action, int client, int Position)
{
	if (action == MenuAction_Select)
	{
		new String:Item[32];
		GetMenuItem(classhandle, Position, Item, sizeof(Item));
		
		if (StrEqual(Item, "1"))
			ServerCommand("sm_freeze @ct 90");
		
		if (StrEqual(Item, "2"))
			ServerCommand("sm_freeze @t 90");
		
		if (StrEqual(Item, "3"))
			ServerCommand("sm_freeze @all 90");
		
	}
	else if (action == MenuAction_End)
		CloseHandle(classhandle);
}

///////////////////////////DRUGS////////////////////////////

public Action Drugs(int client)
{
	Menu menu = new Menu(Drugs_Handler);
	menu.SetTitle("Drug :: %s\n \n ", MENU_PREFIX);
	menu.AddItem("1", "CT");
	menu.AddItem("2", "TT");
	menu.AddItem("3", "All");
	
	menu.Display(client, 0);
	menu.ExitBackButton = true;
	menu.ExitButton = true;
	return Plugin_Handled;
}

public Drugs_Handler(Handle classhandle, MenuAction action, int client, int Position)
{
	if (action == MenuAction_Select)
	{
		new String:Item[32];
		GetMenuItem(classhandle, Position, Item, sizeof(Item));
		
		if (StrEqual(Item, "1"))
			ServerCommand("sm_drug @ct");
		
		if (StrEqual(Item, "2"))
			ServerCommand("sm_drug @t");
		
		if (StrEqual(Item, "3"))
			ServerCommand("sm_drug @all");
		
	}
	else if (action == MenuAction_End)
		CloseHandle(classhandle);
}

///////////////////////////GOD////////////////////////////

public Action God(int client)
{
	Menu menu = new Menu(God_Handler);
	menu.SetTitle("Godemode :: %s\n \n ", MENU_PREFIX);
	menu.AddItem("1", "CT");
	menu.AddItem("2", "TT");
	menu.AddItem("3", "All");
	
	menu.Display(client, 0);
	menu.ExitBackButton = true;
	menu.ExitButton = true;
	return Plugin_Handled;
}

public God_Handler(Handle classhandle, MenuAction action, int client, int Position)
{
	if (action == MenuAction_Select)
	{
		new String:Item[64];
		GetMenuItem(classhandle, Position, Item, sizeof(Item));
		
		if (StrEqual(Item, "1"))
			ServerCommand("sm_god @ct 1");
		
		if (StrEqual(Item, "2"))
			ServerCommand("sm_god @t 1");
		
		if (StrEqual(Item, "3"))
			{
			PrintToChatAll("test");
			ServerCommand("sm_god @all 1");
			}
		
			
		
	}
	else if (action == MenuAction_End)
		CloseHandle(classhandle);
}

///////////////////////////NO-CLIP////////////////////////////

public Action NoClip(int client)
{
	Menu menu = new Menu(NoClip_Handler);
	menu.SetTitle("No Clip :: %s\n \n ", MENU_PREFIX);
	menu.AddItem("1", "CT");
	menu.AddItem("2", "TT");
	menu.AddItem("3", "All");
	
	menu.Display(client, 0);
	menu.ExitBackButton = true;
	menu.ExitButton = true;
	return Plugin_Handled;
}

public NoClip_Handler(Handle classhandle, MenuAction action, int client, int Position)
{
	if (action == MenuAction_Select)
	{
		new String:Item[32];
		GetMenuItem(classhandle, Position, Item, sizeof(Item));
		
		if (StrEqual(Item, "1"))
			ServerCommand("sm_noclip @ct 1");
		
		if (StrEqual(Item, "2"))
			ServerCommand("sm_noclip @t 1");
		
		if (StrEqual(Item, "3"))
			ServerCommand("sm_noclip @all 1");
		
	}
	else if (action == MenuAction_End)
		CloseHandle(classhandle);
}

///////////////////////////SET-HP////////////////////////////

public Action SetHP(int client)
{
	Menu menu = new Menu(SetHP_Handler);
	menu.SetTitle("Set HP For :: %s\n \n ", MENU_PREFIX);
	menu.AddItem("1", "CT");
	menu.AddItem("2", "TT");
	menu.AddItem("3", "All");
	
	menu.Display(client, 0);
	menu.ExitBackButton = true;
	menu.ExitButton = true;
	return Plugin_Handled;
}

public SetHP_Handler(Handle classhandle, MenuAction action, int client, int Position)
{
	if (action == MenuAction_Select)
	{
		new String:Item[64];
		GetMenuItem(classhandle, Position, Item, sizeof(Item));
		
		if (StrEqual(Item, "1"))
			SetHPCT(client);
		
		if (StrEqual(Item, "2"))
			SetHPTT(client);
		
		if (StrEqual(Item, "3"))
			SetHPAll(client);
		
	}
	else if (action == MenuAction_End)
		CloseHandle(classhandle);
}

///////////////////////////SET-HP-CT////////////////////////////
public Action SetHPCT(int client)
{
	Menu menu = new Menu(SetHPCT_Handler);
	menu.SetTitle("Set HP For CT :: %s\n \n ", MENU_PREFIX);
	menu.AddItem("1", "100");
	menu.AddItem("2", "50");
	menu.AddItem("3", "1");
	
	menu.Display(client, 0);
	menu.ExitBackButton = true;
	menu.ExitButton = true;
	return Plugin_Handled;
}

public SetHPCT_Handler(Handle classhandle, MenuAction action, int client, int Position)
{
	if (action == MenuAction_Select)
	{
		new String:Item[64];
		GetMenuItem(classhandle, Position, Item, sizeof(Item));
		
		if (StrEqual(Item, "1"))
			ServerCommand("sm_hp @ct 100");
		
		if (StrEqual(Item, "2"))
			ServerCommand("sm_hp @ct 50");
		
		if (StrEqual(Item, "3"))
			ServerCommand("sm_hp @ct 1");
		
	}
	else if (action == MenuAction_End)
		CloseHandle(classhandle);
}




///////////////////////////SET-HP-TT////////////////////////////
public Action SetHPTT(int client)
{
	Menu menu = new Menu(SetHPTT_Handler);
	menu.SetTitle("Set HP For Terror :: %s\n \n ", MENU_PREFIX);
	menu.AddItem("1", "100");
	menu.AddItem("2", "50");
	menu.AddItem("3", "1");
	
	menu.Display(client, 0);
	menu.ExitBackButton = true;
	menu.ExitButton = true;
	return Plugin_Handled;
}

public SetHPTT_Handler(Handle classhandle, MenuAction action, int client, int Position)
{
	if (action == MenuAction_Select)
	{
		new String:Item[64];
		GetMenuItem(classhandle, Position, Item, sizeof(Item));
		
		if (StrEqual(Item, "1"))
			ServerCommand("sm_hp @t 100");
		
		if (StrEqual(Item, "2"))
			ServerCommand("sm_hp @t 50");
		
		if (StrEqual(Item, "3"))
			ServerCommand("sm_hp @t 1");
		
	}
	else if (action == MenuAction_End)
		CloseHandle(classhandle);
}

///////////////////////////SET-HP-ALL////////////////////////////
public Action SetHPAll(int client)
{
	Menu menu = new Menu(SetHPAll_Handler);
	menu.SetTitle("Set HP For Everyone :: %s\n \n ", MENU_PREFIX);
	menu.AddItem("1", "100");
	menu.AddItem("2", "50");
	menu.AddItem("3", "1");
	
	menu.Display(client, 0);
	menu.ExitBackButton = true;
	menu.ExitButton = true;
	return Plugin_Handled;
}

public SetHPAll_Handler(Handle classhandle, MenuAction action, int client, int Position)
{
	if (action == MenuAction_Select)
	{
		new String:Item[32];
		GetMenuItem(classhandle, Position, Item, sizeof(Item));
		
		if (StrEqual(Item, "1"))
			ServerCommand("sm_hp @all 100");
		
		if (StrEqual(Item, "2"))
			ServerCommand("sm_hp @all 50");
		
		if (StrEqual(Item, "3"))
			ServerCommand("sm_hp @all 1");
		
	}
	else if (action == MenuAction_End)
		CloseHandle(classhandle);
} 

///////////////////////////Blind////////////////////////////

public Action Blind(int client)
{
	Menu menu = new Menu(Blind_Handler);
	menu.SetTitle("Blind :: %s\n \n ", MENU_PREFIX);
	menu.AddItem("1", "Full Blind");
	menu.AddItem("2", "Half Blind");
	menu.AddItem("3", "Remove Blind");
	
	menu.Display(client, 0);
	menu.ExitBackButton = true;
	menu.ExitButton = true;
	return Plugin_Handled;
}

public Blind_Handler(Handle classhandle, MenuAction action, int client, int Position)
{
	if (action == MenuAction_Select)
	{
		new String:Item[32];
		GetMenuItem(classhandle, Position, Item, sizeof(Item));
		
		if (StrEqual(Item, "1"))
			BlindFull(client);
		
		if (StrEqual(Item, "2"))
			BlindHalf(client);
		
		if (StrEqual(Item, "3"))
			BlindRemove(client);
		
	}
	else if (action == MenuAction_End)
		CloseHandle(classhandle);
}

public Action BlindFull(int client)
{
	Menu menu = new Menu(BlindFull_Handler);
	menu.SetTitle("Full Blind :: %s\n \n ", MENU_PREFIX);
	menu.AddItem("1", "CT");
	menu.AddItem("2", "TT");
	menu.AddItem("3", "ALL");
	
	menu.Display(client, 0);
	menu.ExitBackButton = true;
	menu.ExitButton = true;
	return Plugin_Handled;
}

public BlindFull_Handler(Handle classhandle, MenuAction action, int client, int Position)
{
	if (action == MenuAction_Select)
	{
		new String:Item[32];
		GetMenuItem(classhandle, Position, Item, sizeof(Item));
		
		if (StrEqual(Item, "1"))
			ServerCommand("sm_blind @ct 500");
		
		if (StrEqual(Item, "2"))
			ServerCommand("sm_blind @t 500");
		
		if (StrEqual(Item, "3"))
			ServerCommand("sm_blind @all 500");
		
	}
	else if (action == MenuAction_End)
		CloseHandle(classhandle);
} 

public Action BlindHalf(int client)
{
	Menu menu = new Menu(BlindHalf_Handler);
	menu.SetTitle("Half Blind :: %s\n \n ", MENU_PREFIX);
	menu.AddItem("1", "CT");
	menu.AddItem("2", "TT");
	menu.AddItem("3", "ALL");
	
	menu.Display(client, 0);
	menu.ExitBackButton = true;
	menu.ExitButton = true;
	return Plugin_Handled;
}

public BlindHalf_Handler(Handle classhandle, MenuAction action, int client, int Position)
{
	if (action == MenuAction_Select)
	{
		new String:Item[32];
		GetMenuItem(classhandle, Position, Item, sizeof(Item));
		
		if (StrEqual(Item, "1"))
			ServerCommand("sm_blind @ct 250");
		
		if (StrEqual(Item, "2"))
			ServerCommand("sm_blind @t 250");
		
		if (StrEqual(Item, "3"))
			ServerCommand("sm_blind @all 250");
		
	}
	else if (action == MenuAction_End)
		CloseHandle(classhandle);
} 

public Action BlindRemove(int client)
{
	Menu menu = new Menu(BlindRemove_Handler);
	menu.SetTitle("Remove Blind :: %s\n \n ", MENU_PREFIX);
	menu.AddItem("1", "CT");
	menu.AddItem("2", "TT");
	menu.AddItem("3", "ALL");
	
	menu.Display(client, 0);
	menu.ExitBackButton = true;
	menu.ExitButton = true;
	return Plugin_Handled;
}

public BlindRemove_Handler(Handle classhandle, MenuAction action, int client, int Position)
{
	if (action == MenuAction_Select)
	{
		new String:Item[32];
		GetMenuItem(classhandle, Position, Item, sizeof(Item));
		
		if (StrEqual(Item, "1"))
			ServerCommand("sm_blind @ct 0");
		
		if (StrEqual(Item, "2"))
			ServerCommand("sm_blind @t 0");
		
		if (StrEqual(Item, "3"))
			ServerCommand("sm_blind @all 0");
		
	}
	else if (action == MenuAction_End)
		CloseHandle(classhandle);
} 

///////////////////////////Respawn////////////////////////////

public Action Respawn(int client)
{
	Menu menu = new Menu(Respawn_Handler);
	menu.SetTitle("Respawn :: %s\n \n ", MENU_PREFIX);
	menu.AddItem("1", "CT");
	menu.AddItem("2", "TT");
	menu.AddItem("3", "All");
	
	menu.Display(client, 0);
	menu.ExitBackButton = true;
	menu.ExitButton = true;
	return Plugin_Handled;
}

public Respawn_Handler(Handle classhandle, MenuAction action, int client, int Position)
{
	if (action == MenuAction_Select)
	{
		new String:Item[64];
		GetMenuItem(classhandle, Position, Item, sizeof(Item));
		
		if (StrEqual(Item, "1"))
			ServerCommand("sm_respawn @ct");
		
		if (StrEqual(Item, "2"))
			ServerCommand("sm_respawn @t");
		
		if (StrEqual(Item, "3"))
			ServerCommand("sm_respawn @all");
		
	}
	else if (action == MenuAction_End)
		CloseHandle(classhandle);
}

///////////////////////////Disarm////////////////////////////

public Action Disarm(int client)
{
	Menu menu = new Menu(Disarm_Handler);
	menu.SetTitle("Disarm :: %s\n \n ", MENU_PREFIX);
	menu.AddItem("1", "CT");
	menu.AddItem("2", "TT");
	menu.AddItem("3", "All");
	
	menu.Display(client, 0);
	menu.ExitBackButton = true;
	menu.ExitButton = true;
	return Plugin_Handled;
}

public Disarm_Handler(Handle classhandle, MenuAction action, int client, int Position)
{
	if (action == MenuAction_Select)
	{
		new String:Item[32];
		GetMenuItem(classhandle, Position, Item, sizeof(Item));
		
		if (StrEqual(Item, "1"))
			ServerCommand("sm_disarm @ct");
		
		if (StrEqual(Item, "2"))
			ServerCommand("sm_disarm @t");
		
		if (StrEqual(Item, "3"))
			ServerCommand("sm_disarm @all");
		
	}
	else if (action == MenuAction_End)
		CloseHandle(classhandle);
}

///////////////////////////Speed////////////////////////////

public Action Speed(int client)
{
	Menu menu = new Menu(Speed_Handler);
	menu.SetTitle("Speed :: %s\n \n ", MENU_PREFIX);
	menu.AddItem("1", "Fast");
	menu.AddItem("2", "Normal");
	menu.AddItem("3", "Slow");
	
	menu.Display(client, 0);
	menu.ExitBackButton = true;
	menu.ExitButton = true;
	return Plugin_Handled;
}

public Speed_Handler(Handle classhandle, MenuAction action, int client, int Position)
{
	if (action == MenuAction_Select)
	{
		new String:Item[32];
		GetMenuItem(classhandle, Position, Item, sizeof(Item));
		
		if (StrEqual(Item, "1"))
			SpeedFast(client);
		
		if (StrEqual(Item, "2"))
			SpeedNormal(client);
		
		if (StrEqual(Item, "3"))
			SpeedSlow(client);
		
	}
	else if (action == MenuAction_End)
		CloseHandle(classhandle);
}

//////////////////////////////// Fast

public Action SpeedFast(int client)
{
	Menu menu = new Menu(SpeedFast_Handler);
	menu.SetTitle("Fast Speed For :: %s\n \n ", MENU_PREFIX);
	menu.AddItem("1", "CT");
	menu.AddItem("2", "TT");
	menu.AddItem("3", "ALL");
	
	menu.Display(client, 0);
	menu.ExitBackButton = true;
	menu.ExitButton = true;
	return Plugin_Handled;
}

public SpeedFast_Handler(Handle classhandle, MenuAction action, int client, int Position)
{
	if (action == MenuAction_Select)
	{
		new String:Item[32];
		GetMenuItem(classhandle, Position, Item, sizeof(Item));
		
		if (StrEqual(Item, "1"))
			ServerCommand("sm_speed @ct 1.5");
		
		if (StrEqual(Item, "2"))
			ServerCommand("sm_speed @t 1.5");
		
		if (StrEqual(Item, "3"))
			ServerCommand("sm_speed @all 1.5");
		
	}
	else if (action == MenuAction_End)
		CloseHandle(classhandle);
} 

//////////////////////////////// Normal

public Action SpeedNormal(int client)
{
	Menu menu = new Menu(SpeedNormal_Handler);
	menu.SetTitle("Half Blind :: %s\n \n ", MENU_PREFIX);
	menu.AddItem("1", "CT");
	menu.AddItem("2", "TT");
	menu.AddItem("3", "ALL");
	
	menu.Display(client, 0);
	menu.ExitBackButton = true;
	menu.ExitButton = true;
	return Plugin_Handled;
}

public SpeedNormal_Handler(Handle classhandle, MenuAction action, int client, int Position)
{
	if (action == MenuAction_Select)
	{
		new String:Item[32];
		GetMenuItem(classhandle, Position, Item, sizeof(Item));
		
		if (StrEqual(Item, "1"))
			ServerCommand("sm_speed @ct 1");
		
		if (StrEqual(Item, "2"))
			ServerCommand("sm_speed @t 1");
		
		if (StrEqual(Item, "3"))
			ServerCommand("sm_speed @all 1");
		
	}
	else if (action == MenuAction_End)
		CloseHandle(classhandle);
} 

/////////////////////////////// Slow

public Action SpeedSlow(int client)
{
	Menu menu = new Menu(SpeedSlow_Handler);
	menu.SetTitle("Remove Blind :: %s\n \n ", MENU_PREFIX);
	menu.AddItem("1", "CT");
	menu.AddItem("2", "TT");
	menu.AddItem("3", "ALL");
	
	menu.Display(client, 0);
	menu.ExitBackButton = true;
	menu.ExitButton = true;
	return Plugin_Handled;
}

public SpeedSlow_Handler(Handle classhandle, MenuAction action, int client, int Position)
{
	if (action == MenuAction_Select)
	{
		new String:Item[32];
		GetMenuItem(classhandle, Position, Item, sizeof(Item));
		
		if (StrEqual(Item, "1"))
			ServerCommand("sm_speed @ct 0.5");
		
		if (StrEqual(Item, "2"))
			ServerCommand("sm_speed @t 0.5");
		
		if (StrEqual(Item, "3"))
			ServerCommand("sm_speed @all 0.5");
		
	}
	else if (action == MenuAction_End)
		CloseHandle(classhandle);
} 