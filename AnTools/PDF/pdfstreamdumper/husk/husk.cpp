
#include <windows.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdarg.h>
#include <conio.h>

//8.23.12
//		moved shellcode buf to its own segment and exported by name
//		-opts now standardized top /opt
//		added handled flag to cmdline parser and bail on unknown option..

#pragma data_seg (".sc")
int buf[6000] = {0xC3CCCCC3};
#pragma data_seg()
#pragma comment(linker, "/SECTION:.sc,RWE")

void usage(){
	system("cls");
	printf("\n\nHUSK.EXE - Wrapper that allows shellcode to be embedded and executed\n\n");
	printf("Supports the following command line options:\n\n");
	printf("    /break             Inserts breakpoint before shellcode buffer is called.\n");
	printf("    /fopen <file>      Opens a handle to <file> for shellcode to search for.\n");
	printf("    /dll <dllfile>     Loads <dllfile> (add to memory map or use api_log.dll)\n"); 
	printf("    /foff hexnum       Starts execution at file offset\n"); 
	printf("    /va 0xBase-0xSize  VirtualAlloc memory at 0xBase of 0xSize\n\n"); 
	printf("Shellcode buffer VirtualAddress: 0x%x \n\n", &buf);
	exit(0);
}

int main(int argc, char* argv[])
{
	int break_mode = 0;
    int fHand = NULL;
	int foff = 0;
	OFSTRUCT o;
	WSADATA WsaDat;	
	
	if ( WSAStartup(MAKEWORD(1,1), &WsaDat) !=0  ){  
		printf("WSAStartup failed exiting.."); 
		return 0;
	}

	for(int i=1; i<argc; i++){
		
		bool handled = false;
		if( argv[i][0] == '-') argv[i][0] = '/'; //standardize

		if(strstr(argv[i],"/h") > 0 ){usage(); return 0;}
		if(strstr(argv[i],"/?") > 0 ){usage(); return 0;}

		if(strstr(argv[i],"/break") > 0 ){ break_mode=1;handled=true;};

		if(strstr(argv[i],"/fopen") > 0 ){ 
			if(i+1 >= argc){
				printf("/fhand no argument found\n");
				exit(0);
			}else{
				char* target = argv[i+1];
				fHand = OpenFile(target, &o , OF_READ);
				if(fHand==HFILE_ERROR){
					printf("Option /fopen Could not open file %s\r\n", target);
					exit(0);
				}else{
					printf("Successfully opened a handle (0x%X) to %s\r\n", fHand, target);
					i++;handled=true;
				}
			}
		}

		if(strstr(argv[i],"/va") > 0 ){
			if(i+1 >= argc){
				printf("Invalid option /va must specify 0xBase-0xSize as next arg\n");
				exit(0);
			}
		    char *ag = strdup(argv[i+1]);
			char *sz;
			unsigned int size=0;
			unsigned int base=0;
			if (( sz = strstr(ag, "-")) != NULL)
			{
				*sz = '\0';
				sz++;
				size = strtol(sz, NULL, 16);
				base = strtol(ag, NULL, 16);
				int r = (int)VirtualAlloc((void*)base, size, MEM_RESERVE | MEM_COMMIT, 0x40 );
				printf("VirtualAlloc(base=%x, size=%x) = %x - %x\n", base, size, r, r+size);
				if(r==0){ printf("ErrorCode: %x\nAborting...\n", GetLastError()); exit(0);}
				//0x57 = ERROR_INVALID_PARAMETER 
				i++;handled=true;

			}else{
				printf("Invalid option /va must specify 0xBase-0xSize as next arg\n");
				exit(0);
			}
		}

		if(strstr(argv[i],"/dll") > 0 ){
			if(i+1 >= argc){
				printf("Invalid option /dll must specify dll to load as next arg\n");
				exit(0);
			}
			int hh = (int)LoadLibrary(argv[i+1]);
			printf("LoadLibrary(%s) = 0x%x\n", argv[i+1], hh);
			i++;handled=true;
		}

		if(strstr(argv[i],"/foff") > 0 ){
			if(i+1 >= argc){
				printf("Invalid option /foff must specify start file offset as next arg\n");
				exit(0);
			}
			foff = strtol(argv[i+1], NULL, 16);
			printf("Starting at file offset 0x%x\n", foff);
			i++;handled=true;
		}

		if( !handled ){
			printf("Unknown Option %s\n\n", argv[i]);
			usage();
			return 0;
		}


	}

	unsigned char* c = (unsigned char*)buf;
	if(foff > 0) printf("Start opcodes: %04x    %02x %02x %02x %02x %02x\n", foff, c[foff],c[foff+1],c[foff+2],c[foff+3],c[foff+4]);

	int* pBuf = buf;

	int (*sc)();
	sc = (int (*)())&buf[foff]; //9.7.12 no more inline asm...

	if(break_mode) DebugBreak();
	(int)(*sc)();

	/*
	_asm{
		   mov eax, pBuf
		   mov ebx, foff
		   mov ecx, break_mode
		   add eax, ebx
		   cmp ecx, 1
		   jnz no_break
		   int 3
no_break:
		   jmp eax
	}
	*/


}
