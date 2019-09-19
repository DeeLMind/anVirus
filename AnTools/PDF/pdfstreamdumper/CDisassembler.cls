VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CDisassembler"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
'dzzie@yahoo.com
'http://sandsprite.com

Private Type t_Disasm  '         // Results of disassembling
  ip As Long  '                  // Instrucion pointer
  dump As String * 256        '  // Hexadecimal dump of the command
  result As String * 256
  comment As String * 256     '  // Brief comment
  cmdtype As Long '              // One of C_xxx
  memtype As Long '              // Type of addressed variable in memory
  nprefix As Long '              // Number of prefixes
  indexed As Long '              // Address contains register(s)
  jmpconst As Long '             // Constant jump address
  jmptable As Long '             // Possible address of switch table
  adrconst As Long '             // Constant part of address
  immconst As Long '             // Immediate constant
  zeroconst As Long '            // Whether contains zero constant
  fixupoffset As Long '          // Possible offset of 32-bit fixups
  fixupsize As Long '            // Possible total size of fixups or 0
  error As Long '                // Error while disassembling command
  warnings As Long '             // Combination of DAW_xxx
End Type

Enum disasmMode
    DISASM_SIZE = 0     '            // Determine command size only
    DISASM_DATA = 1     '            // Determine size and analysis data
    DISASM_FILE = 3     '            // Disassembly, no symbols
    DISASM_CODE = 4     '            // Full disassembly
End Enum

Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (Destination As Any, Source As Any, ByVal Length As Long)

Private Declare Function disasm Lib "olly.dll" Alias "Disasm" ( _
        ByRef src As Byte, ByVal srcsize As Long, ByVal ip As Long, _
        disasm As t_Disasm, dMode As disasmMode) As Long


Function DisasmBytes(b() As Byte, va As Long) As CInstruction
    Dim da As t_Disasm
    Dim x As Long
    Dim src As String
    Dim dump As String
    Dim inst As String
    
    Dim ret As New CInstruction
    
    x = disasm(b(0), UBound(b) + 1, va, da, DISASM_CODE)
    
    ret.instLen = x
    ret.offset = Hex(va)
    
    inst = da.result
    dump = da.dump

    x = InStr(inst, Chr(0)) - 1
    ret.command = Mid(inst, 1, x)
    
    x = InStr(dump, Chr(0)) - 1
    ret.dump = Mid(dump, 1, x)
    'If x < 30 Then dump = dump & Space(30 - x)
    
    Set DisasmBytes = ret
    
End Function

Function DisasmBlock(b() As Byte, ByVal va As Long) As Collection
    Dim tmp() As Byte
    Dim disasmLen As Long
    Dim pointer As Long
    Dim inst As String
    Dim dump As String
    
    Dim d As CInstruction
    Dim ret As New Collection
    
    On Error GoTo hell
    
    pointer = LBound(b)
     
    While pointer < UBound(b) + 1
    
        ReDim tmp(UBound(b) - pointer + 1)
        CopyMemory tmp(0), b(pointer), UBound(tmp)
        
        Set d = DisasmBytes(tmp, va)
        ret.Add d
        
        va = va + d.instLen
        pointer = pointer + d.instLen
        
    Wend
    
hell:
    Set DisasmBlock = ret

 
End Function

 
