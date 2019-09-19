
This is the readme file for the script interface.

couple newer ui behaviors for jsui code pane...

- custom rt click menu, several options only appear when you are rt clicking on function names
  that are listed in the function list on the left. to hex option only shows up when over
  numeric values. (all instance of it replaced throughout document)

- a navigation list is kept now. if you click around the document or navigate functions or
  use the findall dialog..your top line index is being saved as the document scrolls. it
  will store between 45-70 jumps before compacting. hit escape to navigate back. (there is
  no forward)

- there are a bunch of options in the function list right click, hot keys in ()
- there is a new graph xrefs to/from

- double click a word to select all instances (instance count shown in caption bar)
  this also works if you select a string normally (or partial)

- deobsfuscation tools -> Actioncript processor just added. assumes as3 sourcer output

- function listview supports the following hot keys:
	* n - rename function
	* r - find function references
	* x - graph to
	* z - graph from
	* f5 - refresh function list (if line numbers are off from code modifications)

- the function scanner now has support for jquery type scripts and has been sped up allot.

- if the find/replace form is open and you select a word with the shift key depressed
   the selected word will be transferred into the find textbox automatically. 
   (very useful for deobsfuscation tasks)

In addition to the standard JS features a toolbox class has been 
added with some additional functions use tb. to access

tb.Save2Clipboard(x)  //no binary data
tb.GetClipboard()    //return clipboard data
tb.t(x)             //text to lower textbox
tb.eval(x)          //text to lower textbox
tb.unescape(str)     //unicode safe
tb.alert(str)        //good for objects or strings
tb.Hexdump(str, Optional hexOnly = 0)
tb.WriteFile(path, data)
tb.ReadFile(path)
tb.HexString2Bytes(str) //ex: 9090eb05 -> chr(90) & chr(90)...
tb.Disasm(bytes)        //try: tb.t(tb.disasm(tb.unescape(%90%90%eb%05)))
tb.pad(ByVal str, cnt, Optional char = 0, Optional padleft As Boolean = True)
tb.EscapeHexString(hexstr) //ex: '9090eb05' -> %90%90%eb%05
GetStream(index) ' returns the data from the stream index listed on main form listview
CRC(x) 'returns crc32 hash of string passed in
txtOut.Text = txtOut.Text & str  //directly add txt 2 lower output textbox
GetPageNumWords(Optional page = 0) As Long
GetPageNthWord(Optional page = 0, Optional word = 0, Optional strip = 0)
Property Get pageNum() - set in main ui
Function GetListviewData(index As Long) - get the data stored in the left hand listview clipboard.


You can also use txtOut.Text to retrieve a variable in your script 
(This can be very useful if the string variable has lots of quotes in it)

When the script control is launched, the file userlib.js is also read in.
This file works with call backs in the toolbox class to build up the function
prototypes needed to support app.doc.getAnnots({nPage:0})[1].subject type calls.
it also supports extracting things like doc.info.subject. 

The this pointer in the script control always refers to the first object added to
the script control. so this.info.subject will not work. I have not been able to figure
out how to fix that.

tb.lv returns listview on js form. This way you could use tb.lv.listitems(index).tag 
to access a saved variable directly from the saved scripts listview. I also added the
tb.GetStream() function for similar use. 

The MS Script control does have some nuances. for instances 

var a = 'abc'
c = a[0] 

will not work. this must be replaced in teh scripts with a.charAt(0)

I have been adding support for adobe specific api. It may be a little buggy, but its
worth a shot to help speed up analysis.

The adobe API is huge and very dynamic, so there is no hope of ever supporting it all of it.
The few things I added are to make life easier, but at teh end of the day, you still have all
of the raw tools and data available in the interface to accomplish all the goals in other ways.

so dont be spoiled by a few easy steps :P remember malware guys goal is to break automated analysis
as much as they can.

doc.numPages()
doc.syncAnnotScan()
doc.info
doc.getAnnots

getAnnots implementation supports only the .subject variable right now.
doc.info  implementation supports arbitrary named variables like pdf does.

app.viewerVersion //taken from js ui combobox
app.alert
app.eval  //overridden
app.setInterval  //warns you and still runs it

eval is overridden
unescape is overridden

eeval is a copy of the real eval if you need it.
app.plugIns  supported
app.doc

remember you can do all these things manually, you dont need the 
adobe api to be supported intristically, its only a time saved but
dont require it as a crutch. there is to many api functions they can use
and to many nuances of them to support.

if worse comes to worse, you can update the stream in teh malicious pdf
and see the actual output as it runs natively with logging code inserted.

the no reset feature - some scripts unpack themselves in multiple stages.
occasionally latter stages utilize variables created in earlier stages. there
are as many possibilities to overcome road blocks as your mind can create.

by default streamdumper resets the script control for every run so ever script
runs fresh which wipes out previously created variables. 

If you set the no-reset option, this will not happen and these style scripts 
will be able to be run through multiple stages without problem.



