using System;
using System.Collections.Generic;
using System.Text;
using System.Runtime.InteropServices;
using System.IO;
using System.Windows.Forms;

namespace SharedMemory
{
    class MemMapFile  
    {
        
        [DllImport("kernel32")]
        public static extern int CreateFileMapping( int hFile, int lpAttributes, int flProtect,int dwMaximumSizeLow, int dwMaximumSizeHigh,String lpName);

        [DllImport("kernel32")]
        public static extern bool FlushViewOfFile( int lpBaseAddress, int dwNumBytesToFlush);

        [DllImport("kernel32")]
        public static extern uint MapViewOfFile(int hFileMappingObject, int dwDesiredAccess, int dwFileOffsetHigh, int dwFileOffsetLow, int dwNumBytesToMap);

        [DllImport("kernel32")]
        public static extern int OpenFileMapping(int dwDesiredAccess, bool bInheritHandle, String lpName);

        [DllImport("kernel32")]
        public static extern bool UnmapViewOfFile(uint lpBaseAddress);

        [DllImport("kernel32")]
        public static extern bool CloseHandle(int handle);

        private const int PAGE_READWRITE = 0x4;
        private const int FILE_MAP_ALL_ACCESS = 0xF001F;

        private string VFileName;
        private int MaxSize;
        private int hFile;
        private uint gAddr;

        public string ErrorMessage;
        public bool DebugMode  = false;

        ~MemMapFile()
        {
            Close();
        }

        public void Close()
        {
            UnmapViewOfFile(gAddr);
            CloseHandle(hFile);
            hFile = 0;
            gAddr = 0;
            ErrorMessage = "";
        }

        public bool GetSharedData(string memFileName, int fSize, byte[] bufOut){
            if (!CreateMemMapFile(memFileName, fSize)) return false;
            if (!ReadFile(bufOut, fSize)) return false;
            //MessageBox.Show("RetData s ize: " + ret.Length.ToString("X") + " Data[0]=" + ((int)ret[0]).ToString("X"));
            return true;
        }

        public bool CreateSharedData(byte[] data, ref string memFileNameOut)
        {
            string mFile = "";

            if (hFile != 0)
            {
                ErrorMessage = "Cannot open multiple virtural files with one class";
                return false;
            }

            for (int i = 0; i < 10; i++)
            {
                mFile = ("memFile_" + randomString(8)).ToUpper();
                if (CreateMemMapFile(mFile, data.Length)) break;
            }

            if (hFile == 0) return false;
            if (!WriteFile(data)) return false;
            memFileNameOut = mFile;
            return true;
        }

        public bool CreateMemMapFile(string fName, int mSize){

            byte[] b = new byte[mSize];
            VFileName = fName.ToUpper(); 
            MaxSize = mSize;
            
            if(hFile!=0){
                ErrorMessage = "Cannot open multiple virtural files with one class";
                return false;
            }
            
            hFile = CreateFileMapping(-1, 0, PAGE_READWRITE, 0, mSize, VFileName);

            if( hFile == 0 ){
                ErrorMessage = "Unable to create virtual file " + VFileName + " Size:" + mSize;
                return false;
            }
    
             gAddr = MapViewOfFile(hFile, FILE_MAP_ALL_ACCESS, 0, 0, mSize);

             if (gAddr == 0) return false;
             return true;
            
        }

        public bool WriteFile(byte[] bData){

            if(bData.Length == 0) return false;

            if(bData.Length > this.MaxSize){
                ErrorMessage = "Data is to large for buffer!";
                return false;
            }
    
            if(hFile==0){
                ErrorMessage = "Virtual File or Virtual File Interface not initialized";
                return false;
            }

            Marshal.Copy(bData, 0, (IntPtr)(this.gAddr), bData.Length);
            return true;
        }

        public bool ReadFile(byte[] bData, int length){

            if(length > this.MaxSize){
                ErrorMessage = "ReadLength to large for buffer!";
                return false;
            }
    
            if(hFile==0){
                ErrorMessage = "Virtual File or Virtual File Interface not initialized";
                return false;
            }

            Marshal.Copy((IntPtr)gAddr, bData,(int)0, length);
            return true;
        }

        private static string randomString(int length)
        {
            string tempString = Guid.NewGuid().ToString().ToLower();
            tempString = tempString.Replace("-", "");
            while (tempString.Length < length)
            {
                tempString += tempString;
            }
            tempString = tempString.Substring(0, length);
            return tempString;
        }

    }
}
