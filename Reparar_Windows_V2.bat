::::::::::::::::::::::::::::::::::::::::::::
:: Instalador Automático Janeano Riera
::::::::::::::::::::::::::::::::::::::::::::
@echo off
CLS
ECHO.
ECHO =============================
ECHO Running Admin shell
ECHO =============================

:init
setlocal DisableDelayedExpansion
set "batchPath=%~0"
for %%k in (%0) do set batchName=%%~nk
set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
setlocal EnableDelayedExpansion

:checkPrivileges
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
ECHO.
ECHO **************************************
ECHO Invoking UAC for Privilege Escalation
ECHO **************************************

ECHO Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
ECHO args = "ELEV " >> "%vbsGetPrivileges%"
ECHO For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
ECHO args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
ECHO Next >> "%vbsGetPrivileges%"
ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
"%SystemRoot%\System32\WScript.exe" "%vbsGetPrivileges%" %*
exit /B

:gotPrivileges
setlocal & pushd .
cd /d %~dp0
if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)

::::::::::::::::::::::::::::
::START
::::::::::::::::::::::::::::
REM In this state it will Run shell as admin (example) - add your code here
REM ECHO %batchName% Arguments: %1 %2 %3 %4 %5 %6 %7 %8 %9
REM cmd /k


REM @Echo on desactivar optimizacion del disco
REM Desactiva la optimización del disco si es necesario
REM powercfg /h off

REM @Echo on detener Wupdates
REM Detiene y deshabilita el servicio de Windows Update
sc config wuauserv start= disabled
net stop wuauserv

REM @Echo on Desabilitar updates
REM Esto ya está incluido arriba con sc config y net stop

@Echo on
REM Repara archivos del sistema dañados
sfc /scannow 

REM Verifica la salud de la imagen del sistema
DISM /Online /Cleanup-Image /CheckHealth

REM Realiza un análisis profundo de la imagen del sistema
DISM /Online /Cleanup-Image /ScanHealth

REM Repara la imagen del sistema si hay problemas detectados
DISM /Online /Cleanup-Image /RestoreHealth

REM ------------------------------
REM Comandos adicionales opcionales
REM ------------------------------

REM Liberar caché de DNS
REM ipconfig /flushdns

REM Restablecer configuración de red
REM netsh int ip reset
REM netsh winsock reset

REM Verificar y reparar errores del disco duro
REM chkdsk C: /f /r

REM Limpiar archivos temporales
REM del /s /q %temp%\*

REM Revisar procesos en ejecución
REM tasklist

REM Detener un proceso específico (reemplaza <ID_del_proceso> con el PID real)
REM taskkill /PID <ID_del_proceso> /F

REM Reparar errores de arranque
REM bootrec /fixmbr
REM bootrec /fixboot
REM bootrec /scanos
REM bootrec /rebuildbcd

REM Verificar eventos de error recientes (requiere PowerShell)
REM powershell -Command "Get-EventLog -LogName System -EntryType Error"

REM Escanear el sistema en busca de malware (Windows Defender)
REM "C:\Program Files\Windows Defender\MpCmdRun.exe" -Scan -ScanType 2

REM Restaurar el sistema a un punto anterior
REM rstrui

REM ------------------------------
REM Notas importantes
REM ------------------------------
REM Para usar cualquiera de estos comandos adicionales, simplemente elimina el comentario (REM) al inicio de la línea.
REM Algunos comandos requieren reiniciar el sistema después de su ejecución (por ejemplo, chkdsk, bootrec).
REM Si usas DISM /RestoreHealth sin conexión a Internet, puedes especificar una fuente local con /Source.