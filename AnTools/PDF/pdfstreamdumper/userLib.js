
//allot of adobe specific functions work automatically now, but there are quirks
//also function assignments to script variables of vb functions do not work
//the ms script control also does not allow strings to be referenced by character arrays
// so var a = 'abs'; alert(a[0]) does not work.
//also because the annots and info objects are loaded at script start..we cant log events
//when they are accessed, cause by then they are just data references which sucks.
//these are the limitations of using the ms script control, in the end we could never hope
//to suport the full adobe api anyway cause its huge and dynamic..so while this added 
//feature is buggy, its still useful and we are going to have to accept the good with the bad
//end of the day, you still have to be able to manually tweak these malicious scripts to 
//be able to analyze them. which is why stream dumper offers so many manual tools.
//if they try to access this inside a function it takes local scope so function exploit(){this.eval fails...

var DEBUGJS = false

function jsdebug(x){
	if(DEBUGJS) tb.DebugLog(x);
}

function AnnotClass(page,index){
   try{
	   this.subject = tb.GetSubjectForAnnot(page,index);
   }catch(e){
	   tb.alert("Failed to get subject for annot page: " + page + " index: "+index)
   }
   
}

function PluginClass(){
	this.name = "EScript"
	this.version = tb.GetViewerVersion()
	this.path = "c:\\windows\\"
}

function BSClass(){
	this.newPlayer = function(){ tb.DebugLog("Exploit", "media.newPlayer called - CVE-2009-4324") }
	this.printf = function(){ tb.DebugLog("Exploit", "util.printf() called - CVE-2008-2992") }
	this.printd = function(){;}
	this.collectEmailInfo = function(){ tb.DebugLog("Exploit", "collab.collectEmailInfo() called - CVE-2007-5659") }
	this.getIcon = function (){ tb.DebugLog("Exploit", "collab.getIcon() called - CVE-2009-0927") }	 
	this.customDictionaryOpen = function (){ tb.DebugLog("Exploit", "customDictionaryOpen called - CVE-2009-1493") }
    this.println = function(){;}  //console
    this.clear = function(){;}     //console
    this.byteToChar = String.fromCharCode	 
 
}


//this.info, doc.info
function InfoClass(){
	var xx=''
	//tb.alert("in info fields")
	f = tb.GetInfoFields()
	//tb.alert("InfoFields: " + f)
	f = f.split(",") //get csv list of names in info list
    for(i=0; i<f.length; i++){
	     if(f[i] && f[i].length > 0){
		     tmp = tb.GetInfoField( f[i] ) //get the value
		     sc = "this."+f[i]+"=tmp"      //dynamically set this.[name] = tmp
		     eval(sc)
		     eval(sc.toLowerCase()) //this.Author, this.author adobe is not case specific so we add both.
		     xx+= sc + " ("+ tmp + ")\n";
	     }
   }
   //tb.alert("info class done loading")
   jsdebug("InfoClass added: " + xx)
}

 

function getAnnots(x){
   var ret = new Array()
   cnt = tb.GetAnnotCountForPage(x.nPage)
   for(i=0; i<=cnt; i++){
     ret[i] = new AnnotClass(x.nPage, i );
   }
   return ret
}

function getStackTrace() {  
  var ret='';
  try { aa=bbdskajdklasjk /*error*/ }catch(e) {  
         var x = arguments.callee.caller.toString();  
         a = x.indexOf('function');
         while(a >= 0){
              b = x.indexOf('(');
              if(b<1) break;
              ret += x.substr(a,b-a)+'\r\n';
              x = x.substr(b);
              a = x.indexOf('function');
         }
   }
   return ret;
}  

function myEval(x){ 
	/* I wish this worked...but it doesnt.
	if(tb.AllowMicroEvals && x.length < 100){
		 tb.DebugLog("MicroEval", x)
		 eeval(x)
	}else{*/
		 tb.eval(x)
		 //todo save stack trace 
	//}
}

function myUnescape(x){ return tb.unescape(x) } //%u unescape in script control = ????'s
function myGetPageNumWords(page){ return tb.GetPageNumWords(page)}
function myGetPageNthWord(page,word,strip){ return tb.GetPageNthWord(page,word,strip) }
function alert(x){tb.alert(x)}
function setRefs(obj){  //we make one big obj for simplicity
    obj.info = info
    obj.collab = Collab
    obj.Collab = Collab
    obj.media  = media
    obj.spell = spell
    obj.util = util
    obj.doc = doc
    obj.Doc = doc
    obj.target = doc //for event.target (sometimes this is doc sometimes this should be info object...)

    obj.platform = "WIN"
	obj.syncAnnotScan = function(){}
    obj.getAnnots = getAnnots
    obj.numPages = tb.GetNumPages();
    obj.viewerVersion = tb.GetViewerVersion()
    obj.plugIns = myplugIns
    obj.getPageNumWords = myGetPageNumWords
    obj.getPageNthWord = myGetPageNthWord
    obj.pageNum = tb.GetPageNum()
    obj.printSeps = function(){ tb.DebugLog("Exploit", "printSeps called - CVE-2010-4091") }

    //general
    obj.eval = myEval 
    obj.alert = function(x){ tb.alert(x)} 
    obj.unescape = myUnescape
    obj.setInterval = function(x,y){ tb.DebugLog("setInterval",x); }
    obj.setTimeout  = function(x,y){ tb.DebugLog("setTimeout",x); }
    obj.setTimeOut  = function(x,y){ tb.DebugLog("setTimeout",x); }
    obj.clearTimeOut = function(){}
    obj.clearInterval =function(){}
    obj.clearTimeout = function(){}
    
    //for some basic html support..you can add more here..
    obj.write = function(x){ tb.DebugLog("document.write",x); }
    obj.writeln = function(x){ tb.DebugLog("document.writeln",x); }
    
    //set innerHTML(x) { tb.DebugLog("innerHTML",x); } does not work in ms script control...
  
}

var myplugIns = new Array()
myplugIns[0] = new PluginClass()
for(i=1;i<10;i++) myplugIns[i] = myplugIns[0]
    
var bullshit = new BSClass(); //no need to get to fancy
var media = bullshit
var util = bullshit
var Collab = bullshit
var collab = bullshit
var spell = bullshit
var console = bullshit

try{
   var info = new InfoClass();
}catch(e){
	jsdebug("no info object")
}

var doc = new function(){;}
jsdebug("setting refs on main object")	
setRefs(doc);

var Doc = doc
var event = doc
var App = doc
var app = doc
var document = doc
document.body = doc

//Overrides
eeval = eval         //we keep a real copy in case we need it.
eval = myEval
unescape = myUnescape

