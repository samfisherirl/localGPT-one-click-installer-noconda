@echo off
SET venv_dir=required\venv
SET pyfile=required\main.py
SET python=%venv_dir%\Scripts\python.exe
set LLAMA_CUBLAS="1"
set FORCE_CMAKE="1"
set CMAKE_ARGS="-DLLAMA_CUBLAS=on"
python -m pip install llama-cpp-python --prefer-binary --extra-index-url=https://jllllll.github.io/llama-cpp-python-cuBLAS-wheels/AVX2/cu117

REM Check if the virtual environment directory exists
IF EXIST "%venv_dir%\Scripts\activate.bat" (
    ECHO Virtual environment found. Activating...
    CALL %venv_dir%\Scripts\activate.bat
) ELSE (
    ECHO Creating virtual environment...
    python -m venv %venv_dir%
    CALL %venv_dir%\Scripts\activate.bat
)

REM Check if the virtual environment is activated
IF NOT "%VIRTUAL_ENV%" == "" (
    ECHO Virtual environment activated.
    ECHO Installing dependencies...
    %python% -m pip install --upgrade pip
    %python% -m pip install -r required\requirements.txt
    ECHO Dependencies installed.
    
    REM Check if the specified pyfile exists, if not, find the first .py file except __init__.py
    IF NOT EXIST "%pyfile%" (
        FOR /F "delims=" %%i IN ('DIR *.py /B /A:-D /O:N 2^>nul') DO (
            IF NOT "%%i" == "__init__.py" (
                SET "pyfile=%%i"
                GOTO FoundPyFile
            )
        )
        ECHO No suitable Python file found. Exiting...
        GOTO End
    )
    :FoundPyFile
    REM Run the Python script
    %python% %pyfile%
) ELSE (
    ECHO Failed to activate virtual environment.
)

:End
REM Pause the command window
cmd /k 