#SingleInstance force

IniRead, castDuration1, settings.ini, settings, castDuration1, 1000
IniRead, castDurationKey1, settings.ini, settings, castDurationKey1, Q
IniRead, castDuration2, settings.ini, settings, castDuration2, 1000
IniRead, castDurationKey2, settings.ini, settings, castDurationKey2, W
IniRead, castDuration3, settings.ini, settings, castDuration3, 1000
IniRead, castDurationKey3, settings.ini, settings, castDurationKey3, E
IniRead, castDuration4, settings.ini, settings, castDuration4, 1000
IniRead, castDurationKey4, settings.ini, settings, castDurationKey4, R
IniRead, castDuration5, settings.ini, settings, castDuration5, 1000
IniRead, castDurationKey5, settings.ini, settings, castDurationKey5, T

IniRead, baseMgrPtr , settings.ini, settings, baseMgrPtr, 0

; Example: Tab control:
Gui, margin, 0,0
Gui, Add, Tab3,x0 y0 w340 h360, Cast on Duration|About

Gui, Add, GroupBox, x12 y40 w310 h60, Cast skill 1
Gui, Add, Text, x20 y60 w60, Duration
Gui, Add, Edit, x70 y60 w100 r1 gGuiUpdate vcastDuration1, %castDuration1%
Gui, Add, Text, x200 y60 w60, Key
Gui, Add, Edit, x230 y60 w80 r1 gGuiUpdate vcastDurationKey1, %castDurationKey1%

Gui, Add, GroupBox, x12 y110 w310 h60, Cast skill 2
Gui, Add, Text, x20 y130 w60, Duration
Gui, Add, Edit, x70 y130 w100 r1 gGuiUpdate vcastDuration2, %castDuration2%
Gui, Add, Text, x200 y130 w60, Key
Gui, Add, Edit, x230 y130 w80 r1 gGuiUpdate vcastDurationKey2, %castDurationKey2%

Gui, Add, GroupBox, x12 y170 w310 h60, Cast skill 3
Gui, Add, Text, x20 y190 w60, Duration
Gui, Add, Edit, x70 y190 w100 r1 gGuiUpdate vcastDuration3, %castDuration3%
Gui, Add, Text, x200 y190 w60, Key
Gui, Add, Edit, x230 y190 w80 r1 gGuiUpdate vcastDurationKey3, %castDurationKey3%

Gui, Add, GroupBox, x12 y230 w310 h60, Cast skill 4
Gui, Add, Text, x20 y250 w60, Duration
Gui, Add, Edit, x70 y250 w100 r1 gGuiUpdate vcastDuration4, %castDuration4%
Gui, Add, Text, x200 y250 w60, Key
Gui, Add, Edit, x230 y250 w80  r1 gGuiUpdate vcastDurationKey4, %castDurationKey4%

Gui, Add, GroupBox, x12 y290 w310 h60, Cast skill 5
Gui, Add, Text, x20 y310 w60, Duration
Gui, Add, Edit, x70 y310 w100 r1 gGuiUpdate vcastDuration5, %castDuration5%
Gui, Add, Text, x200 y310 w60, Key
Gui, Add, Edit, x230 y310 w80  r1 gGuiUpdate vcastDurationKey5, %castDurationKey5%

Gui, Tab, About
Gui, Add, GroupBox, x12 y40 w310 h70, Author
Gui, Add, Text, x20 y60 w300, Name: Tam Dao
Gui, Add, Link, x20 y80 w300, Repository: <a href="https://github.com/tamdao/POE-Autocast">https://github.com/tamdao/POE-Autocast</a>

Gui, Tab
Gui, Show

#Include AutoHotkeyMemoryLib.ahk

cliname=Path of Exile
cliexe=PathOfExile.exe
10secsTimer:=A_TickCount-10000
basePtrAoBArray:=[0xCE, 0x50, 0xC7, 0x45, 0xF0]
basePtrAobOffset:=+0x10
WindowBasicsCache:=[]
CastDurationCache:=[100, 100, 100, 100, 100]

Loop {
  Main()
}

Main() {
  global cliexe
  global castDuration1
  global castDurationKey1
  global castDuration2
  global castDurationKey2
  global castDuration3
  global castDurationKey3
  global castDuration4
  global castDurationKey4
  global castDuration5
  global castDurationKey5

  global CastDurationCache

  WinGet, WinID, List, %cliname%

  Loop, %WinID% {
    WinGet, ProcModuleName, ProcessName,  % "ahk_id" WinID%A_Index%
    If (ProcModuleName!="PathOfExile.exe") And (ProcModuleName!="PathOfExileSteam.exe") ; got a window with title "Path of Exile" but exe is not Client.exe, perhaps we have browser window open with PoE site, ignore it
    {
      continue
    }
    PlayerStats:={}
    ReadPlayerStats(WinID%A_Index%, PlayerStats)

    If PlayerStats.MapName = "Enlightened Hideout" {
      continue
    }

    CastDurationCache[0] -= 100
    CastDurationCache[1] -= 100
    CastDurationCache[2] -= 100
    CastDurationCache[3] -= 100
    CastDurationCache[4] -= 100

    Random, randomOffset, 200, 1200

    IfWinActive Path of Exile ahk_class POEWindowClass
    {
      If(castDuration1 > 0 && CastDurationCache[0] <= 0) {
        SendCastKey(castDurationKey1)
        CastDurationCache[0] := castDuration1 + randomOffset
      }

      If(castDuration2 > 0 && CastDurationCache[1] <= 0) {
        SendCastKey(castDurationKey2)
        CastDurationCache[1] := castDuration2 + randomOffset
      }
      
      If(castDuration3 > 0 && CastDurationCache[2] <= 0) {
        SendCastKey(castDurationKey3)
        CastDurationCache[2] := castDuration3 + randomOffset
      }

      If(castDuration4 > 0 && CastDurationCache[3] <= 0) {
        SendCastKey(castDurationKey4)
        CastDurationCache[3] := castDuration4 + randomOffset
      }

      If(castDuration5 > 0 && CastDurationCache[4] <= 0) {
        SendCastKey(castDurationKey5)
        CastDurationCache[4] := castDuration5 + randomOffset
      }
    }
  }
  Sleep, 100
}

SendCastKey(hkey) {
  Sendinput, {%hkey% Down}
  Sendinput, {%hkey% Up}
}

ReadPlayerStats(hwnd, byRef PlayerStats)
{
  global Offset1:=0x138
  global Offset2:=0x144
  global Offset3:=0x13c
  global Offset4:=0x220
  global Offset5:=0x3934
  global Offset6:=0x158c
  global Offset7:=0x1590
  global Offset8:=0xa00
  global Offset9:=0x9a8
  global Offset10:=0xa34
  global Offset11:=0xa9c
   
  GetWindowBasics(hwnd, mBase, pH)
  fBase:=GetFrameBase(hwnd)
  BaseMgr:=ReadMemUInt(pH,mBase+baseMgrPtr)
  PlayerBase:=GetMultilevelPointer(pH,[fBase+Offset1,Offset2])
  ;Config:=GetMultilevelPointer(pH,[BaseMgr+0x180,0x108,0x8c])
  ;PlayerStats.ConfigPath:=ReadMemStr(ph,Config+0xa4,255,"UTF-16")
  PlayerMain:=ReadMemUInt(pH,PlayerBase+4)
  PlayerStatsOffset:=ReadMemUInt(pH,PlayerMain+0xC)
  PlayerStats.MaxHP:=ReadMemUInt(pH,PlayerStatsOffset+0x2c)
  PlayerStats.CurrHP:=ReadMemUInt(pH,PlayerStatsOffset+0x30)  
  PlayerStats.ReservedHPFlat:=ReadMemUInt(pH,PlayerStatsOffset+0x38)
  PlayerStats.ReservedHPPercent:=ReadMemUInt(pH,PlayerStatsOffset+0x3c)
  PlayerStats.MaxMana:=ReadMemUInt(pH,PlayerStatsOffset+0x50)
  PlayerStats.ReservedManaFlat:=ReadMemUInt(pH,PlayerStatsOffset+0x5c)
  PlayerStats.ReservedManaPercent:=ReadMemUInt(pH,PlayerStatsOffset+0x60)
  PlayerStats.CurrMana:=ReadMemUInt(pH,PlayerStatsOffset+0x54)
  PlayerStats.MaxEShield:=ReadMemUInt(pH,PlayerStatsOffset+0x74)
  PlayerStats.CurrEShield:=ReadMemUInt(pH,PlayerStatsOffset+0x78)
  PlayerActionIDOffset:=ReadMemUInt(pH,PlayerMain+0x1C)
  PlayerStats.PlayerActionID:=ReadMemUInt(pH,PlayerActionIDOffset+0x70)
  /*
  SetFormat, IntegerFast, hex
  PlayerActionID += 0
  PlayerActionID .= ""
  StringRight, PlayerActionID2, PlayerActionID, 2
  SetFormat, IntegerFast, d
  PlayerStats.PlayerActionID:=PlayerActionID2
  */

  BuffListStart:=ReadMemUInt(pH,PlayerStatsOffset+0x94)
  BuffListEnd:=ReadMemUInt(pH,PlayerStatsOffset+0x98)
  BuffAmount:=((BuffListEnd-BuffListStart)/4)
  PlayerStats.BuffAmount:=((BuffListEnd-BuffListStart)/4)
  Loop, %BuffAmount%
  {
    BuffBasePtr:=GetMultilevelPointer(ph,[BuffListStart+((A_Index-1)*4),4])
    BuffNamePtr:=GetMultilevelPointer(ph,[BuffBasePtr+4,0])
    BuffNameStr:=ReadMemStr(ph,BuffNamePtr,70,"UTF-16")
    PlayerStats.BuffName[A_Index]:=BuffNameStr
    BuffCharges:=ReadMemUInt(pH,BuffBasePtr+0x20)
    PlayerStats.BuffCharges[A_Index]:=BuffCharges
    BuffTimer:=ReadMemFloat(pH,BuffBasePtr+0xC)
    PlayerStats.BuffTimer[A_Index]:=BuffTimer
  }


  CheckBase:=GetMultilevelPointer(pH,[fBase+Offset3,Offset4])

  ChatStatusOffset:=GetMultilevelPointer(pH,[CheckBase+Offset9,0x708,0x0])
  PlayerStats.ChatStatus:=ReadMemUInt(pH,ChatStatusOffset+0x754)

  PanelInventoryOffset:=ReadMemUInt(pH,CheckBase+Offset8)
  PlayerStats.PanelInventory:=ReadMemUInt(pH,PanelInventoryOffset+0x754)
  PanelSocialOffset:=ReadMemUInt(pH,CheckBase+Offset8+0x14)
  PlayerStats.PanelSocial:=ReadMemUInt(pH,PanelSocialOffset+0x754)
  PanelSkillTreeOffset:=ReadMemUInt(pH,CheckBase+Offset8+0x18)
  PlayerStats.PanelSkillTree:=ReadMemUInt(pH,PanelSkillTreeOffset+0x754)
  PanelWaypointOffset:=ReadMemUInt(pH,CheckBase+Offset8+0x30)
  PlayerStats.PanelWaypoint:=ReadMemUInt(pH,PanelWaypointOffset+0x754)
  PanelInstanceManagerOffset:=ReadMemUInt(pH,CheckBase+Offset8+0xB8)  ;added by immor
  PlayerStats.PanelInstanceManager:=ReadMemUInt(pH,PanelInstanceManagerOffset+0x754) ;added by immor
  InCityOffset:=GetMultilevelPointer(pH,[CheckBase+Offset10,0x704,0x958])
  PlayerStats.InCity:=ReadMemUInt(pH,InCityOffset+0x754)
  MouseOnEnemyOffset:=GetMultilevelPointer(pH,[CheckBase+Offset11,0x8c4,0x7f4])
  PlayerStats.MouseOnEnemyStatus:=ReadMemUInt(pH,MouseOnEnemyOffset+0x38)
  EnemyNamePtr:=GetMultilevelPointer(ph,[CheckBase+Offset11,0x8c4,0xb30])
  EnemyName:=ReadMemStr(ph,EnemyNamePtr,70,"UTF-16")
  PlayerStats.EnemyName:=EnemyName
  EnemyNamePtr2:=GetMultilevelPointer(ph,[CheckBase+Offset11,0x8c4,0xac8])
  EnemyName2:=ReadMemStr(ph,EnemyNamePtr2+0x32,70,"UTF-16")
  PlayerStats.EnemyName2:=EnemyName2

  MapNameOffset:=GetMultilevelPointer(pH,[fBase+Offset1,0x8,0x4])
  MapName:=ReadMemStr(ph,MapNameOffset,100,"UTF-16")
  PlayerStats.MapName:=MapName
}

GetFrameBase(hwnd)
{
   global baseMgrPtr
   global WindowBasicsCache
   global cliname
   global 10secsTimer

   WinGet, CurrPid, PID, ahk_id %hwnd%
   k="%hwnd%%CurrPid%"

   fB:=WindowBasicsCache[k].fBase

   If fB=
   {
      If (A_TickCount>=10secsTimer+10000)
      {
        IniRead, MD5Hash , settings.ini, settings, MD5Hash, 0
      WinGet FullEXEPath, ProcessPath, %cliname%
      NewMD5Hash:=FileMD5(FullEXEPath)

      If (NewMD5Hash!=MD5Hash)
      {
        IniWrite, 0 , settings.ini, settings, baseMgrPtr
        baseMgrPtr:= 0
        IniWrite, %NewMD5Hash% , settings.ini, settings, MD5Hash
      }
      10secsTimer:=A_TickCount
      }

      GetWindowBasics(hwnd, mBase, pH, mSize)

      If baseMgrPtr= 0
      {
         ScanBaseMgrPtr(mBase, pH, mSize)
      }

      fB:=GetMultilevelPointer(pH,[mBase+baseMgrPtr,4,0xFC,0x11c])
      WindowBasicsCache[k].fBase:=fB
   }
   return fB
}

ScanBaseMgrPtr(mBase,pH,moduleSize)
{
   global basePtrAoBArray
   global basePtrAobOffset
   global baseMgrPtr
   aobResult:=AobScan(pH,mBase,moduleSize,basePtrAoBArray)

   If aobResult
   {
      SetFormat, IntegerFast, hex
      baseMgrPtr:=ReadMemUInt(pH,mBase+aobResult+basePtrAobOffset)-mBase
      If (trayNotIfications)
     TrayTip, New Base Pointer Found, baseMgrPtr = %baseMgrPtr%
     IniWrite, %baseMgrPtr% , settings.ini, settings, baseMgrPtr
     SetFormat, IntegerFast, dec
   }
   Else
   {
      MsgBox, baseMgrPtr not found with AoBScan, script will now terminate
      ExitApp
   }   
}

GetWindowBasics(hwnd, byref mB="", byref pH="", byref mS="")
{
   
   global WindowBasicsCache
   global cliexe
   
   WinGet, CurrPid, PID, ahk_id %hwnd%
   
   k="%hwnd%%CurrPid%"
   
   mB:=WindowBasicsCache[k].mBase
   mS:=WindowBasicsCache[k].mSize
   
   If mB=
   {
      WindowBasicsCache[k]:=Object()
      GetModuleInfo(cliexe, CurrPid, mB, mS)
      If (mB="" || mS="")
      {
         MsgBox, Failed to obtain moduleBase or moduleSize for PID %CurrPid% %hwnd%, script will now terminate
         ExitApp
      }      
      WindowBasicsCache[k].mBase:=mB
      WindowBasicsCache[k].mSize:=mS
   }

   pH:=WindowBasicsCache[k].ProcessHandle
   If pH=
   {
      pH:=GetProcessHandle(CurrPid)
      If (pH="" || pH=-1)
      {
         MsgBox, Invalid process handle obtained for PID %CurrPid%, script will now terminate
         ExitApp
      }      
      WindowBasicsCache[k].ProcessHandle:=pH
   }
}

FileMD5( sFile="", cSz=4 )
{  ; by SKAN www.autohotkey.com/community/viewtopic.php?t=64211
  cSz := (cSz<0||cSz>8) ? 2**22 : 2**(18+cSz), VarSetCapacity( Buffer,cSz,0 ) ; 18-Jun-2009
  hFil := DllCall( "CreateFile", Str,sFile,UInt,0x80000000, Int,3,Int,0,Int,3,Int,0,Int,0 )
  IfLess,hFil,1, Return,hFil
  hMod := DllCall( "LoadLibrary", Str,"advapi32.dll" )
  DllCall( "GetFileSizeEx", UInt,hFil, UInt,&Buffer ),    fSz := NumGet( Buffer,0,"Int64" )
  VarSetCapacity( MD5_CTX,104,0 ),    DllCall( "advapi32\MD5Init", UInt,&MD5_CTX )
  Loop % ( fSz//cSz + !!Mod( fSz,cSz ) )
  DllCall( "ReadFile", UInt,hFil, UInt,&Buffer, UInt,cSz, UIntP,bytesRead, UInt,0 )
  , DllCall( "advapi32\MD5Update", UInt,&MD5_CTX, UInt,&Buffer, UInt,bytesRead )
  DllCall( "advapi32\MD5Final", UInt,&MD5_CTX )
  DllCall( "CloseHandle", UInt,hFil )
  Loop % StrLen( Hex:="123456789ABCDEF0" )
  N := NumGet( MD5_CTX,87+A_Index,"Char"), MD5 .= SubStr(Hex,N>>4,1) . SubStr(Hex,N&15,1)
  Return MD5, DllCall( "FreeLibrary", UInt,hMod )
}

GuiUpdate:
  Gui, Submit, NoHide

  IniWrite, %castDuration1%, settings.ini, settings, castDuration1
  IniWrite, %castDurationKey1%, settings.ini, settings, castDurationKey1
  IniWrite, %castDuration2%, settings.ini, settings, castDuration2
  IniWrite, %castDurationKey2%, settings.ini, settings, castDurationKey2
  IniWrite, %castDuration3%, settings.ini, settings, castDuration3
  IniWrite, %castDurationKey3%, settings.ini, settings, castDurationKey3
  IniWrite, %castDuration4%, settings.ini, settings, castDuration4
  IniWrite, %castDurationKey4%, settings.ini, settings, castDurationKey4
  IniWrite, %castDuration5%, settings.ini, settings, castDuration5
  IniWrite, %castDurationKey5%, settings.ini, settings, castDurationKey5

  CastDurationCache:=[100, 100, 100, 100, 100]
