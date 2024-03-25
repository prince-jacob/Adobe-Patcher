#NoTrayIcon
#RequireAdmin

Func _5($0, $1)
	$1 = Int($1)
	If $1 = 0 Then Return ""
	If StringLen($0) < 1 OR $1 < 0 Then Return SetError(1, 0, "")
	Local $2 = ""
	While $1 > 1
		If BitAND($1, 1) Then $2 &= $0
		$0 &= $0
		$1 = BitShift($1, 1)
	WEnd
	Return $0 & $2
EndFunc

Global Const $3 = 12582912
Global Const $4 = 78
Global Const $5 = 0 - 2
Global Const $6 = 0 - 5
Global Const $7 = BitOR(131072, $3, -2147483648, 524288)
Global Enum $8, $9, $a, $b, $c, $d, $e, $f

Func _k(ByRef $g, $h, $i = 0, $j = "|", $k = @CRLF, $l = $8)
	If $i = Default Then $i = 0
	If $j = Default Then $j = "|"
	If $k = Default Then $k = @CRLF
	If $l = Default Then $l = $8
	If NOT IsArray($g) Then Return SetError(1, 0, -1)
	Local $m = UBound($g, 1)
	Local $n = 0
	Switch $l
		Case $a
			$n = Int
		Case $b
			$n = Number
		Case $c
			$n = Ptr
		Case $d
			$n = HWnd
		Case $e
			$n = String
		Case $f
			$n = "Boolean"
	EndSwitch
	Switch UBound($g, 0)
		Case 1
			If $l = $9 Then
				ReDim $g[$m + 1]
				$g[$m] = $h
				Return $m
			EndIf
			If IsArray($h) Then
				If UBound($h, 0) <> 1 Then Return SetError(5, 0, -1)
				$n = 0
			Else
				Local $o = StringSplit($h, $j, 2 + 1)
				If UBound($o, 1) = 1 Then
					$o[0] = $h
				EndIf
				$h = $o
			EndIf
			Local $p = UBound($h, 1)
			ReDim $g[$m + $p]
			For $q = 0 To $p - 1
				If String($n) = "Boolean" Then
					Switch $h[$q]
						Case "True", "1"
							$g[$m + $q] = True
						Case "False", "0", ""
							$g[$m + $q] = False
					EndSwitch
				ElseIf IsFunc($n) Then
					$g[$m + $q] = $n($h[$q])
				Else
					$g[$m + $q] = $h[$q]
				EndIf
			Next
			Return $m + $p - 1
		Case 2
			Local $r = UBound($g, 2)
			If $i < 0 OR $i > $r - 1 Then Return SetError(4, 0, -1)
			Local $s, $t = 0, $u
			If IsArray($h) Then
				If UBound($h, 0) <> 2 Then Return SetError(5, 0, -1)
				$s = UBound($h, 1)
				$t = UBound($h, 2)
				$n = 0
			Else
				Local $v = StringSplit($h, $k, 2 + 1)
				$s = UBound($v, 1)
				Local $o[$s][0], $w
				For $q = 0 To $s - 1
					$w = StringSplit($v[$q], $j, 2 + 1)
					$u = UBound($w)
					If $u > $t Then
						$t = $u
						ReDim $o[$s][$t]
					EndIf
					For $x = 0 To $u - 1
						$o[$q][$x] = $w[$x]
					Next
				Next
				$h = $o
			EndIf
			If UBound($h, 2) + $i > UBound($g, 2) Then Return SetError(3, 0, -1)
			ReDim $g[$m + $s][$r]
			For $y = 0 To $s - 1
				For $x = 0 To $r - 1
					If $x < $i Then
						$g[$y + $m][$x] = ""
					ElseIf $x - $i > $t - 1 Then
						$g[$y + $m][$x] = ""
					Else
						If String($n) = "Boolean" Then
							Switch $h[$y][$x - $i]
								Case "True", "1"
									$g[$y + $m][$x] = True
								Case "False", "0", ""
									$g[$y + $m][$x] = False
							EndSwitch
						ElseIf IsFunc($n) Then
							$g[$y + $m][$x] = $n($h[$y][$x - $i])
						Else
							$g[$y + $m][$x] = $h[$y][$x - $i]
						EndIf
					EndIf
				Next
			Next
		Case Else
			Return SetError(2, 0, -1)
	EndSwitch
	Return UBound($g, 1) - 1
EndFunc

Global Const $0z = "SeDebugPrivilege"
Global Enum $10 = 0, $11, $12, $13

Func _1t(Const $14 = @error, Const $15 = @extended)
	Local $16 = DllCall("kernel32.dll", "dword", "GetLastError")
	Return SetError($14, $15, $16[0])
EndFunc

Func _22($17, $18, $19, $1a, $1b = 0, $1c = 0)
	Local $16 = DllCall("advapi32.dll", "bool", "AdjustTokenPrivileges", "handle", $17, "bool", $18, "struct*", $19, "dword", $1a, "struct*", $1b, "struct*", $1c)
	If @error Then Return SetError(@error, @extended, False)
	Return NOT ($16[0] = 0)
EndFunc

Func _28($1d = $12)
	Local $16 = DllCall("advapi32.dll", "bool", "ImpersonateSelf", "int", $1d)
	If @error Then Return SetError(@error, @extended, False)
	Return NOT ($16[0] = 0)
EndFunc

Func _2c($1e, $1f)
	Local $16 = DllCall("advapi32.dll", "bool", "LookupPrivilegeValueW", "wstr", $1e, "wstr", $1f, "int64*", 0)
	If @error OR NOT $16[0] Then Return SetError(@error + 10, @extended, 0)
	Return $16[3]
EndFunc

Func _2e($1g, $1h = 0, $1i = False)
	Local $16
	If $1h = 0 Then
		$16 = DllCall("kernel32.dll", "handle", "GetCurrentThread")
		If @error Then Return SetError(@error + 20, @extended, 0)
		$1h = $16[0]
	EndIf
	$16 = DllCall("advapi32.dll", "bool", "OpenThreadToken", "handle", $1h, "dword", $1g, "bool", $1i, "handle*", 0)
	If @error OR NOT $16[0] Then Return SetError(@error + 10, @extended, 0)
	Return $16[4]
EndFunc

Func _2f($1g, $1h = 0, $1i = False)
	Local $17 = _2e($1g, $1h, $1i)
	If $17 = 0 Then
		Local Const $1j = 1008
		If _1t() <> $1j Then Return SetError(20, _1t(), 0)
		If NOT _28() Then Return SetError(@error + 10, _1t(), 0)
		$17 = _2e($1g, $1h, $1i)
		If $17 = 0 Then Return SetError(@error, _1t(), 0)
	EndIf
	Return $17
EndFunc

Func _2g($17, $1k, $1l)
	Local $1m = _2c("", $1k)
	If $1m = 0 Then Return SetError(@error + 10, @extended, False)
	Local Const $1n = "dword Count;align 4;int64 LUID;dword Attributes"
	Local $1o = DllStructCreate($1n)
	Local $1p = DllStructGetSize($1o)
	Local $1b = DllStructCreate($1n)
	Local $1q = DllStructGetSize($1b)
	Local $1r = DllStructCreate("int Data")
	DllStructSetData($1o, "Count", 1)
	DllStructSetData($1o, "LUID", $1m)
	If NOT _22($17, False, $1o, $1p, $1b, $1r) Then Return SetError(2, @error, False)
	DllStructSetData($1b, "Count", 1)
	DllStructSetData($1b, "LUID", $1m)
	Local $1s = DllStructGetData($1b, "Attributes")
	If $1l Then
		$1s = BitOR($1s, 2)
	Else
		$1s = BitAND($1s, BitNOT(2))
	EndIf
	DllStructSetData($1b, "Attributes", $1s)
	If NOT _22($17, False, $1b, $1q, $1o, $1r) Then Return SetError(3, @error, False)
	Return True
EndFunc

Global Const $1t = "struct;long X;long Y;endstruct"
Global Const $1u = "struct;long Left;long Top;long Right;long Bottom;endstruct"
Global Const $1v = "struct;hwnd hWndFrom;uint_ptr IDFrom;INT Code;endstruct"
Global Const $1w = $1t & ";uint Flags;int Item;int SubItem;int iGroup"
Global Const $1x = "struct;uint Mask;int Item;int SubItem;uint State;uint StateMask;ptr Text;int TextMax;int Image;lparam Param;" & "int Indent;int GroupID;uint Columns;ptr pColumns;ptr piColFmt;int iGroup;endstruct"
Global Const $1y = $1v & ";int Index;int SubItem;uint NewState;uint OldState;uint Changed;" & $1t & ";lparam lParam;uint KeyFlags"
Global Const $1z = "dword Length;ptr Descriptor;bool InheritHandle"
Global Const $20 = "handle hProc;ulong_ptr Size;ptr Mem"

Func _2l(ByRef $21)
	Local $22 = DllStructGetData($21, "Mem")
	Local $23 = DllStructGetData($21, "hProc")
	Local $24 = _2z($23, $22, 0, 32768)
	DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $23)
	If @error Then Return SetError(@error, @extended, False)
	Return $24
EndFunc

Func _2s($25, $26, ByRef $21)
	Local $16 = DllCall("user32.dll", "dword", "GetWindowThreadProcessId", "hwnd", $25, "dword*", 0)
	If @error Then Return SetError(@error + 10, @extended, 0)
	Local $27 = $16[2]
	If $27 = 0 Then Return SetError(1, 0, 0)
	Local $1g = BitOR(8, 16, 32)
	Local $23 = _30($1g, False, $27, True)
	Local $28 = BitOR(8192, 4096)
	Local $22 = _2x($23, 0, $26, $28, 4)
	If $22 = 0 Then Return SetError(2, 0, 0)
	$21 = DllStructCreate($20)
	DllStructSetData($21, "hProc", $23)
	DllStructSetData($21, "Size", $26)
	DllStructSetData($21, "Mem", $22)
	Return $22
EndFunc

Func _2u(ByRef $21, $29, $2a, $26)
	Local $16 = DllCall("kernel32.dll", "bool", "ReadProcessMemory", "handle", DllStructGetData($21, "hProc"), "ptr", $29, "struct*", $2a, "ulong_ptr", $26, "ulong_ptr*", 0)
	If @error Then Return SetError(@error, @extended, False)
	Return $16[0]
EndFunc

Func _2v(ByRef $21, $29, $2a = 0, $26 = 0, $2b = "struct*")
	If $2a = 0 Then $2a = DllStructGetData($21, "Mem")
	If $26 = 0 Then $26 = DllStructGetData($21, "Size")
	Local $16 = DllCall("kernel32.dll", "bool", "WriteProcessMemory", "handle", DllStructGetData($21, "hProc"), "ptr", $2a, $2b, $29, "ulong_ptr", $26, "ulong_ptr*", 0)
	If @error Then Return SetError(@error, @extended, False)
	Return $16[0]
EndFunc

Func _2x($23, $2c, $26, $2d, $2e)
	Local $16 = DllCall("kernel32.dll", "ptr", "VirtualAllocEx", "handle", $23, "ptr", $2c, "ulong_ptr", $26, "dword", $2d, "dword", $2e)
	If @error Then Return SetError(@error, @extended, 0)
	Return $16[0]
EndFunc

Func _2z($23, $2c, $26, $2f)
	Local $16 = DllCall("kernel32.dll", "bool", "VirtualFreeEx", "handle", $23, "ptr", $2c, "ulong_ptr", $26, "dword", $2f)
	If @error Then Return SetError(@error, @extended, False)
	Return $16[0]
EndFunc

Func _30($1g, $2g, $2h, $2i = False)
	Local $16 = DllCall("kernel32.dll", "handle", "OpenProcess", "dword", $1g, "bool", $2g, "dword", $2h)
	If @error Then Return SetError(@error, @extended, 0)
	If $16[0] Then Return $16[0]
	If NOT $2i Then Return SetError(100, 0, 0)
	Local $17 = _2f(BitOR(32, 8))
	If @error Then Return SetError(@error + 10, @extended, 0)
	_2g($17, $0z, True)
	Local $2j = @error
	Local $2k = @extended
	Local $2l = 0
	If NOT @error Then
		$16 = DllCall("kernel32.dll", "handle", "OpenProcess", "dword", $1g, "bool", $2g, "dword", $2h)
		$2j = @error
		$2k = @extended
		If $16[0] Then $2l = $16[0]
		_2g($17, $0z, False)
		If @error Then
			$2j = @error + 20
			$2k = @extended
		EndIf
	Else
		$2j = @error + 30
	EndIf
	DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $17)
	Return SetError($2j, $2k, $2l)
EndFunc

Func _31($25, $2m, $2n = 0, $2o = 0, $2p = 0, $2q = "wparam", $2r = "lparam", $2s = "lresult")
	Local $16 = DllCall("user32.dll", $2s, "SendMessageW", "hwnd", $25, "uint", $2m, $2q, $2n, $2r, $2o)
	If @error Then Return SetError(@error, @extended, "")
	If $2p >= 0 AND $2p <= 4 Then Return $16[$2p]
	Return $16
EndFunc

Func _36($25)
	Local $16 = DllCall("user32.dll", "int", "GetDlgCtrlID", "hwnd", $25)
	If @error Then Return SetError(@error, @extended, 0)
	Return $16[0]
EndFunc

Func _38($2t, $2u = True)
	Local $2v = _3f($2t, $2u)
	If @error OR NOT $2v Then Return SetError(@error + 10, @extended, "")
	Local $2w = DllStructCreate(($2u ? "wchar" : "char") & "[" & ($2v + 1) & "]", $2t)
	If @error Then Return SetError(@error, @extended, "")
	Return SetExtended($2v, DllStructGetData($2w, 1))
EndFunc

Func _3f($2t, $2u = True)
	Local $2x = ""
	If $2u Then $2x = "W"
	Local $16 = DllCall("kernel32.dll", "int", "lstrlen" & $2x, "struct*", $2t)
	If @error Then Return SetError(@error, @extended, 0)
	Return $16[0]
EndFunc

Global $2y[64][2] = [[0, 0]]

Func _47($25, ByRef $2h)
	Local $16 = DllCall("user32.dll", "dword", "GetWindowThreadProcessId", "hwnd", $25, "dword*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	$2h = $16[2]
	Return $16[0]
EndFunc

Func _49($25, ByRef $2z)
	If $25 = $2z Then Return True
	For $30 = $2y[0][0] To 1 Step -1
		If $25 = $2y[$30][0] Then
			If $2y[$30][1] Then
				$2z = $25
				Return True
			Else
				Return False
			EndIf
		EndIf
	Next
	Local $2h
	_47($25, $2h)
	Local $31 = $2y[0][0] + 1
	If $31 >= 64 Then $31 = 1
	$2y[0][0] = $31
	$2y[$31][0] = $25
	$2y[$31][1] = ($2h = @AutoItPID)
	Return $2y[$31][1]
EndFunc

Func _4a($25, $32 = 0, $33 = True)
	If NOT IsHWnd($25) Then $25 = GUICtrlGetHandle($25)
	Local $16 = DllCall("user32.dll", "bool", "InvalidateRect", "hwnd", $25, "struct*", $32, "bool", $33)
	If @error Then Return SetError(@error, @extended, False)
	Return $16[0]
EndFunc

Global $34

Func _4p($25, $2m, $35, ByRef $36, $37 = 0, $38 = False, $39 = -1, $3a = False, $3b = $39)
	If $39 > 0 Then
		DllStructSetData($36, $39, DllStructGetPtr($37))
		If $39 = $3b Then DllStructSetData($36, $39 + 1, DllStructGetSize($37))
	EndIf
	Local $2l
	If IsHWnd($25) Then
		If _49($25, $34) Then
			$2l = DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $25, "uint", $2m, "wparam", $35, "struct*", $36)[0]
		Else
			Local $3c = DllStructGetSize($36)
			Local $21, $3d
			Local $3e = 0
			If ($39 > 0) OR ($3b = 0) Then $3e = DllStructGetSize($37)
			Local $22 = _2s($25, $3c + $3e, $21)
			If $3e Then
				$3d = $22 + $3c
				If $3b Then
					DllStructSetData($36, $39, $3d)
				Else
					$35 = $3d
				EndIf
				_2v($21, $37, $3d, $3e)
			EndIf
			_2v($21, $36, $22, $3c)
			$2l = DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $25, "uint", $2m, "wparam", $35, "ptr", $22)[0]
			If $3e AND $3a Then _2u($21, $3d, $37, $3e)
			If $38 Then _2u($21, $22, $36, $3c)
			_2l($21)
		EndIf
	Else
		$2l = GUICtrlSendMsg($25, $2m, $35, DllStructGetPtr($36))
	EndIf
	Return $2l
EndFunc

Func _4q($25, $2m, $35, ByRef $36, $37 = 0, $38 = False, $39 = -1, $3a = False, $3b = $39)
	#forceref $2m, $35, $38, $3a
	DllStructSetData($36, $39, DllStructGetPtr($37))
	If $39 = $3b Then DllStructSetData($36, $39 + 1, DllStructGetSize($37))
	Local $3f
	If IsHWnd($25) Then
		If _49($25, $34) Then
			$3f = _4r
			SetExtended(1)
		Else
			$3f = _4s
			SetExtended(2)
		EndIf
	Else
		$3f = _4t
		SetExtended(3)
	EndIf
	Return $3f
EndFunc

Func _4r($25, $2m, $35, ByRef $36, $37 = 0, $38 = False, $39 = -1, $3a = False, $3b = $39)
	#forceref $37, $38, $3a, $3b
	Return DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $25, "uint", $2m, "wparam", $35, "struct*", $36)[0]
EndFunc

Func _4s($25, $2m, $35, ByRef $36, $37 = 0, $38 = False, $39 = -1, $3a = False, $3b = $39)
	Local $3c = DllStructGetSize($36)
	Local $21, $3d
	Local $3e = 0
	If ($39 > 0) OR ($3b = 0) Then $3e = DllStructGetSize($37)
	Local $22 = _2s($25, $3c + $3e, $21)
	If $3e Then
		$3d = $22 + $3c
		If $3b Then
			DllStructSetData($36, $39, $3d)
		Else
			$35 = $3d
		EndIf
		_2v($21, $37, $3d, $3e)
	EndIf
	_2v($21, $36, $22, $3c)
	Local $2l = DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $25, "uint", $2m, "wparam", $35, "ptr", $22)[0]
	If $3e AND $3a Then _2u($21, $3d, $37, $3e)
	If $38 Then _2u($21, $22, $36, $3c)
	_2l($21)
	Return $2l
EndFunc

Func _4t($25, $2m, $35, ByRef $36, $37 = 0, $38 = False, $39 = -1, $3a = False, $3b = $39)
	#forceref $37, $38, $3a, $3b
	Return GUICtrlSendMsg($25, $2m, $35, DllStructGetPtr($36))
EndFunc

Func _5l($3g, $3h = 0, $3i = 0, $3j = False)
	Local $3k = ""
	If IsString($3g) Then $3k = "str"
	If (IsDllStruct($3g) OR IsPtr($3g)) Then $3k = "struct*"
	If $3k = "" Then Return SetError(1, 0, 0)
	Local $16 = DllCall("kernel32.dll", "int", "MultiByteToWideChar", "uint", $3h, "dword", $3i, $3k, $3g, "int", -1, "ptr", 0, "int", 0)
	If @error OR NOT $16[0] Then Return SetError(@error + 10, @extended, 0)
	Local $3l = $16[0]
	Local $3m = DllStructCreate("wchar[" & $3l & "]")
	$16 = DllCall("kernel32.dll", "int", "MultiByteToWideChar", "uint", $3h, "dword", $3i, $3k, $3g, "int", -1, "struct*", $3m, "int", $3l)
	If @error OR NOT $16[0] Then Return SetError(@error + 20, @extended, 0)
	If $3j Then Return DllStructGetData($3m, 1)
	Return $3m
EndFunc

Global Const $3n = BitOR(2, 4, 8)
Global Const $3o = (4096 + 9)
Global Const $3p = (4096 + 157)
Global Const $3q = (4096 + 19)
Global Const $3r = (4096 + 152)
Global Const $3s = (4096 + 149)
Global Const $3t = (4096 + 153)
Global Const $3u = (4096 + 31)
Global Const $3v = (4096 + 5)
Global Const $3w = (4096 + 75)
Global Const $3x = (4096 + 4)
Global Const $3y = (4096 + 14)
Global Const $3z = (4096 + 45)
Global Const $40 = (4096 + 115)
Global Const $41 = (4096 + 50)
Global Const $42 = 8192 + 6
Global Const $43 = (4096 + 143)
Global Const $44 = (4096 + 34)
Global Const $45 = (4096 + 18)
Global Const $46 = (4096 + 27)
Global Const $47 = (4096 + 97)
Global Const $48 = (4096 + 145)
Global Const $49 = (4096 + 7)
Global Const $4a = (4096 + 77)
Global Const $4b = (4096 + 150)
Global Const $4c = (4096 + 20)
Global Const $4d = (4096 + 26)
Global Const $4e = (4096 + 96)
Global Const $4f = (4096 + 30)
Global Const $4g = (4096 + 54)
Global Const $4h = (4096 + 147)
Global Const $4i = (4096 + 6)
Global Const $4j = (4096 + 76)
Global Const $4k = (4096 + 47)
Global Const $4l = (4096 + 43)
Global Const $4m = (-100 - 8)
Global $4n[1][11]
Global $4o, $4p
Global $4q = DllStructCreate($1x)
Global Const $4r = 11
Global Const $4s = "uint Mask;int Fmt;int CX;ptr Text;int TextMax;int SubItem;int Image;int Order;int cxMin;int cxDefault;int cxIdeal"
Global Const $4t = "uint Size;uint Mask;ptr Header;int HeaderMax;ptr Footer;int FooterMax;int GroupID;uint StateMask;uint State;uint Align;" & "ptr  pszSubtitle;uint cchSubtitle;ptr pszTask;uint cchTask;ptr pszDescriptionTop;uint cchDescriptionTop;ptr pszDescriptionBottom;" & "uint cchDescriptionBottom;int iTitleImage;int iExtendedImage;int iFirstItem;uint cItems;ptr pszSubsetTitle;uint cchSubsetTitle"

Func _im($25, ByRef $4u)
	Local $37, $2m, $4v
	If _li($25) Then
		$37 = $4o
		$2m = $4a
		$4v = $4j
	Else
		$37 = $4p
		$2m = $49
		$4v = $4i
	EndIf
	Local $36 = $4q
	DllStructSetData($36, "Mask", 1)
	Local $4w = _kd($25)
	_iv($25)
	Local $4x = _4q($25, $2m, 0, $36, $37, False, 6)
	For $30 = 0 To UBound($4u) - 1
		DllStructSetData($36, "Item", $30 + $4w)
		DllStructSetData($36, "SubItem", 0)
		DllStructSetData($37, 1, $4u[$30][0])
		$4x($25, $2m, 0, $36, $37, False, 6)
		For $4y = 1 To UBound($4u, 2) - 1
			DllStructSetData($36, "SubItem", $4y)
			DllStructSetData($37, 1, $4u[$30][$4y])
			$4x($25, $4v, 0, $36, $37, False, 6)
		Next
	Next
	_jb($25)
EndFunc

Func _in($25, $4z, $50 = 50, $51 = -1, $52 = -1, $53 = False)
	Return _lu($25, _jm($25), $4z, $50, $51, $52, $53)
EndFunc

Func _io($25, $4z, $52 = -1, $54 = 0)
	Return _lw($25, $4z, -1, $52, $54)
EndFunc

Func _ip($25, $35, $4z, $55, $52 = -1)
	Local $37, $2m
	If _li($25) Then
		$37 = $4o
		$2m = $4j
	Else
		$37 = $4p
		$2m = $4i
	EndIf
	Local $36 = $4q
	Local $56 = 1
	If $52 <> -1 Then $56 = BitOR($56, 2)
	DllStructSetData($37, 1, $4z)
	DllStructSetData($36, "Mask", $56)
	DllStructSetData($36, "Item", $35)
	DllStructSetData($36, "SubItem", $55)
	DllStructSetData($36, "Image", $52)
	Local $2l = _4p($25, $2m, 0, $36, $37, False, 6, False, -1)
	Return $2l <> 0
EndFunc

Func _iv($25)
	If IsHWnd($25) Then
		Return _31($25, $4r, False) = 0
	Else
		Return GUICtrlSendMsg($25, $4r, False, 0) = 0
	EndIf
EndFunc

Func _j2($25)
	If _kd($25) = 0 Then Return True
	Local $57 = 0
	If IsHWnd($25) Then
		$57 = _36($25)
	Else
		$57 = $25
		$25 = GUICtrlGetHandle($25)
	EndIf
	If $57 < 10000 Then
		Local $54 = 0
		For $35 = _kd($25) - 1 To 0 Step -1
			$54 = _km($25, $35)
			If GUICtrlGetState($54) > 0 AND GUICtrlGetHandle($54) = 0 Then
				GUICtrlDelete($54)
			EndIf
		Next
		If _kd($25) = 0 Then Return True
	EndIf
	Return _31($25, $3o) <> 0
EndFunc

Func _ja($25, $1l = True)
	If IsHWnd($25) Then
		Return _31($25, $3p, $1l)
	Else
		Return GUICtrlSendMsg($25, $3p, $1l, 0)
	EndIf
EndFunc

Func _jb($25)
	If IsHWnd($25) Then
		Return _31($25, $4r, True) = 0
	Else
		Return GUICtrlSendMsg($25, $4r, True, 0) = 0
	EndIf
EndFunc

Func _jc($25, $35, $58 = False)
	If IsHWnd($25) Then
		Return _31($25, $3q, $35, $58)
	Else
		Return GUICtrlSendMsg($25, $3q, $35, $58)
	EndIf
EndFunc

Func _jm($25)
	Return _31(_k2($25), 4608)
EndFunc

Func _jv($25)
	If IsHWnd($25) Then
		Return _31($25, $3r)
	Else
		Return GUICtrlSendMsg($25, $3r, 0, 0)
	EndIf
EndFunc

Func _jw($25, $59)
	Local $5a = _jx($25, $59, BitOR(1, 8))
	Local $5b = @error
	Local $5c[2]
	$5c[0] = _38(DllStructGetData($5a, "Header"))
	Select 
		Case BitAND(DllStructGetData($5a, "Align"), 2) <> 0
			$5c[1] = 1
		Case BitAND(DllStructGetData($5a, "Align"), 4) <> 0
			$5c[1] = 2
		Case Else
			$5c[1] = 0
	EndSelect
	Return SetError($5b, 0, $5c)
EndFunc

Func _jx($25, $59, $56)
	Local $5a = DllStructCreate($4t)
	Local $5d = DllStructGetSize($5a)
	DllStructSetData($5a, "Size", $5d)
	DllStructSetData($5a, "Mask", $56)
	Local $2l = _4p($25, $3s, $59, $5a, 0, True, -1)
	Return SetError($2l <> $59, 0, $5a)
EndFunc

Func _jy($25, $35)
	Local $5a = DllStructCreate($4t)
	Local $5d = DllStructGetSize($5a)
	DllStructSetData($5a, "Size", $5d)
	DllStructSetData($5a, "Mask", BitOR(1, 8, 16))
	Local $2l = _4p($25, $3t, $35, $5a, 0, True, -1)
	Local $5c[3]
	$5c[0] = _38(DllStructGetData($5a, "Header"))
	Select 
		Case BitAND(DllStructGetData($5a, "Align"), 2) <> 0
			$5c[1] = 1
		Case BitAND(DllStructGetData($5a, "Align"), 4) <> 0
			$5c[1] = 2
		Case Else
			$5c[1] = 0
	EndSelect
	$5c[2] = DllStructGetData($5a, "GroupID")
	Return SetError($2l = 0, 0, $5c)
EndFunc

Func _k2($25)
	If IsHWnd($25) Then
		Return HWnd(_31($25, $3u))
	Else
		Return HWnd(GUICtrlSendMsg($25, $3u, 0, 0))
	EndIf
EndFunc

Func _kc($25, $35)
	Local $2m
	If _li($25) Then
		$2m = $3w
	Else
		$2m = $3v
	EndIf
	Local $36 = $4q
	DllStructSetData($36, "Mask", 8)
	DllStructSetData($36, "Item", $35)
	DllStructSetData($36, "SubItem", 0)
	DllStructSetData($36, "StateMask", 65535)
	Local $2l = _4p($25, $2m, 0, $36, 0, True, -1)
	If NOT $2l Then Return SetError(-1, -1, False)
	Return BitAND(DllStructGetData($36, "State"), 8192) <> 0
EndFunc

Func _kd($25)
	If IsHWnd($25) Then
		Return _31($25, $3x)
	Else
		Return GUICtrlSendMsg($25, $3x, 0, 0)
	EndIf
EndFunc

Func _kg($25, ByRef $36)
	Local $2m
	If _li($25) Then
		$2m = $3w
	Else
		$2m = $3v
	EndIf
	Local $2l = _4p($25, $2m, 0, $36, 0, True, -1)
	Return $2l <> 0
EndFunc

Func _ki($25, $35)
	Local $36 = $4q
	DllStructSetData($36, "Mask", 256)
	DllStructSetData($36, "Item", $35)
	DllStructSetData($36, "SubItem", 0)
	_kg($25, $36)
	Return DllStructGetData($36, "GroupID")
EndFunc

Func _km($25, $35)
	Local $36 = $4q
	DllStructSetData($36, "Mask", 4)
	DllStructSetData($36, "Item", $35)
	DllStructSetData($36, "SubItem", 0)
	_kg($25, $36)
	Return DllStructGetData($36, "Param")
EndFunc

Func _kq($25, $35, $5e = 3)
	Local $32 = _kr($25, $35, $5e)
	Local $5f[4]
	$5f[0] = DllStructGetData($32, "Left")
	$5f[1] = DllStructGetData($32, "Top")
	$5f[2] = DllStructGetData($32, "Right")
	$5f[3] = DllStructGetData($32, "Bottom")
	Return $5f
EndFunc

Func _kr($25, $35, $5e = 3)
	Local $32 = DllStructCreate($1u)
	DllStructSetData($32, "Left", $5e)
	_4p($25, $3y, $35, $32, 0, True, -1)
	Return $32
EndFunc

Func _ky($25, $35, $55 = 0)
	Local $37, $2m
	If _li($25) Then
		$37 = $4o
		$2m = $40
	Else
		$37 = $4p
		$2m = $3z
	EndIf
	Local $36 = $4q
	DllStructSetData($37, 1, "")
	DllStructSetData($36, "Mask", 1)
	DllStructSetData($36, "SubItem", $55)
	_4p($25, $2m, $35, $36, $37, False, 6, True)
	Return DllStructGetData($37, 1)
EndFunc

Func _l8($25)
	If IsHWnd($25) Then
		Return _31($25, $41)
	Else
		Return GUICtrlSendMsg($25, $41, 0, 0)
	EndIf
EndFunc

Func _li($25)
	If NOT IsDllStruct($4o) Then
		$4o = DllStructCreate("wchar Text[4096]")
		$4p = DllStructCreate("char Text[4096]", DllStructGetPtr($4o))
	EndIf
	If IsHWnd($25) Then
		Return _31($25, $42) <> 0
	Else
		Return GUICtrlSendMsg($25, $42, 0, 0) <> 0
	EndIf
EndFunc

Func _lj($25)
	Local $5g
	If IsHWnd($25) Then
		$5g = _31($25, $43)
	Else
		$5g = GUICtrlSendMsg($25, $43, 0, 0)
	EndIf
	Switch $5g
		Case 0
			Return Int(0)
		Case 1
			Return Int(1)
		Case 3
			Return Int(3)
		Case 2
			Return Int(2)
		Case 4
			Return Int(4)
		Case Else
			Return -1
	EndSwitch
EndFunc

Func _lp($25)
	Local $5f[4] = [0, 0, 0, 0]
	Local $5g = _lj($25)
	If ($5g < 0) AND ($5g > 4) Then Return $5f
	Local $32 = DllStructCreate($1u)
	_4p($25, $44, 0, $32, 0, True, -1)
	$5f[0] = DllStructGetData($32, "Left")
	$5f[1] = DllStructGetData($32, "Top")
	$5f[2] = DllStructGetData($32, "Right")
	$5f[3] = DllStructGetData($32, "Bottom")
	Return $5f
EndFunc

Func _lr($25, $5h = -1, $5i = -1)
	Local $5j = Opt("MouseCoordMode", 1)
	Local $5k = MouseGetPos()
	Opt("MouseCoordMode", $5j)
	Local $5l = DllStructCreate($1t)
	DllStructSetData($5l, "X", $5k[0])
	DllStructSetData($5l, "Y", $5k[1])
	Local $16 = DllCall("user32.dll", "bool", "ScreenToClient", "hwnd", $25, "struct*", $5l)
	If @error Then Return SetError(@error, @extended, 0)
	If $16[0] = 0 Then Return 0
	If $5h = -1 Then $5h = DllStructGetData($5l, "X")
	If $5i = -1 Then $5i = DllStructGetData($5l, "Y")
	Local $5m = DllStructCreate($1w)
	DllStructSetData($5m, "X", $5h)
	DllStructSetData($5m, "Y", $5i)
	Local $5n[10]
	$5n[0] = _4p($25, $45, 0, $5m, 0, True, -1)
	Local $3i = DllStructGetData($5m, "Flags")
	$5n[1] = BitAND($3i, 1) <> 0
	$5n[2] = BitAND($3i, 2) <> 0
	$5n[3] = BitAND($3i, 4) <> 0
	$5n[4] = BitAND($3i, 8) <> 0
	$5n[5] = BitAND($3i, $3n) <> 0
	$5n[6] = BitAND($3i, 8) <> 0
	$5n[7] = BitAND($3i, 16) <> 0
	$5n[8] = BitAND($3i, 64) <> 0
	$5n[9] = BitAND($3i, 32) <> 0
	Return $5n
EndFunc

Func _lu($25, $35, $4z, $50 = 50, $51 = -1, $52 = -1, $53 = False)
	Local $5o[3] = [0, 1, 2]
	Local $37, $2m
	If _li($25) Then
		$37 = $4o
		$2m = $47
	Else
		$37 = $4p
		$2m = $46
	EndIf
	Local $5p = DllStructCreate($4s)
	Local $56 = BitOR(1, 2, 4)
	If $51 < 0 OR $51 > 2 Then $51 = 0
	Local $5q = $5o[$51]
	If $52 <> -1 Then
		$56 = BitOR($56, 16)
		$5q = BitOR($5q, 32768, 2048)
	EndIf
	If $53 Then $5q = BitOR($5q, 4096)
	DllStructSetData($37, 1, $4z)
	DllStructSetData($5p, "Mask", $56)
	DllStructSetData($5p, "Fmt", $5q)
	DllStructSetData($5p, "CX", $50)
	DllStructSetData($5p, "Image", $52)
	Local $2l = _4p($25, $2m, $35, $5p, $37, False, 4)
	If $51 > 0 Then _me($25, $2l, $4z, $50, $51, $52, $53)
	Return $2l
EndFunc

Func _lv($25, $35, $59, $5r, $51 = 0)
	Local $5o[3] = [1, 2, 4]
	If $51 < 0 OR $51 > 2 Then $51 = 0
	Local $5s = _5l($5r)
	Local $5a = DllStructCreate($4t)
	Local $56 = BitOR(1, 8, 16)
	DllStructSetData($5a, "Size", DllStructGetSize($5a))
	DllStructSetData($5a, "Mask", $56)
	DllStructSetData($5a, "GroupID", $59)
	DllStructSetData($5a, "Align", $5o[$51])
	Local $2l = _4p($25, $48, $35, $5a, $5s, False, 3)
	Return $2l
EndFunc

Func _lw($25, $4z, $35 = -1, $52 = -1, $54 = 0)
	Local $37, $2m
	If _li($25) Then
		$37 = $4o
		$2m = $4a
	Else
		$37 = $4p
		$2m = $49
	EndIf
	Local $36 = $4q
	If $35 = -1 Then $35 = 999999999
	DllStructSetData($37, 1, $4z)
	Local $56 = BitOR(1, 4)
	If $52 >= 0 Then $56 = BitOR($56, 2)
	DllStructSetData($36, "Mask", $56)
	DllStructSetData($36, "Item", $35)
	DllStructSetData($36, "SubItem", 0)
	DllStructSetData($36, "Image", $52)
	DllStructSetData($36, "Param", $54)
	Local $2l = _4p($25, $2m, 0, $36, $37, False, 6)
	Return $2l
EndFunc

Func _m6($25)
	_iv($25)
	Local $59
	For $5t = _jv($25) - 1 To 0 Step -1
		$59 = _jy($25, $5t)[2]
		_m7($25, $59)
	Next
	_jb($25)
EndFunc

Func _m7($25, $59)
	If IsHWnd($25) Then
		Return _31($25, $4b, $59)
	Else
		Return GUICtrlSendMsg($25, $4b, $59, 0)
	EndIf
EndFunc

Func _m9($25, $5u, $5v)
	If IsHWnd($25) Then
		Return _31($25, $4c, $5u, $5v) <> 0
	Else
		Return GUICtrlSendMsg($25, $4c, $5u, $5v) <> 0
	EndIf
EndFunc

Func _me($25, $35, $4z, $50 = -1, $51 = -1, $52 = -1, $53 = False)
	Local $5o[3] = [0, 1, 2]
	Local $37, $2m
	If _li($25) Then
		$37 = $4o
		$2m = $4e
	Else
		$37 = $4p
		$2m = $4d
	EndIf
	Local $5p = DllStructCreate($4s)
	Local $56 = 4
	If $51 < 0 OR $51 > 2 Then $51 = 0
	$56 = BitOR($56, 1)
	Local $5q = $5o[$51]
	If $50 <> -1 Then $56 = BitOR($56, 2)
	If $52 <> -1 Then
		$56 = BitOR($56, 16)
		$5q = BitOR($5q, 32768, 2048)
	Else
		$52 = 0
	EndIf
	If $53 Then $5q = BitOR($5q, 4096)
	DllStructSetData($37, 1, $4z)
	DllStructSetData($5p, "Mask", $56)
	DllStructSetData($5p, "Fmt", $5q)
	DllStructSetData($5p, "CX", $50)
	DllStructSetData($5p, "Image", $52)
	Local $2l = _4p($25, $2m, $35, $5p, $37, False, 4)
	Return $2l <> 0
EndFunc

Func _mi($25, $5w, $5x = 0)
	Local $2l
	If IsHWnd($25) Then
		$2l = _31($25, $4g, $5x, $5w)
	Else
		$2l = GUICtrlSendMsg($25, $4g, $5x, $5w)
	EndIf
	_4a($25)
	Return $2l
EndFunc

Func _mj($25, $59, $5r, $51 = 0, $5y = 0)
	Local $5a = 0
	If BitAND($5y, 32) Then
		$5a = _jx($25, $59, BitOR(16, 16384))
		If @error OR DllStructGetData($5a, "cItems") = 0 Then Return False
	EndIf
	Local $5o[3] = [1, 2, 4]
	If $51 < 0 OR $51 > 2 Then $51 = 0
	Local $5s = _5l($5r)
	$5a = DllStructCreate($4t)
	Local $56 = BitOR(1, 8, 4)
	DllStructSetData($5a, "Size", DllStructGetSize($5a))
	DllStructSetData($5a, "Mask", $56)
	DllStructSetData($5a, "Align", $5o[$51])
	DllStructSetData($5a, "State", $5y)
	DllStructSetData($5a, "StateMask", $5y)
	Local $2l = _4p($25, $4h, $59, $5a, $5s, False, 3)
	DllStructSetData($5a, "Mask", 16)
	DllStructSetData($5a, "GroupID", $59)
	_4p($25, $4h, 0, $5a, 0, False, -1)
	_4a($25)
	Return $2l <> 0
EndFunc

Func _mt($25, $35, $5z = True)
	Local $2m
	If _li($25) Then
		$2m = $4j
	Else
		$2m = $4i
	EndIf
	Local $36 = $4q
	If ($5z) Then
		DllStructSetData($36, "State", 8192)
	Else
		DllStructSetData($36, "State", 4096)
	EndIf
	DllStructSetData($36, "StateMask", 61440)
	DllStructSetData($36, "Mask", 8)
	DllStructSetData($36, "SubItem", 0)
	Local $60 = $35
	If $35 = -1 Then
		$35 = 0
		$60 = _kd($25) - 1
	EndIf
	Local $2l
	For $5t = $35 To $60
		DllStructSetData($36, "Item", $5t)
		$2l = _4p($25, $2m, 0, $36, 0, False, -1)
		If $2l = 0 Then ExitLoop
	Next
	Return $2l <> 0
EndFunc

Func _mu($25, $61)
	If IsHWnd($25) Then
		Return _31($25, $4k, $61, BitOR(1, 2)) <> 0
	Else
		Return GUICtrlSendMsg($25, $4k, $61, BitOR(1, 2)) <> 0
	EndIf
EndFunc

Func _mx($25, ByRef $36, $62 = 0)
	Local $37, $2m
	If _li($25) Then
		$37 = $4o
		$2m = $4j
	Else
		$37 = $4p
		$2m = $4i
	EndIf
	Local $3e = 0
	If $62 Then
		$37 = 0
		DllStructSetData($36, "Text", 0)
	Else
		If DllStructGetData($36, "Text") <> -1 Then
			$3e = DllStructGetSize($37)
		Else
		EndIf
	EndIf
	DllStructSetData($36, "TextMax", $3e)
	Local $2l = _4p($25, $2m, 0, $36, $37, False, -1)
	Return $2l <> 0
EndFunc

Func _mz($25, $35, $59)
	Local $36 = $4q
	DllStructSetData($36, "Mask", 256)
	DllStructSetData($36, "Item", $35)
	DllStructSetData($36, "SubItem", 0)
	DllStructSetData($36, "GroupID", $59)
	Return _mx($25, $36, 1)
EndFunc

Func _n6($25, $35, $63 = True, $64 = False)
	Local $36 = $4q
	Local $65 = 0, $66 = 0
	If ($63 = True) Then $65 = 2
	If ($64 = True AND $35 <> -1) Then $66 = 1
	DllStructSetData($36, "Mask", 8)
	DllStructSetData($36, "Item", $35)
	DllStructSetData($36, "SubItem", 0)
	DllStructSetData($36, "State", BitOR($65, $66))
	DllStructSetData($36, "StateMask", BitOR(2, $66))
	Local $2l = _4p($25, $4l, $35, $36, 0, False, -1)
	Return $2l <> 0
EndFunc

Func _n9($25, $35, $4z, $55 = 0)
	Local $2l
	If $55 = -1 Then
		Local $67 = Opt("GUIDataSeparatorChar")
		Local $68 = _jm($25)
		Local $69 = StringSplit($4z, $67)
		If $68 > $69[0] Then $68 = $69[0]
		For $q = 1 To $68
			$2l = _n9($25, $35, $69[$q], $q - 1)
			If NOT $2l Then ExitLoop
		Next
		Return $2l
	EndIf
	Local $37, $2m
	If _li($25) Then
		$37 = $4o
		$2m = $4j
	Else
		$37 = $4p
		$2m = $4i
	EndIf
	Local $36 = $4q
	DllStructSetData($37, 1, $4z)
	DllStructSetData($36, "Mask", 1)
	DllStructSetData($36, "Item", $35)
	DllStructSetData($36, "SubItem", $55)
	$2l = _4p($25, $2m, 0, $36, $37, False, 6, False, -1)
	Return $2l <> 0
EndFunc

#Au3Stripper_Ignore_Funcs=__GUICtrlListView_Sort

Func __guictrllistview_sort($6a, $6b, $25)
	Local $35, $6c, $6d, $6e
	Local $37, $2m
	If $4n[$35][0] Then
		$37 = $4o
		$2m = $40
	Else
		$37 = $4p
		$2m = $3z
	EndIf
	Local $36 = $4q
	For $5t = 1 To $4n[0][0]
		If $25 = $4n[$5t][1] Then
			$35 = $5t
			ExitLoop
		EndIf
	Next
	If $4n[$35][3] = $4n[$35][4] Then
		If NOT $4n[$35][7] Then
			$4n[$35][5] *= -1
			$4n[$35][7] = 1
		EndIf
	Else
		$4n[$35][7] = 1
	EndIf
	$4n[$35][6] = $4n[$35][3]
	DllStructSetData($36, "Mask", 1)
	DllStructSetData($36, "SubItem", $4n[$35][3])
	_4p($25, $2m, $6a, $36, $37, False, 6, True)
	$6c = DllStructGetData($37, 1)
	_4p($25, $2m, $6b, $36, $37, False, 6, True)
	$6d = DllStructGetData($37, 1)
	If $4n[$35][8] = 1 Then
		If (StringIsFloat($6c) OR StringIsInt($6c)) Then $6c = Number($6c)
		If (StringIsFloat($6d) OR StringIsInt($6d)) Then $6d = Number($6d)
	EndIf
	If $4n[$35][8] < 2 Then
		$6e = 0
		If $6c < $6d Then
			$6e = -1
		ElseIf $6c > $6d Then
			$6e = 1
		EndIf
	Else
		$6e = DllCall("shlwapi.dll", "int", "StrCmpLogicalW", "wstr", $6c, "wstr", $6d)[0]
	EndIf
	$6e = $6e * $4n[$35][5]
	Return $6e
EndFunc

Func _rf($6f, $6g = 0)
	Local Const $6h = 183
	Local Const $6i = 1
	Local $6j = 0
	If BitAND($6g, 2) Then
		Local $6k = DllStructCreate("byte;byte;word;ptr[4]")
		Local $16 = DllCall("advapi32.dll", "bool", "InitializeSecurityDescriptor", "struct*", $6k, "dword", $6i)
		If @error Then Return SetError(@error, @extended, 0)
		If $16[0] Then
			$16 = DllCall("advapi32.dll", "bool", "SetSecurityDescriptorDacl", "struct*", $6k, "bool", 1, "ptr", 0, "bool", 0)
			If @error Then Return SetError(@error, @extended, 0)
			If $16[0] Then
				$6j = DllStructCreate($1z)
				DllStructSetData($6j, 1, DllStructGetSize($6j))
				DllStructSetData($6j, 2, DllStructGetPtr($6k))
				DllStructSetData($6j, 3, 0)
			EndIf
		EndIf
	EndIf
	Local $6l = DllCall("kernel32.dll", "handle", "CreateMutexW", "struct*", $6j, "bool", 1, "wstr", $6f)
	If @error Then Return SetError(@error, @extended, 0)
	Local $6m = DllCall("kernel32.dll", "dword", "GetLastError")
	If @error Then Return SetError(@error, @extended, 0)
	If $6m[0] = $6h Then
		If BitAND($6g, 1) Then
			DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $6l[0])
			If @error Then Return SetError(@error, @extended, 0)
			Return SetError($6m[0], $6m[0], 0)
		Else
			Exit -1
		EndIf
	EndIf
	Return $6l[0]
EndFunc

AutoItSetOption("GUICloseOnESC", 0)
Global Const $6n = "Patcher", $6o = "v2024"
If _rf($6n, 1) = 0 Then
	Exit
EndIf
Global $6p = True
Global $6q = 0
Global $6r[0][1], $6s[0][1]
Global $6t[0][1], $6u = 0
Global $6v, $6w, $6x, $6y, $6z, $70, $71, $72, $73
Global $74, $75, $76, $77 = 1
Global $78, $79, $7a, $7b, $7c, $7d, $7e
Global $7f = @ScriptDir & "\config.ini"
If NOT FileExists($7f) Then
	FileInstall("config.ini", @ScriptDir & "\config.ini")
EndIf
Global $7g = IniRead($7f, "Default", "Path", "C:\Program Files")
If NOT FileExists($7g) OR NOT StringInStr(FileGetAttrib($7g), "D") Then
	IniWrite($7f, "Default", "Path", "C:\Program Files")
	$7g = "C:\Program Files"
EndIf
Global $7h = 0, $7i = 0, $7j
Global $7k[0], $7l[0], $7m[0]
Global $7n, $7o = False, $7p, $7q = "|"
Global $7r, $7s
Local $7t = IniReadSection($7f, "TargetFiles")
Global $7u[0]
If NOT @error Then
	ReDim $7u[$7t[0][0]]
	For $q = 1 To $7t[0][0]
		$7u[$q - 1] = StringReplace($7t[$q][1], '"', "")
	Next
EndIf
$7p = IniReadSection($7f, "CustomPatterns")
For $q = 1 To UBound($7p) - 1
	$7q = $7q & $7p[$q][0] & "|"
Next
GUIRegisterMsg(273, "_s8")
_rl()
While 1
	$6z = GUIGetMsg()
	Select 
		Case $6z = -3
			GUIDelete($6v)
			_sa()
		Case $6z = -12
			ContinueCase
		Case $6z = -5
			ContinueCase
		Case $6z = -6
			Local $50
			Local $7v = WinGetPos($6v)
			Local $5f = _lp($71)
			If ($5f[2] > $7v[2]) Then
				$50 = $7v[2] - 75
			Else
				$50 = $5f[2] - 25
			EndIf
			GUICtrlSendMsg($70, $4f, 1, $50)
		Case $6z = $73
			$77 = 0
			_rn()
			_rp(@CRLF & "Path" & @CRLF & "---" & @CRLF & $7g & @CRLF & "---" & @CRLF & "Waiting for user action.")
			GUICtrlSetState($73, 32)
			GUICtrlSetState($72, 16)
			GUICtrlSetState($72, 64)
			GUICtrlSetState($7d, 32)
			GUICtrlSetState($78, 16)
			GUICtrlSetState($78, 64)
			GUICtrlSetState($76, 128)
			GUICtrlSetState($75, 128)
			GUICtrlSetState($79, 64)
		Case $6z = $72
			$6q = 0
			GUICtrlSetState($72, 32)
			GUICtrlSetState($73, 16)
			_rr(0)
			GUICtrlSetState($76, 128)
			GUICtrlSetState($78, 128)
			GUICtrlSetState($70, 128)
			GUICtrlSetState($75, 128)
			GUICtrlSetState($74, 128)
			GUICtrlSetState($79, 128)
			_j2($71)
			_mi($70, BitOR(32, 1, 65536))
			_io($70, "", 0)
			_io($70, "", 1)
			_io($70, "", 2)
			_io($70, "", 2)
			_m6($70)
			_lv($70, -1, 1, "", 1)
			_mj($70, 1, "Info", 1, 8)
			_ip($70, 0, "", 1)
			_ip($70, 1, "Preparing...", 1)
			_ip($70, 2, "", 1)
			_ip($70, 3, "Be patient, please.", 1)
			_mz($70, 0, 1)
			_mz($70, 1, 1)
			_mz($70, 2, 1)
			_mz($70, 3, 1)
			_s7()
			_mj($70, 1, "Info", 1, 8)
			$6r = $6s
			$6t = $6s
			$7b = TimerInit()
			Local $7w
			Local $7x = DirGetSize($7g, 1)
			If UBound($7x) >= 2 Then
				$7w = $7x[1]
				$7r = 100 / $7w
				$7s = 0
				_ru(0)
				_rm($7g, 0, $7w)
				Sleep(100)
				_ru(0)
			EndIf
			If $7g = "C:\Program Files" OR $7g = "C:\Program Files\Adobe" Then
				Local $7y = EnvGet("ProgramFiles(x86)") & "\Common Files\Adobe"
				$7x = DirGetSize($7y, 1)
				If UBound($7x) >= 2 Then
					$7w = $7x[1]
					_rm($7y, 0, $7w)
					_ru(0)
				EndIf
			EndIf
			_ro()
			If _kd($70) > 0 Then
				_s5()
				$77 = 1
				GUICtrlSetState($72, 128)
				GUICtrlSetState($76, 128)
				GUICtrlSetState($75, 64)
				GUICtrlSetState($75, 256)
				If UBound($6t) > 0 Then
					GUICtrlSetState($78, 32)
					GUICtrlSetState($7d, 64)
					GUICtrlSetState($7d, 16)
				EndIf
			Else
				$77 = 0
				_rn()
				GUICtrlSetState($75, 128)
				GUICtrlSetState($76, 128)
				GUICtrlSetState($72, 64)
				GUICtrlSetState($72, 256)
			EndIf
			_s7()
			GUICtrlSetState($76, 64)
			GUICtrlSetState($78, 64)
			GUICtrlSetState($70, 64)
			GUICtrlSetState($74, 64)
			GUICtrlSetState($72, 16)
			GUICtrlSetState($73, 32)
			GUICtrlSetState($79, 64)
		Case $6z = $74
			_rr(0)
			_rv()
			_s7()
			If $6u = 0 Then
				GUICtrlSetState($75, 128)
				GUICtrlSetState($76, 128)
				GUICtrlSetState($72, 64)
				GUICtrlSetState($72, 256)
			Else
				GUICtrlSetState($72, 128)
				GUICtrlSetState($76, 64)
				GUICtrlSetState($75, 64)
				GUICtrlSetState($75, 256)
			EndIf
		Case $6z = $76
			_rr(0)
			If $77 = 1 Then
				For $q = 0 To _kd($70) - 1
					_mt($70, $q, 0)
				Next
				$77 = 0
			Else
				For $q = 0 To _kd($70) - 1
					_mt($70, $q, 1)
				Next
				$77 = 1
			EndIf
		Case $6z = $78
			_rr(0)
			_s2()
		Case $6z = $79
			Global $7z = "C:\Program Files (x86)\Common Files\Adobe\Adobe Desktop Common\AppsPanel\AppsPanelBL.dll"
			Global $80 = "C:\Program Files (x86)\Common Files\Adobe\Adobe Desktop Common\ADS\ContainerBL.dll"
			Global $81 = "C:\Program Files (x86)\Common Files\Adobe\Adobe Desktop Common\ADS\Adobe Desktop Service.exe"
			_rr(0)
			GUICtrlSetState($76, 128)
			GUICtrlSetState($78, 128)
			GUICtrlSetState($70, 128)
			GUICtrlSetState($74, 128)
			GUICtrlSetState($72, 128)
			GUICtrlSetState($79, 128)
			_rx($7z)
			_ru(0)
			Sleep(100)
			_rp(@CRLF & "File Path:" & @CRLF & "" & @CRLF & $7z & @CRLF & "" & @CRLF & "")
			Sleep(100)
			_s0($7z, $7k)
			Sleep(500)
			_rx($80)
			_ru(0)
			Sleep(100)
			_rp(@CRLF & "File Path:" & @CRLF & "" & @CRLF & $80 & @CRLF & "" & @CRLF & "")
			Sleep(100)
			_s0($80, $7k)
			Sleep(500)
			_rx($81)
			_ru(0)
			Sleep(100)
			_rp(@CRLF & "File Path:" & @CRLF & "" & @CRLF & $81 & @CRLF & "" & @CRLF & "")
			Sleep(100)
			_s0($81, $7k)
			Sleep(500)
			_ru(0)
			_rp(@CRLF & "All files patched" & @CRLF & "" & @CRLF & "")
			GUICtrlSetState($76, 64)
			GUICtrlSetState($78, 64)
			GUICtrlSetState($70, 64)
			GUICtrlSetState($74, 64)
			GUICtrlSetState($72, 64)
			GUICtrlSetState($79, 64)
			GUICtrlSetState($6y, 16)
		Case $6z = $75
			_rr(0)
			GUICtrlSetState($70, 128)
			GUICtrlSetState($76, 128)
			GUICtrlSetState($72, 128)
			GUICtrlSetState($75, 128)
			GUICtrlSetState($78, 128)
			GUICtrlSetState($7d, 128)
			GUICtrlSetState($74, 128)
			GUICtrlSetState($79, 128)
			_s7()
			_jc($70, 0, 0)
			Local $82
			For $q = 0 To _kd($70) - 1
				If _kc($70, $q) = True Then
					_n6($70, $q)
					$82 = _ky($70, $q, 1)
					_rx($82)
					_ru(0)
					Sleep(100)
					_rp(@CRLF & "Path" & @CRLF & "---" & @CRLF & $82 & @CRLF & "---" & @CRLF & "medication :)")
					_rq(1, $82)
					Sleep(100)
					_s0($82, $7k)
					_m9($70, 0, 10)
					_jc($70, $q, 0)
					Sleep(100)
				EndIf
				_mt($70, $q, False)
			Next
			_j2($71)
			_mi($70, BitOR(32, 1, 65536))
			_m6($70)
			_lv($70, -1, 1, "", 1)
			_mj($70, 1, "Info", 1, 8)
			_rp(@CRLF & "Path" & @CRLF & "---" & @CRLF & $7g & @CRLF & "---" & @CRLF & "waiting for user action")
			GUICtrlSetState($70, 64)
			GUICtrlSetState($72, 64)
			GUICtrlSetState($74, 64)
			GUICtrlSetState($78, 64)
			GUICtrlSetState($78, 16)
			GUICtrlSetState($7d, 32)
			GUICtrlSetState($75, 128)
			GUICtrlSetState($72, 256)
			GUICtrlSetState($79, 64)
			_rn()
			If $7o = True Then
				MsgBox(4096, "Information", "Patcher does not patch the x32 bit version of Acrobat. Please use the x64 bit version of Acrobat.")
				_rq(1, "Patcher does not patch the x32 bit version of Acrobat. Please use the x64 bit version of Acrobat.")
			EndIf
			_rr(1)
			GUICtrlSetState($6y, 16)
		Case $6z = $7d
			GUICtrlSetData($7c, "Activity Log" & @CRLF)
			_rr(0)
			GUICtrlSetState($70, 128)
			GUICtrlSetState($76, 128)
			GUICtrlSetState($72, 128)
			GUICtrlSetState($75, 128)
			GUICtrlSetState($78, 128)
			GUICtrlSetState($7d, 128)
			GUICtrlSetState($74, 128)
			GUICtrlSetState($79, 128)
			_s7()
			_jc($70, 0, 0)
			Local $82, $83, $84
			For $q = 0 To _kd($70) - 1
				If _kc($70, $q) = True Then
					_n6($70, $q)
					$82 = _ky($70, $q, 1)
					$83 = _l8($70)
					$84 = 100 / $83
					_ru(0)
					_s1($82)
					_ru($84)
					Sleep(100)
					_rp(@CRLF & "Path" & @CRLF & "---" & @CRLF & $82 & @CRLF & "---" & @CRLF & "restoring :)")
					Sleep(100)
					_m9($70, 0, 10)
					_jc($70, $q, 0)
					Sleep(100)
				EndIf
				_mt($70, $q, False)
			Next
			_j2($71)
			_mi($70, BitOR(32, 1, 65536))
			_m6($70)
			_lv($70, -1, 1, "", 1)
			_mj($70, 1, "Info", 1, 8)
			_rp(@CRLF & "Path" & @CRLF & "---" & @CRLF & $7g & @CRLF & "---" & @CRLF & "waiting for user action")
			GUICtrlSetState($70, 64)
			GUICtrlSetState($74, 64)
			GUICtrlSetState($78, 64)
			GUICtrlSetState($78, 16)
			GUICtrlSetState($7d, 32)
			GUICtrlSetState($7d, 64)
			GUICtrlSetState($75, 128)
			GUICtrlSetState($72, 64)
			GUICtrlSetState($72, 256)
			GUICtrlSetState($79, 64)
			_rn()
			_rr(1)
		Case $6z = $7e
			_rs()
	EndSelect
WEnd

Func _rl()
	$6v = GUICreate($6n, 595, 350, -1, -1, BitOR(65536, 131072, 262144, $7))
	$6w = GUICtrlCreateTab(0, 1, 597, 250)
	$6x = GUICtrlCreateTabItem("Main")
	$70 = GUICtrlCreateListView("", 10, 35, 575, 200)
	GUICtrlSetResizing(-1, 1)
	$71 = GUICtrlGetHandle($70)
	_mi($70, BitOR(32, 1, 65536, 4))
	_mu($70, UBound($6r))
	_in($70, "", 20)
	_in($70, "For collapsing or expanding all groups, please click here", 532, 2)
	_ja($70)
	_lv($70, -1, 1, "", 1)
	_mj($70, 1, "Info", 1, 8)
	_rn()
	$74 = GUICtrlCreateButton("Path", 10, 300, 80, 30)
	GUICtrlSetTip(-1, "Select Path that You want -> press Search -> press Patch button")
	GUICtrlSetImage(-1, "imageres.dll", -4, 0)
	GUICtrlSetResizing(-1, 1)
	$72 = GUICtrlCreateButton("Search", 110, 300, 80, 30)
	GUICtrlSetTip(-1, "Let Patcher find Apps automatically in current path")
	GUICtrlSetImage(-1, "imageres.dll", -8, 0)
	GUICtrlSetResizing(-1, 1)
	$73 = GUICtrlCreateButton("Stop", 110, 300, 80, 30)
	GUICtrlSetState(-1, 32)
	GUICtrlSetTip(-1, "Stop searching for Apps")
	GUICtrlSetImage(-1, "imageres.dll", -8, 0)
	GUICtrlSetResizing(-1, 1)
	$76 = GUICtrlCreateButton("De/Select", 210, 300, 80, 30)
	GUICtrlSetState(-1, 128)
	GUICtrlSetTip(-1, "De/Select All files")
	GUICtrlSetImage(-1, "imageres.dll", -76, 0)
	GUICtrlSetResizing(-1, 1)
	$75 = GUICtrlCreateButton("Patch", 305, 300, 80, 30)
	GUICtrlSetState(-1, 128)
	GUICtrlSetTip(-1, "Patch all selected files")
	GUICtrlSetImage(-1, "imageres.dll", -102, 0)
	GUICtrlSetResizing(-1, 1)
	$78 = GUICtrlCreateButton("Pop-up", 405, 300, 80, 30)
	GUICtrlSetTip(-1, "Block Unlicensed Pop-up via Hosts file")
	GUICtrlSetImage(-1, "imageres.dll", -101, 0)
	GUICtrlSetResizing(-1, 1)
	$7d = GUICtrlCreateButton("Restore", 405, 300, 80, 30)
	GUICtrlSetState(-1, 32)
	GUICtrlSetTip(-1, "Restore Original Files")
	GUICtrlSetImage(-1, "imageres.dll", -113, 0)
	GUICtrlSetResizing(-1, 1)
	$79 = GUICtrlCreateButton("Patch CC", 505, 300, 80, 30)
	GUICtrlSetImage(-1, "imageres.dll", -74, 0)
	If (@UserName = "SYSTEM") Then
		GUICtrlSetState(-1, 128)
	EndIf
	GUICtrlSetTip(-1, "Patch Creative Cloud")
	GUICtrlSetResizing(-1, 1)
	$7j = GUICtrlCreateProgress(10, 260, 575, 25, 16)
	GUICtrlSetResizing(-1, 128)
	GUICtrlCreateLabel($6o, 10, 677, 575, 25, 1)
	GUICtrlSetResizing(-1, 64)
	GUICtrlCreateTabItem("")
	$6y = GUICtrlCreateTabItem("Log")
	$7a = GUICtrlCreateEdit("", 10, 35, 575, 300, BitOR(2048, 1, 134217728))
	GUICtrlSetResizing(-1, 128)
	$7c = GUICtrlCreateEdit("", 10, 35, 575, 300, BitOR(2097152, 64, 2048))
	GUICtrlSetResizing(-1, 128)
	GUICtrlSetState($7c, 32)
	GUICtrlSetData($7c, "Activity Log" & @CRLF)
	$7e = GUICtrlCreateButton("Copy", 257, 150, 80, 30)
	GUICtrlSetTip(-1, "Copy log to the clipboard")
	GUICtrlSetImage(-1, "imageres.dll", -77, 0)
	GUICtrlSetResizing(-1, 1)
	GUICtrlCreateLabel($6o, 10, 677, 575, 25, 1)
	GUICtrlSetResizing(-1, 64)
	GUICtrlCreateTabItem("")
	_rp(@CRLF & "Path" & @CRLF & "---" & @CRLF & $7g & @CRLF & "---" & @CRLF & "Waiting for user action.")
	GUICtrlSetState($72, 256)
	GUISetState(@SW_SHOW)
	GUIRegisterMsg($4, "_s9")
EndFunc

Func _rm($85, $86, $7w)
	_n9($70, 1, "Searching for files.", 1)
	Local $87 = 6
	If $86 > $87 Then Return 
	Local $88 = $85 & "\"
	$7s += 1
	Local $89 = FileFindFirstFile($88 & "*.*")
	If @error Then Return 
	Local $8a, $8b, $8c
	While $6q = 0
		$8a = FileFindNextFile($89)
		$7s += 1
		If @error Then ExitLoop
		$8c = StringInStr(FileGetAttrib($88 & $8a), "D")
		If $8c Then
			Local $8d
			$8d = _rm($88 & $8a, $86 + 1, $7w)
		Else
			$8b = $88 & $8a
			Local $8e
			If (IsArray($7u)) Then
				For $8f In $7u
					$8e = StringSplit(StringLower($8b), StringLower($8f), 1)
					If @error <> 1 Then
						If NOT StringInStr($8b, ".bak") Then
							If StringInStr($8b, "Adobe") OR StringInStr($8b, "Acrobat") Then
								_k($6r, $8b)
							EndIf
						Else
							_k($6t, $8b)
						EndIf
					EndIf
				Next
			EndIf
		EndIf
	WEnd
	If 1 = Random(0, 10, 1) Then
		_rp(@CRLF & "Searching in " & $7w & " files" & @TAB & @TAB & "Found : " & UBound($6r) & @CRLF & "---" & @CRLF & "Level: " & $86 & " Time elapsed : " & Round(TimerDiff($7b) / 1000, 0) & " second(s)" & @TAB & @TAB & "Excluded because of *.bak: " & UBound($6t) & @CRLF & "---" & @CRLF & $85)
		_ru($7r * $7s)
	EndIf
	FileClose($89)
EndFunc

Func _rn()
	_j2($71)
	_mi($70, BitOR(32, 1, 65536))
	_s7()
	_mj($70, 1, "Info", 1, 8)
	For $q = 0 To 3
		_io($70, "", $q)
		_mz($70, $q, 1)
	Next
	_ip($70, 0, "", 1)
	_ip($70, 1, "Press 'Search Files' - Press 'Patch Files'", 1)
	_ip($70, 2, "Default path - C:\Program Files", 1)
	_ip($70, 3, "'Unlicensed Pop-up' Blocker", 1)
	$6u = 0
EndFunc

Func _ro()
	_j2($71)
	_mi($70, BitOR(32, 1, 65536, 4))
	If UBound($6r) > 0 Then
		Global $4u[UBound($6r)][2]
		For $q = 0 To UBound($4u) - 1
			$4u[$q][0] = $q
			$4u[$q][1] = $6r[$q][0]
		Next
		_im($70, $4u)
		_rp(@CRLF & UBound($6r) & " File(s) were found in " & Round(TimerDiff($7b) / 1000, 0) & " second(s) at:" & @CRLF & "---" & @CRLF & $7g & @CRLF & "---" & @CRLF & "Press the 'Patch Files'")
		_rq(1, UBound($6r) & " File(s) were found in " & Round(TimerDiff($7b) / 1000, 0) & " second(s)" & @CRLF)
		$6u = 1
	Else
		_rp(@CRLF & "Nothing was found in" & @CRLF & "---" & @CRLF & $7g & @CRLF & "---" & @CRLF & "waiting for user action")
		_rq(1, "Nothing was found in " & $7g)
		$6u = 0
	EndIf
EndFunc

Func _rp($8g)
	GUICtrlSetData($7a, $8g)
EndFunc

Func _rq($8h, $8g)
	_rt($7c, $8g, $8h)
EndFunc

Func _rr($8i)
	If $8i = 1 Then
		GUICtrlSetState($7a, 32)
		GUICtrlSetState($7c, 16)
	Else
		GUICtrlSetState($7c, 32)
		GUICtrlSetState($7a, 16)
	EndIf
EndFunc

Func _rs()
	If BitAND(GUICtrlGetState($7a), 32) = 32 Then
		ClipPut(GUICtrlRead($7c))
	Else
		ClipPut(GUICtrlRead($7a))
	EndIf
EndFunc

Func _rt($25, $4z, $8h)
	If NOT IsHWnd($25) Then $25 = GUICtrlGetHandle($25)
	Local $2v = DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $25, "uint", 14, "wparam", 0, "lparam", 0)
	DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $25, "uint", 177, "wparam", $2v[0], "lparam", $2v[0])
	If $8h = 1 Then
		Local $8j = @CRLF & @YEAR & "-" & @MON & "-" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC & "." & @MSEC & " " & $4z
	Else
		Local $8j = $4z
	EndIf
	DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $25, "uint", 194, "wparam", True, "wstr", $8j)
EndFunc

Func _ru($8k)
	GUICtrlSetData($7j, $8k)
EndFunc

Func _rv()
	Local Const $8g = "Select a Path"
	FileSetAttrib("C:\Program Files\WindowsApps", "-H")
	Local $8l = FileSelectFolder($8g, $7g, 0, $7g, $6v)
	If @error Then
		FileSetAttrib("C:\Program Files\WindowsApps", "+H")
		_rp(@CRLF & "Path" & @CRLF & "---" & @CRLF & $7g & @CRLF & "---" & @CRLF & "waiting for user action")
	Else
		GUICtrlSetState($75, 128)
		$7g = $8l
		IniWrite($7f, "Default", "Path", $7g)
		_j2($71)
		_mi($70, BitOR(1, 32, 2))
		_io($70, "", 0)
		_io($70, "", 1)
		_io($70, "", 2)
		_io($70, "", 3)
		_io($70, "", 4)
		_io($70, "", 5)
		_io($70, "", 6)
		_ip($70, 0, "", 1)
		_ip($70, 1, "Path:", 1)
		_ip($70, 2, " " & $7g, 1)
		_ip($70, 3, "Step 1:", 1)
		_ip($70, 4, " Press 'Search Files' - wait until Patcher finds all files", 1)
		_ip($70, 5, "Step 2:", 1)
		_ip($70, 6, " Press 'Patch Files' - wait until Patcher will do it's job", 1)
		_mz($70, 0, 1)
		_mz($70, 1, 1)
		_mz($70, 2, 1)
		_mz($70, 3, 1)
		_mz($70, 4, 1)
		_mz($70, 5, 1)
		_mz($70, 6, 1)
		_mj($70, 1, "Info", 1, 8)
		FileSetAttrib("C:\Program Files\WindowsApps", "+H")
		_rp(@CRLF & "Path" & @CRLF & "---" & @CRLF & $7g & @CRLF & "---" & @CRLF & "Press the Search button")
		GUICtrlSetState($78, 16)
		GUICtrlSetState($7d, 32)
		$6u = 0
	EndIf
EndFunc

Func _rw($1f)
	Local $2h = Run("TASKKILL /F /T /IM " & $1f, @TempDir, @SW_HIDE)
	ProcessWaitClose($2h)
EndFunc

Func _rx($8m)
	$7m = $7l
	$7k = $7l
	_ru(0)
	$7h = 0
	$7i = 15
	Local $8n = StringRegExpReplace($8m, "^.*\\", "")
	Local $8o = StringRegExpReplace($8n, "^.*\.", "")
	_rp(@CRLF & $8m & @CRLF & "---" & @CRLF & "Preparing to Analyze" & @CRLF & "---" & @CRLF & "*****")
	_rq(1, "Checking File: " & $8n & " ")
	If $8o = "exe" Then
		_rw('"' & $8n & '"')
	EndIf
	If $8n = "AppsPanelBL.dll" OR $8n = "ContainerBL.dll" Then
		_rw('"Creative Cloud.exe"')
		_rw('"Adobe Desktop Service.exe"')
		Sleep(100)
	EndIf
	If StringInStr($7q, $8n) Then
		_rq(0, " - using Custom Patterns")
		_ry($8n, 0, $8m)
	Else
		_rq(0, " - using Default Patterns")
		_ry($8n, 1, $8m)
	EndIf
	Sleep(100)
EndFunc

Func _ry($8p, $8q, $8m)
	Local $8r, $8s, $8t, $g, $8u, $8v, $8w
	If $8q = 0 Then
		$8r = _sb($7f, "CustomPatterns", $8p, "")
	Else
		$8r = _sb($7f, "DefaultPatterns", "Values", "")
	EndIf
	For $q = 0 To UBound($8r) - 1
		$8s = $8r[$q]
		$8t = IniRead($7f, "Patches", $8s, "")
		If StringInStr($8t, "|") Then
			$g = StringSplit($8t, "|")
			If UBound($g) = 3 Then
				$8u = StringReplace($g[1], '"', "")
				$8v = StringReplace($g[2], '"', "")
				$8w = StringLen($8u)
				If $8w <> StringLen($8v) OR Mod($8w, 2) <> 0 Then
					MsgBox(4096, "Error", "Pattern Error in config.ini:" & $8s & @CRLF & $8u & @CRLF & $8v)
					Exit
				EndIf
				_rq(1, "Searching for: " & $8s & ": " & $8u)
				_rz($8m, $8u, $8v, $8s)
			EndIf
		EndIf
	Next
EndFunc

Func _rz($8x, $8y, $8z, $90)
	Local $91 = FileOpen($8x, 0 + 16)
	FileSetPos($91, 60, 0)
	$7n = FileRead($91, 4)
	FileSetPos($91, Number($7n) + 4, 0)
	$7n = FileRead($91, 2)
	If $7n = "0x4C01" AND StringInStr($8x, "Acrobat", 2) > 0 Then
		_rp(@CRLF & $8x & @CRLF & "---" & @CRLF & "File is 32bit. Aborting..." & @CRLF & "---")
		FileClose($91)
		Sleep(100)
		$7o = True
	Else
		FileSetPos($91, 0, 0)
		Local $92 = FileRead($91)
		Local $93, $94, $95
		For $q = 256 To 1 Step -2
			$93 = _5("??", $q / 2)
			$94 = "(.{" & $q & "})"
			$95 = StringReplace($8y, $93, $94)
			$8y = $95
		Next
		Local $96 = $95
		Local $97 = $8z
		Local $98 = "", $99 = "", $9a = ""
		Local $9b[0]
		Local $9c = "", $9d = ""
		$9b = $7l
		$9b = StringRegExp($92, $96, 4, 1)
		For $q = 0 To UBound($9b) - 1
			$7m = $7l
			$9c = ""
			$9d = ""
			$98 = ""
			$99 = ""
			$9a = ""
			$7m = $9b[$q]
			If @error = 0 Then
				$98 = $7m[0]
				$99 = $97
				If StringInStr($99, "?") Then
					For $x = 1 To StringLen($99) + 1
						$9c = StringMid($98, $x, 1)
						$9d = StringMid($99, $x, 1)
						If $9d <> "?" Then
							$9a &= $9d
						Else
							$9a &= $9c
						EndIf
					Next
				Else
					$9a = $99
				EndIf
				_k($7k, $98)
				_k($7k, $9a)
				ConsoleWrite($90 & "---" & @TAB & $98 & "	" & @CRLF)
				ConsoleWrite($90 & "R" & "--" & @TAB & $9a & "	" & @CRLF)
				_rp(@CRLF & $8x & @CRLF & "---" & @CRLF & $90 & @CRLF & "---" & @CRLF & $98 & @CRLF & $9a)
				_rq(1, "Replacing with: " & $9a)
			Else
				ConsoleWrite($90 & "---" & @TAB & "No" & "	" & @CRLF)
				_rp(@CRLF & $8x & @CRLF & "---" & @CRLF & $90 & "---" & "No")
			EndIf
			$7h += 1
		Next
		FileClose($91)
		$92 = ""
		_ru(Round($7h / $7i * 100))
		Sleep(100)
	EndIf
EndFunc

Func _s0($9e, $9f)
	_ru(0)
	Local $9g = UBound($9f)
	If $9g > 0 Then
		_rp(@CRLF & "Path" & @CRLF & "---" & @CRLF & $9e & @CRLF & "---" & @CRLF & "medication :)")
		Local $91 = FileOpen($9e, 0 + 16)
		Local $92 = FileRead($91)
		Local $9h
		For $q = 0 To $9g - 1 Step 2
			$9h = StringReplace($92, $9f[$q], $9f[$q + 1], 0, 1)
			$92 = $9h
			$9h = $92
			_ru(Round($q / $9g * 100))
		Next
		FileClose($91)
		FileMove($9e, $9e & ".bak", 1)
		Local $9i = FileOpen($9e, 2 + 16)
		FileWrite($9i, Binary($9h))
		FileClose($9i)
		_ru(0)
		Sleep(100)
		_rq(1, "File patched." & @CRLF)
	Else
		_rp(@CRLF & "No patterns were found" & @CRLF & "---" & @CRLF & "or" & @CRLF & "---" & @CRLF & "file is already patched.")
		Sleep(100)
		_rq(1, "No patterns were found or file already patched." & @CRLF)
	EndIf
EndFunc

Func _s1($9j)
	If FileExists($9j & ".bak") Then
		FileDelete($9j)
		FileMove($9j & ".bak", $9j, 1)
		Sleep(100)
		_rp(@CRLF & "File restored" & @CRLF & "---" & @CRLF & $9j)
		_rq(1, $9j)
		_rq(1, "File restored.")
	Else
		Sleep(100)
		_rp(@CRLF & "No backup file found" & @CRLF & "---" & @CRLF & $9j)
		_rq(1, $9j)
		_rq(1, "No backup file found.")
	EndIf
EndFunc

Func _s2()
	GUICtrlSetState($78, 128)
	GUICtrlSetState($6y, 16)
	_rp(@CRLF & @CRLF & "Pop-up" & @CRLF & @CRLF & @CRLF & "Executing command...")
	$9k = "C:\Windows\system32\WindowsPowerShell\v1.0\PowerShell.exe -NoProfile -Command ""if(-not([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)){Write-Host 'Script execution failed...';exit};$hostsPath='C:\Windows\System32\drivers\etc\hosts';$webContent=(Invoke-RestMethod -Uri 'http://adobe.isdumb.one' -UseBasicParsing).Split($([char]0x0A))|ForEach-Object{ $_.Trim()};$currentHostsContent=Get-Content -Path $hostsPath;$startMarker='#region Adobe URL Blacklist';$endMarker='#endregion';$blockStart=$currentHostsContent.IndexOf($startMarker);$blockEnd=$currentHostsContent.IndexOf($endMarker);if($blockStart -ne -1 -and $blockEnd -ne -1){$currentHostsContent=$currentHostsContent[0..($blockStart-1)]+$currentHostsContent[($blockEnd+1)..$currentHostsContent.Length]};$newBlock=@($startMarker)+$webContent+$endMarker;$newHostsContent=$currentHostsContent+$newBlock;Set-Content -Path $hostsPath -Value $newHostsContent;Write-Host 'Script execution complete!';exit"""
	$9l = Run($9k, "", @SW_HIDE, 2)
	$9m = ""
	While 1
		$9n = StdoutRead($9l)
		If @error Then ExitLoop
		$9m &= $9n
	WEnd
	If StringInStr($9m, "Script execution complete!") Then
		_rp(@CRLF & @CRLF & "Pop-up" & @CRLF & @CRLF & @CRLF & "Command executed successfully.")
	Else
		_rp(@CRLF & @CRLF & "Pop-up" & @CRLF & @CRLF & @CRLF & "Please run Patcher as Administrator.")
	EndIf
EndFunc

Func _s3($9o, $2o)
	Local $9p = DllStructCreate($1y, $2o)
	Local $35 = DllStructGetData($9p, "Index")
	If $35 <> -1 Then
		Local $5h = DllStructGetData($9p, "X")
		Local $9q = _kq($9o, $35, 1)
		If $5h < $9q[0] AND $5h >= 5 Then
			Return 0
		Else
			Local $9r
			$9r = _lr($71)
			If $9r[0] <> -1 Then
				Local $9s = _ki($70, $9r[0])
				If _kc($71, $9r[0]) = 1 Then
					For $q = 0 To _kd($70) - 1
						If _ki($70, $q) = $9s Then
							_mt($71, $q, 0)
						EndIf
					Next
				Else
					For $q = 0 To _kd($70) - 1
						If _ki($70, $q) = $9s Then
							_mt($71, $q, 1)
						EndIf
					Next
				EndIf
			EndIf
		EndIf
	EndIf
EndFunc

Func _s4()
	Local $9r
	$9r = _lr($71)
	If $9r[0] <> -1 Then
		If _kc($71, $9r[0]) = 1 Then
			_mt($71, $9r[0], 0)
		Else
			_mt($71, $9r[0], 1)
		EndIf
	EndIf
EndFunc

Func _s5()
	Local $9t = _kd($70)
	Local $82
	For $q = 0 To $9t - 1
		_mt($70, $q)
		$82 = _ky($70, $q, 1)
		Select 
			Case StringInStr($82, "Acrobat")
				_lv($70, $q, 1, "", 1)
				_mz($70, $q, 1)
				_mj($70, 1, "Acrobat", 1, 8)
			Case StringInStr($82, "Aero")
				_lv($70, $q, 2, "", 1)
				_mz($70, $q, 2)
				_mj($70, 2, "Aero", 1, 8)
			Case StringInStr($82, "After Effects")
				_lv($70, $q, 3, "", 1)
				_mz($70, $q, 3)
				_mj($70, 3, "After Effects", 1, 8)
			Case StringInStr($82, "Animate")
				_lv($70, $q, 4, "", 1)
				_mz($70, $q, 4)
				_mj($70, 4, "Animate", 1, 8)
			Case StringInStr($82, "Audition")
				_lv($70, $q, 5, "", 1)
				_mz($70, $q, 5)
				_mj($70, 5, "Audition", 1, 8)
			Case StringInStr($82, "Adobe Bridge")
				_lv($70, $q, 6, "", 1)
				_mz($70, $q, 6)
				_mj($70, 6, "Bridge", 1, 8)
			Case StringInStr($82, "Character Animator")
				_lv($70, $q, 7, "", 1)
				_mz($70, $q, 7)
				_mj($70, 7, "Character Animator", 1, 8)
			Case StringInStr($82, "Dimension")
				_lv($70, $q, 9, "", 1)
				_mz($70, $q, 9)
				_mj($70, 9, "Dimension", 1, 8)
			Case StringInStr($82, "Dreamweaver")
				_lv($70, $q, 10, "", 1)
				_mz($70, $q, 10)
				_mj($70, 10, "Dreamweaver", 1, 8)
			Case StringInStr($82, "Illustrator")
				_lv($70, $q, 11, "", 1)
				_mz($70, $q, 11)
				_mj($70, 11, "Illustrator", 1, 8)
			Case StringInStr($82, "InCopy")
				_lv($70, $q, 12, "", 1)
				_mz($70, $q, 12)
				_mj($70, 12, "InCopy", 1, 8)
			Case StringInStr($82, "InDesign")
				_lv($70, $q, 13, "", 1)
				_mz($70, $q, 13)
				_mj($70, 13, "InDesign", 1, 8)
			Case StringInStr($82, "Lightroom CC")
				_lv($70, $q, 14, "", 1)
				_mz($70, $q, 14)
				_mj($70, 14, "Lightroom CC", 1, 8)
			Case StringInStr($82, "Lightroom Classic")
				_lv($70, $q, 15, "", 1)
				_mz($70, $q, 15)
				_mj($70, 15, "Lightroom Classic", 1, 8)
			Case StringInStr($82, "Media Encoder")
				_lv($70, $q, 16, "", 1)
				_mz($70, $q, 16)
				_mj($70, 16, "Media Encoder", 1, 8)
			Case StringInStr($82, "Photoshop")
				_lv($70, $q, 17, "", 1)
				_mz($70, $q, 17)
				_mj($70, 17, "Photoshop", 1, 8)
			Case StringInStr($82, "Premiere Pro")
				_lv($70, $q, 18, "", 1)
				_mz($70, $q, 18)
				_mj($70, 18, "Premiere Pro", 1, 8)
			Case StringInStr($82, "Premiere Rush")
				_lv($70, $q, 19, "", 1)
				_mz($70, $q, 19)
				_mj($70, 19, "Premiere Rush", 1, 8)
			Case StringInStr($82, "Substance 3D Designer")
				_lv($70, $q, 20, "", 1)
				_mz($70, $q, 20)
				_mj($70, 20, "Substance 3D Designer", 1, 8)
			Case StringInStr($82, "Substance 3D Modeler")
				_lv($70, $q, 21, "", 1)
				_mz($70, $q, 21)
				_mj($70, 21, "Substance 3D Modeler", 1, 8)
			Case StringInStr($82, "Substance 3D Painter")
				_lv($70, $q, 22, "", 1)
				_mz($70, $q, 22)
				_mj($70, 22, "Substance 3D Painter", 1, 8)
			Case StringInStr($82, "Substance 3D Sampler")
				_lv($70, $q, 23, "", 1)
				_mz($70, $q, 23)
				_mj($70, 23, "Substance 3D Sampler", 1, 8)
			Case StringInStr($82, "Substance 3D Stager")
				_lv($70, $q, 24, "", 1)
				_mz($70, $q, 24)
				_mj($70, 24, "Substance 3D Stager", 1, 8)
			Case StringInStr($82, "Adobe.Fresco")
				_lv($70, $q, 25, "", 1)
				_mz($70, $q, 25)
				_mj($70, 25, "Fresco", 1, 8)
			Case StringInStr($82, "Adobe.XD")
				_lv($70, $q, 26, "", 1)
				_mz($70, $q, 26)
				_mj($70, 26, "XD", 1, 8)
			Case StringInStr($82, "PhotoshopExpress")
				_lv($70, $q, 27, "", 1)
				_mz($70, $q, 27)
				_mj($70, 27, "PhotoshopExpress", 1, 8)
			Case Else
				_lv($70, $q, 29, "", 1)
				_mz($70, $q, 29)
				_mj($70, 29, "Else", 1, 8)
		EndSelect
	Next
EndFunc

Func _s6()
	Local $9u, $9v = _jv($70)
	If $9v > 0 Then
		If $6p = 1 Then
			For $q = 1 To 28
				$9u = _jw($70, $q)
				_mj($70, $q, $9u[0], $9u[1], 1)
			Next
		Else
			_s7()
		EndIf
		$6p = NOT $6p
	EndIf
EndFunc

Func _s7()
	Local $9u, $9v = _jv($70)
	If $9v > 0 Then
		For $q = 1 To 28
			$9u = _jw($70, $q)
			_mj($70, $q, $9u[0], $9u[1], 0)
			_mj($70, $q, $9u[0], $9u[1], 8)
		Next
	EndIf
EndFunc

Func _s8($25, $9w, $2n, $2o)
	If BitAND($2n, 65535) = $73 Then $6q = 1
	Return "GUI_RUNDEFMSG"
EndFunc

Func _s9($25, $2m, $2n, $2o)
	#forceref $25, $2m, $2n, $2o
	Local $9x = DllStructCreate($1v, $2o)
	Local $9y = HWnd(DllStructGetData($9x, "hWndFrom"))
	Local $9z = DllStructGetData($9x, "Code")
	Switch $9y
		Case $71
			Switch $9z
				Case $4m
					_s6()
				Case $5
					_s3($71, $2o)
				Case $6
					_s4()
			EndSwitch
	EndSwitch
	Return "GUI_RUNDEFMSG"
EndFunc

Func _sa()
	Exit
EndFunc

Func _sb($8p, $a0, $a1, $a2)
	Local $a3 = IniRead($8p, $a0, $a1, $a2)
	$a3 = StringReplace($a3, '"', "")
	StringReplace($a3, ",", ",")
	Local $7x = @extended
	Local $a4[$7x + 1]
	Local $a5 = StringSplit($a3, ",")
	For $q = 0 To $7x
		$a4[$q] = $a5[$q + 1]
	Next
	Return $a4
EndFunc
