#include "macro.hpp";

///////////////////////////////////////////////////
/* GENERAL SETTINGS                              */
///////////////////////////////////////////////////

// Enable mod
[
	SETNAME("enabled"),
	"CHECKBOX",
	["Enabled", "Restart is required"],
	[TITLE, "General settings"],
	true,
	1,
	{},
	true
] call CBA_Settings_fnc_init;

// Logic interval
[
	SETNAME("logicInterval"),
	"SLIDER",
	["Logic interval", "Interval to check for new groups to add the morale logic to. Default: 60"],
	[TITLE, "General settings"],
	[5, 600, 60, 0],
	1
] call CBA_Settings_fnc_init;

// Clean-up interval
[
	SETNAME("cleanUpInterval"),
	"SLIDER",
	["Clean-up interval", "Interval to check for surrendered or fleeing units to clean up. Default: 60"],
	[TITLE, "General settings"],
	[30, 600, 60, 0],
	1
] call CBA_Settings_fnc_init;

// Clean-up distance
[
	SETNAME("cleanUpDistance"),
	"SLIDER",
	["Clean-up distance", "Do not remove marked unit if a player is within this distance. Default: 800"],
	[TITLE, "General settings"],
	[100, 2000, 800, 0],
	1
] call CBA_Settings_fnc_init;

///////////////////////////////////////////////////
/* MORALE SETTINGS                               */
///////////////////////////////////////////////////

// Morale breakpoint
[
	SETNAME("moraleBreakPoint"),
	"SLIDER",
	["Morale breakpoint", "Units will check for morale when below this value. Default: -0.2."],
	[TITLE, "Morale settings"],
	[-1, 1, -0.2, 2],
	1
] call CBA_Settings_fnc_init;

// Morale check cooldown
[
	SETNAME("moraleCheckCooldown"),
	"SLIDER",
	["Morale check cooldown", "Duration after a unit passes a morale check before a new one can be made. Default: 120"],
	[TITLE, "Morale settings"],
	[5, 600, 120, 0],
	1
] call CBA_Settings_fnc_init;

// Morale debuff
[
	SETNAME("useMoraleDebuff"),
	"CHECKBOX",
	["Use morale debuff mechanics", "The larger the morale hit a group takes the less likely they are to have a positive result on the morale check."],
	[TITLE, "Morale settings"],
	true,
	1
] call CBA_Settings_fnc_init;

///////////////////////////////////////////////////
/* MORALE ACTION SETTINGS                        */
///////////////////////////////////////////////////

// Fighting retreat duration
[
	SETNAME("fightingRetreatDuration"),
	"SLIDER",
	["Fighting retreat duration", "The duration of a fighting retreat action. Default: 90"],
	[TITLE, "Morale actions settings"],
	[10, 600, 90, 0],
	1
] call CBA_Settings_fnc_init;

// AI ignore fleeing
[
	SETNAME("aiIgnoreFleeing"),
	"CHECKBOX",
	["Ignore fleeing units", "AI will ignore fleeing enemy units if set to true."],
	[TITLE, "Morale actions settings"],
	true,
	1
] call CBA_Settings_fnc_init;

// Flee min distance
[
	SETNAME("fleeMinDistance"),
	"SLIDER",
	["Flee min distance", "Minimum distance a unit will flee. Needs to be lower than max distance. Default: 150"],
	[TITLE, "Morale actions settings"],
	[0, 1000, 150, 0],
	1
] call CBA_Settings_fnc_init;

// Flee max distance
[
	SETNAME("fleeMaxDistance"),
	"SLIDER",
	["Flee max distance", "Maximum distance a unit will flee. Needs to be higher than min distance. Default: 500"],
	[TITLE, "Morale actions settings"],
	[0, 1000, 500, 0],
	1
] call CBA_Settings_fnc_init;

// Enable AI go hostile
[
	SETNAME("enableAIGoHostile"),
	"CHECKBOX",
	["Enable AI re-engage", "Surrendered units may go hostile if not monitored or handcuffed."],
	[TITLE, "Morale actions settings"],
	true,
	1
] call CBA_Settings_fnc_init;

// Go hostile interval
[
	SETNAME("goHostileInterval"),
	"SLIDER",
	["Re-engage check interval", "Interval to check if a surrendered unit should go hostile. Default: 10"],
	[TITLE, "Morale actions settings"],
	[5, 300, 10, 0],
	1
] call CBA_Settings_fnc_init;

///////////////////////////////////////////////////
/* OTHER                                         */
///////////////////////////////////////////////////

// Enable add cable ties
[
	SETNAME("enableAddCableTies"),
	"CHECKBOX",
	["Add cable ties", "Add cable ties to units."],
	[TITLE, "Other"],
	true,
	1
] call CBA_Settings_fnc_init;

// Cable tie amount players
[
	SETNAME("cableTieAmountPlayers"),
	"SLIDER",
	["Player amount", "Amount of cable ties to add to each unit in player groups. Default: 10"],
	[TITLE, "Other"],
	[0, 30, 10, 0],
	1
] call CBA_Settings_fnc_init;

// Cable tie amount AI
[
	SETNAME("cableTieAmountAI"),
	"SLIDER",
	["AI amount", "Amount of cable ties to add to each unit in AI groups. Default: 2"],
	[TITLE, "Other"],
	[0, 30, 2, 0],
	1
] call CBA_Settings_fnc_init;

// Enable rally
[
	SETNAME("enableRally"),
	"CHECKBOX",
	["Enable rally", "Allows the player to rally surrendered or fleeing allies, having them join the player group."],
	[TITLE, "Other"],
	true,
	1
] call CBA_Settings_fnc_init;

///////////////////////////////////////////////////
/* DEBUG                                         */
///////////////////////////////////////////////////

// Debug all
[
	SETNAME("debugAll"),
	"CHECKBOX",
	["Debug all", "Dump all debugging variables to chat."],
	[TITLE, "Debug"],
	false,
	1
] call CBA_Settings_fnc_init;

// Debug clean-up
[
	SETNAME("debugCleanUp"),
	"CHECKBOX",
	["Debug cleanup", "Dump clean-up debug variables to chat."],
	[TITLE, "Debug"],
	false,
	1
] call CBA_Settings_fnc_init;

// Debug morale event
[
	SETNAME("debugMoraleEvent"),
	"CHECKBOX",
	["Debug morale event", "Dump morale event debug variables to chat."],
	[TITLE, "Debug"],
	false,
	1
] call CBA_Settings_fnc_init;

// Debug morale action
[
	SETNAME("debugMoraleAction"),
	"CHECKBOX",
	["Debug morale action", "Dump morale action debug variables to chat."],
	[TITLE, "Debug"],
	false,
	1
] call CBA_Settings_fnc_init;

// Debug fighting retreat
[
	SETNAME("debugFightingRetreat"),
	"CHECKBOX",
	["Debug fighting retreat action", "Dump fighting retreat debug variables to chat and show fighting retreat target waypoint."],
	[TITLE, "Debug"],
	false,
	1
] call CBA_Settings_fnc_init;

// Debug go hostile
[
	SETNAME("debugGoHostile"),
	"CHECKBOX",
	["Debug go hostile action", "Dump go hostile debug variables to chat."],
	[TITLE, "Debug"],
	false,
	1
] call CBA_Settings_fnc_init;

// Debug flee
[
	SETNAME("debugFlee"),
	"CHECKBOX",
	["Debug flee action", "Dump flee debug variables to chat."],
	[TITLE, "Debug"],
	false,
	1
] call CBA_Settings_fnc_init;

// Debug casualties
[
	SETNAME("debugCasualties"),
	"CHECKBOX",
	["Debug casualties", "Dump casualties debug variables to chat."],
	[TITLE, "Debug"],
	false,
	1
] call CBA_Settings_fnc_init;

// Debug rearm
[
	SETNAME("debugRearm"),
	"CHECKBOX",
	["Debug rearm", "Dump rearm debug variables to chat."],
	[TITLE, "Debug"],
	false,
	1
] call CBA_Settings_fnc_init;

// Debug morale cooldown
[
	SETNAME("debugMoraleCooldown"),
	"CHECKBOX",
	["Debug morale cooldown", "Dump cooldown debug variables to chat."],
	[TITLE, "Debug"],
	false,
	1
] call CBA_Settings_fnc_init;