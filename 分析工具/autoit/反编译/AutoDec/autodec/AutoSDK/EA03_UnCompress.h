#ifndef __JB01_DECOMPRESS_H__
#define __JB01_DECOMPRESS_H__


// The start of the compression stream will contain "other" items apart from data.
//
// Algorithm ID				4 bytes
// Revision ID				1 byte
// Total Uncompressed Size	4 bytes (1 ULONG)
// Compressed Data			nn bytes (16 bit aligned)
// 
#define HS_COMP_SafeFree(x) { if (x) free(x); }


// Error codes
#define	JB01_E_OK			0					// OK
#define JB01_E_NOTJB01		1					// Not a valid LZSS data stream
#define JB01_E_READINGSRC	2					// Error reading source file
#define JB01_E_WRITINGDST	3					// Error writing dest file
#define JB01_E_ABORT		4					// Operation was aborted
#define JB01_E_MEMALLOC		5					// Couldn't allocate all the mem we needed


// Working block sizes
#define JB01_DATA_SIZE		(128*1024)			// Uncompressed buffer - must be >window+lookahead+1 and a POWER OF 2 (for ANDing)
#define JB01_DATA_MASK		(JB01_DATA_SIZE-1)	// AND mask (data size MUST be a power of 2)


// Define huffman and related
#define JB01_MINMATCHLEN				3			// Minimum match length

#define	JB01_HUFF_LITERAL_ALPHABETSIZE	(256 + 32)	// Number of characters to represent literals(256) + match lengths (32 match len codes, 0-511)
#define JB01_HUFF_LITERAL_LENSTART		256			// Match lens are elements 256 and above in the literal alphabet

#define	JB01_HUFF_OFFSET_ALPHABETSIZE	32			// Number of characters to represent offset codes (32 codes = 0-65535)

#define JB01_HUFF_LITERAL_INITIALDELAY	(JB01_HUFF_LITERAL_ALPHABETSIZE / 4)	// Literal trees are initially regenerated after this many codings
#define JB01_HUFF_LITERAL_DELAY			(JB01_HUFF_LITERAL_ALPHABETSIZE * 12)	// Literal trees are thereafter regenerated after this many codings

#define JB01_HUFF_OFFSET_INITIALDELAY	(JB01_HUFF_OFFSET_ALPHABETSIZE / 4)		// Offset trees are initially regenerated after this many codings
#define JB01_HUFF_OFFSET_DELAY			(JB01_HUFF_OFFSET_ALPHABETSIZE * 12)	// Offset trees are thereafter regenerated after this many codings

#define	JB01_HUFF_LITERAL_FREQMOD		1			// Frequency modifier for old values
#define	JB01_HUFF_OFFSET_FREQMOD		1			// Frequency modifier for old values

#define JB01_HUFF_MAXCODEBITS			16			// Maximum number of bits for a huffman code (must be <= 16)

typedef struct _JB01_HuffmanDecompNode
{
	ULONG	nFrequency;						// Frequency value
	bool	bSearchMe;
	UINT	nParent;
	UINT	nChildLeft;						// Left child node or NULL
	UINT	nChildRight;					// Right child node or NULL
	UCHAR	cValue;
}JB01_HuffmanDecompNode;

class EA03_Decompress
{
public:
	// Functions
	EA03_Decompress() { SetDefaults(); }		// Constructor
	int		Decompress();

	void	SetDefaults(void);
	void	SetInputBuffer(UCHAR *bBuf) { m_bUserCompData = bBuf; }
	void	SetOutputBuffer(UCHAR *bBuf) { m_bUserData = bBuf; }
	void	SetAlgID(CHAR *szAlgID) {strcpy(m_szAlgID, szAlgID);}

private:
	// Functions
	int		AllocMem(void);
	void	FreeMem(void);
	int		ReadUserCompHeader(ULONG &nSize);
	void	WriteUserData(void);
	int		DecompressLoop(void);

	// Bit operation functions
	inline	UINT	CompressedStreamReadBits(UINT nNumBits);
	inline	UINT	CompressedStreamReadLiteral(void);
	inline	UINT	CompressedStreamReadLen(UINT nCode);
	inline	UINT	CompressedStreamReadOffset(void);
	inline	UINT	CompressedStreamReadHuffman(JB01_HuffmanDecompNode *HuffTree, UINT nAlphabetSize);

	// Huffman functions
	void	HuffmanInit(void);
	void	HuffmanZero(JB01_HuffmanDecompNode *HuffTree, UINT nAlphabetSize);	// Clears the frequencies in the huffman tree
	void	HuffmanGenerate(JB01_HuffmanDecompNode *HuffTree, UINT nAlphabetSize, UINT nFreqMod);

private:
	// User supplied buffers and counters	
	UCHAR	*m_bUserCompData;						// When compressing to memory this is the user output buffer
	UCHAR	*m_bUserData;							// When compressing from memory this is the user input buffer
	ULONG	m_nUserDataPos;							// Position in user uncompressed stream (also used for info)
	ULONG	m_nUserCompPos;							// Position in user compressed stream (also used for info)

	// Master variables
	ULONG	m_nDataSize;							// TOTAL file uncompressed size

	UCHAR	*m_bData;
	ULONG	m_nDataPos;								// Position in output stream
	ULONG	m_nDataUsed;							// How much current info is in the data buff
	ULONG	m_nDataWritePos;						// Where new data should be written from

	// Temporary variables used for the bit operations
	ULONG	m_nCompressedLong;						// Compressed stream temporary 32bit value
	int		m_nCompressedBitsUsed;					// Number of bits used in temporary value

	// Huffman variables
	JB01_HuffmanDecompNode *m_HuffmanLiteralTree;	// The huffman literal/len tree
	ULONG	m_nHuffmanLiteralsLeft;					// Number of literals before huffman regenerated
	bool	m_bHuffmanLiteralFullyActive;
	ULONG	m_nHuffmanLiteralIncrement;

	JB01_HuffmanDecompNode *m_HuffmanOffsetTree;	// The huffman offset tree
	ULONG	m_nHuffmanOffsetsLeft;					// Number of literals before huffman regenerated
	bool	m_bHuffmanOffsetFullyActive;
	ULONG	m_nHuffmanOffsetIncrement;

	CHAR	m_szAlgID[8];							// The Alg ID string
};

#endif	//__JB01_DECOMPRESS_H__
