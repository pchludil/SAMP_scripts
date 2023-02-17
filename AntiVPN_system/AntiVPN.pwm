#include <a_samp>
#include <a_http>

public OnPlayerConnect(playerid)
{
	new ip[16], string[59];
	GetPlayerIp(playerid, ip, sizeof ip);
	format(string, sizeof string, "https://proxy.mind-media.com/block/proxycheck.php?ip=%s", ip);
	HTTP(playerid, HTTP_GET, string, "", "MyHttpResponse");
	return 1;
}
forward MyHttpResponse(playerid, response_code, data[]);
public MyHttpResponse(playerid, response_code, data[])
{
	new name[MAX_PLAYERS],string[256];
	new ip[16];
	GetPlayerName(playerid, name, sizeof(name));
	GetPlayerIp(playerid, ip, sizeof ip);
	if(strcmp(ip, "127.0.0.1", true) == 0)
	{
        return 1;
	}
	if(response_code == 200)
	{
		if(data[0] == 'Y')
		{
			format(string, 256, "Hráč %s(%d) byl vyhozen za VPN/Proxy IP", name, playerid);
	    	SendClientMessageToAll( 0xFF0000FF, string);
	    	Kick(playerid);
		}
		if(data[0] == 'N')
		{
		}
		if(data[0] == 'X')
		{
		}
		else
		{
		}
	}
	return 1;
}
