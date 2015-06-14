:: Script for fixing commit names in a Git repo
:: ~Keripo

:SCRIPT_SETTINGS
@echo off

:CHECK_ARGS
if "%~4"=="" goto :USAGE

:SET_ARGS
set PATH_TO_GIT_REPO=%1
set OLD_NAME=%~2
set NEW_NAME=%~3
set NEW_EMAIL=%~4

:FUNCTION
pushd %PATH_TO_GIT_REPO%
git filter-branch --force --env-filter "if [ "$GIT_COMMITTER_NAME" = "%OLD_NAME%" ]; then export GIT_COMMITTER_NAME="%NEW_NAME%"; export GIT_COMMITTER_EMAIL="%NEW_EMAIL%"; export GIT_AUTHOR_NAME="%NEW_NAME%"; export GIT_AUTHOR_EMAIL="%NEW_EMAIL%"; fi" -- --all
popd
goto :EOF

:USAGE
echo Usage:   %0 ^<path_to_git_repo^> ^<old_name^> ^<new_name^> ^<new_email^>
echo Example: %0 "C:\GitHub\MyProjectRepo" "msmith" "Mr. Smith" "msmith@github.com"
exit /B 1
