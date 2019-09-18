#include <SQLite.au3>
#include <SQLite.dll.au3>

_SQLite_Startup()
_SQLite_SaveMode(False)
_SQLite_Exec(-1,"CREATE tblTest (a,b,c);"); No database openend, this will crash
_SQLite_Shutdown()