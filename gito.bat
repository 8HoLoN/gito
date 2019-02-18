@echo off
rem git (single layer) onion
rem @license
rem Copyright (c) 2019 Alexandre REMY
rem
rem https://github.com/8HoLoN/gito
rem @version: 0.0.1 ( February 2019 )
rem @author 8HoLoN / https://github.com/8HoLoN/
rem < 8holon [at] gmail.com >

set action=%1
set sevenzPath="C:\Program Files\7-Zip\7z.exe"
set password=%2
set archiveName="secure.7z"
set innerRepo="inner"

IF "%action%" == "clone" (
    set repoPath=%3
    call:parseRepoName
    call:gitoClone
) else IF "%action%" == "init" (
    set repoPath=%3
    call:parseRepoName
    call:gitoInit
) else IF "%action%" == "pull" (
    call:gitoPull
) else IF "%action%" == "push" (
    call:gitoPull
    call:gitoPush
) else (
    echo "Wrong parameters."
)

goto:eof

:gitoInit
git clone --mirror %repoPath%
cd "%repoName%.git"
%sevenzPath% a "%archiveName%" * -p"%password%" -mhe=on
move "%archiveName%" "../"
cd ..
rem del /s /q  "%repoName%.git"
rmdir /s /q "%repoName%.git"
git clone %repoPath%
move /Y "%archiveName%" "%repoName%"
cd "%repoName%"
git add "%archiveName%"
git commit -a -m "init repo"
git push
cd ..
rmdir /s /q "%repoName%"
goto:eof

:gitoClone
git clone %repoPath% --no-hardlinks --no-local
mkdir ".gito"
move "%repoName%" ".gito"
cd ".gito"
RENAME "%repoName%" "sub"
cd "sub"
%sevenzPath% -y x "%archiveName%" -p"%password%" -o.\%innerRepo%.git
rem del "%archiveName%"
git clone "%innerRepo%.git" --no-hardlinks --no-local
rem mkdir "../../lan"
move "%innerRepo%" "../.."
cd "../.."
move ".gito" "%innerRepo%"
RENAME "%innerRepo%" "%repoName%"
cd %repoName%
rem make it hidden
attrib +h ".gito" /s /d
git remote set-url origin .gito/sub/%innerRepo%.git
cd ..
goto:eof

:gitoPull
cd ".gito/sub"
git pull
%sevenzPath% -y x "%archiveName%" -p"%password%" -o.\%innerRepo%.git
cd "../.."
git pull
goto:eof

:gitoPush
git push
cd ".gito/sub/%innerRepo%.git"
%sevenzPath% a "%archiveName%" * -p"%password%" -mhe=on
move /Y "%archiveName%" "../%archiveName%"
cd ..
git commit -a -m "update repo"
git push
cd "../.."
goto:eof

:parseRepoName
set "char=/"
call :lastIndexOf repoPath char rtn
set /a rtn1=%rtn%+1
call set repoName=%%repoPath:~%rtn1%,-4%%
goto:eof

:lastIndexOf  strVar  charVar  [rtnVar]
  setlocal enableDelayedExpansion

  :: Get the string values
  set "lastIndexOf.char=!%~2!"
  set "str=!%~1!"
  set "chr=!lastIndexOf.char:~0,1!"

  :: Determine the length of str - adapted from function found at:
  :: http://www.dostips.com/DtCodeCmdLib.php#Function.strLen
  set "str2=.!str!"
  set "len=0"
  for /L %%A in (12,-1,0) do (
    set /a "len|=1<<%%A"
    for %%B in (!len!) do if "!str2:~%%B,1!"=="" set /a "len&=~1<<%%A"
  )

  :: Find the last occurrance of chr in str
  for /l %%N in (%len% -1 0) do if "!str:~%%N,1!" equ "!chr!" (
    set rtn=%%N
    goto :break
  )
  set rtn=-1

  :break - Return the result if 3rd arg specified, else print the result
  ( endlocal
    if "%~3" neq "" (set %~3=%rtn%) else echo %rtn%
  )
exit /b
