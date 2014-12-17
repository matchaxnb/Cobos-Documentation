@echo off
setlocal
set GENE=OK

set ROOTDIR=%~dp0
set OUTDIR=Output

echo in folder %ROOTDIR%
pushd %ROOTDIR%

set CLEAN=NO
set CLEANFILE=*.out *.log *.aux
:_loop
if T%1 == T goto _next
if T%1 == Tclean set CLEAN=YES
if T%1 == Tall set CLEANFILE=%CLEANFILE% *.toc *.pdf
shift
goto _loop
:_next
if %CLEAN% == YES del %CLEANFILE% >nul

for %%f in (*.tex) do call :build %%f
goto end

:build
if %GENE% == KO goto _end
set TEXFILE=%1
set TOCFILE=%~n1.toc
set PDFFILE=%~n1.pdf
set LOGFILE=%~n1.log

rem The first iteration collects all headings and captions and writes them to meta files (*.toc, *.lof, *.lot).
if exist %TOCFILE% goto step2
:step1
echo Build %TOCFILE%
 call :compil %TEXFILE%
if errorlevel 1 goto error

:step2
echo Build %PDFFILE%
call :compil %TEXFILE%
if errorlevel 1 goto error
move %PDFFILE% %OUTDIR%
set GENE=OK
goto end

:compil
rem  -output-directory=%OUTDIR%
rem pushd %OUTDIR%
lualatex.exe -halt-on-error -interaction=nonstopmode -output-format=pdf %ROOTDIR%\%1 >nul
rem goto end
goto _end

:error
echo failed! see %LOGFILE% file.
set GENE=KO
rem pause
goto _end

:end
popd
:_end

