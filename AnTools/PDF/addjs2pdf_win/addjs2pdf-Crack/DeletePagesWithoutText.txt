// DELETE PAGES WITHOUT TEXT from the PDF document
// IMPORTANT: This script assumes that page is blank if it does not contain any "pdf words"

try {

// save a copy of original document
var newName = this.path;
var filename = newName.replace(".pdf","_Original.pdf"); 
this.saveAs(filename);

for (var i = 0; i <  this.numPages; i++) 
{
	numWords = this.getPageNumWords(i);
	if (numWords == 0) 
	{
	// this page has no text, delete it
	this.deletePages(i,i);
	}
}

}
catch(e)
{
    app.alert(e);
}
