function myMain(){
	jsdebug("In myMain")
	setRefs(this)
	
	//real script here
    

}

var mmclass = new myMain(); 

//this allows the this pointer to be as expected
//seperate from userLib.js so that script control error line number is relative to this static file and not
//to the ever changing userlib.js line numbers
 
