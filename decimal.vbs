If WScript.Arguments.Count > 0 Then
    If WScript.Arguments(0) = "hex" Then
        Dim hexVal
        hexVal = Hex(WScript.Arguments(1))
        
        ' If the length is odd (1, 3, 5 characters...), add a leading zero
        If Len(hexVal) Mod 2 <> 0 Then
            hexVal = "0" & hexVal
        End If
        
        WScript.Echo hexVal
    End If
    If WScript.Arguments(0) = "power" Then
        If WScript.Arguments(3) <> 0 Then
            WScript.Echo ((2 ^ CDbl(WScript.Arguments(1))) * CDbl(WScript.Arguments(2))) / CDbl(WScript.Arguments(3))
        Else
            WScript.Echo (2^CDbl(WScript.Arguments(1)))
        End If
    End If
    If WScript.Arguments(0) = "mantissa" Then
        If WScript.Arguments(3) <> 0 Then
            WScript.Echo (CDbl(WScript.Arguments(1)) * CDbl(WScript.Arguments(2))) / CDbl(WScript.Arguments(3))
        Else
            WScript.Echo (WScript.Arguments(1))
        End If
    End If
    If WScript.Arguments(0) = "replace" Then
        Dim fso, txt, file, finalBase64, searchPattern, line, currentLine
        file = WScript.Arguments(1)
        finalBase64 = WScript.Arguments(2)
        Set fso = CreateObject("Scripting.FileSystemObject")
        txt = Split(fso.OpenTextFile(file, 1).ReadAll, vbCrLf)
        For i = 0 To UBound(txt)
            currentLine = txt(i)
            If InStr(currentLine, """normalHostOptions"":") > 0 Then
                Dim leadingSpaces
                leadingSpaces = Left(currentLine, InStr(currentLine, """normalHostOptions"":") - 1)
                txt(i) = leadingSpaces & """normalHostOptions"": """ & finalBase64 & ""","
            End If
        Next
        fso.OpenTextFile(file, 2).Write Join(txt, vbCrLf)
    End If
    If WScript.Arguments(0) = "ieee" Then
        Dim inputVal
        inputVal = WScript.Arguments(1)
        If IsNumeric(inputVal) Then
            WScript.Echo FloatToIEEE754Hex(inputVal)
        Else
            WScript.Echo "ERROR: Input is not a valid number"
        End If
    End If
End If

Function FloatToIEEE754Hex(ByVal num)
    Dim value, sign, exponent, mantissa, hexStr, i, byteVal, bits
    value = CDbl(num)
    
    ' 1. Handle special case for zero
    If value = 0 Then
        FloatToIEEE754Hex = "00000000"
        Exit Function
    End If
    
    ' 2. Determine sign bit
    If value < 0 Then
        sign = 1
        value = Abs(value)
    Else
        sign = 0
    End If
    
    ' 3. Calculate exponent and normalise the mantissa
    exponent = Int(Log(value) / Log(2))
    mantissa = value / (2 ^ exponent)
    
    ' Handle boundary adjustment
    If mantissa < 1 Then
        mantissa = mantissa * 2
        exponent = exponent - 1
    ElseIf mantissa >= 2 Then
        mantissa = mantissa / 2
        exponent = exponent + 1
    End If
    
    ' Apply bias (127 for 32-bit single precision)
    exponent = exponent + 127
    
    ' Remove the implicit leading 1 from the mantissa fractional part
    mantissa = mantissa - 1
    
    ' 4. Construct the 32-bit stream layout
    Dim bitPattern
    bitPattern = sign * (2 ^ 31)
    bitPattern = bitPattern + (exponent * (2 ^ 23))
    bitPattern = bitPattern + Int(mantissa * (2 ^ 23) + 0.5)
    
    ' 5. Extract bytes in Little-Endian layout (Forward progression)
    hexStr = ""
    For i = 0 To 3
        byteVal = Int(bitPattern / (2 ^ (8 * i))) And 255
        If byteVal < 16 Then
            hexStr = hexStr & "0" & Hex(byteVal)
        Else
            hexStr = hexStr & Hex(byteVal)
        End If
    Next
    
    FloatToIEEE754Hex = UCase(hexStr)
End Function