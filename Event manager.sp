#define PLUGIN_AUTHOR "Di3Z1E"
#define PLUGIN_VERSION "0.00"
#define PREFIX " \x10 [המחתרת]\x01"
#define MENU_PREFIX "Event Manager"
#define Vote_Event "Would you like to start an Event?"

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
	//HookEvent("round_end");
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
	menu.AddItem("1", "טנוויא רובע העבצה לחתה!");
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
	//menu.AddItem("2", "דנוארה ףוסב העבצה לחתה");
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
	menu.AddItem("1", "Tools");
	menu.AddItem("2", "Drug: CT/TT/ALL");
	menu.AddItem("3", "Godmode: CT/TT/ALL/Player");
	menu.AddItem("4", "Noclip: CT/TT/ALL/Player");
	menu.AddItem("5", "Set HP: CT/TT/ALL/Player");
	
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
			
		if (StrEqual(Item, "1"))
			Tools(client);
		
		if (StrEqual(Item, "2"))
			Drugs(client);
		
		if (StrEqual(Item, "3"))
			God(client);
		
		if (StrEqual(Item, "4"))
			NoClip(client);
		
		if (StrEqual(Item, "5"))
			SetHP(client);
		
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
		new String:Item[32];
		GetMenuItem(classhandle, Position, Item, sizeof(Item));
		
		if (StrEqual(Item, "1"))
			ServerCommand("sm_god @ct 1");
		
		if (StrEqual(Item, "2"))
			ServerCommand("sm_god @t 1");
		
		if (StrEqual(Item, "3"))
			ServerCommand("sm_god @all 1");
		
	}
	else if (action == MenuAction_End)
		CloseHandle(classhandle);
}

///////////////////////////NO-CLIP////////////////////////////

public Action NoClip(int client)
{
	Menu menu = new Menu(God_Handler);
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
		new String:Item[32];
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
		new String:Item[32];
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
		new String:Item[32];
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