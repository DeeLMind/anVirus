//
// jb01_decompress.cpp
// (c)2002 Jonathan Bennett (jon@hiddensoft.com)
//
//
#include "stdafx.h"
#include "EA03_UnCompress.h"

///////////////////////////////////////////////////////////////////////////////
// SetDefaults()
// Should be called once before first using the Compress() function
///////////////////////////////////////////////////////////////////////////////

void EA03_Decompress::SetDefaults(void)
{
	m_bUserData			= NULL;
	m_bUserCompData		= NULL;

	m_nUserDataPos		= 0;					// TOTAL data bytes read
	m_nUserCompPos		= 0;					// TOTAL compressed bytes written

	m_nDataSize			= 0;					// TOTAL file uncompressed size

	m_szAlgID[0]		= '\0';
} // SetDefaults()


///////////////////////////////////////////////////////////////////////////////
// DecompressFile()
//
// Only accesses m_bBlockData and m_bCompBlockData member variables!
//
///////////////////////////////////////////////////////////////////////////////

int EA03_Decompress::Decompress(void)
{
	// Initialise vars 
	m_nUserCompPos			= 0;				// Bytes read from input
	m_nUserDataPos			= 0;				// Bytes written to output
	m_nDataPos				= 0;				// Pos in our internal data buffer
	m_nDataUsed				= 0;	
	m_nDataWritePos			= 0;
	m_nCompressedLong		= 0;				// Compressed stream temporary 32bit value
	m_nCompressedBitsUsed	= 0;				// Number of bits unused in temporary value

	// Check that data is a valid LZSS stream and get uncompressed size too
	int nRes = ReadUserCompHeader(m_nDataSize);

	if ( nRes != JB01_E_OK )
	{
		return JB01_E_NOTJB01;				// Wasn't a valid LZSS stream
	}

	// Allocate the memory needed for decompression
	nRes = AllocMem();
	if (nRes != JB01_E_OK)
	{
		return nRes;							// Return error code
	}

	
	// At the start huffman coding is off
	HuffmanInit();

	// Do the decompression
	DecompressLoop();


	// Free memory used by decompression
	FreeMem();								

	// Close our files if required
	return JB01_E_OK;							// Return with success message

} // Decompress


///////////////////////////////////////////////////////////////////////////////
// ReadUserCompHeader()
// Reads in the header (Alg ID, Rev ID, uncompressed size) from the compressed
// input (9 bytes)
///////////////////////////////////////////////////////////////////////////////

int EA03_Decompress::ReadUserCompHeader(ULONG &nSize)
{
	UCHAR	bBuffer[8];
	memcpy(bBuffer, &m_bUserCompData[m_nUserCompPos], 8);

	// Update position (skip the header, basically)
	m_nUserCompPos += 8;


	// Get uncompressed size
	nSize = (ULONG)bBuffer[4] << 24;				
	nSize = nSize | (ULONG)bBuffer[5] << 16;
	nSize = nSize | (ULONG)bBuffer[6] << 8;	
	nSize = nSize | (ULONG)bBuffer[7];

	// Terminate ALG string
	bBuffer[4] = '\0';

	if (!strcmp((char*)bBuffer, m_szAlgID))
		return JB01_E_OK;							// Return with success message
	else
		return JB01_E_NOTJB01;

} // ReadUserCompHeader()


///////////////////////////////////////////////////////////////////////////////
// AllocMem()
//
// Allocates our block buffer
//
///////////////////////////////////////////////////////////////////////////////

int EA03_Decompress::AllocMem(void)
{
	m_bData	= (UCHAR *)malloc(JB01_DATA_SIZE * sizeof(UCHAR));

	// Huffman stuff
	// Tree can be 2n-1 elements in size
	// Number of output codes = size of alphabet
	m_HuffmanLiteralTree	
		= (JB01_HuffmanDecompNode *)malloc(((2*JB01_HUFF_LITERAL_ALPHABETSIZE)-1) * sizeof (JB01_HuffmanDecompNode));

	m_HuffmanOffsetTree	
		= (JB01_HuffmanDecompNode *)malloc(((2*JB01_HUFF_OFFSET_ALPHABETSIZE)-1) * sizeof (JB01_HuffmanDecompNode));

	if ( (m_bData == NULL) //|| (m_bComp == NULL) 
			|| (m_HuffmanLiteralTree == NULL) || (m_HuffmanOffsetTree == NULL) )
	{
		FreeMem();
		return JB01_E_MEMALLOC;
	}
	else
		return JB01_E_OK;


} // AllocMem()


///////////////////////////////////////////////////////////////////////////////
// FreeMem()
//
// Frees our block buffer
//
///////////////////////////////////////////////////////////////////////////////

void EA03_Decompress::FreeMem(void)
{
	HS_COMP_SafeFree(m_bData);

	HS_COMP_SafeFree(m_HuffmanLiteralTree);
	HS_COMP_SafeFree(m_HuffmanOffsetTree);

} // FreeMem()


///////////////////////////////////////////////////////////////////////////////
// WriteUserData()
// Outputs data the the uncompressed data stream (file or memory)
///////////////////////////////////////////////////////////////////////////////

void EA03_Decompress::WriteUserData(void)
{
	// Write out all the data from our last write position to our current position

	// Memory or file as the input?
	while (m_nDataWritePos < m_nDataPos)
	{
		m_bUserData[m_nUserDataPos++] = m_bData[m_nDataWritePos & JB01_DATA_MASK];
		m_nDataWritePos++;
	}

	// Update totals
	m_nDataUsed		= 0;						// Update how full the buffer is

} // WriteUserData()


///////////////////////////////////////////////////////////////////////////////
// DecompressLoop()
///////////////////////////////////////////////////////////////////////////////

int EA03_Decompress::DecompressLoop(void)
{
	ULONG	nMaxPos;
	UINT	nTemp;
	UINT	nLen;
	UINT	nOffset;
	ULONG	nTempPos;

	// Perform decompression until we fill our predicted size (uncompressed size)
	nMaxPos		= m_nDataSize;

	while(m_nDataPos < nMaxPos)
	{
		// Read in a literal
		nTemp = CompressedStreamReadLiteral();

		// Was it a literal byte, or a  match len?
		if (nTemp < JB01_HUFF_LITERAL_LENSTART)	// 0-255 are literals, 256-292 are lengths
		{
			// Store the literal byte
			m_bData[m_nDataPos & JB01_DATA_MASK] = (UCHAR)nTemp;
			m_nDataPos++;
			m_nDataUsed++;
		}
		else
		{
			// Decode (and read more if required) to get the length of the match
			nLen = CompressedStreamReadLen(nTemp) + JB01_MINMATCHLEN;

			// Read the offset
			nOffset = CompressedStreamReadOffset();

			// Write out our match
			nTempPos = m_nDataPos - nOffset;
			while (nLen)
			{
				--nLen;
				m_bData[m_nDataPos & JB01_DATA_MASK] = m_bData[nTempPos & JB01_DATA_MASK];
				nTempPos++;
				m_nDataPos++;
				m_nDataUsed++;
			}
		}
	

		// Write it out
		WriteUserData();
	}

	return JB01_E_OK;

} // DecompressLoop()


///////////////////////////////////////////////////////////////////////////////
// CompressedStreamReadBits()
//
// Will read up to 16 bits from the compressed data stream
//
///////////////////////////////////////////////////////////////////////////////

inline UINT EA03_Decompress::CompressedStreamReadBits(UINT nNumBits)
{
	// Ensure that the high order word of our bit buffer is blank 
	m_nCompressedLong = m_nCompressedLong & 0x0000ffff;

	while (nNumBits)
	{
		--nNumBits;

		// Check if we need to refill our decoding bit buffer
		if (!m_nCompressedBitsUsed)
		{
			// Yes, we need to read in another 16 bits (two bytes)
			// Fill the low order 16 bits of our long buffer
			m_nCompressedLong = m_nCompressedLong | (m_bUserCompData[m_nUserCompPos++] << 8);
			m_nCompressedLong = m_nCompressedLong | m_bUserCompData[m_nUserCompPos++];

			m_nCompressedBitsUsed = 16;			// We've used 16 bits
		}

		// Shift the data into the high part of the long
		m_nCompressedLong = m_nCompressedLong << 1;
		--m_nCompressedBitsUsed;
	}

	return (UINT)(m_nCompressedLong >> 16);

} // CompressedStreamReadBits()


///////////////////////////////////////////////////////////////////////////////
// HuffmanInit()
///////////////////////////////////////////////////////////////////////////////

void EA03_Decompress::HuffmanInit(void)
{
	// Literal and match length tree
	HuffmanZero(m_HuffmanLiteralTree, JB01_HUFF_LITERAL_ALPHABETSIZE);
	HuffmanGenerate(m_HuffmanLiteralTree, JB01_HUFF_LITERAL_ALPHABETSIZE, 0);
	m_bHuffmanLiteralFullyActive = false;
	m_nHuffmanLiteralIncrement = JB01_HUFF_LITERAL_INITIALDELAY;
	m_nHuffmanLiteralsLeft	= m_nHuffmanLiteralIncrement;

	// Offset tree
	HuffmanZero(m_HuffmanOffsetTree, JB01_HUFF_OFFSET_ALPHABETSIZE);
	HuffmanGenerate(m_HuffmanOffsetTree, JB01_HUFF_OFFSET_ALPHABETSIZE, 0);
	m_bHuffmanOffsetFullyActive = false;
	m_nHuffmanOffsetIncrement = JB01_HUFF_OFFSET_INITIALDELAY;
	m_nHuffmanOffsetsLeft	= m_nHuffmanOffsetIncrement;

} // HuffmanInit()


///////////////////////////////////////////////////////////////////////////////
// HuffmanZero()
///////////////////////////////////////////////////////////////////////////////

void EA03_Decompress::HuffmanZero(JB01_HuffmanDecompNode *HuffTree, UINT nAlphabetSize)
{
	// Reset the freqencies for all entries 
	// At the start all entries are equally probably for an unknown file
	// A frequency of zero at the start creates a worst case tree with 255 char codes :(
	for (UINT i=0; i<nAlphabetSize; ++i)
	{
		HuffTree[i].nFrequency	= 1;
		HuffTree[i].nChildLeft	= i;			// The children on the leaf node will ALWAYS
		HuffTree[i].nChildRight	= i;			// equal themselves to indicate a leaf!
	}
}


///////////////////////////////////////////////////////////////////////////////
// HuffmanGenerate()
///////////////////////////////////////////////////////////////////////////////

void EA03_Decompress::HuffmanGenerate(JB01_HuffmanDecompNode *HuffTree, UINT nAlphabetSize, UINT nFreqMod)
{
	UINT	i, j;
	UINT	nNextBlankEntry;
	UINT	nByte1 = 0, nByte2 = 0;
	ULONG	nByte1Freq, nByte2Freq;
	UINT	nParent;
	UINT	nRoot;
	UINT	nEndNode;

	// Reset the table so we can search the first set of elements
	// entries (actual bytes)
	for (i=0; i<nAlphabetSize; ++i)
		HuffTree[i].bSearchMe = true;

	nRoot = (nAlphabetSize << 1) - 2;

	// Next free entry in the array is now nAlphabetSize
	nNextBlankEntry = nAlphabetSize;
	nEndNode = nRoot + 1;
	while (nNextBlankEntry != nEndNode )
	{
		// Get least 2 frequent entries (byte1=least frequent, byte2= next least recent)
		nByte1Freq	= nByte2Freq	= 0xffffffff;
		for (i=0; i<nNextBlankEntry; ++i)
		{
			if ( HuffTree[i].bSearchMe != false) 
			{
				if (HuffTree[i].nFrequency < nByte2Freq)
				{
					if (HuffTree[i].nFrequency < nByte1Freq)
					{
						nByte2		= nByte1;
						nByte2Freq	= nByte1Freq;
						nByte1		= i;
						nByte1Freq	= HuffTree[i].nFrequency;
					}
					else
					{
						nByte2		= i;
						nByte2Freq	= HuffTree[i].nFrequency;
					}
				}
			}
		}

		// Remove the two entries from the search list
		HuffTree[nByte1].bSearchMe = false;
		HuffTree[nByte2].bSearchMe = false;

		// Create a new parent entry with the combined frequency
		HuffTree[nNextBlankEntry].nFrequency	= HuffTree[nByte1].nFrequency + HuffTree[nByte2].nFrequency;
		HuffTree[nNextBlankEntry].bSearchMe		= true;	// Add to search list
		HuffTree[nNextBlankEntry].nChildLeft	= nByte1;
		HuffTree[nNextBlankEntry].nChildRight	= nByte2;
		HuffTree[nByte1].nParent				= nNextBlankEntry;
		HuffTree[nByte2].nParent				= nNextBlankEntry;
		HuffTree[nByte1].cValue					= 0;
		HuffTree[nByte2].cValue					= 1;

		++nNextBlankEntry;
	} // End while

	// The last array entry (JB01_HUFF_ROOTNODE) is now the parent node!

	// Check our tree to see that no codes are too long
	for (i=0; i<nAlphabetSize; ++i)				// nAlphabetSize symbols to code
	{
		nParent = i;
		j = 0;									// Number of bits long the code is
		while (nParent != nRoot)
		{
			++j;
			nParent = HuffTree[nParent].nParent;
		}

		// Ensure that codes are not too long, if they are divide the freqencies by 4 
		// then start again
		if (j > JB01_HUFF_MAXCODEBITS)
		{
			//printf("\n\nDamnit - huffman code too long\n\n");
			for (i=0; i<nAlphabetSize; ++i)			
				HuffTree[i].nFrequency = (HuffTree[i].nFrequency >> 2) + 1;
		
			HuffmanGenerate(HuffTree, nAlphabetSize, nFreqMod);
			return;
		}
	} // End For


	// Finally, reduce the probability of all the freqencies of the individual
	// bytes so that "old" frequencies are worth less than any new data we get
	if (nFreqMod)
	{
		// Divide by freqency modifier, make sure is 1 or more (zeros do bad things...)
		for (i=0; i<nAlphabetSize; ++i)	
			HuffTree[i].nFrequency = (HuffTree[i].nFrequency >> nFreqMod) + 1;			
	}


} // HuffmanGenerate()


///////////////////////////////////////////////////////////////////////////////
// CompressedStreamReadHuffman()
///////////////////////////////////////////////////////////////////////////////

inline UINT EA03_Decompress::CompressedStreamReadHuffman(JB01_HuffmanDecompNode *HuffTree, UINT nAlphabetSize)
{
	UINT	nCode, nTemp;

	// Start with Root node of the tree, if a child is a pointer to itself
	// then it is the leaf and we stop
	nCode = ( nAlphabetSize << 1 ) - 2;
	while (HuffTree[nCode].nChildLeft != nCode)
	{
		nTemp = CompressedStreamReadBits(1);
		if (!nTemp)
			nCode = HuffTree[nCode].nChildLeft;
		else
			nCode = HuffTree[nCode].nChildRight;
	}

	// nLiteral will now be the leaf, which index in the array=literal :)

	return nCode;

} // CompressedStreamReadHuffman()


///////////////////////////////////////////////////////////////////////////////
// CompressedStreamReadLiteral()
///////////////////////////////////////////////////////////////////////////////

inline UINT EA03_Decompress::CompressedStreamReadLiteral(void)
{
	UINT	nLiteral;

	// Read in a huffman code from the compressed stream
	nLiteral = CompressedStreamReadHuffman(m_HuffmanLiteralTree, JB01_HUFF_LITERAL_ALPHABETSIZE);

	// Update the frequency of this character
	m_HuffmanLiteralTree[nLiteral].nFrequency++;
	--m_nHuffmanLiteralsLeft;

	// If we have coded enough literals, then generate/regenerate the huffman tree
	if (!m_nHuffmanLiteralsLeft)
	{
		if (m_bHuffmanLiteralFullyActive)
		{
			m_nHuffmanLiteralsLeft	= JB01_HUFF_LITERAL_DELAY;
			HuffmanGenerate(m_HuffmanLiteralTree, JB01_HUFF_LITERAL_ALPHABETSIZE, JB01_HUFF_LITERAL_FREQMOD);
		}
		else
		{
			m_nHuffmanLiteralIncrement += JB01_HUFF_LITERAL_INITIALDELAY;
			if (m_nHuffmanLiteralIncrement >= JB01_HUFF_LITERAL_DELAY)
				m_bHuffmanLiteralFullyActive = true;

			m_nHuffmanLiteralsLeft	= JB01_HUFF_LITERAL_INITIALDELAY;
			HuffmanGenerate(m_HuffmanLiteralTree, JB01_HUFF_LITERAL_ALPHABETSIZE, 0);
		}
	}

	return nLiteral;

} // CompressedStreamReadLiteral()


///////////////////////////////////////////////////////////////////////////////
// CompressedStreamReadLen()
///////////////////////////////////////////////////////////////////////////////

inline UINT EA03_Decompress::CompressedStreamReadLen(UINT nCode)
{
	UINT	nValue;
	UINT	nExtraBits;
	UINT	nMSBValue;
	
	if (nCode <= 263)
		return nCode - 256;
	else
	{
		// nCode increases by 4 for every extra bit added, 264 = 1 bit
		nCode = nCode - 264;
		nExtraBits	= (nCode >> 2) + 1;
		nMSBValue	= 1 << (nExtraBits+2);
		nCode = nCode & 0x0003;

		// Read in the extra bits
		nValue = CompressedStreamReadBits(nExtraBits);

		return nValue + nMSBValue + (nCode << nExtraBits);
	}

} // CompressedStreamReadLen()


///////////////////////////////////////////////////////////////////////////////
// CompressedStreamReadOffset()
///////////////////////////////////////////////////////////////////////////////

inline UINT EA03_Decompress::CompressedStreamReadOffset(void)
{
	UINT	nValue;
	UINT	nExtraBits;
	UINT	nMSBValue;
	UINT	nCode;

	// Read in a huffman code from the compressed stream
	nCode = CompressedStreamReadHuffman(m_HuffmanOffsetTree, JB01_HUFF_OFFSET_ALPHABETSIZE);

	// Update the frequency of this character
	m_HuffmanOffsetTree[nCode].nFrequency++;

	if (nCode <= 3)
		nValue = nCode;
	else
	{
		// nCode increases by 2 for every extra bit added, 4 = 1 bit
		nCode = nCode - 4;
		nExtraBits	= (nCode >> 1) + 1;
		nMSBValue	= 1 << (nExtraBits+1);
		nCode = nCode & 0x0001;

		// Read in the extra bits
		nValue = CompressedStreamReadBits(nExtraBits);
		nValue = nValue + nMSBValue + (nCode << nExtraBits);
	}

	// Update the frequency (above)
	--m_nHuffmanOffsetsLeft;

	// If we have coded enough literals, then generate/regenerate the huffman tree
	if (!m_nHuffmanOffsetsLeft)
	{
		if (m_bHuffmanOffsetFullyActive)
		{
			m_nHuffmanOffsetsLeft	= JB01_HUFF_OFFSET_DELAY;
			HuffmanGenerate(m_HuffmanOffsetTree, JB01_HUFF_OFFSET_ALPHABETSIZE, JB01_HUFF_OFFSET_FREQMOD);
		}
		else
		{
			m_nHuffmanOffsetIncrement += JB01_HUFF_OFFSET_INITIALDELAY;
			if (m_nHuffmanOffsetIncrement >= JB01_HUFF_OFFSET_DELAY)
				m_bHuffmanOffsetFullyActive = true;

			m_nHuffmanOffsetsLeft	= JB01_HUFF_OFFSET_INITIALDELAY;
			HuffmanGenerate(m_HuffmanOffsetTree, JB01_HUFF_OFFSET_ALPHABETSIZE, 0);
		}
	}

	return nValue;

} // CompressedStreamReadOffset()
