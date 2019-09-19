
License/Credits
------------------------------------------------------------
sclog developer David Zimmer <dzzie@yahoo.com>

sclog uses a slightly modified version of the open source x86/x64 
NTCore Hooking Engine written by: Daniel Pistelli <ntcore@gmail.com>

as well as the diStorm x86/x64 GPL disassembler engine
Copyright (C) 2003-2012 Gil Dabah. diStorm at gmail dot com.


About:
-------------------------------------------------------------

sclog is a GPL shellcode analysis project that was released 
in 2005 as part of the Malcode Analyst Pack while I was at iDefense

iDefense is no longer making this download available so I have decided to
take over support fo the code and post it on github with some additions
I have made over the years.

The git archive is here:
   https://github.com/dzzie/sclog

A training video is available here:
   http://www.youtube.com/watch?v=XBcmC4jYiRI

Initially sclog was developed to handle shellcode exploits
captured from web pages or network captures. 

This copy is an experimental build that plays with some ideas
on adapting it to handle more advanced shellcodes which are
part of file format exploits.

New options include:

    /fhand <file>       opens file handle(s) the shellcode can search for
    /showadr            Show return address for calls outside shellcode bufffer
    /log <file>         Write all output to logfile
    /alloc              

The main one of interest is the /fhand option..this allows it to try to probe
deeper into shellcodes which expect there to be an open file handle in memory
to the original file that is triggering the exploit. The main way i have seen
this done so far, is for the shellcode to call GetFileSize(x) over and over again
as x is incremented scanning for open file handles. 

(Special care had to be taken not to spam the console during this operation)

New hooks in this version include:

	ADDHOOK(GetFileSize)
	ADDHOOK(FindFirstFileA)
	ADDHOOK(VirtualAlloc)
	ADDHOOK(VirtualFree)
	ADDHOOK(GlobalAlloc)
	ADDHOOK(GlobalFree)

The alloc and free hooks, will record allocations made from within the shellcode
block. When the block is latter freed (or when the program exits) these allocations
are then dumped to disk. This is to try to capture any stage 2 shellcode stage 1
is trying to load from the parent file.

Offsets shown in the output can be in one of 5 forms.
  if the hooked call is:
    a) called from teh shellcode buffer, the relative offset is shown (to line up with disasm of dump)
    b) called from a GlobalAlloc buffer, offset relative to Galloc buf shown (prefix GAlloc:)
    c) called from a virtualAlloc buffer, offset relative to Valloc buf shown (prefix VAlloc:)
    d) /showadr will show absolute addresses of ret addr for calls outside shellcode buffer
    e) if you see --- it means call was from outside shellcode buffer

Currently it is still a bit messy in there as a jiggle things around. We are after all still
experimenting with whats needed and how to do it.


