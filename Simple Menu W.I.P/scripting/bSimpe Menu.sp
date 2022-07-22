#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "Di3Z1E"
#define PLUGIN_VERSION "1.00"

#include <sourcemod>

EngineVersion g_Game;

public Plugin myinfo = 
{
	name = "Simple Menu",
	author = PLUGIN_AUTHOR,
	description = "Simple Menu to edit",
	version = PLUGIN_VERSION,
	url = ""
};

public void OnClientPutInServer()
{
	new Handle:menuhandle == CreateMenu(MenuCallBack);
	SetMenuTitle(menuhandle, "Text-Menu-Title");
	AddMenuItem(menuhandle, "Text1", "Text2");
	SetMenuPagination(menuhandle, 6);
	SetMenuExitBackButton(menuhandle, true);
	DisplayMenu(menuhandle, client, 250);
}

public void MenuCallBack(Handle:menuhandle, MenuAction, client, postioin)
{
	if(action == MenuAction_Select)
{
	decl String:Item[20];
	GetMenuItem(menuhandle, Postioin, Item, sizeof(Item);
			
	if(StrEqual(Item, "Text3"))
}else{ 
	if(action == MenuAction_End)
		{
			CloseHandle(menuhandle);
		}
}