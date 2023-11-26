#include <sourcemod>
#include <sdktools>
#include <multicolors>
#include <geoip>

#pragma semicolon 1
#pragma newdecls required

#define PLUGIN_VERSION "1.0.1"

public Plugin myinfo = 
{
	name = "Get Info",
	author = "Nathy",
	description = "Get full info about a player",
	version = PLUGIN_VERSION,
	url = "https://steamcommunity.com/id/nathyzinhaa"
};

public void OnPluginStart()
{
	LoadTranslations("common.phrases");
	RegAdminCmd("sm_getinfo", Command_GetInfo, ADMFLAG_GENERIC, "sm_getinfo <#userid|name>");
}

public Action Command_GetInfo(int client, int args)
{
    if (args < 1)
    {
        ReplyToCommand(client, "[SM] Usage: sm_getinfo <#userid|name>");
        return Plugin_Handled;
    }
    
    char arg[32];     
    GetCmdArg(1, arg, sizeof(arg));
   
    int target = FindTarget(client, arg);


    
    if(target == -1)
    {
    	return Plugin_Handled;
    }
    else
    {
    	char ip[32];
    	char url[256];
    	char country[32];
    	char city[32];
    	char steam32[32];
    
    	float packets;
    	float choke;
    	float ping;
    	float loss;
    	
    	packets = GetClientAvgPackets(target, NetFlow_Both);
    	loss = GetClientAvgLoss(target, NetFlow_Both);
    	choke = GetClientAvgChoke(target, NetFlow_Both);
    	ping = GetClientAvgLatency(target, NetFlow_Both);
    	ping = ping * 1000.0;
    
    	GetClientIP(target, ip, sizeof(ip));
    	GetClientAuthId(target, AuthId_SteamID64, url, sizeof(url));
    	GetClientAuthId(target, AuthId_Steam2, steam32, sizeof(steam32));
    	GeoipCountry(ip, country, sizeof(country));
    	GeoipCity(ip, city, sizeof(city));
    	
    	CReplyToCommand(client, "Name: {green}%N", target);
    	CReplyToCommand(client, "Profile: {green}https://steamcommunity.com/profiles/%s", url);
    	CReplyToCommand(client, "SteamID: {green}%s", steam32);
    	CReplyToCommand(client, "IP: {green}%s", ip);
    	CReplyToCommand(client, "Location: {green}%s - {green}%s", city, country);
    	CReplyToCommand(client, "Ping: {green}%.0f", ping);
    	CReplyToCommand(client, "Packets: {green}%f", packets);
    	CReplyToCommand(client, "Loss: {green}%f", loss);
    	CReplyToCommand(client, "Choke: {green}%f", choke);
    }
    return Plugin_Handled;
} 
