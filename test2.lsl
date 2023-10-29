// This script performs two functions: // 1) scans a crowd, randomly picks an AV and the displays their first name in an attractive particle stream. EG: "Joe Smith" will be "HI JOE" in particles // 2) creates an attractive particle text banner from a selection of your choosing. EG: "HAPPY REZ DAY" "PARTICLE CRUCIBLE", "MY STORE NAME"

// Based on the original XYText work of Xylor Baysklef and an in-world script attributed to Zara Vale. // All new functionality and code improvements by Debbie Trilling.

// Script is free to use and modify as you wish but under the condition that the title and this introduction // remain in place, and that due credit continues to be given to Xylor Baysklef, Zara Vale & Debbie Trilling. // Fonts and their texture UUIDS may be used but only under recognision that they were created by // Debbie Trilling specifically for the 'Particle Crucible' brand and further, that no attempt is made to sell them or use them for any other branding purposes


// BRIEF INSTRUCTIONS: // Full instructions at http://wiki.secondlife.com/wiki/Talk:Random_AV_Particle_Name_Generator // It is controlled from a dialog menu. Simply put the script in a prim and 'touch'. Make a selection from the buttons. // To change the default text to a selection of your own choice, change the text in 'DefaultTextPalette' a few lines below. // Rather than display the same AV name twice in a row, on the second time it will display a random selection from the default text // The bigger the prim that you put this script into, the further away you will be able to see the particle text // Rotate the prim to have the text travel horizontally rather than vertically


// ** PARAMETERS THAT YOU CAN CHANGE **

// Default text
list DefaultTextPalette = ["Particle Crucible", "Particle Garden", "SpoLand", "Cartoonimals"];
// Default values initialization
list WorkCharIndex = []; list WorkUUIDPalette = []; float Radius = 0.50; float FontSize = 1.40;

integer Power = FALSE; string PowerText = "On"; key ObjectOwner = ""; key LastTarget = ""; string WorkChar = ""; integer NoSensorCounter = 0; integer ListenChannel = 0; list MenuItems = []; string MenuText = ""; string WorkDisplayText = ""; float LetterTimeGap = 2.7; integer FindRandomAV = TRUE; string FindRandomAVText = "Defaults"; float ScanArc = 3.141592653; string ScanArcText = "X-Axis";  float Range = 25.00; list ScannerItems = ["75m", "90m","40m", "50m", "60m", "25m", "30m", "35m", "10m", "15m", "20m" ];

list MasterUUIDPalette = [ "342005c0-e916-015a-1d9f-f5a5282658d6", "3ceaeb61-7877-347f-200c-389b008dfba2", "a767bfba-3580-48e5-bf82-843c69996828", "3774a58b-b0a2-68d5-4a3a-ce1f85f719b7", "b214c1c0-774a-becf-8a6f-4a771b3a16fb", "ae3792c0-33e7-0de5-4c98-6e1cfa7a4c4c", "694b92e3-bdec-534a-52c4-b955685ab109", "dfd35eec-7232-26f8-bdd0-ce9a7c142451", "18a70d23-254a-0a3c-4d4b-c6692f5941b3", "b05d6f5f-2b1b-ff7c-2951-ec1f68238c90", "4df1867f-bf31-17d5-3b88-d5703a782c46", "1812a48f-0ee8-de20-b7d8-a33cff922303", "d2bb1c89-5e3c-b084-33f1-a723e5ceb005", "74a39f5d-0aa8-f7c1-e5b2-7ca6470b1877", "340a9361-8f00-5e8c-ef41-89fb25fc26b9", "d8b0f853-ee63-6248-ea70-bd0806fe5259", "6dc7465d-bb3d-c664-98a1-15293d1c1973", "a45ee3fa-102a-32ce-140a-73c11fd3e873", "378bf10c-86f7-69e5-d6cb-3a27bfa9ed0a", "e8170991-11bd-e2e4-3662-d4b265d785ae", "0541fb80-0055-3815-04d1-fbb2c10e9a59", "45d0a340-32c1-f95a-0a76-7f96c1675d55", "7c8f2c6e-1e44-1af7-4c2b-15c40fa1273d", "0694bea0-21c0-67ec-f420-05e1a5e76e69", "2de3d529-95e8-64a7-45d0-f7e497bf7480", "558a2f3a-5e76-f0c6-32ad-2db1258250f8", "75ef778c-cbb2-9a59-8044-49e37753dcfe", "2ed7ef82-2770-b316-b796-84fec6273270", "50fe9926-264a-2017-c7c4-f1ff8a0677eb", "bccfb0e1-1ace-a919-1ca5-ee2387011129", "c38898d2-8b84-eb09-6f63-f88fe8ce62ec", "829e0036-75b0-54a0-2515-6ba1c01b5272", "e84d0ad8-ff28-ba59-4d8e-698f5fc96311", "c8a80085-079e-a00a-6ec4-7c0a82782043", "57df7103-c08f-58b7-5f78-a22d5c200d58", "c259edf8-9875-da57-34a2-d2428e39afb9", "701917a8-d614-471f-13dd-5f4644e36e3c"];

list MasterCharIndex = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","1","2","3","4","5","6","7","8","9","0"," "];

string Author = ""; string Supplier = ""; string ObjectName = ""; string Version = "";

integer TotalNoScansAllowed = 0;


InitialiseObject() { Power = FALSE; PowerText = "On"; ObjectOwner = llGetOwner(); llSetObjectName(ObjectName + Version); llSetObjectDesc(""); vector PrimSize = llGetScale(); Radius = ((PrimSize.z / 2) + (FontSize/2)) + 0.50; StopOperation(); }


MakeMenu() { integer CommChannel = (-200000 - ((integer)llFrand(12345) * -1)); ListenChannel = llListen(CommChannel, "", ObjectOwner, ""); llDialog(ObjectOwner, MenuText, MenuItems, CommChannel); }


StartOperation() { WorkChar = ""; NoSensorCounter = 0; llOwnerSay( ObjectName + " has been turned ON"); }

// start particles inworld
StartParticle(string ParticleChar) {

// particle config
llParticleSystem([ PSYS_PART_FLAGS, 0x100, PSYS_SRC_PATTERN, 0x04, PSYS_SRC_TEXTURE, llList2Key(WorkUUIDPalette, llListFindList(WorkCharIndex, (list)ParticleChar)), PSYS_PART_START_SCALE,<FontSize, FontSize, 0.0>, PSYS_PART_END_SCALE,<FontSize, FontSize, 0.0>, PSYS_PART_START_ALPHA,1.0, PSYS_PART_END_ALPHA,1.0, PSYS_PART_MAX_AGE, 30.0, PSYS_SRC_BURST_PART_COUNT, 1, PSYS_SRC_BURST_RADIUS, Radius, PSYS_SRC_BURST_RATE, LetterTimeGap, PSYS_SRC_MAX_AGE, LetterTimeGap, PSYS_SRC_BURST_SPEED_MIN,0.45, PSYS_SRC_BURST_SPEED_MAX,0.45 ]); }


PrepareData() { MakeCharIndex(); MakeTexturePalette(); llSetTimerEvent(LetterTimeGap); }


MakeCharIndex() {

list WorkCharIndex = []; integer x; integer y = llStringLength(WorkDisplayText); for (x = 0; x < y; x++) { if (llListFindList(WorkCharIndex, (list)llGetSubString(WorkDisplayText, x, x)) == -1) { WorkCharIndex = WorkCharIndex + (list)llGetSubString(WorkDisplayText, x, x); } } }


MakeTexturePalette() { list WorkUUIDPalette = []; integer x; integer y = llGetListLength(WorkCharIndex); for (x = 0; x < y; x++) { WorkUUIDPalette = WorkUUIDPalette + (list)llList2Key(MasterUUIDPalette, llListFindList(MasterCharIndex, (list)llList2String(WorkCharIndex,x))); } }


ApplyDefaultText() { WorkDisplayText = llToUpper(llList2String(DefaultTextPalette, (integer)llFrand((float)llGetListLength(DefaultTextPalette)))) + " "; PrepareData(); }

StopOperation() { llSetTimerEvent(0.0); llSensorRemove(); llListenRemove(ListenChannel); llParticleSystem([]); }


default {

on_rez(integer start_param) { llResetScript(); }


changed( integer change ) { if(change & CHANGED_OWNER ) {  llResetScript(); } }


state_entry() { InitialiseObject(); }


touch_start(integer num_detected) { key DetectedUser = llDetectedKey(0);

if (DetectedUser == ObjectOwner) { if(Power) { PowerText = "Off"; } else { PowerText = "On"; }

if (FindRandomAV) { MenuItems = [PowerText, FindRandomAVText, ScanArcText, "SetRange"]; } else { MenuItems = [ PowerText, FindRandomAVText ]; } MenuItems = ["Close", "Help", "ResetScript"] + llListSort(MenuItems,1,TRUE); MenuText = "MAIN MENU: \n- On-Off: toggle power \n- Defaults-Names: toggle display mode \n- XAxis-360 degree: toggle if scan is forward of the prim, or all around it \n- SetRange: set scanner range \n- ResetScript: restore settings \n- Help: Link to product Help page"; MakeMenu(); } else { llInstantMessage("Script running"); } }


sensor(integer total_number) { key IntendedTarget = llDetectedKey((integer)llFrand(total_number)); if (IntendedTarget == LastTarget) {  ApplyDefaultText(); LastTarget = ""; } else { LastTarget = IntendedTarget; WorkDisplayText = "HI " + llToUpper(llGetSubString(llKey2Name(IntendedTarget), 0, (llSubStringIndex(llKey2Name(IntendedTarget), " ") -1))) + " "; PrepareData(); } }


no_sensor() { if ((NoSensorCounter > TotalNoScansAllowed) && (TotalNoScansAllowed > 0)) { StopOperation(); llInstantMessage(ObjectOwner, "\nThe " + ObjectName + " has been automatically switched OFF as no Agents have been detected within the set timeframe."); } else { ApplyDefaultText(); } }


timer() { if(WorkChar == "") { WorkChar = WorkDisplayText; } //error

StartParticle(llGetSubString(WorkChar, 0, 0));

if(llStringLength(WorkChar) == 1) { WorkChar = ""; StartSensorCheck(); } else { WorkChar = llGetSubString(WorkChar, 1, -1); } }


listen(integer channel, string name, key id, string message) { llListenRemove(ListenChannel); message = llToLower(message); 
if ((message == "on") || (message == "off")) { if (message == "on") { StartOperation(); } else { StopOperation(); llOwnerSay( ObjectName + " has been turned OFF"); } Power = !Power; } else if ((message == "defaults") || (message == "names")) { if (message == "defaults") { FindRandomAVText = "Names"; llOwnerSay("Particle stream will display default texts only"); } else { FindRandomAVText = "Defaults"; llOwnerSay("Particle stream will display random names and default texts"); } FindRandomAV = !FindRandomAV; } else if ((message == "x-axis") || (message == "360degree")) {  if (message == "x-axis") { ScanArc = PI_BY_TWO; ScanArcText = "360degree"; } else { ScanArc = PI; ScanArcText = "X-Axis"; }; } else if (message == "setrange") {  MenuText = "SET SCANNER RANGE MENU: Please set the scanner range:"; MenuItems = (list)"Close" + ScannerItems; MakeMenu(); } else if (llListFindList(ScannerItems, (list)message) != -1) { Range = (float)llGetSubString(message, 0, 1); } else if (message == "resetscript") { llOwnerSay("Resetting script. Please wait..."); llResetScript(); } else if (message == "help") { string URL_HELPPAGE = "http://wiki.secondlife.com/wiki/Talk:Random_AV_Particle_Name_Generator"; llLoadURL(ObjectOwner, "This link will take you to the " + ObjectName + "'s Help page.", URL_HELPPAGE); } else if (message == "close") {  } else { llOwnerSay("MAIN MENU: Unrecognised menu selection"); }
}
}
