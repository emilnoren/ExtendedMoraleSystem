CONSTANT_DEBUG = false; // Debugging variable, set to true to dump debug data to the chat
publicVariable "CONSTANT_DEBUG";

PLAYERS = [];

logicInterval = 30; // Interval to check for new groups to add the surrender logic to
moraleBreakingPoint = -0.2; // Threshold the unit need to pass to test for morale
moraleCheckCooldown = 120; // How much time has to pass between morale checks
useMoraleDebuff = true; // Use morale debuff mechanic. Try setting this to false if units flee or surrender too often.
fightingRetreatDuration = 90; // How long will the fighting retreat last?
aiIgnoreFleeing = true; // Should the AI ignore fleeing units?
fleeMinDistance = 150; // Minimum distance an enemy will flee
fleeMaxDistance = 500; // Max distance an enemy will flee
enableAIGoHostile = true; // Enable the AI to pick up weapons and fight back if not handcuffed
goHostileInterval = 10; // Interval to run the 'go hostile' check
enableAddCableTies = true; // Add cable ties to units
cableTieAmountPlayers = 10; // Amount of cable ties to add to each player
cableTieAmountAI = 2; // Amount of cable ties to add to each AI unit
enableRally = true; // Enable players to rally surrendered or fleeing units
cleanUpInterval = 60; // Interval to check for units to clean up
cleanUpDistance = 800; // Run cleanup on units that are this distance or further from nearest player

if (isDedicated || isServer) then {

	[] spawn {
		
		[] remoteExec ["fnc_init", 0];

	};

};

// Init all base threads
fnc_init = {

	PLAYERS = [] call fnc_getPlayers;

	[] spawn fnc_addLogicInterval;
	[] spawn fnc_cleanUpInterval;
	
};

// Check for and remove old and busted units on an interval
// I.E. units in groups marked for clean up that are beyond a certain distance from the nearest player and not within line of sight
fnc_cleanUpInterval = {

	private _LOCALDEBUG = false;
	
	while {true} do {

		// Get all groups marked for clean up
		_groups = allGroups select {
			(_x getVariable ["cleanUp", false]) 
		};

		// Loop through groups
		{
			_group = _x;

			// Loop through units in each group
			{
				_unit = _x;

				if (!(alive _unit)) exitWith {};
				
				_visibility = 1;
				_nearPlayers = [];

				// Check if any player is near unit or in line of sight
				{
					_player = _x;
					_distance = _player distance _unit;

					_visibility = [objNull, "VIEW"] checkVisibility [eyePos _unit, eyePos _player];
					
					if (_distance < cleanUpDistance) then {

						_nearPlayers pushBack _player;

					};

				} forEach PLAYERS;

				if (
					count _nearPlayers == 0 
					&& 
					_visibility == 0
				) then {

					deleteVehicle _unit;
					[_LOCALDEBUG, format ["Deleted %1", _unit]] call fnc_log;

				};

			} forEach units _group;

		} forEach _groups;

		sleep cleanUpInterval;

	};

};

// Add surrender logic to newly created groups on an interval
fnc_addLogicInterval = {
	
	while {true} do {

		PLAYERS = [] call fnc_getPlayers;

		{

			_group = _x;

			// Check for non-player, non-civilian groups and add the surrender logic
			if (
				!([_group] call fnc_groupHasPlayer) 
				&&
				side _group != civilian 
				&& 
				isNil {_group getVariable "logicAdded"} 
			) then {

				_group setVariable ["broken", false];
				_group setVariable ["onMoraleCooldown", false];
				_group setVariable ["logicAdded", true];
				_group allowFleeing 0;
				_group spawn fnc_setGroupSkillLevel;
				_group call fnc_addMoraleHandler;

			};

		} forEach allGroups;

		[] spawn fnc_addCableTies;
		[] spawn fnc_addPlayerFiredHandler;

		sleep logicInterval;
	};

};

// Add set amount of cable ties to each unit in group
fnc_addCableTies = {
	
	{
		_group = _x;

		if (
			enableAddCableTies 
			&& 
			isNil {_group getVariable "cableTiesAdded"} 
		) then {

			_group setVariable ["cableTiesAdded", true];

			{
				_unit = _x;
				_cableTieAmount = if (([_group] call fnc_groupHasPlayer)) then {
					cableTieAmountPlayers;
				} else {
					cableTieAmountAI;
				};

				for "_i" from 1 to _cableTieAmount do {

					_unit addItem  "ACE_CableTie";

				};

			} forEach units _group;

		};

	} forEach allGroups;

};

// Check if a player fires at a surrendered or cowering unit
fnc_addPlayerFiredHandler = {

	{
		_player = _x;

		if (isNil {_player getVariable "logicAdded"}) then {

			// On player fire event
			_player addEventHandler ["Fired", {
				params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];

				// Throttle fire event
				if (!(_unit getVariable ["onCooldown", false])) then {

					[_unit, 0.6] call fnc_addGeneralCooldown;

					// On projectile hit event
					_projectile addEventHandler ["HitPart", {
						params ["_projectile", "_target", "_shooter", "_position", "_velocity", "_selection", "_ammo", "_vector", "_radius", "_surfaceType", "_isDirect"];

						[_shooter, _position] spawn fnc_handleBulletImpact;

					}];

				};

			}];

			_player setVariable ["logicAdded", true];

		};

	} forEach PLAYERS;

};

// Test for morale every time a shot is fired near a unit
fnc_addMoraleHandler = {
	params ["_group"];

	private _LOCALDEBUG = false;

	_group setVariable ["_debug", _LOCALDEBUG];

	{
		_x setVariable ["Surrendered", false];
		_x setVariable ["Cowering", false];

		_x addEventHandler ["FiredNear", {
			params ["_unit"];

			private _debug = (group _unit) getVariable "_debug";

			// This is to prevent any jank when using PiR
			if (
				!alive _unit 
				|| 
				lifeState _unit == "INCAPACITATED"
			) exitWith {};

			_group = group _unit;
			_morale = morale (leader _group);

			[_debug, format ["Group %1 morale: %2", _group, (morale (leader _group))]] call fnc_log;

			if (
				!(_group getVariable "broken") 
				&& 
				!(_group getVariable "onMoraleCooldown") 
				&& 
				_morale < moraleBreakingPoint 
			) then {

				[_debug, format ["Group %1 checking for morale", _group]] call fnc_log;

				_group setVariable ["broken", true];
				[_group, _morale] call fnc_moraleAction;
			
			};

		}];
	
	} forEach units _group;

};

// Select appropriate group action on morale break depending on skill, courage and enemy distance
fnc_moraleAction = {
	params ["_group", "_morale"];

	_LOCALDEBUG = false;

	_takeMoraleCheck = _group call fnc_checkCasualties;

	// Has unit taken enough casualties to warrant a morale check?
	if (!(_takeMoraleCheck)) exitWith {

		_group setVariable ["broken", false];

	};

	_action = [_group, _morale] call fnc_selectMoraleAction;

	switch (_action) do { 

		case "SURRENDER": {
			[_group, "LIMITED", fnc_surrender] call fnc_removeWeapons;
		};

		case "FLEE": {
			[_group, "FULL", fnc_flee] call fnc_removeWeapons;
		};

		case "FIGHTINGRETREAT": {
			_group spawn fnc_fightingRetreat;
		};

		case "PASSMORALECHECK": {
			_group call fnc_addMoraleCooldown;
		};

		default {
			[_LOCALDEBUG, "Something went wrong ¯\_(ツ)_/¯"] call fnc_log;
		};
	};

};

// Calculate morale and select group action
fnc_selectMoraleAction = {
	params ["_group", "_morale"];
	
	_action = "";

	// Skill level with corresponding percentages for morale action calculations
	// index 1 = PASSMORALECHECK, 2 = FIGHTINGRETREAT
	_skillLevel = [
		["VLOW", 25, 50],
		["LOW", 30, 60],
		["NORMAL", 35, 70],
		["HIGH", 40, 80],
		["VHIGH", 45, 90]
	] select {
		_x select 0 == _group getVariable "skillLevel"
	};
	_skillLevel = _skillLevel select 0;

	_moraleDebuff = 0;

	// Morale debuff calculations
	// The bigger the hit the unit takes to morale the less likely they are to have a positive outcome on the morale check
	if (useMoraleDebuff) then {
	
		_moraleDebuff = [_morale, 2] call BIS_fnc_cutDecimals;
		_moraleDebuff = round (_moraleDebuff * 100);
		_moraleDebuff = if (_moraleDebuff >= 0) then { 0 } else { _moraleDebuff - (moraleBreakingPoint * 100) };
		_moraleDebuff = _moraleDebuff / 2;
	
	};
	
	_diceRoll = floor (random 101);

	switch (true) do {

		case (_diceRoll <= (_skillLevel select 1) + _moraleDebuff): {
			_action = "PASSMORALECHECK";
		};

		case (
			_diceRoll > (_skillLevel select 1) + _moraleDebuff 
			&& 
			_diceRoll <= (_skillLevel select 2) + _moraleDebuff
		): {
			_action = "FIGHTINGRETREAT";
		};

		// Flee or surrender action is determined by checking the distance to the nearest known enemy
		// The closer an enemy is the more likely the group is to surrender instead of fleeing
		case (_diceRoll > (_skillLevel select 2) + _moraleDebuff): {

			_leader = leader _group;
			_nearestEnemy = _leader findNearestEnemy _leader;
			_distance = _nearestEnemy distance _leader;

			_diceRoll = floor (random 101);

			switch (true) do {

				case (_distance <= 40): {

					if (_diceRoll <= 80) then {
						_action = "SURRENDER";
					} else {
						_action = "FLEE";
					};

				};

				case (
					_distance > 40 
					&& 
					_distance <= 80
				): {

					if (_diceRoll <= 50) then {
						_action = "SURRENDER";
					} else {
						_action = "FLEE";
					};

				};

				case (
					_distance > 80 
					&& 
					_distance <= 120
				): {

					if (_diceRoll <= 25) then {
						_action = "SURRENDER";
					} else {
						_action = "FLEE";
					};

				};

				default {
					_action = "FLEE";
				};
			};

		};

		default {};
	};

	_action;

};

// Group makes a semi-orderly retreat
// This function is not great
fnc_fightingRetreat = {
	params ["_group"];

	_LOCALDEBUG = false;

	_leader = leader _group;
	
	_nearestEnemy = (_leader findNearestEnemy _leader);
	_direction = 180 + (_leader getRelDir _nearestEnemy);
	_rallyPoint = _leader getrelPos [floor (random [150, 225, 350]), _direction];

	[_group, getPos _nearestEnemy] spawn fnc_groupSmokeCover;

	sleep (random [5, 8, 10]);
	
	_unitsArray = units _group;
	_newGroup = createGroup [side _group, true];
	_newGroup setVariable ["logicAdded", true];
	_newGroup setVariable ["broken", true];
	
	[_group, false] call fnc_enableAdvancedAI;

	_unitsArray joinSilent _newGroup;

	_rallyPoint = [
		_rallyPoint,
		0,
		200,
		1,
		0,
		50
	] call BIS_fnc_findSafePos;

	// Keep spawning smoke at rally point if debugging is active
	if (CONSTANT_DEBUG || _LOCALDEBUG) then {

		[_rallyPoint, _leader] spawn {
			params ["_rallyPoint", "_leader"];
			while {true} do {

				_shell = "";

				switch (side _leader) do {

					case west: {
						_shell = "SmokeShellBlue";
					};

					case east: {
						_shell = "SmokeShellRed";
					};

					case independent: {
						_shell = "SmokeShellGreen";
					};

					default {
						_shell = "SmokeShellWhite";
					};

				};

				createVehicle [_shell, _rallyPoint, [], 0, "NONE"];

				sleep 30;
			};
		};

	};
	
	{
		_unit = _x;

		_pos = [
			_rallyPoint,
			4,
			15,
			1
		] call BIS_fnc_findSafePos;

		_unit setBehaviour "CARELESS";
		_unit setSpeedMode "FULL";
		_unit doMove _pos;

	} forEach _unitsArray;

	// Reset the group after x amount of time, essentially finishing the orderly retreat
	[_newGroup, getPos _nearestEnemy] spawn {
		params ["_group", "_targetPos"];

		sleep fightingRetreatDuration;

		[_group, _targetPos] call fnc_resetGroup;
	};

};

// Reset a group to it's initial state after a fighting retreat, adding a SAD waypoint to re-engage
fnc_resetGroup = {
	params ["_group", "_targetPos"];

	_LOCALDEBUG = false;
	
	_group setVariable ["logicAdded", nil];

	[_group, true] call fnc_enableAdvancedAI;

	{

		_x setBehaviour "COMBAT";

	} forEach units _group;

	_waypoint = _group addWaypoint [_targetPos, 100];
	_waypoint setWaypointType "SAD";

	[_LOCALDEBUG, format ["Group %1 has been reset", _group]] call fnc_log;

};

// Remove weapon for each unit in group
fnc_removeWeapons = {
	params ["_group", "_speed", "_callback"];

	[_group, false] call fnc_enableAdvancedAI;

	_group setCombatMode "BLUE";
	_group setBehaviour "SAFE";
	_group setSpeedMode _speed;
	
	{

		[_x, _callback, _LOCALDEBUG] spawn {
			params ["_unit", "_callback"];

			if (!alive _unit) exitWith {};

			_weapons = [
				primaryWeapon _unit,
				handgunWeapon _unit,
				secondaryWeapon _unit
			];

			sleep (random 10);

			// Disembark unit and prevent them from reembarking
			// This is probably unnecessary since units don't seem to trigger morale checks while in vehicles, but better safe than sorry
			[_unit] allowGetIn false;
			doGetOut _unit;

			_unit removeWeapon (primaryWeapon _unit);
			_unit removeWeapon (handgunWeapon _unit);
			_unit removeWeapon (secondaryWeapon _unit);

			[_unit, _weapons, _callback] call fnc_dropWeapons;

			_unit spawn fnc_addRallyAction;
		};

	} forEach units _group;

};

// Drop weapons at units feet
fnc_dropWeapons = {
	params ["_unit", "_weapons", "_callback"];

	_LOCALDEBUG = false;

	sleep 0.3;

	[_LOCALDEBUG, format ["Unit is alive: %1", (alive _unit)]] call fnc_log;

	if (!alive _unit) exitWith {};
	_speed = 1.5;
	_z = 0;

	{
		_weapon = _x;
		_direction = random 360;

		if (_weapon == "") exitWith {};

		_stance = stance _unit;

		switch (_stance) do {

			case "CROUCH": {
				_z = 0.8;
			};

			case "PRONE": {
				_z = 0.4;
			};

			// Using the default case for STAND stance
			default {
				_z = 1.2;
			};
		};

		_weaponHolder = "WeaponHolderSimulated" createVehicle [0, 0, 0];
		_weaponHolder addWeaponCargoGlobal [_weapon, 1];
		_weaponHolder setPos (_unit modelToWorld [0, 0.2, _z]);
		_weaponHolder disableCollisionWith _unit;
		_weaponHolder setVelocity [_speed * sin(_direction), _speed * cos(_direction), 0];

		sleep 0.2;

	} forEach _weapons;

	_unit spawn fnc_removeGrenades;

	sleep 0.2;

	_unit spawn _callback;

};

// Enable/disable VCOM stuff
fnc_enableAdvancedAI = {
	params ["_group", "_setting"];
	
	_group setVariable ["Vcm_Disable", _setting];
	_group setVariable ["VCM_NOFLANK", _setting]; 
	_group setVariable ["VCM_NORESCUE", _setting];
	_group setVariable ["VCM_TOUGHSQUAD", _setting];
	_group setVariable ["VCM_DisableForm", _setting];

};

// Make unit surrender
fnc_surrender = {
	params ["_unit"];

	(group _unit) setVariable ["cleanUp", true];

	_unit setUnitPos "UP";
	_unit enableAI "PATH";

	["ace_captives_setSurrendered", [_unit, true]] call CBA_fnc_globalEvent; // Set unit as surrendered
	["UVO_fnc_disableUVO", [_unit]] call CBA_fnc_globalEvent; // Disable VO callouts

	_unit setVariable ["Surrendered", true];

	_unit call fnc_assignSleeperHostiles;

};

// Make surrendered units potentially turn hostile if not monitored or handcuffed
// The higher skill a group has the more likely they are to turn hostile again
fnc_assignSleeperHostiles = {
	params ["_unit"];

	_group = group _unit;

	if (!(enableAIGoHostile)) exitWith {};
	
	// Index 1 = skillLevel, 2 = chance to turn hostile in percentage
	_skillLevel = [
		["VLOW", 40],
		["LOW", 60],
		["NORMAL", 80],
		["HIGH", 90],
		["VHIGH", 100]
	] select {
		_x select 0 == _group getVariable "skillLevel"
	};
	_skillLevel = _skillLevel select 0;

	_diceRoll = floor (random 101);

	if (_diceRoll <= _skillLevel select 1) then {

		_unit setVariable ["hostileLogic", true];
		_unit spawn fnc_goHostileCheck;

	};

};

// Check if marked unit is monitored, if not go hostile
fnc_goHostileCheck = {
	params ["_unit"];

	_LOCALDEBUG = false;

	sleep goHostileInterval;

	[_LOCALDEBUG, format ["Added hostile logic to unit %1", _unit]] call fnc_log;
	
	while {
		alive _unit 
		&& 
		!(_unit getVariable ["Fleeing", false]) 
		&& 
		!(_unit getVariable ["Cowering", false])
	} do {

		_goHostile = false;
		_nearUnits = _unit targets [true, 100];

		{
			_target = _x;
			_visibility = [objNull, "VIEW"] checkVisibility [eyePos _unit, eyePos _target];

			// Visibility <= 0.2 instead of 0 because target may be partially hidden by smoke or foliage
			if (_visibility <= 0.2) then {
				_goHostile = true;
			};

			[_LOCALDEBUG, format ["Unit %1 visibility of target %2: %3", _unit, _target, _visibility]] call fnc_log;

		} forEach _nearUnits;

		if (
			_goHostile 
			|| 
			count _nearUnits == 0
		) then {

			_unit spawn fnc_rearmAndEngage;

		};

		sleep goHostileInterval;
	};

};

// Make unit flee towards a point furthest away from any enemies
fnc_flee = {
	params ["_unit", ["_delay", 6]];

	_LOCALDEBUG = false;

	if (!alive _unit || _unit getVariable "Fleeing") exitWith {};

	(group _unit) setVariable ["cleanUp", true];

	_unit spawn fnc_addRallyAction;

	[_unit, false] call fnc_enableAdvancedAI;
	_unit setVariable ["lambs_danger_disableAI", true];

	_unit setVariable ["Cowering", false];
	_unit setVariable ["Fleeing", true];
	_unit setVariable ["Side", (side _unit)];
	_unit enableAI "MOVE";
	_unit setUnitPos "UP";

	sleep _delay;

	// Stop AI from shooting at this unit if flag is set
	if (aiIgnoreFleeing && !(captive _unit)) then {

		_unit setCaptive true;
	
	};

	doStop _unit;
	_unit disableAI "AUTOCOMBAT";
	_unit disableAI "CHECKVISIBLE";

	sleep 0.2;

	_unit switchMove "ApanPercMstpSnonWnonDnon_G01";

	_randomPos = [_unit, fleeMinDistance, fleeMaxDistance, 50] call fnc_getSafePos;

	[_LOCALDEBUG, format ["%1 moving to position %2", _unit, _randomPos]] call fnc_log;

	_unit doMove _randomPos;

	[_unit, _LOCALDEBUG] spawn {
		params ["_unit", "_debug"];

		waitUntil {moveToCompleted _unit};

		_unit disableAI "MOVE"; // This is to make sure that the unit does not fall back into formation as soon as it reaches it's destination

		// Swap animation when unit has finished moving
		if (floor random 2 > 0) then {
			
			_unit playMoveNow "ApanPknlMstpSnonWnonDnon_G01";
		
		} else {

			_unit playMoveNow "ApanPpneMstpSnonWnonDnon_G01";

		};

		_unit setVariable ["Fleeing", false];
		_unit setVariable ["Cowering", true];

		// Was the unit set as hostile before fleeing?
		if ((_unit getVariable ["hostileLogic", false])) exitWith {

			_unit switchMove "";
			_unit setVariable ["lambs_danger_disableAI", false];
			_unit spawn fnc_rearmAndEngage;

		};

		[_debug, format ["%1 has arrived at position", _unit]] call fnc_log;

	}

};

// Get a safe position, I.E. on land and not near enemies
fnc_getSafePos = {
	params ["_unit", "_minDistance", "_maxDistance", "_safeRadius"];
	
	// Get a random position
	_randomPos = [
		getPos _unit,
		_minDistance,
		_maxDistance,
		1,
		0,
		50
	] call BIS_fnc_findSafePos;

	_i = 0;

	// Check if position is safe, otherwise get a new position. Stop after a certaion amount of checks
	while {!([_randomPos, side _unit] call fnc_isSafePos) && _i < 500} do {

		_randomPos = [
			getPos _unit,
			fleeMaxDistance,
			fleeMinDistance,
			1,
			0,
			_safeRadius
		] call BIS_fnc_findSafePos;

		_i =+ 1;

	};

	_randomPos;

};

// Check if position is safe
fnc_isSafePos = {
	params ["_pos", "_side"];

	_result = true;

	_nearUnits = _pos nearEntities [["Man", "Car", "Tank"], 50]; // Check for units within a 50 m radius of the selected position

	{
		_isFriendly = [_side, side _x] call BIS_fnc_sideIsFriendly;

		if (!_isFriendly) exitWith {_result = false;};

	} forEach _nearUnits;

	_result;

};

// Set the group skill level depending on the leaders skill stat
// This is not recalculated if the leader dies because why bother
fnc_setGroupSkillLevel = {
	params ["_group"];

	// Save amount of units originally in group
	if (isNil {_group getVariable "baseUnitNum"}) then {
		
		_numOfUnits = count (units _group select {
			alive _x
		});
		_group setVariable ["baseUnitNum", _numOfUnits];

	};


	_leader = leader _group;
	_skill = (_leader skill "general") * 100;

	switch (true) do {

		case (_skill < 25): {
			_group setVariable ["skillLevel", "VLOW"];
		};

		case (_skill >= 25 && _skill < 40): {
			_group setVariable ["skillLevel", "LOW"];
		};

		case (_skill >= 40 && _skill < 60): {
			_group setVariable ["skillLevel", "NORMAL"];
		};

		case (_skill >= 60 && _skill < 80): {
			_group setVariable ["skillLevel", "HIGH"];
		};

		case (_skill >= 80): {
			_group setVariable ["skillLevel", "VHIGH"];
		};
		
		default {
			_group setVariable ["skillLevel", "NORMAL"];
		};
	};

};

// Check if group has taken enough casualties to warrant a morale check
fnc_checkCasualties = {
	params ["_group"];

	_LOCALDEBUG = false;

	_takeTest = false;

	_skillLevel = _group getVariable "skillLevel";
	_baseNumUnits = _group getVariable "baseUnitNum";
	_numOfAliveUnits = count (units _group select {
		alive _x 
		&& 
		lifeState _unit != "INCAPACITATED"
	});

	_percentageAlive = (100 / _baseNumUnits) * _numOfAliveUnits;
	_casualtyPercentageThreshold = 100;

	switch (_skillLevel) do {

		case "VLOW": {
			_casualtyPercentageThreshold = 30;
		};

		case "LOW": {
			_casualtyPercentageThreshold = 40;
		};

		case "NORMAL": {
			_casualtyPercentageThreshold = 50;
		};

		case "HIGH": {
			_casualtyPercentageThreshold = 60;
		};

		case "VHIGH": {
			_casualtyPercentageThreshold = 70;
		};

		default {};
	};

	[_LOCALDEBUG, format ["Alive: %1; Threshold: %2", _percentageAlive, (100 - _casualtyPercentageThreshold)]] call fnc_log;

	if (
		_numOfAliveUnits == 1 
		|| 
		_percentageAlive <= (100 - _casualtyPercentageThreshold)
	) then {
		_takeTest = true;
	};

	_takeTest;

};

// Make surrendered or cowering units react to being fired upon
fnc_handleBulletImpact = {
	params ["_shooter", "_position"];
	
	_nearUnits = _position nearEntities [["Man"], 10];

	{
		_unit = _x;

		if (
			!(_unit getVariable ["onCooldown", false]) 
			&& 
			!(_unit getVariable ["ace_captives_isHandcuffed", false]) 
			&& 
			((group _unit) getVariable "broken") 
			&& 
			( 
				(_unit getVariable "Surrendered") 
				|| 
				(_unit getVariable "Cowering")
			)
		) then {

			// Unsurrender unit, enable VO and trigger fleeing state
			if (_unit getVariable "Surrendered") then {

				["ace_captives_setSurrendered", [_unit, false]] call CBA_fnc_globalEvent;
				["UVO_fnc_enableUVO", [_unit]] call CBA_fnc_globalEvent;
				_unit setVariable ["Surrendered", false];

				[_unit, 0] spawn fnc_flee;

			// Else determine if unit is going to surrender or flee depending of distance to shooter
			} else {

				_distance = _shooter distance _unit;

				switch (true) do {

					case (_distance <= 30): {

						_unit spawn fnc_surrender;

					};

					case (
						_distance > 30 
						&& 
						_distance <= 50
					): {

						if (floor (random 100) <= 49) then {

							_unit spawn fnc_surrender;

						} else {

							[_unit, 0] spawn fnc_flee;

						};

					};

					case (
						_distance > 50 
						&& 
						_distance <= 90
					): {

						if (floor (random 100) <= 25) then {

							_unit spawn fnc_surrender;

						} else {

							[_unit, 0] spawn fnc_flee;

						};

					};
					
					default {
						[_unit, 0] spawn fnc_flee;
					};
				
				};

			};

			[_unit, 6] spawn fnc_addGeneralCooldown;

		};

	} forEach _nearUnits;

};

// Make unit pick up nearby primary weapon
// This function is good enough I guess
fnc_rearm = {
	params ["_unit"];
	
	_box = [];
	_i = 0;
	
	while {
		count _box == 0 
		&& 
		_i <= 20
	} do {

		_box = nearestObjects [_unit, ["WeaponHolderSimulated"], 10] select {
			getNumber(configFile >> "CfgWeapons" >> ((weaponCargo _x) select 0) >> "type") == 1
		};

		_i = _i + 1;

		sleep 0.2;

	};
	
	if (count _box == 0) exitWith {};
	
	_box = _box select 0;
	_boxContents = weaponCargo _box;
	_weapon = _boxContents select 0;

	_unit action ["TakeWeapon", _box, _weapon];

};

// Rearm unit and make it hostile
// LAMBS will take care of ammo looting
fnc_rearmAndEngage = {
	params ["_unit"];

	_LOCALDEBUG = false;

	doStop _unit;
	_unit setVariable ["Hostile", true];
	_unit enableAI "MOVE";
	_unit enableAI "AUTOCOMBAT";
	_unit enableAI "CHECKVISIBLE";
	_unit setCaptive false;

	sleep (floor (random 5));

	_box = [];
	_i = 0;
	
	// Get nearby primary weapons
	while {
		count _box == 0 
		&& 
		_i <= 20
	} do {

		_box = nearestObjects [_unit, ["WeaponHolderSimulated"], 300] select {
			getNumber(configFile >> "CfgWeapons" >> ((weaponCargo _x) select 0) >> "type") == 1
		};

		_i = _i + 1;

		sleep 0.2;

	};
	
	if (count _box == 0) exitWith {};
	
	_box = _box select 0;
	_boxContents = weaponCargo _box;
	_weapon = _boxContents select 0;

	["ace_captives_setSurrendered", [_unit, false]] call CBA_fnc_globalEvent;
	["UVO_fnc_enableUVO", [_unit]] call CBA_fnc_globalEvent;
	_side = _unit getVariable ["Side", (side _unit)];
	_newGroup = createGroup [_side, true];
	_newGroup setVariable ["logicAdded", true];
	_newGroup setSpeedMode "FULL";
	_newGroup setCombatMode "BLUE";
	_unit setBehaviour "CARELESS";

	[_unit] joinSilent _newGroup;

	sleep 1;

	_unit setUnitPos "UP";
	_unit doMove (getPosATL _box);

	waitUntil {moveToCompleted _unit};

	_unit action ["TakeWeapon", _box, _weapon];

	sleep 1;

	_unit setVariable ["Surrendered", false];
	_newGroup setVariable ["broken", true];
	_newGroup setVariable ["cleanUp", true];
	_newGroup setCombatMode "RED";
	_unit setBehaviour "COMBAT";

	_pos = [_unit, 100, 300, 0] call fnc_getSafePos;
	_waypoint = _newGroup addWaypoint [_pos, 100];
	_waypoint setWaypointType "SAD";

	[_LOCALDEBUG, format ["Unit %1 is rearmed and hostile", _unit]] call fnc_log;

};

// Remove all grenades from the unit, this is done so VCOM-enabled units don't spam grenades while fleeing or surrendering
fnc_removeGrenades = {
	params ["_unit"];

	_grenades = ["HandGrenade", "MiniGrenade"];;

	{
		_item = _x;

		if(_item in magazines _unit) then {

			_unit removeMagazines _item;

		};

	} forEach _grenades;

};

// Add a cooldown to the unit, making them immune from taking morale checks for the duration
fnc_addMoraleCooldown = {
	params ["_group"];

	_LOCALDEBUG = false;

	_group setVariable ["onMoraleCooldown", true];

	[_LOCALDEBUG, format ["Group %1 cooldown started", _group]] call fnc_log;

	[_group, _LOCALDEBUG] spawn {
		params ["_group", "_debug"];

		sleep moraleCheckCooldown;

		_group setVariable ["broken", false];
		_group setVariable ["onMoraleCooldown", false];

		[_debug, format ["Group %1 cooldown done", _group]] call fnc_log;

	};

};

// Add cooldown to unit
fnc_addGeneralCooldown = {
	params ["_unit", "_cooldownDuration"];

	_unit setVariable ["onCooldown", true];

	[_unit, _cooldownDuration] spawn {
		params ["_unit", "_cooldownDuration"];

		sleep _cooldownDuration;

		_unit setVariable ["onCooldown", false];

	};

};

// Make the group cover the retreat with smoke, depending on group skill
// Requires LAMBS Danger
fnc_groupSmokeCover = {
	params ["_group", "_target"];

	// Index 1 = skillLevel, 2 = chance to throw smoke in percentage
	_skillLevel = [
		["VLOW", 40],
		["LOW", 60],
		["NORMAL", 80],
		["HIGH", 90],
		["VHIGH", 100]
	] select {
		_x select 0 == _group getVariable "skillLevel"
	};
	_skillLevel = _skillLevel select 0;

	{
		_unit = _x;

		if (floor (random 101) <= _skillLevel select 1) then {
		
			sleep (floor random 3);
			[_unit, _target] call lambs_main_fnc_doSmoke;

		};

	} forEach units _group;

};

// Adds the action for players to rally fleeing, cowering or surrendered allies
fnc_addRallyAction = {
	params ["_unit"];

	if (!(enableRally)) exitWith {};

	sleep 4;

	_unit addAction [
		"Rally unit", 
		{
			params ["_target", "_caller"];

			["ace_captives_setSurrendered", [_target, false]] call CBA_fnc_globalEvent;
			["UVO_fnc_enableUVO", [_target]] call CBA_fnc_globalEvent;
			[_target, true] call fnc_enableAdvancedAI;

			_target setVariable ["lambs_danger_disableAI", false];
			_target setVariable ["Surrendered", false];
			_target setVariable ["Cowering", false];
			_target setVariable ["Fleeing", true];

			_target removeAllEventHandlers "FiredNear";

			_target setCaptive false;
			_target switchMove "";
			_target enableAI "MOVE";
			_target setUnitPos "UP";
			_target enableAI "AUTOCOMBAT";
			_target enableAI "CHECKVISIBLE";

			[_target] joinSilent (group _caller);

			if (primaryWeapon _target == "") then {
				_target spawn fnc_rearm;
			};
			
			"Soldier has joined your squad" remoteExec ["hint", _caller];
			sleep 3;
			"" remoteExec ["hint", _caller];
		},
		nil,
		1,
		true,
		true,
		"",
		"side player == side (group _target)",
		3
	];

};

// Get all real human beans
fnc_getPlayers = {
	
	_players = allPlayers - entities "HeadlessClient_F"; // Remove all headless clients
	_players = _players select {
		!(_x isKindOf "VirtualMan_F") 
		&& 
		(alive _x)
	};

	_players;

};

// Check if group has a player
fnc_groupHasPlayer = {
	params ["_group"];

	_hasPlayer = false;

	{

		_playerGroup = group _x;

		if (_group == _playerGroup) then {

			_hasPlayer = true;

		};

	} forEach PLAYERS;

	_hasPlayer;

};

// Debug function for checking group morale
fnc_moraleChecker = {
	params ["_group"];

	private _LOCALDEBUG = false;

	while {true} do {

		[_debug, format ["Group %1 morale: %2", _group, (morale (leader _group))]] call fnc_log;

		sleep 1;

	};

};

// Log message to player chat
fnc_log = {
	params ["_localDebug", "_message"];

	if(CONSTANT_DEBUG || _localDebug) then {

		{

			_x groupChat _message;

		} forEach PLAYERS;

	}

}