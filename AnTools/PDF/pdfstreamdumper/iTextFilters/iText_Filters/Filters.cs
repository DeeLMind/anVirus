using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using System.util.zlib;
using iTextSharp.text.pdf;        //we only use the 3.3mb iTextSharp for Decrypt and its zlib implementation
using iTextSharp.text.factories;  //the decrypt feature doesnt help that often destroys things as it rebuilds . - remove this external dependancy?
using com.sun.pdfview.CCITTFaxDecoder;  //Copyright (c) 2001 Sun Microsystems, Copyright (c) 2007, intarsys consulting GmbH

//todo implement SetFaxParams, and add CCITTFaxDecoder enum and handler...main decoder block already ported and debugged

namespace iTextFilters
{
    public enum mDecoders
    {
        RunLengthDecode = 0,
        FlateDecode = 1,
        ASCIIHexDecode = 2,
        ASCII85Decode = 3,
        LzwDecode = 4,
        DecodePredictor = 5,
        DCTDecode = 6,        /*unsupported*/
        CCITTFaxDecode = 7,
        JBIG2Decode = 8,      /*uses native mupdf code*/
        JPXDecode = 9        /*unsupported*/
    }

    public interface ICDecoder
    {
        string ErrorMessage { get; }
        bool Debug { get; set; }
        void ReleaseMem();
        void SetPredictorParams(int predictor, int columns, int colorss, int bitspercomponent);
        bool Decode(ref int address, ref int bufSize, mDecoders method);
        bool Decrypt(string infile, string outfile);
    }

    public class MemDecoder : ICDecoder
    {  
            private bool DebugMode = false;
            private string mErrorMessage = "";
            private int mAllocAddr = 0;
            private int mAllocSize = 0;

            private int mpredictor = 1;
            private int mcolumns = 1;
            private int mcolors = 1;
            private int mbitspercomponent = 8;

            //private int mcolumns = 1728;
            private int mrows = 0 ;
            private int mk = 0;
            private int mend_of_line = 0;        
            private int mencoded_byte_align = 0;
            private int mend_of_block = 1;
            private int mblack_is1 = 0;

            public void SetPredictorParams(int predictor, int columns, int colors, int bitspercomponent)
            {
                mpredictor = predictor;
                if (columns > 0) mcolumns = columns;
                if (colors > 0) mcolors = colors;
                if (bitspercomponent > 0) mbitspercomponent = bitspercomponent;
            }

            public void SetFaxParams(int columns,int rows, int k ,int end_of_line, int encoded_byte_align, int end_of_block, int black_is1)
            {
                 mcolumns = columns;
                 mrows = rows ;
                 mk = k;
                 mend_of_line = end_of_line;
                 mencoded_byte_align = encoded_byte_align;
                 mend_of_block = end_of_block;
                 mblack_is1 = black_is1;
            }

            public string ErrorMessage { get { return mErrorMessage; } }
            public bool Debug { get { return DebugMode; } set { DebugMode = value; } }

            public void ReleaseMem(){ 
                    if(mAllocAddr!=0){
                        try { Marshal.FreeHGlobal((IntPtr)mAllocAddr); }
                        catch (Exception e) { }; 
                        mAllocAddr = 0;
                    }
            }
 
            public bool Decode(ref int address, ref int bufSize, mDecoders method){

                    byte[] buf;
                    byte[] bufIn = new byte[bufSize];

                    if (mAllocAddr != 0) ReleaseMem();
                        
                    try
                    {

                        Marshal.Copy((IntPtr)address, bufIn, 0, bufSize);
                        
                        if (DebugMode) MessageBox.Show("itf> Received Data size: " + bufIn.Length.ToString("X") + "Data:\n\n" + HexDumper.HexDump(bufIn));

                        switch (method)
                        {
                            case mDecoders.FlateDecode:     buf = ByteDecoder.FlateDecode(bufIn, true); break;
                            case mDecoders.ASCIIHexDecode:  buf = ByteDecoder.ASCIIHexDecode(bufIn); break;
                            case mDecoders.ASCII85Decode:   buf = ByteDecoder.ASCII85Decode(bufIn); break;
                            case mDecoders.LzwDecode:       buf = ByteDecoder.LzwDecode(bufIn); break;
                            case mDecoders.RunLengthDecode: buf = ByteDecoder.RunLengthDecode(bufIn); break;
                            case mDecoders.DecodePredictor: buf = ByteDecoder.DecodePredictor(bufIn, mpredictor, mcolumns, mcolors, mbitspercomponent); break;
                            case mDecoders.CCITTFaxDecode:  buf = ByteDecoder.FaxDecode(bufIn, mcolumns, mrows, mk, mencoded_byte_align, mblack_is1); break;  
                            default:
                                        mErrorMessage = "Unknown decode method: " + method ;
                                        return false;
                        }

                        if (buf.Length == 0)
                        {
                            mErrorMessage = "iText_Filters Error: decoded buffer length=0";
                            return false;
                        }

                        if (DebugMode) MessageBox.Show("itf> ByteDecoder output size: " + buf.Length.ToString("X") + "Data:\n\n" + HexDumper.HexDump(buf));

                        mAllocSize = buf.Length;
                        mAllocAddr = (int)Marshal.AllocHGlobal(mAllocSize);
                        Marshal.Copy(buf, 0, (IntPtr)mAllocAddr, mAllocSize); 

                        address = mAllocAddr; //these are byref so we pass back the new memory address and size like this
                        bufSize = mAllocSize;
                        return true;

                    }
                    catch (Exception e)
                    {
                        if (DebugMode) MessageBox.Show("itf> Exception Caught: " + e.ToString() );
                        mErrorMessage = "iText_Filters Error: Caught Exception: " + e.ToString();
                        return false;
                    }
                }

            public bool Decrypt(string infile, string outfile)
            {
                if (!File.Exists(infile)){
                    mErrorMessage = "iTextFilters.Decrypt Could not find infile: " + infile;
                    return false;
                }

                if (File.Exists(outfile)){
                    mErrorMessage = "iTextFilters.Decrypt Outfile already exists bailing: " + outfile;
                    return false;
                }

                try{
                    FileStream FileOutputStream = new FileStream(outfile, System.IO.FileMode.OpenOrCreate);
                    PdfReader.unethicalreading = true;
                    PdfReader reader1 = new PdfReader(infile);
                    PdfCopyFields copy = new PdfCopyFields(FileOutputStream);
                    copy.AddDocument(reader1);
                    copy.Close();
                    return true;
                }
                catch (Exception e){
                    mErrorMessage = "iTextFilters.Decrypt Caught Exception: \n\n" + e.ToString();
                    return false;
                }

            }
         
    }


    static class ByteDecoder
    {
        private static bool IsWhitespace(int ch)
        {
            return (ch == 0 || ch == 9 || ch == 10 || ch == 12 || ch == 13 || ch == 32);
        }

        private static int GetHex(int v)
        {
            if (v >= '0' && v <= '9')
                return v - '0';
            if (v >= 'A' && v <= 'F')
                return v - 'A' + 10;
            if (v >= 'a' && v <= 'f')
                return v - 'a' + 10;
            return -1;
        }

        
        public static byte[] FlateDecode(byte[] inp, bool strict)
        {
            MemoryStream stream = new MemoryStream(inp);
            ZInflaterInputStream zip = new ZInflaterInputStream(stream);
            MemoryStream outp = new MemoryStream();
            byte[] b = new byte[strict ? 4092 : 1];
            try
            {
                int n;
                while ((n = zip.Read(b, 0, b.Length)) > 0)
                {
                    outp.Write(b, 0, n);
                }
                zip.Close();
                outp.Close();
                return outp.ToArray();
            }
            catch
            {
                if (strict)
                    return null;
                return outp.ToArray();
            }
        }
        

        //ported from pdf-parser - Didier Stevens 2010/01/09 - couldnt find in iText??
        public static byte[] RunLengthDecode(byte[] data)
        {
            MemoryStream input = new MemoryStream(data);
            MemoryStream decompressed = new MemoryStream();
            byte b;

            int runLength = input.ReadByte();
            while (runLength > 0)
            {
                if (runLength < 128)
                { //if runLength < 128: decompressed += f.read(runLength + 1)
                    for (int i = 0; i < runLength + 1; i++)
                    {
                        b = (byte)input.ReadByte();
                        decompressed.WriteByte(b);
                    }
                }
                /*if (runLength > 128)
                { //if runLength > 128 decompressed += f.read(1) * (257 - runLength)
                    for (int i = 1; i < (257 - runLength); i++)
                    {
                        b = (byte)input.ReadByte();
                        decompressed.WriteByte(b);
                    }
                }*/
                if (runLength > 128) //Koji Ando patch 11.27.16
                 { //if runLength > 128 decompressed += f.read(1) * (257 - runLength)
                    b = (byte)input.ReadByte();
                    for (int i = 0; i < (257 - runLength); i++)
                     {
                         decompressed.WriteByte(b);
                     }
                 }
                if (runLength == 128) break;

                runLength = input.ReadByte();
            }

            return decompressed.ToArray();

        }

        public static byte[] LzwDecode(byte[] data)
        {
            try
            {
                LZWDecoder lzw = new LZWDecoder();
                MemoryStream stream = new MemoryStream();
                lzw.Decode(data, stream);
                return stream.GetBuffer();
            }
            catch (Exception e)
            {
                //mErrorMessage = "LZW Decode Error: " + e.ToString();
                //MessageBox.Show(e.ToString() );
            }
            return new byte[0];
        }

        public static byte[] ASCII85Decode(byte[] inp)
        {
            MemoryStream outp = new MemoryStream();
            int state = 0;
            int[] chn = new int[5];
            for (int k = 0; k < inp.Length; ++k)
            {
                int ch = inp[k] & 0xff;
                if (ch == '~')
                    break;
                if (IsWhitespace(ch))
                    continue;
                if (ch == 'z' && state == 0)
                {
                    outp.WriteByte(0);
                    outp.WriteByte(0);
                    outp.WriteByte(0);
                    outp.WriteByte(0);
                    continue;
                }
                if (ch < '!' || ch > 'u')
                    throw new ArgumentException("llegal.character.in.ascii85decode");
                chn[state] = ch - '!';
                ++state;
                if (state == 5)
                {
                    state = 0;
                    int rx = 0;
                    for (int j = 0; j < 5; ++j)
                        rx = rx * 85 + chn[j];
                    outp.WriteByte((byte)(rx >> 24));
                    outp.WriteByte((byte)(rx >> 16));
                    outp.WriteByte((byte)(rx >> 8));
                    outp.WriteByte((byte)rx);
                }
            }
            int r = 0;
            // We'll ignore the next two lines for the sake of perpetuating broken PDFs
            //            if (state == 1)
            //                throw new ArgumentException(MessageLocalization.GetComposedMessage("illegal.length.in.ascii85decode"));
            if (state == 2)
            {
                r = chn[0] * 85 * 85 * 85 * 85 + chn[1] * 85 * 85 * 85 + 85 * 85 * 85 + 85 * 85 + 85;
                outp.WriteByte((byte)(r >> 24));
            }
            else if (state == 3)
            {
                r = chn[0] * 85 * 85 * 85 * 85 + chn[1] * 85 * 85 * 85 + chn[2] * 85 * 85 + 85 * 85 + 85;
                outp.WriteByte((byte)(r >> 24));
                outp.WriteByte((byte)(r >> 16));
            }
            else if (state == 4)
            {
                r = chn[0] * 85 * 85 * 85 * 85 + chn[1] * 85 * 85 * 85 + chn[2] * 85 * 85 + chn[3] * 85 + 85;
                outp.WriteByte((byte)(r >> 24));
                outp.WriteByte((byte)(r >> 16));
                outp.WriteByte((byte)(r >> 8));
            }
            return outp.ToArray();
        }

        public static byte[] DecodePredictor(byte[] inp, int predictor, int columns, int colorss, int bitspercomponent)
        {
            if (predictor < 10) return inp;

            int width = 1;
            if (columns > 0) width = columns;

            int bpc = 8;
            if (bitspercomponent > 0) bpc = bitspercomponent;

            int colors = 1;
            if (colorss > 0) colors = colorss;

            MemoryStream dataStream = new MemoryStream(inp);
            MemoryStream fout = new MemoryStream(inp.Length);
            int bytesPerPixel = colors * bpc / 8;
            int bytesPerRow = (colors * width * bpc + 7) / 8;
            byte[] curr = new byte[bytesPerRow];
            byte[] prior = new byte[bytesPerRow];

            // Decode the (sub)image row-by-row
            while (true)
            {
                // Read the filter type byte and a row of data
                int filter = 0;
                try
                {
                    filter = dataStream.ReadByte();
                    if (filter < 0)
                    {
                        return fout.ToArray();
                    }
                    int tot = 0;
                    while (tot < bytesPerRow)
                    {
                        int n = dataStream.Read(curr, tot, bytesPerRow - tot);
                        if (n <= 0)
                            return fout.ToArray();
                        tot += n;
                    }
                }
                catch
                {
                    return fout.ToArray();
                }

                switch (filter)
                {
                    case 0: //PNG_FILTER_NONE
                        break;
                    case 1: //PNG_FILTER_SUB
                        for (int i = bytesPerPixel; i < bytesPerRow; i++)
                        {
                            curr[i] += curr[i - bytesPerPixel];
                        }
                        break;
                    case 2: //PNG_FILTER_UP
                        for (int i = 0; i < bytesPerRow; i++)
                        {
                            curr[i] += prior[i];
                        }
                        break;
                    case 3: //PNG_FILTER_AVERAGE
                        for (int i = 0; i < bytesPerPixel; i++)
                        {
                            curr[i] += (byte)(prior[i] / 2);
                        }
                        for (int i = bytesPerPixel; i < bytesPerRow; i++)
                        {
                            curr[i] += (byte)(((curr[i - bytesPerPixel] & 0xff) + (prior[i] & 0xff)) / 2);
                        }
                        break;
                    case 4: //PNG_FILTER_PAETH
                        for (int i = 0; i < bytesPerPixel; i++)
                        {
                            curr[i] += prior[i];
                        }

                        for (int i = bytesPerPixel; i < bytesPerRow; i++)
                        {
                            int a = curr[i - bytesPerPixel] & 0xff;
                            int b = prior[i] & 0xff;
                            int c = prior[i - bytesPerPixel] & 0xff;

                            int p = a + b - c;
                            int pa = Math.Abs(p - a);
                            int pb = Math.Abs(p - b);
                            int pc = Math.Abs(p - c);

                            int ret;

                            if ((pa <= pb) && (pa <= pc))
                            {
                                ret = a;
                            }
                            else if (pb <= pc)
                            {
                                ret = b;
                            }
                            else
                            {
                                ret = c;
                            }
                            curr[i] += (byte)(ret);
                        }
                        break;
                    default:
                        // Error -- uknown filter type
                        throw new Exception("png.filter.unknown");
                }
                fout.Write(curr, 0, curr.Length);

                // Swap curr and prior
                byte[] tmp = prior;
                prior = curr;
                curr = tmp;
            }
        }

        public static byte[] ASCIIHexDecode(byte[] inp)
        {
            MemoryStream outp = new MemoryStream();
            bool first = true;
            int n1 = 0;
            for (int k = 0; k < inp.Length; ++k)
            {
                int ch = inp[k] & 0xff;
                if (ch == '>') break;
               
                if (IsWhitespace(ch))
                {
                    continue;
                }
                int n = GetHex(ch);
                if (n == -1)
                    throw new ArgumentException("illegal.character.in.asciihexdecode");
                if (first)
                {
                    n1 = n;
                }
                else
                {
                    byte b = (byte)((n1 << 4) + n);
                    outp.WriteByte(b);
                }
                first = !first;
            }
            if (!first) outp.WriteByte((byte)(n1 << 4));            

            return outp.ToArray();
        }

        //not implemented into decode loop yet but debugged already...
        public static byte[] FaxDecode(byte[] src, int columns, int rows, int k, int encodedByteAlign, int blackIs1)
        {

            sbyte[] source = (sbyte[])(Array)src;
            int size = rows * ((columns + 7) >> 3);
            sbyte[] destination = new sbyte[size];

            CCITTFaxDecoder decoder = new CCITTFaxDecoder(1, columns, rows);
            decoder.alignProperty = encodedByteAlign == 0 ? true : false;
            if (k == 0)
            {
                decoder.decodeT41D(destination, source, 0, rows);
            }
            else if (k > 0)
            {
                decoder.decodeT42D(destination, source, 0, rows);
            }
            else if (k < 0)
            {
                decoder.decodeT6(destination, source, 0, rows);
            }
            if (blackIs1 == 0)
            {
                for (int i = 0; i < destination.Length; i++)
                {
                    // bitwise not
                    destination[i] = (sbyte)~destination[i];
                }
            }

            return (byte[])(Array)destination;
        }


    }

    static class HexDumper
    {

        private const int LineLen = 16;
        private static int bCount = 0;
        private static byte[] bytes = new byte[LineLen];
        private static StringBuilder buf;

        public static string HexDump(string str)
        {
            buf = new StringBuilder();
            char[] ch = str.ToCharArray();
            for (int i = 0; i < ch.Length; i++) AddByte((byte)ch[i], (i == ch.Length - 1));
            return buf.ToString();
        }

        public static string HexDump(byte[] b)
        {
            buf = new StringBuilder();
            for (int i = 0; i < b.Length; i++) AddByte(b[i], (i == b.Length - 1));
            return buf.ToString();
        }

        private static void AddByte(byte b, bool final)
        {

            bytes[bCount++] = b;
            if (!final) if (bCount != LineLen) return;
            if (bCount <= 0) return;

            //main dump section
            for (int i = 0; i < LineLen; i++)
            {
                buf.Append(i >= bCount ? "   " : bytes[i].ToString("X2") + " ");
            }

            buf.Append("  ");

            //char display pad
            for (int i = 0; i < LineLen; i++)
            {
                byte ch = bytes[i] >= 32 && bytes[i] <= 126 ? bytes[i] : (byte)0x2e; //dot
                buf.Append(i >= bCount ? " " : (char)ch + "");
            }

            buf.Append("\n");
            bCount = 0;
        }
    }


}
