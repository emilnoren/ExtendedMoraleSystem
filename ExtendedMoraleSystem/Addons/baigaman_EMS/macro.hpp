#define PREFIX "baigaman_EMS"
#define TITLE "Extended Morale System"
#define SETNAME(x) format["%1_%2", PREFIX, x]
#define QUOTE(s) #s
#define GVAR(x) baigaman_EMS_##x
#define SVAR(x) QUOTE(GVAR(x))