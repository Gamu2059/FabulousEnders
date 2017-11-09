@echo off

for /f "delims=" %%a in ('dir /B *.pde ^| find /V "FabolousEnders"') do copy %%a %%a.java
javadoc -d html -encoding UTF-8 *.java
for /f "delims=" %%a in ('dir /B *.java ^| find /V "FabolousEnders"') do del %%a
PAUSE
