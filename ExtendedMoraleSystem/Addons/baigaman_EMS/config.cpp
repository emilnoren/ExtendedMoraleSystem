#include "script_component.hpp"

class CfgPatches {
	class ADDON {
			name = "Extended Morale System";
			author = "baigaman";
			requiredVersion = 2.14;
			requiredAddons[] = {"CBA_main", "ace_interaction", "lambs_danger"};
			units[] = {};
			weapons[] = {};
	};
};

class Extended_PostInit_EventHandlers {
	class ADDON {
		serverInit = QUOTE(call COMPILE_SCRIPT(XEH_postInit));
	};
};