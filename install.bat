@echo off
setlocal EnableDelayedExpansion
echo ============================================
echo  UMA IT BOT - one-time install
echo  Requires: Python 3.10-3.12 (NOT 3.13+), MuMu Player
echo ============================================
cd /d "%~dp0"

REM numpy==1.26.4 and paddlepaddle==2.6.2 have no Windows wheels for
REM Python 3.13+, so a newer Python falls back to a source build that
REM needs MSVC (and fails). Pin to 3.10-3.12.
set "PY="
for %%V in (3.12 3.11 3.10) do (
    if not defined PY (
        py -%%V -c "import sys" >nul 2>&1
        if not errorlevel 1 set "PY=py -%%V"
    )
)
if not defined PY (
    python -c "import sys" >nul 2>&1
    if not errorlevel 1 set "PY=python"
)
if not defined PY (
    echo ERROR: No Python found. Install Python 3.10-3.12 from python.org
    echo        and tick "Add python.exe to PATH", then run this again.
    pause
    exit /b 1
)

%PY% -c "import sys; sys.exit(0 if (3,10) <= sys.version_info[:2] <= (3,12) else 1)" >nul 2>&1
if errorlevel 1 (
    echo ERROR: %PY% is Python 3.13+ . The pinned numpy/paddlepaddle
    echo        wheels only exist up to Python 3.12. Install Python 3.12
    echo        and run this again.
    pause
    exit /b 1
)

echo Using %PY%
%PY% -m venv venv
if errorlevel 1 (
    echo ERROR: could not create the virtualenv.
    pause
    exit /b 1
)
call venv\Scripts\activate.bat

python -m pip install --upgrade pip
if errorlevel 1 (
    echo ERROR: pip upgrade failed.
    pause
    exit /b 1
)
pip install -r requirements.txt
if errorlevel 1 (
    echo.
    echo ============================================
    echo  ERROR: dependency install FAILED.
    echo  If your Python is 3.13+, downgrade to 3.12
    echo  and delete the venv folder, then re-run.
    echo ============================================
    pause
    exit /b 1
)

echo.
echo Install complete. Run Start.bat to launch the bot.
pause
