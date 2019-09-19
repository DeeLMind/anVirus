#include "fitz.h"
#include "fitz-internal.h"
#include <stdio.h>
#include <windows.h>
#include <conio.h>

extern int read_ahxd(fz_stream *stm, unsigned char *buf, int len);
extern void close_ahxd(fz_context *ctx, void *state_);

extern int read_jbig2d(fz_stream *stm, unsigned char *buf, int len);
extern void close_jbig2d(fz_context *ctx, void *state_);

extern void close_faxd(fz_context *ctx, void *state_);
extern int read_faxd(fz_stream *stm, unsigned char *buf, int len);

/*
int file_length(FILE *f)
{
	int pos;
	int end;

	pos = ftell (f);
	fseek (f, 0, SEEK_END);
	end = ftell (f);
	fseek (f, pos, SEEK_SET);

	return end;
}

unsigned int LoadFile(char* path, unsigned char** bufOut){

	unsigned int fsize = 0;
	FILE* fp = fopen(path, "rb");
	if(fp==0) return 0;
	fsize = file_length(fp);
	if(fsize == 0) return 0;
	*bufOut = (unsigned char*)malloc(fsize); 
	fread(*bufOut, 1, fsize, fp);
	fclose(fp);
	return fsize;

}

void hexdump(unsigned char* str, int len, int offset, bool hexonly){
	
	char asc[19];
	int aspot=0;
	int i=0;
    int hexline_length = 3*16+4;
	
	char *nl="\n";
	char *tmp = (char*)malloc(75);

	if(!hexonly) printf(nl);
	
	if(offset >=0){
		printf("        0  1  2  3  4  5  6  7   8  9  A  B  C  D  E  F\n");
		printf("%04x   ", offset);
	}

	for(i=0;i<len;i++){

		sprintf(tmp, "%02x ", str[i]);
		printf("%s",tmp);
		
		if( (int)str[i]>20 && (int)str[i] < 123 ) asc[aspot] = str[i];
		 else asc[aspot] = 0x2e;

		aspot++;
		if(aspot%8==0) printf(" "); //to make figuring out offset easier

		if(aspot%16==0){
			asc[aspot]=0x00;
			if(!hexonly){
				sprintf(tmp,"    %s\n", asc);
				printf("%s",tmp);
			}
			if(offset >=0){
				offset += 16;
				if(i+1 != len) printf("%04x   ", offset);
			}
			aspot=0;
		}

	}

	if(aspot%16!=0){//print last ascii segment if not full line
		if(!hexonly){
			int spacer = hexline_length - (aspot*3);
			while(spacer--)	printf("%s"," ");	
			asc[aspot]=0x00;
			sprintf(tmp, "%s\n",asc);
			printf("%s",tmp);
		}
	}
	
	if(!hexonly) printf("%s",nl);
	free(tmp);

}
*/

//returns a malloced unsigned char*  of *bufSz
int __stdcall AsciiHexDecode(char* buf, unsigned char** bufOut){

	try{
	   int l = strlen(buf);
	   int sz = 0;
		
	   *bufOut = (unsigned char*)malloc(l);
	   if((int)*bufOut==0) return 0;

	   memset(*bufOut,0,l);
	   fz_stream* s = fz_open_memory(0, (unsigned char*)buf, l);
	   fz_stream* s2 = fz_open_ahxd(s);
	   sz = read_ahxd(s2, *bufOut, l);
	   close_ahxd(0, s2->state);  
	   fz_close(s);
	   fz_free(0,s);
	   fz_free(0,s2);
	   return sz;
	}
	catch(...){
		return 0;
	}

}

void __stdcall FreeBuffer(unsigned char** bufOut){
	//this way we are sure we are using the same version of the vcrt to do the freeing...
	free(*bufOut);
}

//returns a malloced unsigned char*  of *bufSz
//mem leak could exist based on where error was thrown..
int __stdcall JBIG2Decode(unsigned char* buf, int sz, unsigned char** bufOut){
   //_asm int 3

	//try{ //i want to know if this crashs anywhere right now..seems stable in bulk testing so far..
	   fz_stream * s = fz_open_memory(0, (unsigned char*)buf, sz);
	   fz_stream * s2 = fz_open_jbig2d(s, NULL);
	   int bufsz = sz * 20; //should be big enough...
	   *bufOut = (unsigned char*)malloc(bufsz);
	   if((int)*bufOut==0) return 0;
	   int r = read_jbig2d(s2, *bufOut, bufsz);
	   close_jbig2d(0, s2->state); 
	   fz_close(s);
	   fz_free(0,s);
	   fz_free(0,s2);
	   return r;	
	/*}
	catch(...){
		return 0;
	}*/

}

//returns a malloced unsigned char*  of *bufSz
/* Default: columns = 1728, end_of_block = 1, the rest = 0 */
int __stdcall FaxDecode(unsigned char* buf, int sz, unsigned char** bufOut, 
			  int cols=1728, int rows=0, int k=0, int end_of_line=0, int encoded_byte_align=0,
			  int end_of_block=1, int black_is_1=0)
{
	try{
	   int r = 0 ;
	   fz_stream * s = fz_open_memory(0, (unsigned char*)buf, sz);
	   fz_stream * s2 = fz_open_faxd(s, k, end_of_line, encoded_byte_align,
									 cols, rows, end_of_block, black_is_1);
	   int bufsz = sz * 20; //should be big enough...
	   *bufOut = (unsigned char*)malloc(bufsz);
	   if((int)*bufOut==0) return 0;
	   r = read_faxd(s2,*bufOut, bufsz);  //can throw many errors on purpose...
	   close_faxd(0, s2->state); 
	   fz_close(s);
	   fz_free(0,s);
	   fz_free(0,s2);
	   return r;	
	 }
	 catch(...){
		  return 0;
	 }

}





/*
void test_ashx(){
   int sz=0;
   unsigned char* msg = AsciiHexDecode("6D796D65737361676500", &sz);
   printf("decoded size = %d\n",sz);
   printf("decoded msg %s\n", msg);
   free(msg);
}

void test_jbig(){
   unsigned char* buf = 0;
   unsigned char* decoded = 0;
   int sz=0;

   char* f = "c:\\bad.jb2";
   sz = LoadFile(f, &buf);
   if(sz==0){
	   printf("Failed to load file %s", f);
	   return ;
   }

   printf("File loaded size: %d   buf: %x\n",sz, (int)buf);
   sz = JBIG2Decode(buf,sz,&decoded);

   if(sz==0){
	   printf("Could not decode JBIG2 Stream");
	   return ;
   }
   
   if(decoded==0){
	   printf("*decode was 0? alloc failed?");
	   return ;
   }

   printf("Decode result: %d\n",sz);
   hexdump(decoded,0x30,0,false);
   unlink("C:\\out.bin");
   FILE *fp = fopen("C:\\out.bin","wb");
   fwrite(decoded,1,sz,fp);
   fclose(fp);
   free(decoded);

}

int testFax(){
   unsigned char* buf = 0;
   unsigned char* decoded = 0;
   int sz=0;

   char* f = "c:\\ccit_hex.bin";
   sz = LoadFile(f, &buf);
   if(sz==0){
	   printf("Failed to load file %s", f);
	   return 0;
   }

   printf("File loaded size: %d   buf: %x\n",sz, (int)buf);
   sz = FaxDecode(buf, sz, &decoded, 28176,1);

   if(sz==0){
	   printf("Could not decode CCTIFax Stream");
	   return 0;
   }
   
   if(decoded==0){
	   printf("*decode was 0? alloc failed?");
	   return 0;
   }

   printf("Decode result: %d\n",sz);
   hexdump(decoded,0x30,0,false);
   unlink("C:\\out.bin");
   FILE *fp = fopen("C:\\out.bin","wb");
   fwrite(decoded,1,sz,fp);
   fclose(fp);
   free(decoded);
}
*/

/*
	/Filter [ /FlateDecode /CCITTFaxDecode ] /DecodeParms [ null 
	<<
		 /Columns 26128 /Rows 2 
	>>
	ccit_data.bin is already flatedecoded...
* /
else if (!strcmp(s, "CCITTFaxDecode") || !strcmp(s, "CCF"))
	
		pdf_obj *k = pdf_dict_gets(p, "K");
		pdf_obj *eol = pdf_dict_gets(p, "EndOfLine");
		pdf_obj *eba = pdf_dict_gets(p, "EncodedByteAlign");
		pdf_obj *columns = pdf_dict_gets(p, "Columns");
		pdf_obj *rows = pdf_dict_gets(p, "Rows");
		pdf_obj *eob = pdf_dict_gets(p, "EndOfBlock");
		pdf_obj *bi1 = pdf_dict_gets(p, "BlackIs1");
		if (params)
		{
			/* We will shortstop here * /
			params->type = PDF_IMAGE_FAX;
			params->u.fax.k = (k ? pdf_to_int(k) : 0);
			params->u.fax.eol = (eol ? pdf_to_bool(eol) : 0);
			params->u.fax.eba = (eba ? pdf_to_bool(eba) : 0);
			params->u.fax.columns = (columns ? pdf_to_int(columns) : 1728);
			params->u.fax.rows = (rows ? pdf_to_int(rows) : 0);
			params->u.fax.eob = (eob ? pdf_to_bool(eob) : 1);
			params->u.fax.bi1 = (bi1 ? pdf_to_bool(bi1) : 0);
			return chain;

			<<
	/Length 65932
	/Filter [/ASCIIHexDecode /CCITTFaxDecode /ASCIIHexDecode /FlateDecode] /DecodeParms [ null 
	<<
		 /Columns 28176 /Rows 1 
	>>
	 ]
	/Length1 9684
>>


*/

