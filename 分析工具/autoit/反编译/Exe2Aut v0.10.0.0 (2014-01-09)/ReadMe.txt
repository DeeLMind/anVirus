
; **********************************                                                                                           Jan 2014
; * Exe2Aut v0.10                  *
; * a tiny AutoIt3 decompiler      *
; *                        by link *
; **********************************

homepage: https://exe2aut.com/

should support
v3.2.6.0 - v3.3.11.2

Exe2Aut.exe [-nogui] [-quiet] [...] filename

  -nogui          launch without gui, try to decompile, report back and close afterwards
  -quiet          don't show any messages (for "-nogui"), a nonzero exit-code indicates success
  -nofiles        don't extract files embedded via FileInstall

  -uninstall      delete registry keys and exit

  filename        optional if -nogui isn't specified


Disclaimer:
  Start Exe2Aut.exe without -nogui to see the disclaimer.

How to use:
  Drag&drop an AutoIt3 exe-file into Exe2Aut's window or pass its filename via the commandline.
  For increased security, it's advised to invoke Exe2Aut with a sandbox-tool like Sandboxie or the like.

Greetz to:
scbiz, terrornerd, cw2k, CyRuSTheViRuS, fasm community, Sirius_White & others.










version 0.01 (Sep 13, 2011)

[!] Initial release (only v3.3.6.1 supported)

version 0.02 (Sep 14, 2011)

[+] added support for various versions

[-] fixed a small indentation error

version 0.03 (Sep 17, 2011)

[+] added support for rest of v3.2.6.0 to v3.3.7.15

[+] added support for armadillo packed files

version 0.04b (Oct 05, 2011)

[+] added capitalization of functions, keywords, #-directives and macros

[+] added extraction of fileinstalls

version 0.05 (Oct 26, 2011)

[+] added commandline switches

[-] fixed space errors and #-directive capitalization

[-] fixed a font bug in the gui

version 0.06 (Dec 17, 2011)

[+] added support for armadillo packed files with memory patching protection

[+] added quick&dirty deobfuscation for Jos van der Zande Obfuscator v1.0.29.0

[-] fixed a crash which occurred when only a filename instead of a full path was passed

version 0.07b (Feb 17, 2012)

[+] added rudimentary support for 64bit files

version 0.08 (Dec 25, 2013)

[!] rewritten from scratch for unicode

[!] changed versioning (previous version was 'v6'/0.07b)

[!] removed 64bit-support & deobfuscation until it's more stable

[+] added support for up to v3.3.10.0

[-] fixed some minor code generation flaws

version 0.09 (Jan 05, 2014)

[+] added support for safengine packed files

[+] added support for Undecompile It by M3 modified files

[-] fixed extraction of fileinstalls

version 0.10 (Jan 09, 2014)

[+] added support for v3.3.11.0 to v3.3.11.2

[+] added support for enigma packed files

[+] added #region-indentation

[-] fixed a small bug which occurred when invoking Exe2Aut twice

[-] fixed -nofiles commandline option
