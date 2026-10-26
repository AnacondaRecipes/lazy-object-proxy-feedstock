@echo on

"%PYTHON%" -m pip install . --no-deps --no-build-isolation -vv
if errorlevel 1 exit 1

rem Do not match cext.c, which is copied even when the extension is skipped.
dir /b "%SP_DIR%\lazy_object_proxy\cext*.pyd"
if errorlevel 1 exit 1
