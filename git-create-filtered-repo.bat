:: Script for creating a new Git repo from from an existing parent repo but only include files
:: that match a list of patterns. See git-ignore for pattern details.
:: ~Keripo

:SCRIPT_SETTINGS
@echo off

:CHECK_ARGS
if "%~3"=="" goto :USAGE

:SET_ARGS
set PATH_TO_PARENT_REPO="%~1"
set NEW_REPO_NAME=%~2
set PATTERNS_TO_FILTER_BY=%~3
set PATH_TO_NEW_REPO="%~4"
if %PATH_TO_NEW_REPO%=="" set PATH_TO_NEW_REPO="%CD%\%NEW_REPO_NAME%"

:FUNCTION
pushd %PATH_TO_PARENT_REPO%
git checkout -b %NEW_REPO_NAME%
git filter-branch --index-filter "git rm -rf --cached --ignore-unmatch -qr -- . && git reset -q $GIT_COMMIT -- %PATTERNS_TO_FILTER_BY%" --prune-empty -f -- %NEW_REPO_NAME%
git checkout master
popd
mkdir %PATH_TO_NEW_REPO%
pushd %PATH_TO_NEW_REPO%
git init
git pull %PATH_TO_PARENT_REPO% %NEW_REPO_NAME%
popd
goto :EOF

:USAGE
echo Usage:   %0 ^<path_to_parent_repo^> ^<new_repo_name^> "^<patterns_to_filter_by^>" [^<path_to_new_repo^>]
echo Example: %0 "C:\GitHub\MyProjectRepo" "MyLibrariesProject" "*/Library1 */Library2" "C:\GitHub\MyLibrariesProject"
exit /B 1
