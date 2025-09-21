@echo off
setlocal enabledelayeexpansion

:: Defina o diretório onde os scripts estão localizados
set script_dir=%SQLPATH%

:: Verifique se o diretório existe
if not exist "%script_dir%" (
	echo Directory %script_dir% not found.
	goto : EOF

)

:: Cabeçalho da saída
echo Script Name
echo ============================

:: Percorra todos os arquivos .sql no diretório
for %%f in ("%script_dir%\*.sql") do (
	echo %%~nxf

)

endlocal