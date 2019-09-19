
 this project uses raw memory addresses files to transfer binary data from 
 vb6 to the csharp itextFilters.dll and back

 raw.dat is a sample encoded data file. the vb6 demo app will load it on startup
 press the buttons from left to right to decompress the multiple stages in sequence

 if you havent compiled the itext_filters dll then you have to use regasm to 
 register it first.

 code in iTextFilters is taken from iTextSharp see source for credits or main project
 credits file.

 to generate the .reg file for the installer 

 regasm [path]\iTextFilters.dll /regfile:test.reg

 default compile path for the dll is to the app install directory
