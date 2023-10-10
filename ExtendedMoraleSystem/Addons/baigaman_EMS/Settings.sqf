#include "macro.hpp";

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