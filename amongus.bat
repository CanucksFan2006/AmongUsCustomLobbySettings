@ECHO off
cls
setlocal enabledelayedexpansion
set "charset=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
set "hexSet=0123456789ABCDEF"
set "settings=%USERPROFILE%\AppData\LocalLow\Innersloth\Among Us\settings.amogus"
set "bin="
set "byte="
set "newByte="
if not exist !settings! (
    echo Among Us Settings Not Found!
    goto :end
)
set "string="
set quote="
for /F "tokens=1,2 delims=: " %%a in ('type "!settings!" ^| findstr "normalHostOptions"') do (
    set "temp=%%b"
    for /l %%i in (0,1,999) do (
        if not "!temp:~%%i,1!"=="," (
            if not "!temp:~%%i,1!"=="!quote!" (
                set "string=!string!!temp:~%%i,1!"
            )
            if "!temp:~%%i,1!"=="" (
                goto :endloop
            )
        ) else (
            goto :endloop
        )
    )
)

:endloop
echo Backup of Settings Saved at originalAmongUsSettingsString.txt
echo !string!>originalAmongUsSettingsString.txt

:readSettings
echo Converting Base64 to Binary
for /l %%i in (0,1,999) do (
    if "!string:~%%i,1!"=="" (
        goto :readBinary
    )
    for /l %%j in (0,1,63) do (
        if "!string:~%%i,1!"=="!charset:~%%j,1!" (
            set /a num=%%j
            call :toBinary
        )
    )
)

:toBinary
if !num! GEQ 32 (
    set /a num=!num!%%32
    set "bin=!bin!1"
) else (
    set "bin=!bin!0"
)
if !num! GEQ 16 (
    set /a num=!num!%%16
    set "bin=!bin!1"
) else (
    set "bin=!bin!0"
)
if !num! GEQ 8 (
    set /a num=!num!%%8
    set "bin=!bin!1"
) else (
    set "bin=!bin!0"
)
if !num! GEQ 4 (
    set /a num=!num!%%4
    set "bin=!bin!1"
) else (
    set "bin=!bin!0"
)
if !num! GEQ 2 (
    set /a num=!num!%%2
    set "bin=!bin!1"
) else (
    set "bin=!bin!0"
)
if !num! GEQ 1 (
    set "bin=!bin!1"
) else (
    set "bin=!bin!0"
)
goto :end

:toBinary2
if !num! GEQ 128 (
    set /a num=!num!%%128
    set "bin=!bin!1"
) else (
    set "bin=!bin!0"
)
if !num! GEQ 64 (
    set /a num=!num!%%64
    set "bin=!bin!1"
) else (
    set "bin=!bin!0"
)
if !num! GEQ 32 (
    set /a num=!num!%%32
    set "bin=!bin!1"
) else (
    set "bin=!bin!0"
)
if !num! GEQ 16 (
    set /a num=!num!%%16
    set "bin=!bin!1"
) else (
    set "bin=!bin!0"
)
if !num! GEQ 8 (
    set /a num=!num!%%8
    set "bin=!bin!1"
) else (
    set "bin=!bin!0"
)
if !num! GEQ 4 (
    set /a num=!num!%%4
    set "bin=!bin!1"
) else (
    set "bin=!bin!0"
)
if !num! GEQ 2 (
    set /a num=!num!%%2
    set "bin=!bin!1"
) else (
    set "bin=!bin!0"
)
if !num! GEQ 1 (
    set "bin=!bin!1"
) else (
    set "bin=!bin!0"
)
goto :end

:toHex
set /a n=0
set /a powerOfTwo=128
for /l %%j in (0,1,7) do (
    if "!temp:~%%j,1!"=="1" (
        set /a n+=!powerOfTwo!
    )
    set /a powerOfTwo/=2
)
if !n! GEQ 16 (
    set /a char=!n!/16
    for /f "delims=" %%c in ("!char!") do (
        set "byte=!byte!!hexSet:~%%c,1!"
    )
    set /a n=!n!%%16
    
) else (
    set "byte=!byte!0"
)
if !n! GEQ 1 (
    for /f "delims=" %%n in ("!n!") do (
        set "byte=!byte!!hexSet:~%%n,1!"
    )
) else (
    set "byte=!byte!0"
)
goto :end

:hexToDec
set /a dec=0
for /l %%i in (0,1,15) do (
    if "!hexSet:~%%i,1!"=="!tempByte:~0,1!" (
        set /a dec=!dec!+%%i*16
    )
    if "!hexSet:~%%i,1!"=="!tempByte:~1,1!" (
        set /a dec=!dec!+%%i
    )
)
goto :end

:binToDec
set /a dec=0
for /l %%i in (0,1,1) do (
    if "%%i"=="!exponent:~0,1!" (
        set /a dec=!dec!+%%i*128
    )
    if "%%i"=="!exponent:~1,1!" (
        set /a dec=!dec!+%%i*64
    )
    if "%%i"=="!exponent:~2,1!" (
        set /a dec=!dec!+%%i*32
    )
    if "%%i"=="!exponent:~3,1!" (
        set /a dec=!dec!+%%i*16
    )
    if "%%i"=="!exponent:~4,1!" (
        set /a dec=!dec!+%%i*8
    )
    if "%%i"=="!exponent:~5,1!" (
        set /a dec=!dec!+%%i*4
    )
    if "%%i"=="!exponent:~6,1!" (
        set /a dec=!dec!+%%i*2
    )
    if "%%i"=="!exponent:~7,1!" (
        set /a dec=!dec!+%%i
    )
)
goto :end

:ieee754Bin
if !dec! GEQ 8 (
    set /a dec=!dec!%%8
    set "mainBin=!mainBin!1"
) else (
    set "mainBin=!mainBin!0"
)
if !dec! GEQ 4 (
    set /a dec=!dec!%%4
    set "mainBin=!mainBin!1"
) else (
    set "mainBin=!mainBin!0"
)
if !dec! GEQ 2 (
    set /a dec=!dec!%%2
    set "mainBin=!mainBin!1"
) else (
    set "mainBin=!mainBin!0"
)
if !dec! GEQ 1 (
    set "mainBin=!mainBin!1"
) else (
    set "mainBin=!mainBin!0"
)
goto :end

:mantissaConvert
set /a largestNumber = 0
set /a currentNumber = 1
set /a multiplier = 0
for /l %%i in (0,1,22) do (
    set /a currentNumber*=2
    if "!mantissa:~%%i,1!"=="1" (
        set /a largestNumber=!currentNumber!
    )
)
set /a currentNumber = 1
for /l %%i in (0,1,22) do (
    set /a currentNumber*=2
    if "!mantissa:~%%i,1!"=="1" (
        set /a multiplier+=!largestNumber!/!currentNumber!
    )
)
set /a multiplier+=!largestNumber!
goto :end

:ieee754
set "mainBin="
set "reversed="
set "finalNum="
for /l %%i in (6,-2,0) do (
    set "reversed=!reversed!!tempByte:~%%i,2!"
)
for /l %%i in (0,1,7) do (
    set "tempByte=0!reversed:~%%i,1!"
    call :hexToDec
    call :ieee754Bin
)
if "!mainBin:~0,1!"=="1" (
    set "finalNum=-!finalNum!"
)
set "exponent=!mainBin:~1,8!"
call :binToDec
set /a power=!dec!-127
set "mantissa=!mainBin:~9!"
call :mantissaConvert
set /a powerOfTwo=1
if !power! GEQ 0 (
    for /l %%i in (1,1,!power!) do (
        set /a powerOfTwo*=2
    )
) else (
    for /F %%n in ('cscript //nologo decimal.vbs power !power! !multiplier! !largestNumber!') do set dec=!finalNum!%%n
    goto :end
)
for /F %%n in ('cscript //nologo decimal.vbs mantissa !powerOfTwo! !multiplier! !largestNumber!') do set dec=!finalNum!%%n
goto :end

:readBinary
for /l %%i in (0,8,10000) do (
    if not "!bin:~%%i,8!"=="" (
        set "temp=!bin:~%%i,8!"
        if not "!temp:~7,1!"=="" (
            call :toHex
        )
    ) else (
        goto :readByte
    )
)

:readByte
cls
set "newByte=!byte!"
echo Your Current Settings:
set "tempByte=!byte:~14,2!"
call :hexToDec
echo Max Players: !dec!
set "tempByte=!byte:~24,2!"
call :hexToDec
if !dec! EQU 0 (
    echo Map: Skeld
) else if !dec! EQU 1 (
    echo Map: Mira HQ
) else if !dec! EQU 2 (
    echo Map: Polus
) else if !dec! EQU 4 (
    echo Map: Airship
) else if !dec! EQU 5 (
    echo Map: Fungle
)
set "tempByte=!byte:~26,8!"
call :ieee754
echo Player Speed: !dec!x
set "tempByte=!byte:~34,8!"
call :ieee754
echo Crewmate Vision: !dec!x
set "tempByte=!byte:~42,8!"
call :ieee754
echo Impostor Vision: !dec!x
set "tempByte=!byte:~50,8!"
call :ieee754
echo Kill Cooldown: !dec! Seconds
set "tempByte=!byte:~58,2!"
call :hexToDec
echo Common Tasks: !dec!
set "tempByte=!byte:~60,2!"
call :hexToDec
echo Long Tasks: !dec!
set "tempByte=!byte:~62,2!"
call :hexToDec
echo Short Tasks: !dec!
set "tempByte=!byte:~64,2!"
call :hexToDec
echo Emergency Meetings: !dec!
set "tempByte=!byte:~72,2!"
call :hexToDec
echo Impostors: !dec!
set "tempByte=!byte:~74,2!"
call :hexToDec
if !dec! EQU 0 (
    echo Kill Distance: Short
) else if !dec! EQU 1 (
    echo Kill Distance: Medium
) else if !dec! EQU 2 (
    echo Kill Distance: Long
)
set "tempByte=!byte:~76,2!"
call :hexToDec
echo Discussion Time: !dec! Seconds
set "tempByte=!byte:~84,2!"
call :hexToDec
echo Voting Time: !dec! Seconds
set "tempByte=!byte:~94,2!"
call :hexToDec
echo Emergency Cooldown: !dec! Seconds
set "tempByte=!byte:~96,2!"
call :hexToDec
if !dec! EQU 0 (
    echo Confirm Ejects: Off
) else (
    echo Confirm Ejects: On
)
set "tempByte=!byte:~98,2!"
call :hexToDec
if !dec! EQU 0 (
    echo Visual Tasks: Off
) else (
    echo Visual Tasks: On
)
set "tempByte=!byte:~100,2!"
call :hexToDec
if !dec! EQU 0 (
    echo Anonymous Votes: Off
) else (
    echo Anonymous Votes: On
)
set "tempByte=!byte:~102,2!"
call :hexToDec
if !dec! EQU 0 (
    echo Task Bar Updates: Always
) else if !dec! EQU 1 (
    echo Task Bar Updates: Meetings
) else if !dec! EQU 2 (
    echo Task Bar Updates: Never
)
set "tempByte=!byte:~104,2!"
call :hexToDec
if !dec! EQU 0 (
    echo Difficulty: None
) else if !dec! EQU 1 (
    echo Difficulty: Beginner
) else if !dec! EQU 2 (
    echo Difficulty: Intermediate
) else if !dec! EQU 3 (
    echo Difficulty: Expert
)
echo.
echo Role Settings:
set "tempByte=!byte:~112,2!"
call :hexToDec
echo Number of Shapeshifters: !dec!
set "tempByte=!byte:~114,2!"
call :hexToDec
echo Percent Chance of Shapeshifters: !dec!%%
set "tempByte=!byte:~122,2!"
call :hexToDec
if !dec! EQU 0 (
    echo Leave Shapeshifting Evidence: Off
) else if !dec! EQU 1 (
    echo Leave Shapeshifting Evidence: On
)
set "tempByte=!byte:~124,2!"
call :hexToDec
echo Shapeshift Duration: !dec! Seconds
set "tempByte=!byte:~126,2!"
call :hexToDec
echo Shapeshift Cooldown: !dec! Seconds
echo.
set "tempByte=!byte:~206,2!"
call :hexToDec
echo Number of Phantoms: !dec!
set "tempByte=!byte:~208,2!"
call :hexToDec
echo Percent Chance of Phantoms: !dec!%%
set "tempByte=!byte:~216,2!"
call :hexToDec
echo Vanish Cooldown: !dec! Seconds
set "tempByte=!byte:~218,2!"
call :hexToDec
echo Vanish Duration: !dec! Seconds
echo.
set "tempByte=!byte:~260,2!"
call :hexToDec
echo Number of Vipers: !dec!
set "tempByte=!byte:~262,2!"
call :hexToDec
echo Percent Chance of Vipers: !dec!
set "tempByte=!byte:~270,2!"
call :hexToDec
echo Dissolve Time: !dec! Seconds
echo.
set "tempByte=!byte:~132,2!"
call :hexToDec
echo Number of Scientists: !dec!
set "tempByte=!byte:~134,2!"
call :hexToDec
echo Percent Chance of Scientists: !dec!%%
set "tempByte=!byte:~142,2!"
call :hexToDec
echo Vitals Display Cooldown: !dec! Seconds
set "tempByte=!byte:~144,2!"
call :hexToDec
echo Battery Duration: !dec! Seconds
echo.
set "tempByte=!byte:~150,2!"
call :hexToDec
echo Number of Guardian Angels: !dec!
set "tempByte=!byte:~152,2!"
call :hexToDec
echo Percent Chance of Guardian Angels: !dec!%%
set "tempByte=!byte:~160,2!"
call :hexToDec
echo Protect Cooldown: !dec! Seconds
set "tempByte=!byte:~162,2!"
call :hexToDec
echo Protect Duration: !dec! Seconds
set "tempByte=!byte:~164,2!"
call :hexToDec
if !dec! EQU 0 (
    echo Protect Visible to Impostors: Off
) else if !dec! EQU 1 (
    echo Protect Visible to Impostors: On
)
echo.
set "tempByte=!byte:~170,2!"
call :hexToDec
echo Number of Engineers: !dec!
set "tempByte=!byte:~172,2!"
call :hexToDec
echo Percent Chance of Engineers: !dec!%%
set "tempByte=!byte:~180,2!"
call :hexToDec
echo Vent Use Cooldown: !dec! Seconds
set "tempByte=!byte:~182,2!"
call :hexToDec
echo Max Time in Vents: !dec! Seconds
echo.
set "tempByte=!byte:~188,2!"
call :hexToDec
echo Number of Noisemakers: !dec!
set "tempByte=!byte:~190,2!"
call :hexToDec
echo Percent Chance of Noisemakers: !dec!%%
set "tempByte=!byte:~198,2!"
call :hexToDec
echo Alert Duration: !dec! Seconds
set "tempByte=!byte:~200,2!"
call :hexToDec
if !dec! EQU 0 (
    echo Impostors Get Alert: Off
) else if !dec! EQU 1 (
    echo Impostors Get Alert: On
)
echo.
set "tempByte=!byte:~224,2!"
call :hexToDec
echo Number of Trackers: !dec!
set "tempByte=!byte:~226,2!"
call :hexToDec
echo Percent Chance of Trackers: !dec!%%
set "tempByte=!byte:~234,2!"
call :hexToDec
echo Tracking Cooldown: !dec! Seconds
set "tempByte=!byte:~236,2!"
call :hexToDec
echo Tracking Duration: !dec! Seconds
set "tempByte=!byte:~238,2!"
call :hexToDec
echo Tracking Delay: !dec! Seconds
echo.
set "tempByte=!byte:~244,2!"
call :hexToDec
echo Number of Detectives: !dec!
set "tempByte=!byte:~246,2!"
call :hexToDec
echo Percent Chance of Detectives: !dec!%%
set "tempByte=!byte:~254,2!"
call :hexToDec
echo Suspects per Case: !dec!
choice /c YN /N /M "Would you like to change any of these settings? (Y/N)"
if errorlevel 2 (
    goto :end
)
if errorlevel 1 (
    goto :writeSettings
)
:getInput
set "userInput="
set /p "userInput=%~1"
if "!userInput!"=="" (
    set "%~2=%~3 %~4"
    goto :end
)
echo !userInput!| findstr /r "^[0-9][0-9]*$" >nul
set "isWhole=!errorlevel!"
echo !userInput!| findstr /r "^[0-9][0-9]*\.[0-9][0-9]*$" >nul
set "isDecimal=!errorlevel!"
if !isWhole! neq 0 (
    if !isDecimal! neq 0 (
        goto :getInput
    )
)
set "%~2=!userInput! %~4"
goto :end
:writeSettings
set "lobbyVars=mp m ps cv iv kc ct lt st em i kd dt vt ec ce vista av tbu d"
set "roleVars=ss_n ss_c ss_e ss_d ss_co ph_n ph_c ph_co ph_d vp_n vp_c vp_dt sc_n sc_c sc_vc sc_bd ga_n ga_c ga_co ga_d ga_v en_n en_c en_co en_d nm_n nm_c nm_d nm_a tr_n tr_c tr_co tr_d tr_de de_n de_c de_s"
set "allVars=!lobbyVars! !roleVars!"
echo Enter the New Values or Leave it Blank to Keep the Value
call :getInput "Max Players: " mp !byte:~14,2!_ "14|2"
call :getInput "Map: " m !byte:~24,2!_ "24|2"
call :getInput "Player Speed: " ps !byte:~26,8!_ "26|8"
call :getInput "Crewmate Vision: " cv !byte:~34,8!_ "34|8"
call :getInput "Impostor Vision: " iv !byte:~42,8!_ "42|8"
call :getInput "Kill Cooldown: " kc !byte:~50,8!_ "50|8"
call :getInput "Common Tasks: " ct !byte:~58,2!_ "58|2"
call :getInput "Long Tasks: " lt !byte:~60,2!_ "60|2"
call :getInput "Short Tasks: " st !byte:~62,2!_ "62|2"
call :getInput "Emergency Meetings: " em !byte:~64,2!_ "64|2"
call :getInput "Impostors: " i !byte:~72,2!_ "72|2"
call :getInput "Kill Distance: " kd !byte:~74,2!_ "74|2"
call :getInput "Discussion Time: " dt !byte:~76,2!_ "76|2"
call :getInput "Voting Time: " vt !byte:~84,2!_ "84|2"
call :getInput "Emergency Cooldown: " ec !byte:~94,2!_ "94|2"
call :getInput "Confirm Ejects: " ce !byte:~96,2!_ "96|2"
call :getInput "Visual Tasks: " vista !byte:~98,2!_ "98|2"
call :getInput "Anonymous Votes: " av !byte:~100,2!_ "100|2"
call :getInput "Task Bar Updates: " tbu !byte:~102,2!_ "102|2"
call :getInput "Difficulty: " d !byte:~104,2!_ "104|2"

call :getInput "Number of Shapeshifters: " ss_n !byte:~112,2!_ "112|2"
call :getInput "Percent Chance of Shapeshifters: " ss_c !byte:~114,2!_ "114|2"
call :getInput "Leave Shapeshifting Evidence: " ss_e !byte:~122,2!_ "122|2"
call :getInput "Shapeshift Duration: " ss_d !byte:~124,2!_ "124|2"
call :getInput "Shapeshift Cooldown: " ss_co !byte:~126,2!_ "126|2"

call :getInput "Number of Phantoms: " ph_n !byte:~206,2!_ "206|2"
call :getInput "Percent Chance of Phantoms: " ph_c !byte:~208,2!_ "208|2"
call :getInput "Vanish Cooldown: " ph_co !byte:~216,2!_ "216|2"
call :getInput "Vanish Duration: " ph_d !byte:~218,2!_ "218|2"

call :getInput "Number of Vipers: " vp_n !byte:~260,2!_ "260|2"
call :getInput "Percent Chance of Vipers: " vp_c !byte:~262,2!_ "262|2"
call :getInput "Dissolve Time: " vp_dt !byte:~270,2!_ "270|2"

call :getInput "Number of Scientists: " sc_n !byte:~132,2!_ "132|2"
call :getInput "Percent Chance of Scientists: " sc_c !byte:~134,2!_ "134|2"
call :getInput "Vitals Display Cooldown: " sc_vc !byte:~142,2!_ "142|2"
call :getInput "Battery Duration: " sc_bd !byte:~144,2!_ "144|2"

call :getInput "Number of Guardian Angels: " ga_n !byte:~150,2!_ "150|2"
call :getInput "Percent Chance of Guardian Angels: " ga_c !byte:~152,2!_ "152|2"
call :getInput "Protect Cooldown: " ga_co !byte:~160,2!_ "160|2"
call :getInput "Protect Duration: " ga_d !byte:~162,2!_ "162|2"
call :getInput "Protect Visible to Impostors: " ga_v !byte:~164,2!_ "164|2"

call :getInput "Number of Engineers: " en_n !byte:~170,2!_ "170|2"
call :getInput "Percent Chance of Engineers: " en_c !byte:~172,2!_ "172|2"
call :getInput "Vent Use Cooldown: " en_co !byte:~180,2!_ "180|2"
call :getInput "Max Time in Vents: " en_d !byte:~182,2!_ "182|2"

call :getInput "Number of Noisemakers: " nm_n !byte:~188,2!_ "188|2"
call :getInput "Percent Chance of Noisemakers: " nm_c !byte:~190,2!_ "190|2"
call :getInput "Alert Duration: " nm_d !byte:~198,2!_ "198|2"
call :getInput "Impostors Get Alert: " nm_a !byte:~200,2!_ "200|2"

call :getInput "Number of Trackers: " tr_n !byte:~224,2!_ "224|2"
call :getInput "Percent Chance of Trackers: " tr_c !byte:~226,2!_ "226|2"
call :getInput "Tracking Cooldown: " tr_co !byte:~234,2!_ "234|2"
call :getInput "Tracking Duration: " tr_d !byte:~236,2!_ "236|2"
call :getInput "Tracking Delay: " tr_de !byte:~238,2!_ "238|2"

call :getInput "Number of Detectives: " de_n !byte:~244,2!_ "244|2"
call :getInput "Percent Chance of Detectives: " de_c !byte:~246,2!_ "246|2"
call :getInput "Suspects per Case: " de_s !byte:~254,2!_ "254|2"
for %%v in (!allVars!) do (
    set "tempVar=!%%v!"
    for /f "tokens=1,2 delims= " %%a in ("!tempVar!") do (
        for /f "tokens=1,2 delims=|" %%c in ("%%b") do (
            set "tempVar2=%%a"
            set "tempVar3=%%c"
            set "tempVar4=%%d"
            if "!tempVar2:~-1,1!"=="_" (
                set "clean=!tempVar2:~0,-1!"
                set /a afterStart=tempVar3+tempVar4
                for /f "tokens=1,2" %%i in ("!tempVar3! !afterStart!") do (
                    set "before=!newByte:~0,%%i!"
                    set "after=!newByte:~%%j!"
                )
                set "newByte=!before!!clean!!after!"
            ) else (
                if "!tempVar4!"=="2" (
                    for /F %%n in ('cscript //nologo decimal.vbs hex !tempVar2!') do set "hex=%%n"
                ) else (
                    for /F %%n in ('cscript //nologo decimal.vbs ieee !tempVar2!') do set "hex=%%n"
                )
                set /a afterStart=tempVar3+tempVar4
                for /f "tokens=1,2" %%i in ("!tempVar3! !afterStart!") do (
                    set "before=!newByte:~0,%%i!"
                    set "after=!newByte:~%%j!"
                )
                set "newByte=!before!!hex!!after!"
            )
        )
    )
)
cls
echo Converting Hex to Binary
set "mainBin="
for /l %%i in (0,2,10000) do (
    set "tempByte=!newByte:~%%i,2!"
    if "!tempByte!"=="" (
        goto :binToBase64
    )
    call :hexToDec
    set "num=!dec!"
    set "bin="
    call :toBinary2
    set "mainBin=!mainBin!!bin!"
)

:binToBase64
cls
echo Converting Binary to Base64
set "finalBase64="
set /a letterCount=0
for /l %%i in (0,6,10000) do (
    set "letter=!mainBin:~%%i,6!"
    if "!letter!"=="" (
        goto :addPadding
    )
    if not "letter:~5,1"=="" (
        set "exponent=00!letter!"
        call :binToDec
        for /f "tokens=1" %%a in ("!dec!") do (
            set "finalBase64=!finalBase64!!charset:~%%a,1!"
        )
        set /a letterCount+=1
    )
)

:addPadding
set /a numOfEquals=!letterCount!%%4
for /l %%i in (1,1,!numOfEquals!) do (
    set "finalBase64=!finalBase64!="
)
cscript //nologo decimal.vbs "replace" "!settings!" "!finalBase64!"
cls
echo Finished
:end