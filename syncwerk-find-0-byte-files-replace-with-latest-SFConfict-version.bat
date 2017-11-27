@echo off
setlocal enabledelayedexpansion
set log_file=syncwerk-replaced-empty-files.log
echo !date!-!time! - Start >> !log_file!
for /r %%i in (*) do (
  if %%~zi == 0 (
	rem Check if 0-byte file has a corresponding SFConflict version 

	set empty_file=%%~di%%~pi%%~ni%%~xi
	echo "!empty_file!"
	if exist replacement_file.txt del replacement_file.txt
	set "replacement_file="
	dir /A-D /b /o-d "%%~di%%~pi%%~ni (SFConflict*@*%%~xi" | findstr /n ^^| findstr "^[1]:" > replacement_file.txt
	set /p replacement_file= < replacement_file.txt	
	
	if [!replacement_file!]==[] (
		echo "Nothing to do"
        ) else (
		if exist %%~di%%~pi!replacement_file:1:=! (
			echo !date!-!time! - Replacing empty file "!empty_file!" with "%%~di%%~pi!replacement_file:1:=!" >> !log_file!
			move "%%~di%%~pi!replacement_file:1:=!" "!empty_file!"
		)	
        )	
  )
)
echo !date!-!time! - End >> !log_file!
