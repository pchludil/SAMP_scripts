#include <a_samp>

#define LIST_COMMAND            true
#define LIST_USE_DIALOG         false

#define COMMAND_BLOCKED_MSG     "{FF0000}[!] {FFFFFF}Tento Příkaz je dočasně zablokován !."
#define COMMAND_BLOCKED_COLOR   0xFF0000FF
#define MAX_COMMAND_BLOCKED     50

#pragma tabsize 0


new BlockedCommand[MAX_COMMAND_BLOCKED][50];

public OnPlayerCommandText(playerid, cmdtext[])
{
        new bool:CMD_BLOCKED = false;
        for(new i = 0; i < MAX_COMMAND_BLOCKED; i++)
        {
            if(BlockedCommand[i][0] == '\0') continue;
                if(cmdtext[0] == '/')
                {
                        if(!strcmp(BlockedCommand[i], cmdtext[1], true)) CMD_BLOCKED = true;
                }
                else if(!strcmp(BlockedCommand[i], cmdtext, true)) CMD_BLOCKED = true;
                else continue;
        }
        if(CMD_BLOCKED)
			return SendClientMessage(playerid, COMMAND_BLOCKED_COLOR, COMMAND_BLOCKED_MSG);

        #if LIST_COMMAND == true
                if(!strcmp(cmdtext, "/blocklist", true))
                {
                    if(!IsPlayerAdmin(playerid)) return 0;
                        #if LIST_USE_DIALOG == true
                                new fstr[600], str[30];
                                for(new i = 0; i < sizeof(BlockedComand); i++)
                                {
                                        if(BlockedCommand[i][0] == '\0') continue;
                                        format(str, sizeof(str), "/%s\n", BlockedCommand[i]);
                                        strcat(fstr, str);
                                }
                                ShowPlayerDialog(playerid, 14653, DIALOG_STYLE_MSGBOX, "Blokované přikazy", fstr, "Zavřít", "");
                        #else
                                new str[30];
                                SendClientMessage(playerid, 0xFF0000FF, " Seznam blokovaných CMD:{FFFFFF}");
                                for(new i = 0; i < MAX_COMMAND_BLOCKED; i++)
                                {
                                        if(BlockedCommand[i][0] == '\0') continue;
                                        format(str, sizeof(str), "/%s", BlockedCommand[i]);
                                        SendClientMessage(playerid, -1, str);
                                }
                        #endif
                        return 1;
                }
        #endif

        new split = strfind(cmdtext, " ", true), command[60];
        if(split != -1)
        {
                strmid(command, cmdtext, 0, split);
                strdel(cmdtext, 0, split + 1);
        }
        else format(command, sizeof(command), "%s", cmdtext);

        if(!strcmp(command, "/blockcommand", true) || !strcmp(command, "/blockcmd", true))
        {
                if(!IsPlayerAdmin(playerid)) return 0;
                if(split == -1)
					return SendClientMessage(playerid, -1, "{FF0000}Napověda : /blockcmd (PŘÍKAZ)");
                if(cmdtext[0] == '/') strdel(cmdtext, 0, 1);
                new slotfree = -1;
                for(new i = 0; i < MAX_COMMAND_BLOCKED; i++)
                {
                    if(BlockedCommand[i][0] == '\0') slotfree = i;
                    else if(!strcmp(BlockedCommand[i], cmdtext, true))
						return SendClientMessage(playerid, -1, "{FF0000}[ ! ] {FFFFFF}Tento příkaz je již zablokován. Použijte '/ unblockcommand [command]' pro odblokování.");
                        if(slotfree != -1) continue;
                }
                if(slotfree == -1)
					return SendClientMessage(playerid, -1, "{FF0000}[ ! ] {FFFFFF}Dosáhli jste maximálního limitu zablokovaných příkazů. Předtím, než budete pokračovat, odblokujte některé.");
                format(BlockedCommand[slotfree], 25, "%s", cmdtext);
                SendClientMessage(playerid, -1, "{00FF00}[ i ] {FFFFFF}Příkaz byl úspěšně zablokován.");
                return 1;
        }

        if(!strcmp(command, "/unblockcommand", true) || !strcmp(command, "/unblockcmd", true))
        {
                if(!IsPlayerAdmin(playerid))
					return 0;
                if(split == -1)
					return SendClientMessage(playerid, -1, "{FF0000}Nápověda : /unblockcmd (PŘÍKAZ)");
                
                if(cmdtext[0] == '/') strdel(cmdtext, 0, 1);
                new slotfree = -1;
                for(new i = 0; i < MAX_COMMAND_BLOCKED; i++)
                {
                        if(!strcmp(BlockedCommand[i], cmdtext, true) && BlockedCommand[i][0] != '\0')
                        {
                                slotfree = i;
                                break;
                        }
                }
                if(slotfree == -1)
					return SendClientMessage(playerid, -1, "{FF0000}[ ! ] {FFFFFF}Tento příkaz není zablokován.");
                
                strdel(BlockedCommand[slotfree], 0, strlen(BlockedCommand[slotfree]));
                SendClientMessage(playerid, -1,"{00FF00}[ i ] {FFFFFF}Příkaz byl úspěšně odblokován.");
                return 1;
        }
        return 0;
}
