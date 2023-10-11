class CfgPatches {
	class baigaman_EMS {
			name = "Extended Morale System";
			author = "baigaman";
			requiredVersion = 2.14;
			requiredAddons[] = {"CBA_MAIN", "ace_interaction", "lambs_main"};
			units[] = {};
			weapons[] = {};
	};
};

class Extended_PreInit_EventHandlers {
	class baigaman_EMS {
		init = call compile preprocessFileLineNumbers "\baigaman_EMS\XEH_preInit.sqf";
	};
};

class Extended_PostInit_EventHandlers {
	class baigaman_EMS {
		init = call compile preprocessFileLineNumbers "\baigaman_EMS\XEH_postInit.sqf";
	};
};