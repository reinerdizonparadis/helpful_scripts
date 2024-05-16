@echo off
set /p msg="Enter Commit Message: "
start "" "%PROGRAMFILES%\Git\bin\sh.exe" --login -i -c "./push.sh \"%msg%\""
