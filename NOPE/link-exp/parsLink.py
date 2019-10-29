#!/usr/bin/python
"""
# lnkparse.py - Parses a windows .lnk file
# 
# Created by: Joel D. Yonts
# Modified by: Alan Brenner, (refactor into a Python class, add docstrings,
#							  add psuedo I18N, separate output from parsing)
#
# Creation Date: 04/28/2008
# Last Updated: 06/28/2008
#
# License: good question, Joel?
"""
__version__ = '0.9c'

import struct
import time

#********************* File Definitions **********************************
HEADER_LEN = 76
LNK_HEADER = {'unknown1':[0, 4, "<I"], \
				'GUID':[4, 20, ""], \
				'flags':[20, 24, "<I"], \
				'file_attributes':[24, 28, "<I"], \
				'ctimeL':[28, 32, "<I"], \
				'ctimeH':[32, 36, "<I"], \
				'mtimeL':[36, 40, "<I"], \
				'mtimeH':[40, 44, "<I"], \
				'atimeL':[44, 48, "<I"], \
				'atimeH':[48, 52, "<I"], \
				'file_length':[52, 56, "<I"], \
				'icon_number':[56, 60, "<I"], \
				'show_wnd':[60, 64, "<I"], \
				'hot_key':[64, 68, "<I"], \
				'unknown2':[68, 76, ""], \
				}
				
# Build dictionary containing header format
NET_VOL_TBL = {'size':[0, 4, "<I", "Size: "], \
			'uknown1':[4, 8, "<I", ""], \
			'net_sharename_offset':[8, 12, "<I", ""], \
			'unknown2':[12, 16, "<I", ""], \
			'unknown3':[16, 20, "<I", ""], \
			'net_sharename':[20, "", "", "Network Sharename: "], \
			}

# Build dictionary containing header format
LOCAL_VOL_TBL = {'size':[0, 4, "<I"], \
			'vol_type':[4, 8, "<I"], \
			'vol_serial_num':[8, 12, "<I"], \
			'volume_name_offset':[12, 16, "<I"], \
			'volume_label':[16, "", ""], \
			}

# Build dictionary containing header format
FILE_LOC_HEADER_SIZE = 28
FILE_LOC_HEADER = {'size':[0, 4, "<I"], \
			'first_entry':[4, 8, "<I"], \
			'flags':[8, 12, "<I"], \
			'local_vol_info_offset':[12, 16, "<I"], \
			'local_base_path_offset':[16, 20, "<I"], \
			'net_vol_info_offset':[20, 24, "<I"], \
			'remain_pathname_offset':[24, 28, "<I"], \
			}

#********************* Redefine these for local language output **********
FILE_ATTRIBUTES = [
	"File Attribute(s):\tRead Only",
	"File Attribute(s):\tHidden",
	"File Attribute(s):\tSystem File",
	"File Attribute(s):\tVolume Label",
	"File Attribute(s):\tDirectory",
	"File Attribute(s):\tModified Since Last Backup",
	"File Attribute(s):\tEncrypted (NTFS Partitions)",
	"File Attribute(s):\tNormal",
	"File Attribute(s):\tTemporary",
	"File Attribute(s):\tSparse File",
	"File Attribute(s):\tReparse Point Data",
	"File Attribute(s):\tCompressed",
	"File Attribute(s):\tOffline"]
SHOW_WND = [
	"Show Window:\tNormal",
	"Show Window:\tHidden",
	"Show Window:\tMinimized",
	"Show Window:\tMaximized"]
GET_LNK_HEADER = [
	"Target Type:\t\tFile or Directory",
	"Creation Time:\t",
	"Mod Time:\t",
	"Access Time:\t",
	"File Length:\t",
	"Icon Number:\t",
	"Hot key:\t"]
VOL_TYPE = [
	"Volume Type:\t\tNo root directory",
	"Volume Type:\t\tRemovable (Floppy, Zip, etc..)",
	"Volume Type:\t\tFixed (Hard Disk)",
	"Volume Type:\t\tRemote (Network Drive)",
	"Volume Type:\t\tCD-ROM",
	"Volume Type:\t\tRam drive"]
FILE_LOC = [
	"Target Type:\t\tLocal Volume",
	"Target Filename:\t\t",
	"Volume Label: ",
	"Volume Serial#: "
	"Target Filename: "]
###############################################################################
def parseStructuredData( raw_data, format ):
	"""Generic file parsing engine. Utilizes gen file defs.
	
	@type raw_data: string
	@param row_data: The string to turn in to a dictionary of values
	@type format: dictionary
	@param format: something like LNK_HEADER as defined in this module
	
	@return: dictionary
	"""
	parsed_data = {}

	BEGIN = 0
	END = 1
	CONV = 2

	for key in format.keys():
		key_format = format[key]

		if key_format[END] == "":
			key_format[END] = key_format[BEGIN] + len(raw_data)

		txt = raw_data[key_format[BEGIN]:key_format[END]]

		if len(key_format[CONV]) > 0:
			parsed_data[key] = struct.unpack(key_format[CONV], txt)[0]
		else:
			parsed_data[key] = txt

	return parsed_data

def processVolTbl(raw_data, info_offset, parse_dict):
	"""Build new dictionary containing file location data
	
	@type raw_data: string
	@param raw_data: The input to turn in to a dictionary
	@type info_offset: int
	@param info_offset: the value of file_loc['net_vol_info_offset']
	@type parse_dict: dictionary
	@param parse_dict: either LOCAL_VOL_TBL or NET_VOL_TBL
	
	@return: dictionary
	"""
	# Extract size of net volume info structure
	txt = raw_data[info_offset:info_offset + 4]
	size = struct.unpack("<I", txt)[0]
	
	vol_tbl_raw = raw_data[info_offset:info_offset + size]
	return parseStructuredData(vol_tbl_raw, parse_dict)

###############################################################################
def conv_time(l, h):
	"""Function converts FILETIME structure to formated time str
	(num of 100-nanosecond since 01/01/1601) to (num of sec since 01/01/1970)
	(epoc) to (formated time string)"""
	# Function modified from post on ActiveState by John Nielsen

	#converts 64-bit integer specifying the number of 100-nanosecond
	#intervals which have passed since January 1, 1601.
	#This 64-bit value is split into the
	#two 32 bits  stored in the structure.
	d = 116444736000000000L 

	# Some LNK files do not have time field populated 
	if l + h != 0:
		newTime = (((long(h) << 32) + long(l)) - d)/10000000  
	else:
		newTime = 0

	return time.strftime("%Y/%m/%d %H:%M:%S %a", time.localtime(newTime))


###############################################################################
class LnkParser:
	"""Parse a Windows .lnk file.
	"""
	def __init__(self, fname=None):
		self.fname = fname
		self.fpLnk = None
		self.header = None
		self.file_loc = None
		self.shellItemIDList = None
		self.descrString = None
		self.relPathString = None
		self.workingDir = None
		self.cmdLineString = None
		self.iconFilename = None
		if self.fname:
			self.openLnkFile()

	def __str__(self):
		return "\n".join(self.getLnkHeader()) + "\n".join(self.getFileLoc())

	def getLnkHeader(self):
		"""Return formated output of parsed lnk header.
		
		@return: list"""
		rval = []
		if (self.header['flags'] & 2) > 0:
			rval.append(GET_LNK_HEADER[0])
	
		for ii in range(len(FILE_ATTRIBUTES)):
			if (self.header['file_attributes'] & (2 ** ii)) > 0:
				rval.append(FILE_ATTRIBUTES[ii])

		timeStr = conv_time(int(self.header['ctimeL']),
			int(self.header['ctimeH']))
		rval.append(GET_LNK_HEADER[1] + timeStr)
		timeStr = conv_time(int(self.header['mtimeL']),
			int(self.header['mtimeH']))
		rval.append(GET_LNK_HEADER[2] + timeStr)
		timeStr = conv_time(int(self.header['atimeL']),
			int(self.header['atimeH']))
		rval.append(GET_LNK_HEADER[3] + timeStr)
	
		rval.extend((GET_LNK_HEADER[4] + str(self.header['file_length']),
			GET_LNK_HEADER[5] + str(self.header['icon_number'])))
	
		for ii in range(len(SHOW_WND)):
			if (self.header['file_attributes'] & (2 ** ii)) > 0:
				rval.append(SHOW_WND[ii])
	
		rval.append(GET_LNK_HEADER[6] + str(hex(self.header['hot_key'])))
		return rval

	def getFileLoc(self):
		"""Return formated output of file locations fields.
		
		@return: list"""
		rval = []
		localVolTbl = self.file_loc['localVolTbl']
		netVolTbl = self.file_loc['netVolTbl']
		
		if localVolTbl != None:
			rval.extend((FILE_LOC[0],
				FILE_LOC[1] + self.file_loc['basePathname'] + \
				"\\" + self.file_loc['remainPathname']))
	
			for ii in range(len(VOL_TYPE)):
				if (self.header['file_attributes'] & (2 ** (ii + 1))) > 0:
					rval.append(VOL_TYPE[ii])
				
			rval.extend((FILE_LOC[2] + localVolTbl['volume_label'],
				FILE_LOC[3] + str(localVolTbl['vol_serial_num'])))		
	
		if netVolTbl != None:
			rval.append(FILE_LOC[4] + netVolTbl['net_sharename'] + \
				"\\" + self.file_loc['remainPathname'])
		return rval

	def openLnkFile(self, fname=None):
		"""Open the .lnk file

		@type fname: string
		@param fname: path to .lnk file

		@raise: IOError

		@return: None, sets self.fpLnk
		"""
		if fname:
			self.fpLnk = open(fname, "rb")
		else:
			self.fpLnk = open(self.fname, "rb")

	def processLnkHeader(self):
		"""Reads file header and sends data to parsing engine
		
		@raise: IOError

		@return: None, sets self.header"""
		# Read LNK heaer from file
		header_raw = self.fpLnk.read(HEADER_LEN)
		# Build new dictionary containing header data
		self.header = parseStructuredData(header_raw, LNK_HEADER)

	def _getVal(self, mask, size):
		"""If the header flags is set, read it from the file.
		
		@type mask: integer
		@param mask: offset in self.header['flags'] to check
		@type size: integer
		@param size: length multiplier (1 for byte, 2 for unicode)
		
		@raise: IOError
		
		@return string, the value read
		"""
		if (int(self.header['flags']) & mask) > 0:
			# First unsigned short is the length of the string
			txt = self.fpLnk.read(2)
			length = struct.unpack("<H", txt)[0]
			# Adjust for unicode
			length = length * size
			return self.fpLnk.read(length)

	def processShellItemIDList(self):
		"""Get the shell item ID list from the file.
		
		@raise: IOError
		
		@return: None, sets self.shellItemIDList
		"""
		self.shellItemIDList = self._getVal(1, 1)

	def processFileLocInfo(self):
		"""Extract file location data from the .lnk file.

		@raise: IOError
		
		@return: None, sets self.file_loc dictionary values
		"""
		# If bit 1 of the flags field is set
		if int(self.header['flags']) & 2 > 0:

			# Read size of file location info
			txt = self.fpLnk.read(4)
			self.file_loc = {}
			self.file_loc['size'] = struct.unpack("<I", txt)[0]
				
			# Read size of file location info and prepend the previous read value.
			# Txt was prepended to remove a special condition case need to skip
			# the re-reading of the size field.
			file_loc_raw = txt + self.fpLnk.read(self.file_loc['size'] - 4)

			# Loop throuh predefine file format, extracting field into a new data
			# file location header dictionary.
			# XXX: do we really want to clobber the dictionary we just created
			# and not self.file_loc.update(parseStructuredData())?
			self.file_loc = parseStructuredData(file_loc_raw, FILE_LOC_HEADER)
		
			# Process local volume info if flag is set
			if (self.file_loc['flags'] & 1) > 0:
				localVolTbl = processVolTbl(file_loc_raw, 
					self.file_loc['local_vol_info_offset'], LOCAL_VOL_TBL)
				self.file_loc['localVolTbl'] = localVolTbl
				offset = self.file_loc['local_base_path_offset']
				basePathname = file_loc_raw[offset:].split('\x00')[0]
				self.file_loc['basePathname'] = basePathname
			else:
				self.file_loc['localVolTbl'] = None

			# Process net volume info if flag is set
			if (self.file_loc['flags'] & 2) > 0:
				netVolTbl = processVolTbl(file_loc_raw, 
					self.file_loc['net_vol_info_offset'], NET_VOL_TBL)
				self.file_loc['netVolTbl'] = netVolTbl
			else:
				self.file_loc['netVolTbl'] = None

			# Process remaining portion of pathname
			offset = self.file_loc['remain_pathname_offset']
			remainPathname = file_loc_raw[offset:].split('\x00')[0]
			self.file_loc['remainPathname'] = remainPathname

	def processDescrString(self):
		"""Get the description from the file.
		
		@raise: IOError
		
		@return None, sets self.descrString
		"""
		self.descrString = self._getVal(4, 1)

	def processRelPathString(self):
		"""Get the relative path from the file.
		
		@raise: IOError
		
		@return None, sets self.relPathString
		"""
		self.relPathString = self._getVal(8, 2)

	def processWorkingDir(self):
		"""Get the working directory from the file.
		
		@raise: IOError
		
		@return None, sets self.workingDir
		"""
		self.workingDir = self._getVal(16, 2)

	def processCmdLineString(self):
		"""Get the command line string from the file.
		
		@raise: IOError
		
		@return None, sets self.cmdLineString
		"""
		self.cmdLineString = self._getVal(32, 2)

	def processIconFilename(self):
		"""Get the icon file name from the file.
		
		@raise: IOError
		
		@return None, sets self.iconFilename
		"""
		self.iconFilename = self._getVal(64, 2)


if __name__ == '__main__':
	import optparse
	import sys
	usage = "usage: %prog [options] filename"
	options = optparse.OptionParser(usage=usage, version=__version__,
		description="Run this with a .lnk file to see its contents.")
	opts, args = options.parse_args()
	if len(args) != 1:
		options.print_help()
		options.exit(1)

	print "Processing ... %s\n" % (args[0])

	try:
		parser = LnkParser(args[0])
		parser.processLnkHeader()
		parser.processShellItemIDList()
		parser.processFileLocInfo()
	except IOError, e:
		print "error: %s" % str(e)
		sys.exit(1)

	print str(parser)

	try:
		parser.processDescrString()
		print "Description: " + str(parser.descrString)
		parser.processRelPathString()
		print "Relative Path: " + str(parser.relPathString)
		parser.processWorkingDir()
		print "Working Directory: " + str(parser.workingDir)
		parser.processCmdLineString()
		print "Command Line Args: " + str(parser.cmdLineString)
		parser.processIconFilename()
		print "Icon Filename: " + str(parser.iconFilename)
	except IOError, e:
		print "error: %s" % str(e)
		sys.exit(2)