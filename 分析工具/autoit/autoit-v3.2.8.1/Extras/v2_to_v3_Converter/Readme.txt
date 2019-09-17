----------------- INSTALLATION ------------------

After AutoIt3 installation the Translator files are in the "Extra\V2 to V3 Converter"
You can run thee _Shortcut_creation.au3 script to create a shortcut on the desktop.

And just click select the file to be translated.

Good conversion and forget about AutoItV2 :)

REPORTS problem with the sample reproducing the error or the faulty script itself
	don't forget to join the AutoItV2toV3.dat used if MODIFIED
TO JPaul-Mesnage at ifrance.com or through the http://www.autoitscript.com/forum

-------------------- HISTORY --------------------
1.06	- Added	Ignore labels not referenced
	- Fixed	default internal variable initialisation as for stringcase

1.05	- Fixed	Bad variable like a(%i%)

1.04	- Added	Fileselection to choose file to be converted
	- Fixed	Launching by drag & drop on AutoItV2toV3.exe

1.03	- Added	Update #include filename extension to .AU3
	- Added	use "include".ini function definitions if found in the folder
		containing the file being translated
	- Added	Continueloop in while statement
		for ScriptKitty satisfaction (I hope !!!)
		just add label in the [While] in *.ini
	- Added	/1 option to execute only one translation
		default now is 2 runs with the first one generating references
	- Added	Define constant parameter in function definition
		 func ( const) as opposed to func ( $par)
		will suppress SetEnv, Par, const translation except if /G used
	- Added	varname return by a function can be derived from a const param
		 func ( const) = ret$const
	- Added redefinition of internal variable. Can be used in case homonymy.
		 ex desktop = desktop will suppress internal reference to @desktop
			and produce a $desktop translation for %desktop%

	- Fixed variable name containing "-$" (substitution with "_")

1.02	- Fixed %i% = $CmdLine[$i]
	- Fixed " " after a %variable% in a string (sorry for @comspec !!!)
	- Fixed comment line with only ";" no more skipped
	- Fixed IfEqual,IfNotEqual referencing __cmp() compatibilty function
	- Fixed filename can be protected with " to contain space character
	- Fixed #include generation
	- Fixed empty value
		 for SetEnv, Send, Splash, String..., File...,Ini..., Reg...
	- Fixed String generation (starting with a protected char)

	- Added %comspec% = @Comspec
	- Added %DosEnvironment% = EnvGet('DosEnvironment')
	- Added Global variables generation when needed
	- Added Global or Environment variable can be predefined in *.ini
		/R will set what it thinks is the best !!!
	- Added correct error code handling for
	        FileReadLine, RegRead, StringReplace, StringGetPos
	- Removed /E Kamikaze option (2 runs with /R should be save)
	- Added /G force extra code Generation for ERRORLEVEL checking
		for those which get trouble with 2 runs
	- Added	a%i% -> $a[$i]. Only works if it is a variable type in V2
		 For Tylo satisfaction and my AutoItV2 code too !!!
	- Added Global variable renaming predefinition in *.ini
		 For handling simple case a%i% -> $ret to avoid __idx()
		 Only works if it is a variable type in V2 SetEnv, a%i%
	- Added Function parameter/return predefinition in *.ini

To be done

1.01	- Added Support "," in last parameter (Send, Msgbox, SetEnv, ...)
	- Added simple DO Until
	- Added %i% command line parameter
	- Added /Q /E options

	- Fixed string starting with special variable
	- Fixed WinMinimize with empty Text
		WinMaximize
		WinRestore
		WinShow
		WinHide
	- Fixed SplashTextOff

1.00 Initial release

-------------- Command Line SYNTAX --------------

	Translator AutoItV2toV3 [Version 1.0.6]
	(C) Copyright 2004 J-Paul Mesnage.

AutoItV2toV3 source [/C] [/R] [/1] [/Q] [/G] [/P] [/S] [/1] [deffile]

  /C	insertion of AutoIt V2 source line
  /R	create/update AutoIt V2 label Reference file (*.ini)
		will be reused in the next translation.
		
  /1	do only one phase translation.
  	By default Translator is called twice first time forcing /R.
  	If /R is not initialy requested, the *.ini will not be changed.

  /Q	Quit translation without stopping at completion

  /G	force extra code Generation for ERRORLEVEL checking
  	or for SetEnv used for function call constant parameter.

  /P	trace AutoIt V2 Parameters (for trouble shooting)
  /S	trace AutoIt V3 Statement  (for trouble shooting)

source	filename to be translated.
	AutoItV3 script will be created in the same directory suffixed by .AU3

deffile	allow to override the standard AutoItV2toV3.dat
	by default located in the same directory as AutoItV2toV3.exe

----------------- *.ini SYNTAX ------------------
/R option will generate/update a *.ini
   sometime it helps to force some labels before the first run
	I found the forcing func label for Stop followed by Exit
	very fruitful to solved:
	    V2			     V3		*.ini
	Goto, Stop		Stop ()		[Func]
	...					Stop
	Stop:			Func Stop ()
	Exit			Exit
				EndFunc

Each section are terminated by a blank line
No blank line inside section
Inside each section, each line will defined the type of the Label/Variable

[Func]
FuncLabel1
FuncLabel2 ( $par1,  ... ) = $retvar	; par and retvar are optional
FuncLabel3 ( const1, ... ) = $retvar	; const is the variable define
...					; in the corresponding SetEnv
...					; preceeding the Gosub
FuncLabel4 ( const, ... ) = str$const	; const is as above
...					; the translated return value
...					; will be stored in a variable
...					; whose name is concatenation
...					; of "str" and const value

[FuncDo]
as [Func] but forcing a Do at the begining

[FuncWhile]
as [Func] but forcing a While at the begining

[DoUntil]
DoUntilLabel1
...

[While]
WhileLabel1
...

[NoRef]
NoRefLabel1
...

[Global]
GlobalVariable1
GlobalVariable2[dim]			; "[dim]" is optional
GlobalVariable3 = NewName		; The AutoItV2 variable will be renamed
...					; in "NewName"

[Environment]
EnvironmentVariable1
...

[ReturnError]
Linenumber1				; input source linenumber where the
...					; setting of error code will be forced
...					; to go around case the checking
...					; is not generated the line after

----------------- Sample *.ini ------------------
[Func]
MyRoutine
MyRoutineWithPar ( $par1, $par2)
MyFunction ( $par1) = $ret
MyFunctionWithConstant ( par1) = $ret

[Global]
_var
_%_Str% = _str_

[Environment]
USERPROFILE
ProgramFiles

--------------------- HINTS ---------------------
0. don't expect a 100% translation.

1. source MUST run under AutoItV2 without ERRORS.
2. simple "if then else endif" will be detected even nested.
3. simple "while wend" even nested.
4. it is better to have a label only reference once.

5. for script with ERRORLEVEL checking not working use /G to generate extra code
   or if a SetEnv corresponding to a constant parameter is badly suppress
6. use /1 to run only one run translation at a time.
   Needed if the *.ini must be changed manualy before second run

7. noodle GOTO will not translate.
8. combined endif GOTO may not be translated
	ex: if...,Goto, endif1
		...
		if..., Goto, endif1
			...
			if..., Goto, else1
				...
				goto, endif1
			else1:
				...
	    endif1:
