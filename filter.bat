@echo off

call "%~dp0.\env.bat"

set file_in=%~dp0.\in.pdf

set dir_tmp=%~dp0.\temp
set file_t1=%dir_tmp%\1_encrypted.pdf
set file_t2=%dir_tmp%\2_decrypted.pdf
set file_t3=%dir_tmp%\3_decompressed.pdf

if exist "%dir_tmp%" rmdir /Q /S "%dir_tmp%"
mkdir "%dir_tmp%"

move "%file_in%" "%file_t1%"
qpdf --decrypt "%file_t1%" "%file_t2%"
qpdf --stream-data=uncompress "%file_t2%" "%file_t3%"
move "%file_t3%" "%file_in%"
perl "%~dp0.\filter.pl"

:cleanup
del /Q /F "%file_in%"
del /Q /F "%file_t2%"
move "%file_t1%" "%file_in%"
rmdir /Q /S "%dir_tmp%"
