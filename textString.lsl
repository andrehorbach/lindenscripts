string mainMenuDialog = "\nWhich settings would you like to access?\n";
list mainMenuButtons = ["Set Text", "Smoke On", "Clear Text"];

string subMenu_01_Dialog = "\nClick \"Close\" to close the menu.\nClick \"-Main-\" to return to the main menu.\n\nYou are here:\nMainmenu > sub 01";
list subMenu_01_Buttons = ["action 01a", "action 01b", "Close", "-Main-"];

string subMenu_02_Dialog = "\nClick \"Close\" to close the menu.\nClick \"-Main-\" to return to the main menu.\n\nYou are here:\nMainmenu > sub 02";

list subMenu_02_Buttons = ["action 02a", "action 02b", "Close", "-Main-"];

integer dialogChannel;
integer dialogHandle;

open_menu(key inputKey, string inputString, list inputList)
{
    dialogChannel = (integer)llFrand(DEBUG_CHANNEL)*-1;
    dialogHandle = llListen(dialogChannel, "", inputKey, "");
    llDialog(inputKey, inputString, inputList, dialogChannel);
    llSetTimerEvent(30.0);
}

close_menu()
{
    llSetTimerEvent(0.0);// you can use 0 as well to save memory
    llListenRemove(dialogHandle);
}

default
{
    on_rez(integer start_param)
    {
        llResetScript();
    }

    touch_start(integer total_number)
    {
        key id = llDetectedKey(0);
        // Ensure any outstanding listener is removed before creating a new one
        close_menu();
        open_menu(id, mainMenuDialog, mainMenuButtons);
    }

    listen(integer channel, string name, key id, string message)
    {
        if(channel != dialogChannel)
            return;

        close_menu();

        if(message == "-Main-")
            open_menu(id, mainMenuDialog, mainMenuButtons);

        else if(message == "sub 01")
            open_menu(id, subMenu_01_Dialog, subMenu_01_Buttons);

        else if(message == "sub 02")
            open_menu(id, subMenu_02_Dialog, subMenu_02_Buttons);

        else if (message == "action 01a")
        {
            //do something
            open_menu(id, subMenu_01_Dialog, subMenu_01_Buttons);
        }
        else if (message == "action 01b")
        {
            //do something else

            //maybe not re-open the menu for this option?
            //open_menu(id, subMenu_01_Dialog, subMenu_01_Buttons);
        }
        else if (message == "action 02a")
        {
            //do something
            open_menu(id, subMenu_02_Dialog, subMenu_02_Buttons);
        }
        else if (message == "action 02b")
        {
            //do something else
            open_menu(id, subMenu_02_Dialog, subMenu_02_Buttons);
        }
    }

    timer()
    {
        close_menu();
    }
}