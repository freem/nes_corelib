-- makefds Lua script by freem
--============================================================================--
-- Create a .fds image (with or without header) from various files.
--============================================================================--
local params = {...}
local VERSION = "0.0"

-- program vars
local inScriptName = nil
local outFilename = nil
local scriptFile, fdsOutFile = nil, nil
local errorStr = ""
local exportFDSHeader = false

local scriptLines = {}
local diskInformation = {}
local curFileList = {}

local totalSides = nil
local totalDisks = 0
local curDiskSide = 0
local curDiskNumber = 0

-- you can't fool me, I'm not a copier!
local reportedNumFiles = 0
local realNumFiles = 0

--============================================================================--
-- utility routines
--============================================================================--
-- getToday()
-- Returns today's date in the required format for FDS images.
local function getToday()
	if os.date("%Y")-1925 > 99 then
		print("(!) WARNING: Current year can't be encoded properly. (You can't fix this.)")
	end

	return {
		Y=os.date("%Y")-1925,
		M=os.date("%m"),
		D=os.date("%d")
	}
end

--============================================================================--
local loadTypeToNum = { PRG=0, CHR=1, NT=2 }

-- AddFile()
-- Adds a file to the disk. Size is calculated automatically.
local function AddFile(_fileNum,_fileID,_fileName,_loadAddr,_fileType,_filePath)
	-- attempt to open file
	print(string.format("File 0x%02X (ID 0x%02X): %s (%s 0x%04X)",_fileNum,_fileID,_fileName,_fileType,_loadAddr))
	print("Data from ".._filePath)

	local fileToAdd
	-- xxx: all files opened in binary mode, even text
	fileToAdd,errorStr = io.open(_filePath,"rb")
	if not fileToAdd then
		error(string.format("Error attempting to add \"%s\" to disk:\n%s",_filePath,errorStr))
	end

	-- file was opened successfully; get file size
	local fileSize = nil
	fileSize,errorStr = fileToAdd:seek("end")
	if not fileSize then
		error(string.format("Seeking to the end of %s (%s) failed!",_fileName,_filePath))
	end
	-- rewind
	fileToAdd:seek("set")

	-- grab data
	local fileData = fileToAdd:read("*a")
	if #fileData ~= fileSize then
		print("(!) WARNING: Read file size does not match initial file size!")
	end

	fileToAdd:close()

	-- add entry to curFileList
	table.insert(curFileList,
		{
			FileNum=_fileNum,
			FileID=_fileID,
			Filename=_fileName,
			LoadAddr=_loadAddr,
			FileSize=fileSize,
			FileType=_fileType,
			FileData=fileData
		}
	)
end

--============================================================================--
-- the command parsing club!
--============================================================================--
-- parseTotalSides()
local function parseTotalSides(_args)
	if not exportFDSHeader then
		print("(!) WARNING: totalsides only matters in headered files")
		return
	end

	totalSides = tonumber(_args,16)
	-- calculate number of disks from number of sides, rounding up
	totalDisks = math.ceil(totalSides/2)
end

--============================================================================--
-- parseManufacturer()
local function parseManufacturer(_args)
	local manufacturer = tonumber(_args,16)
	if not manufacturer or manufacturer > 255 then
		error("Invalid input for manufacturer!")
	end
	print(string.format("Manufacturer: 0x%02X (%d)",manufacturer,manufacturer))
	diskInformation.Manufacturer = manufacturer
end

--============================================================================--
-- parseGameName()
local function parseGameName(_args)
	local gameName = _args
	if #gameName > 3 then
		print("(!) WARNING: Game Name is longer than 3 characters; truncating")
		gameName = string.sub(gameName,1,3)
	end

	if #gameName < 3 then
		print("(!) WARNING: Game Name is less than 3 characters; padding")
		-- pad input (quite hackily, I might add)
		for i=1,(3-#gameName) do
			gameName = gameName.." "
		end
	end

	print(string.format("Game Name: %s",gameName))
	diskInformation.GameName = gameName
end

--============================================================================--
local gameTypeToChar = {
	normal = " ",
	event  = "E",
	sale   = "R"
}

-- parseGameType()
local function parseGameType(_args)
	if not gameTypeToChar[_args] then
		error(string.format("Error: Invalid game type '%s'",_args))
	end

	print(string.format("Game Type: %s ('%s')",_args,gameTypeToChar[_args]))
	diskInformation.GameType = gameTypeToChar[_args]
end

--============================================================================--
-- parseVersion()
local function parseVersion(_args)
	local version = tonumber(_args,16)
	if not version or version > 255 then
		error("Invalid input for version!")
	end
	print(string.format("Version: 0x%02X (%d)",version,version))
	diskInformation.Version = version
end

--============================================================================--
-- parseSideNum()
local function parseSideNum(_args)
	local sidenum = tonumber(_args,16)
	if not sidenum or sidenum > 1 then
		error("Invalid input for side number!")
	end
	print(string.format("Side Number: 0x%02X (%s)",sidenum,sidenum == 0 and "A" or "B"))
	diskInformation.SideNum = sidenum
end

--============================================================================--
-- parseDiskNum()
local function parseDiskNum(_args)
	local disknum = tonumber(_args,16)
	if not disknum or disknum > 255 then
		error("Invalid input for disk number!")
	end
	print(string.format("Disk Number: 0x%02X (%d)",disknum,disknum))
	diskInformation.DiskNum = disknum
end

--============================================================================--
-- parseDiskType()
local function parseDiskType(_args)
	local disktype = tonumber(_args,16)
	if not disktype or disktype > 255 then
		error("Invalid input for disk type!")
	end
	print(string.format("Disk Type: 0x%02X (%d)",disktype,disktype))
	diskInformation.DiskType = disktype
end

--============================================================================--
-- parseBootFile()
local function parseBootFile(_args)
	local bootfile = tonumber(_args,16)
	if not bootfile or bootfile > 255 then
		error("Invalid input for boot file ID!")
	end
	print(string.format("Boot File ID: 0x%02X (%d)",bootfile,bootfile))
	diskInformation.BootFileID = bootfile
end

--============================================================================--
-- parseMakeDate()
local function parseMakeDate(_args)
	local finalDate = 0
	if _args == "now" then
		-- special case "now": use today's date
		local date = getToday()
		finalDate = tonumber(string.format("%s%s%s",date.Y,date.M,date.D),16)
	else
		-- date is already in hex BCD representation
		finalDate = tonumber(_args,16)
	end

	print(string.format("Manufacturing Date: %06X",finalDate))
	diskInformation.ManufactureDate = finalDate
end

--============================================================================--
-- parseCountry()
local function parseCountry(_args)
	-- currently unimplemented
	print("(!) WARNING: 'country' command is currently unimplemented.")
end

--============================================================================--
-- parseUnknown6*()
local function parseUnknown6a(_args)
	diskInformation.Unknown6a = tonumber(_args,16)
end
local function parseUnknown6b(_args)
	diskInformation.Unknown6b = tonumber(_args,16)
end
local function parseUnknown6c(_args)
	diskInformation.Unknown6c = tonumber(_args,16)
end
local function parseUnknown6d(_args)
	diskInformation.Unknown6d = tonumber(_args,16)
end
local function parseUnknown6e(_args)
	diskInformation.Unknown6e = tonumber(_args,16)
end

--============================================================================--
-- parseWriteDate()
local function parseWriteDate(_args)
	local finalDate = 0
	if _args == "now" then
		-- special case "now": use today's date
		local date = getToday()
		finalDate = tonumber(string.format("%s%s%s",date.Y,date.M,date.D),16)
	else
		-- date is already in hex BCD representation
		finalDate = tonumber(_args,16)
	end

	print(string.format("Write Date: %06X",finalDate))
	diskInformation.WriteDate = finalDate
end

--============================================================================--
-- parseDiskWriter()
local function parseDiskWriter(_args)
	local serial = tonumber(_args,16)
	if not serial or serial > 65535 then
		error("Invalid input for Disk Writer Serial Number!")
	end
	print(string.format("Disk Writer Serial Number: 0x%04X (%d)",serial,serial))
	diskInformation.WriterSerial = serial
end

--============================================================================--
-- parseRealDiskSide()
local function parseRealDiskSide(_args)
	local diskside = tonumber(_args,16)
	if not diskside or diskside > 255 then
		error("Invalid input for real disk side!")
	end
	print(string.format("Real Disk Side: 0x%02X (%d)",diskside,diskside))
	diskInformation.RealDiskSide = diskside
end

--============================================================================--
-- parsePrice()
local function parsePrice(_args)
	local price = tonumber(_args,16)
	if not price or price > 255 then
		error("Invalid input for price!")
	end
	print(string.format("Price: 0x%02X (%d)",price,price))
	diskInformation.Price = price
end

--============================================================================--
-- parseNumFiles()
local function parseNumFiles(_args)
	local numFiles = tonumber(_args,16)
	if not numFiles or numFiles > 255 then
		error("Invalid input for number of files!")
	end
	print(string.format("Reported number of Files: 0x%02X (%d)",numFiles,numFiles))
	reportedNumFiles = numFiles
	diskInformation.NumFiles = numFiles
end

--============================================================================--
-- parseFile()
-- This function does a lot of heavy lifting, but not as much as AddFile().

local function parseFile(_args)
	-- unlike all other files, we need to parse the arguments further.
	print("----------------------------------------------------------------")

	-- the arguments are in this format:
	-- num,ID,"FILENAME",loadAddr,loadType,pathStr

	-- the values
	local fileNum,fileID,fileName,loadAddr,loadType,pathStr
	-- re-usable comma position finder
	local commaPos = string.find(_args,",")
	local lastComma = -1
	-- file number
	fileNum = tonumber(string.sub(_args,1,commaPos-1),16)

	-- file ID
	lastComma = commaPos
	commaPos = string.find(_args,",",commaPos+1)
	fileID = tonumber(string.sub(_args,lastComma+1,commaPos-1),16)

	-- filename
	lastComma = commaPos
	commaPos = string.find(_args,",",commaPos+1)
	fileName = string.sub(_args,lastComma+2,commaPos-2)
	-- pad filename to 8 characters with $00
	local fnLen = #fileName
	if fnLen < 8 then
		for i=fnLen,8 do
			fileName = fileName..string.char(0)
		end
	end

	-- file load address (LSB first when writing)
	lastComma = commaPos
	commaPos = string.find(_args,",",commaPos+1)
	loadAddr = tonumber(string.sub(_args,lastComma+1,commaPos-1),16)

	-- file load type (string)
	lastComma = commaPos
	commaPos = string.find(_args,",",commaPos+1)
	loadType = string.sub(_args,lastComma+1,commaPos-1)

	-- file path string is the last entry
	pathStr = string.sub(_args,commaPos+1)

	-- call AddFile
	AddFile(fileNum,fileID,fileName,loadAddr,loadType,pathStr)

	-- increment realNumFiles after calling AddFile
	realNumFiles = realNumFiles + 1

end

--============================================================================--
-- commandHeader()
local function commandHeader()
	exportFDSHeader = true
	print("Will create FDS file with fwNES header.")
end

--============================================================================--
-- commandNoHeader()
local function commandNoHeader()
	exportFDSHeader = false
	print("Will create headerless FDS file.")
end

--============================================================================--
-- commands with arguments
local scriptCommands = {
	totalsides   = parseTotalSides,
	manufacturer = parseManufacturer,
	gamename     = parseGameName,
	gametype     = parseGameType,
	version      = parseVersion,
	sidenum      = parseSideNum,
	disknum      = parseDiskNum,
	disktype     = parseDiskType,
	bootfile     = parseBootFile,
	makedate     = parseMakeDate,
	country      = parseCountry,
	unknown6a    = parseUnknown6a,
	unknown6b    = parseUnknown6b,
	unknown6c    = parseUnknown6c,
	unknown6d    = parseUnknown6d,
	unknown6e    = parseUnknown6e,
	writedate    = parseWriteDate,
	diskwriter   = parseDiskWriter,
	realdiskside = parseRealDiskSide,
	price        = parsePrice,
	numfiles     = parseNumFiles,
	file         = parseFile
}

-- commands without arguments
local stateCommands = {
	header       = commandHeader,
	noheader     = commandNoHeader,
	nextside     = nil,
	newdisk      = nil
}

--============================================================================--
-- MakeHeader()
-- Creates a fwNES .FDS header.
local function MakeHeader()
	-- "FDS",$1A
	fdsOutFile:write("FDS")
	fdsOutFile:write(string.char(26))

	-- num sides
	fdsOutFile:write(string.char(totalSides))

	-- padding (11 bytes)
	for i=1,11 do
		fdsOutFile:write(string.char(0))
	end
end

--============================================================================--
-- MakeBlock1()
-- Disk information block
local function MakeBlock1()
	fdsOutFile:write(string.char(1)) -- block type 1
	fdsOutFile:write("*NINTENDO-HVC*")
	fdsOutFile:write(string.char(diskInformation.Manufacturer))
	fdsOutFile:write(diskInformation.GameName)
	fdsOutFile:write(diskInformation.GameType)
	fdsOutFile:write(string.char(diskInformation.Version))
	fdsOutFile:write(string.char(diskInformation.SideNum)) -- disk side
	fdsOutFile:write(string.char(diskInformation.DiskNum)) -- disk number
	fdsOutFile:write(string.char(diskInformation.DiskType))

	-- unknown 1 (1 byte)
	-- disk color??
	fdsOutFile:write(string.char(0))

	fdsOutFile:write(string.char(diskInformation.BootFileID)) -- boot read file code

	-- unknown 2 (5 $FF values)
	fdsOutFile:write(string.char(255))
	fdsOutFile:write(string.char(255))
	fdsOutFile:write(string.char(255))
	fdsOutFile:write(string.char(255))
	fdsOutFile:write(string.char(255))

	-- ManufactureDate is a number; we need to split it into three bytes
	fdsOutFile:write(string.char(bit32.rshift(bit32.band(diskInformation.ManufactureDate,0x00FF0000),16)))
	fdsOutFile:write(string.char(bit32.rshift(bit32.band(diskInformation.ManufactureDate,0x0000FF00),8)))
	fdsOutFile:write(string.char(bit32.band(diskInformation.ManufactureDate,0x000000FF)))

	-- country code (todo: hardcoded to Japan)
	fdsOutFile:write(string.char(0x49))
	-- unknown 3/region code? (1 byte)
	fdsOutFile:write(string.char(0x61))

	-- unknown 4 (1 byte)
	fdsOutFile:write(string.char(0))

	-- unknown 5 (2 bytes)
	fdsOutFile:write(string.char(0))
	fdsOutFile:write(string.char(2))

	-- unknown 6 (5 bytes)
	-- diskInformation.Unknown6
	fdsOutFile:write(string.char(diskInformation.Unknown6a))
	fdsOutFile:write(string.char(diskInformation.Unknown6b))
	fdsOutFile:write(string.char(diskInformation.Unknown6c))
	fdsOutFile:write(string.char(diskInformation.Unknown6d))
	fdsOutFile:write(string.char(diskInformation.Unknown6e))

	-- diskInformation.WriteDate is also a number that needs to be split into three bytes
	fdsOutFile:write(string.char(bit32.rshift(bit32.band(diskInformation.WriteDate,0x00FF0000),16)))
	fdsOutFile:write(string.char(bit32.rshift(bit32.band(diskInformation.WriteDate,0x0000FF00),8)))
	fdsOutFile:write(string.char(bit32.band(diskInformation.WriteDate,0x000000FF)))

	-- unknown 7 (1 byte)
	-- related to disk writing? some (rewritten?) disk images have $FF here.
	fdsOutFile:write(string.char(0))

	-- unknown 8 (1 byte)
	-- related to disk writing? some disk images have $80 here.
	fdsOutFile:write(string.char(255))

	-- diskInformation.WriterSerial
	-- two bytes... probably little endian (LSB,MSB)
	fdsOutFile:write(string.char(bit32.rshift(bit32.band(diskInformation.WriterSerial,0xFF00),8)))
	fdsOutFile:write(string.char(bit32.band(diskInformation.WriterSerial,0x00FF)))

	-- unknown 9 (1 byte)
	-- related to disk writing? some disk images have $06 here.
	fdsOutFile:write(string.char(255))

	-- disk rewrite count
	fdsOutFile:write(string.char(0))

	-- diskInformation.RealDiskSide
	fdsOutFile:write(string.char(diskInformation.RealDiskSide))

	-- unknown 10 (1 byte)
	fdsOutFile:write(string.char(0))

	-- price
	fdsOutFile:write(string.char(diskInformation.Price))
end

--============================================================================--
-- MakeBlock2()
-- Number of files block
local function MakeBlock2()
	fdsOutFile:write(string.char(2))
	fdsOutFile:write(string.char(diskInformation.NumFiles))
end

--============================================================================--
-- MakeBlock3(index, file)
-- File header block
local function MakeBlock3(_index, _file)
	fdsOutFile:write(string.char(3))
	fdsOutFile:write(string.char(_file.FileNum)) -- file number
	fdsOutFile:write(string.char(_file.FileID)) -- file ID code
	fdsOutFile:write(string.upper(string.sub(_file.Filename,1,8))) -- filename, 8 chars uppercase ascii

	--fdsOutFile:write(_file.LoadAddr)
	fdsOutFile:write(string.char(bit32.band(_file.LoadAddr,0x000000FF)))
	fdsOutFile:write(string.char(bit32.rshift(bit32.band(_file.LoadAddr,0x0000FF00),8)))

	--fdsOutFile:write(_file.FileSize)
	fdsOutFile:write(string.char(bit32.band(_file.FileSize,0x000000FF)))
	fdsOutFile:write(string.char(bit32.rshift(bit32.band(_file.FileSize,0x0000FF00),8)))

	fdsOutFile:write(string.char(loadTypeToNum[_file.FileType])) -- file type
end

--============================================================================--
-- MakeBlock4(file)
-- File data block
local function MakeBlock4(_file)
	fdsOutFile:write(string.char(4))
	fdsOutFile:write(_file.FileData)
end

--============================================================================--
-- begin program, finally.

-- print header and check for number of arguments
print(string.format("makefds v%s (by freem)",VERSION))
print("========================================")

if #params < 2 then
	print("usage: lua makefds.lua (infile) (outfile)")
	return
end

inScriptName = params[1]
outFilename = params[2]

-- attempt to open script file
scriptFile,errorStr = io.open(inScriptName)

if not scriptFile then
	print(string.format("Error attempting to open \"%s\":\n%s",inScriptName,errorStr))
	return
end

-- load scriptFile contents into scriptLines
local curLine = scriptFile:read()
while curLine ~= nil do
	table.insert(scriptLines,curLine)
	curLine = scriptFile:read()
end

-- finished with scriptFile
print(string.format("Successfully loaded %s.\n",inScriptName))
scriptFile:close()

-- parse script (oh boy)
for lineNum,strCommand in pairs(scriptLines) do
	if string.sub(strCommand,1,1) == "#" or string.sub(strCommand,1,1) == ";" then
		-- this is a comment, ignore it
	else
		-- parse command
		-- find the colon
		local colonIndex = string.find(strCommand,":")
		if colonIndex then
			-- if it's found, get the command
			local thisCommand = string.sub(strCommand,1,colonIndex-1)
			local commandArgs = string.sub(strCommand,colonIndex+1)
			-- and send it to the parsing club
			if scriptCommands[thisCommand] then
				(scriptCommands[thisCommand])(commandArgs)
			else
				error(string.format("Error parsing script on line %d: unknown command '%s'",lineNum,thisCommand))
			end
		else
			-- if not found, we might have one of the commands without arguments.
			if stateCommands[strCommand] then
				(stateCommands[strCommand])()
			else
				error(string.format("Error parsing script on line %d: unknown command '%s'",lineNum,strCommand))
			end
		end
	end
end

-- create output file
fdsOutFile,errorStr = io.open(outFilename,"w+b")
if not fdsOutFile then
	print(string.format("Error attempting to open \"%s\" for writing:\n%s",inScriptName,errorStr))
	return
end

-- write header if needed
if exportFDSHeader then
	MakeHeader()
else
	-- headerless files are single sides of disks
	totalSides = 0
end

-- file list!
for i,file in pairs(curFileList) do
	print("File "..i)
	for k,v in pairs(file) do
		if k ~= "FileData" then
			print(string.format("[%s] %s",k,v))
		end
	end
end

if totalSides == 0 then
	-- only do one side
	MakeBlock1()
	MakeBlock2()

	for i,file in pairs(curFileList) do
		MakeBlock3(i,file)
		MakeBlock4(file)
	end
else
	-- for all sides
	for i=1,totalSides do
		MakeBlock1()
		MakeBlock2()

		for j,file in pairs(curFileList) do
			MakeBlock3(j,file)
			MakeBlock4(file)
		end
	end
end

fdsOutFile:close()
