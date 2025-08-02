echo off
setlocal enabledelayedexpansion
echo ============convert start============

::src forder
set srcForder=%1


if "%srcForder%"=="" (
  echo srcForder not exist
  goto end
)

set desForder=%srcForder%
set str1=srcForder:
set str2=desForder:
::des forder

rem 针对 目录有盘符的情况
cd /D %srcForder%


rem 查找数字文件夹
:: set numberFolderName=0;

:: for /f "delims=" %%a in (' dir /b^|findstr "^[0-9]*$" ') do (
::	set numberFolderName=%%a
:: )
:: echo is numberName %numberFolderName%

rem 替换index.html
rem =====================================================================================
rem xcopy %srcForder%\index.html %srcForder%\%numberFolderName% /y


rem files\mobile 图片jpg转gif 图片修改
rem =====================================================================================
set mobileFolder=%srcForder%\files\mobile

echo %mobileFolder%

cd /D %mobileFolder%

for /f %%i in ('dir /b *.jpg') do (

set src=%%i

set des=%mobileFolder%\%%~ni.gif

set /a str3 = 0

for /f "delims=" %%a in ('identify -format %%k %%i') do (
	if %%a=="" goto aa
	echo %%a
	set /a str3 = %%a
)
:aa
if !str3! LSS 256 (
	echo '!str3! less 256 run convert -colors 8'
	convert -colors 8 !src! !des! 
) else ( 
	echo '!str3! more 256 run convert -colors 32'
	convert -colors 32 !src! !des! 
)
echo %str1% !src! %str2% !des!
)

rem 删除当前文件夹中的.jpg文件

for /f %%i in ('dir /b *.jpg') do (

set src=%%i

echo del !src!

del !src!

)


rem files\thumb 图片jpg转gif 图片修改
rem =====================================================================================

set thumbFolder=%srcForder%\files\thumb

echo %thumbFolder%

cd /D %thumbFolder%

for /f %%i in ('dir /b *.jpg') do (

set src=%%i

set des=%thumbFolder%\%%~ni.gif

set /a str3 = 0

for /f "delims=" %%a in ('identify -format %%k %%i') do (
	if %%a=="" goto aa
	echo %%a
	set /a str3 = %%a
)
:aa
if !str3! LSS 256 (
	echo '!str3! less 256 run convert -colors 8'
	convert -colors 8 !src! !des! 
) else ( 
	echo '!str3! more 256 run convert -colors 32'
	convert -colors 32 !src! !des! 
)
echo %str1% !src! %str2% !des!
)

rem 删除当前文件夹中的.jpg文件

for /f %%i in ('dir /b *.jpg') do (
	set src=%%i

	echo del !src!

	del !src!
	
)

rem files\extfiles && files\mobile-ext 删除
rem mobile\style\icon 删除
rem mobile\style\raw 删除
rem mobile\javascript\jquery-1.9.1.min.js 删除
rem mobile\javascript\main.js 删除
rem mobile\style\phoneTemplate.css 删除
rem mobile\style\player.css 删除
rem mobile\style\style.css 删除
rem mobile\style\template.css 删除
:b
set extfilesFolder=%srcForder%\files\extfiles
if exist %extfilesFolder% (
  rd /s /q %extfilesFolder%
)

set mobileExtFolder=%srcForder%\files\mobile-ext
if exist %mobileExtFolder% (
  rd /s /q %mobileExtFolder%
)

set iconFolder=%srcForder%\mobile\style\icon
if exist %iconFolder% (
  rd /s /q %iconFolder%
)

set rawFolder=%srcForder%\mobile\style\raw
if exist %rawFolder% (
  rd /s /q %rawFolder%
)

set jqueryFile=%srcForder%\mobile\javascript\jquery-1.9.1.min.js
if exist %jqueryFile% ( del /f /s /q %jqueryFile% )

set mainFile=%srcForder%\mobile\javascript\main.js
if exist %mainFile% ( del /f /s /q %mainFile% )

set phoneTemplateFile=%srcForder%\mobile\style\phoneTemplate.css
if exist %phoneTemplateFile% ( del /f /s /q %phoneTemplateFile% )

set playerFile=%srcForder%\mobile\style\player.css
if exist %playerFile% ( del /f /s /q %playerFile% )

set styleFile=%srcForder%\mobile\style\style.css
if exist %styleFile% ( del /f /s /q %styleFile% )

set templateFile=%srcForder%\mobile\style\template.css
if exist %templateFile% ( del /f /s /q %templateFile% )

:end
Pause





