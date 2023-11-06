#include "macro.hpp";

///////////////////////////////////////////////////
/* GENERAL SETTINGS                              */
///////////////////////////////////////////////////

// Enable mod
[
	SETNAME("enabled"),
	"CHECKBOX",
	["Enabled", "Restart is required"],
	[TITLE, "1. General settings"],
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
	[TITLE, "1. General settings"],
	[5, 600, 60, 0],
	1
] call CBA_Settings_fnc_init;

// Enable mod
[
	SETNAME("enableCleanup"),
	"CHECKBOX",
	["Enable clean-up logic", "Restart is required"],
	[TITLE, "1. General settings"],
	true,
	1,
	{},
	true
] call CBA_Settings_fnc_init;

// Clean-up interval
[
	SETNAME("cleanUpInterval"),
	"SLIDER",
	["Clean-up interval", "Interval to check for surrendered or fleeing units to clean up. Default: 60"],
	[TITLE, "1. General settings"],
	[30, 600, 60, 0],
	1
] call CBA_Settings_fnc_init;

// Clean-up distance
[
	SETNAME("cleanUpDistance"),
	"SLIDER",
	["Clean-up distance", "Do not remove marked unit if a player is within this distance. Default: 800"],
	[TITLE, "1. General settings"],
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
	[TITLE, "2. Morale settings"],
	[-1, 1, -0.2, 2],
	1
] call CBA_Settings_fnc_init;

// Morale check cooldown
[
	SETNAME("moraleCheckCooldown"),
	"SLIDER",
	["Morale check cooldown", "Duration after a unit passes a morale check before a new one can be made. Default: 120"],
	[TITLE, "2. Morale settings"],
	[5, 600, 120, 0],
	1
] call CBA_Settings_fnc_init;

// Morale debuff
[
	SETNAME("useMoraleDebuff"),
	"CHECKBOX",
	["Use morale debuff mechanics", "The larger the morale hit a group takes the less likely they are to have a positive result on the morale check."],
	[TITLE, "2. Morale settings"],
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
	[TITLE, "3. Morale actions settings"],
	[10, 600, 90, 0],
	1
] call CBA_Settings_fnc_init;

// AI ignore fleeing
[
	SETNAME("aiIgnoreFleeing"),
	"CHECKBOX",
	["Ignore fleeing units", "AI will ignore fleeing enemy units if set to true."],
	[TITLE, "3. Morale actions settings"],
	true,
	1
] call CBA_Settings_fnc_init;

// Flee min distance
[
	SETNAME("fleeMinDistance"),
	"SLIDER",
	["Flee min distance", "Minimum distance a unit will flee. Needs to be lower than max distance. Default: 150"],
	[TITLE, "3. Morale actions settings"],
	[0, 1000, 150, 0],
	1
] call CBA_Settings_fnc_init;

// Flee max distance
[
	SETNAME("fleeMaxDistance"),
	"SLIDER",
	["Flee max distance", "Maximum distance a unit will flee. Needs to be higher than min distance. Default: 500"],
	[TITLE, "3. Morale actions settings"],
	[0, 1000, 500, 0],
	1
] call CBA_Settings_fnc_init;

// Enable AI go hostile
[
	SETNAME("enableAIGoHostile"),
	"CHECKBOX",
	["Enable AI re-engage", "Surrendered units may go hostile if not monitored or handcuffed."],
	[TITLE, "3. Morale actions settings"],
	true,
	1
] call CBA_Settings_fnc_init;

// Go hostile interval
[
	SETNAME("goHostileInterval"),
	"SLIDER",
	["Re-engage check interval", "Interval to check if a surrendered unit should go hostile. Default: 10"],
	[TITLE, "3. Morale actions settings"],
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
	[TITLE, "4. Other"],
	true,
	1
] call CBA_Settings_fnc_init;

// Cable tie amount players
[
	SETNAME("cableTieAmountPlayers"),
	"SLIDER",
	["Player amount", "Amount of cable ties to add to each unit in player groups. Default: 10"],
	[TITLE, "4. Other"],
	[0, 30, 10, 0],
	1
] call CBA_Settings_fnc_init;

// Cable tie amount AI
[
	SETNAME("cableTieAmountAI"),
	"SLIDER",
	["AI amount", "Amount of cable ties to add to each unit in AI groups. Default: 2"],
	[TITLE, "4. Other"],
	[0, 30, 2, 0],
	1
] call CBA_Settings_fnc_init;

// Enable rally
[
	SETNAME("enableRally"),
	"CHECKBOX",
	["Enable rally", "Allows the player to rally surrendered or fleeing allies, having them join the player group."],
	[TITLE, "4. Other"],
	true,
	1
] call CBA_Settings_fnc_init;

///////////////////////////////////////////////////
/* ADVANCED SETTINGS                             */
///////////////////////////////////////////////////

// Disable for BLUFOR
[
	SETNAME("disableMoraleBlufor"),
	"CHECKBOX",
	["Disable BLUFOR", "Disable morale logic for BLUFOR"],
	[TITLE, "5. Advanced settings"],
	false,
	1
] call CBA_Settings_fnc_init;

// Disable for OPFOR
[
	SETNAME("disableMoraleOpfor"),
	"CHECKBOX",
	["Disable OPFOR", "Disable morale logic for OPFOR"],
	[TITLE, "5. Advanced settings"],
	false,
	1
] call CBA_Settings_fnc_init;

// Disable for INDEPENDENT
[
	SETNAME("disableMoraleIndependent"),
	"CHECKBOX",
	["Disable INDEPENDENT", "Disable morale logic for INDEPENDENT"],
	[TITLE, "5. Advanced settings"],
	false,
	1
] call CBA_Settings_fnc_init;

// VLOW casualty threshold
[
	SETNAME("vlowCasualtyThreshold"),
	"SLIDER",
	["VLOW casualty threshold", "Amount of casualties in percent a VLOW skilled group has to suffer before they start taking morale checks. Default: 30"],
	[TITLE, "5. Advanced settings"],
	[0, 100, 30, 1],
	1
] call CBA_Settings_fnc_init;

// VLOW morale pass chance
[
	SETNAME("vlowMoralePassChance"),
	"SLIDER",
	["VLOW pass chance", "Chance for VLOW skilled groups to pass a morale check. The sum of this and the fighting retreat chance need to be less or equal to 100. Default: 25"],
	[TITLE, "5. Advanced settings"],
	[0, 100, 25, 1],
	1
] call CBA_Settings_fnc_init;

// VLOW fighting retreat chance
[
	SETNAME("vlowFightingRetreatChance"),
	"SLIDER",
	["VLOW fighting retreat chance", "Chance for VLOW skilled groups to do the fighting retreat action. The sum of this and the pass chance need to be less or equal to 100. Default: 25"],
	[TITLE, "5. Advanced settings"],
	[0, 100, 25, 1],
	1
] call CBA_Settings_fnc_init;

// VLOW smoke chance
[
	SETNAME("vlowSmokeChance"),
	"SLIDER",
	["VLOW smoke chance", "Chance for each unit in VLOW skilled groups to drop smoke grenades during the fighting retreat action. Default: 40"],
	[TITLE, "5. Advanced settings"],
	[0, 100, 40, 1],
	1
] call CBA_Settings_fnc_init;

// VLOW go hostile chance
[
	SETNAME("vlowGoHostileChance"),
	"SLIDER",
	["VLOW go hostile chance", "Chance for VLOW skilled groups to go hostile again after surrendering. Default: 40"],
	[TITLE, "5. Advanced settings"],
	[0, 100, 40, 1],
	1
] call CBA_Settings_fnc_init;

// LOW casualty threshold
[
	SETNAME("lowCasualtyThreshold"),
	"SLIDER",
	["LOW casualty threshold", "Amount of casualties in percent a LOW skilled group has to suffer before they start taking morale checks. Default: 40"],
	[TITLE, "5. Advanced settings"],
	[0, 100, 40, 1],
	1
] call CBA_Settings_fnc_init;

// LOW morale pass chance
[
	SETNAME("lowMoralePassChance"),
	"SLIDER",
	["LOW pass chance", "Chance for LOW skilled groups to pass a morale check. The sum of this and the fighting retreat chance need to be less or equal to 100. Default: 30"],
	[TITLE, "5. Advanced settings"],
	[0, 100, 30, 1],
	1
] call CBA_Settings_fnc_init;

// LOW fighting retreat chance
[
	SETNAME("lowFightingRetreatChance"),
	"SLIDER",
	["LOW fighting retreat chance", "Chance for LOW skilled groups to do the fighting retreat action. The sum of this and the pass chance need to be less or equal to 100. Default: 30"],
	[TITLE, "5. Advanced settings"],
	[0, 100, 30, 1],
	1
] call CBA_Settings_fnc_init;

// LOW smoke chance
[
	SETNAME("lowSmokeChance"),
	"SLIDER",
	["LOW smoke chance", "Chance for each unit in LOW skilled groups to drop smoke grenades during the fighting retreat action. Default: 60"],
	[TITLE, "5. Advanced settings"],
	[0, 100, 60, 1],
	1
] call CBA_Settings_fnc_init;

// LOW go hostile chance
[
	SETNAME("lowGoHostileChance"),
	"SLIDER",
	["LOW go hostile chance", "Chance for LOW skilled groups to go hostile again after surrendering. Default: 60"],
	[TITLE, "5. Advanced settings"],
	[0, 100, 60, 1],
	1
] call CBA_Settings_fnc_init;

// NORMAL casualty threshold
[
	SETNAME("normalCasualtyThreshold"),
	"SLIDER",
	["NORMAL casualty threshold", "Amount of casualties in percent a NORMAL skilled group has to suffer before they start taking morale checks. Default: 50"],
	[TITLE, "5. Advanced settings"],
	[0, 100, 50, 1],
	1
] call CBA_Settings_fnc_init;

// NORMAL morale pass chance
[
	SETNAME("normalMoralePassChance"),
	"SLIDER",
	["NORMAL pass chance", "Chance for NORMAL skilled groups to pass a morale check. The sum of this and the fighting retreat chance need to be less or equal to 100. Default: 35"],
	[TITLE, "5. Advanced settings"],
	[0, 100, 35, 1],
	1
] call CBA_Settings_fnc_init;

// NORMAL fighting retreat chance
[
	SETNAME("normalFightingRetreatChance"),
	"SLIDER",
	["NORMAL fighting retreat chance", "Chance for NORMAL skilled groups to do the fighting retreat action. The sum of this and the pass chance need to be less or equal to 100. Default: 35"],
	[TITLE, "5. Advanced settings"],
	[0, 100, 35, 1],
	1
] call CBA_Settings_fnc_init;

// NORMAL smoke chance
[
	SETNAME("normalSmokeChance"),
	"SLIDER",
	["NORMAL smoke chance", "Chance for each unit in NORMAL skilled groups to drop smoke grenades during the fighting retreat action. Default: 80"],
	[TITLE, "5. Advanced settings"],
	[0, 100, 80, 1],
	1
] call CBA_Settings_fnc_init;

// NORMAL go hostile chance
[
	SETNAME("normalGoHostileChance"),
	"SLIDER",
	["NORMAL go hostile chance", "Chance for NORMAL skilled groups to go hostile again after surrendering. Default: 80"],
	[TITLE, "5. Advanced settings"],
	[0, 100, 80, 1],
	1
] call CBA_Settings_fnc_init;

// HIGH casualty threshold
[
	SETNAME("highCasualtyThreshold"),
	"SLIDER",
	["HIGH casualty threshold", "Amount of casualties in percent a HIGH skilled group has to suffer before they start taking morale checks. Default: 60"],
	[TITLE, "5. Advanced settings"],
	[0, 100, 60, 1],
	1
] call CBA_Settings_fnc_init;

// HIGH morale pass chance
[
	SETNAME("highMoralePassChance"),
	"SLIDER",
	["HIGH pass chance", "Chance for HIGH skilled groups to pass a morale check. The sum of this and the fighting retreat chance need to be less or equal to 100. Default: 40"],
	[TITLE, "5. Advanced settings"],
	[0, 100, 40, 1],
	1
] call CBA_Settings_fnc_init;

// HIGH fighting retreat chance
[
	SETNAME("highFightingRetreatChance"),
	"SLIDER",
	["HIGH fighting retreat chance", "Chance for HIGH skilled groups to do the fighting retreat action. The sum of this and the pass chance need to be less or equal to 100. Default: 40"],
	[TITLE, "5. Advanced settings"],
	[0, 100, 40, 1],
	1
] call CBA_Settings_fnc_init;

// HIGH smoke chance
[
	SETNAME("highSmokeChance"),
	"SLIDER",
	["HIGH smoke chance", "Chance for each unit in HIGH skilled groups to drop smoke grenades during the fighting retreat action. Default: 90"],
	[TITLE, "5. Advanced settings"],
	[0, 100, 90, 1],
	1
] call CBA_Settings_fnc_init;

// HIGH go hostile chance
[
	SETNAME("highGoHostileChance"),
	"SLIDER",
	["HIGH go hostile chance", "Chance for HIGH skilled groups to go hostile again after surrendering. Default: 90"],
	[TITLE, "5. Advanced settings"],
	[0, 100, 90, 1],
	1
] call CBA_Settings_fnc_init;

// VHIGH casualty threshold
[
	SETNAME("vhighCasualtyThreshold"),
	"SLIDER",
	["VHIGH casualty threshold", "Amount of casualties in percent a VHIGH skilled group has to suffer before they start taking morale checks. Default: 70"],
	[TITLE, "5. Advanced settings"],
	[0, 100, 70, 1],
	1
] call CBA_Settings_fnc_init;

// VHIGH morale pass chance
[
	SETNAME("vhighMoralePassChance"),
	"SLIDER",
	["VHIGH pass chance", "Chance for VHIGH skilled groups to pass a morale check. The sum of this and the fighting retreat chance need to be less or equal to 100. Default: 45"],
	[TITLE, "5. Advanced settings"],
	[0, 100, 45, 1],
	1
] call CBA_Settings_fnc_init;

// VHIGH fighting retreat chance
[
	SETNAME("vhighFightingRetreatChance"),
	"SLIDER",
	["VHIGH fighting retreat chance", "Chance for VHIGH skilled groups to do the fighting retreat action. The sum of this and the pass chance need to be less or equal to 100. Default: 45"],
	[TITLE, "5. Advanced settings"],
	[0, 100, 45, 1],
	1
] call CBA_Settings_fnc_init;

// VHIGH smoke chance
[
	SETNAME("vhighSmokeChance"),
	"SLIDER",
	["VHIGH smoke chance", "Chance for each unit in VHIGH skilled groups to drop smoke grenades during the fighting retreat action. Default: 100"],
	[TITLE, "5. Advanced settings"],
	[0, 100, 100, 1],
	1
] call CBA_Settings_fnc_init;

// VHIGH go hostile chance
[
	SETNAME("vhighGoHostileChance"),
	"SLIDER",
	["VHIGH go hostile chance", "Chance for VHIGH skilled groups to go hostile again after surrendering. Default: 100"],
	[TITLE, "5. Advanced settings"],
	[0, 100, 100, 1],
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
	[TITLE, "6. Debug"],
	false,
	1
] call CBA_Settings_fnc_init;

// Debug clean-up
[
	SETNAME("debugCleanUp"),
	"CHECKBOX",
	["Debug cleanup", "Dump clean-up debug variables to chat."],
	[TITLE, "6. Debug"],
	false,
	1
] call CBA_Settings_fnc_init;

// Debug morale event
[
	SETNAME("debugMoraleEvent"),
	"CHECKBOX",
	["Debug morale event", "Dump morale event debug variables to chat."],
	[TITLE, "6. Debug"],
	false,
	1
] call CBA_Settings_fnc_init;

// Debug morale action
[
	SETNAME("debugMoraleAction"),
	"CHECKBOX",
	["Debug morale action", "Dump morale action debug variables to chat."],
	[TITLE, "6. Debug"],
	false,
	1
] call CBA_Settings_fnc_init;

// Debug fighting retreat
[
	SETNAME("debugFightingRetreat"),
	"CHECKBOX",
	["Debug fighting retreat action", "Dump fighting retreat debug variables to chat and show fighting retreat target waypoint."],
	[TITLE, "6. Debug"],
	false,
	1
] call CBA_Settings_fnc_init;

// Debug go hostile
[
	SETNAME("debugGoHostile"),
	"CHECKBOX",
	["Debug go hostile action", "Dump go hostile debug variables to chat."],
	[TITLE, "6. Debug"],
	false,
	1
] call CBA_Settings_fnc_init;

// Debug flee
[
	SETNAME("debugFlee"),
	"CHECKBOX",
	["Debug flee action", "Dump flee debug variables to chat."],
	[TITLE, "6. Debug"],
	false,
	1
] call CBA_Settings_fnc_init;

// Debug casualties
[
	SETNAME("debugCasualties"),
	"CHECKBOX",
	["Debug casualties", "Dump casualties debug variables to chat."],
	[TITLE, "6. Debug"],
	false,
	1
] call CBA_Settings_fnc_init;

// Debug rearm
[
	SETNAME("debugRearm"),
	"CHECKBOX",
	["Debug rearm", "Dump rearm debug variables to chat."],
	[TITLE, "6. Debug"],
	false,
	1
] call CBA_Settings_fnc_init;

// Debug morale cooldown
[
	SETNAME("debugMoraleCooldown"),
	"CHECKBOX",
	["Debug morale cooldown", "Dump cooldown debug variables to chat."],
	[TITLE, "6. Debug"],
	false,
	1
] call CBA_Settings_fnc_init;

// Debug morale logic removal
[
	SETNAME("debugMoraleLogicRemoval"),
	"CHECKBOX",
	["Debug logic removal", "Dump morale logic removal debug variables to chat. This fires when a player joins an AI group."],
	[TITLE, "6. Debug"],
	false,
	1
] call CBA_Settings_fnc_init;