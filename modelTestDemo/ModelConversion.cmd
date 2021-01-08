@echo off

set workspacePath= C:\Users\HIREN PATEL\Desktop\mtl2.0_models\
set fileNames= sp_v4_2020_06_12.mdl psy_v21_2019_11_04.mdl mm_v36_2019_09_06.mdl cc_v36_2019_09_06.mdl agg_v15_2019_06_14.mdl


set fileNames=%fileNames:"=%
echo "SPECIAL>NOINTERACTION" > "VensimInputFile.cmd"
echo "SPECIAL>CONTINUEONERROR|1" >> "VensimInputFile.cmd"
(for %%a in (%fileNames%) do (
   echo "FILE>MDL2VMFX|%workspacePath%%%a" >> "VensimInputFile.cmd"
   echo "FILE>MDL2XMILE|%workspacePath%%%a" >> "VensimInputFile.cmd"
))
echo "SPECIAL>CONTINUEONERROR|0" >> "VensimInputFile.cmd"
echo "MENU>EXIT" >> "VensimInputFile.cmd"
"C:\Program Files\Vensim\vendss64" "VensimInputFile.cmd"
del "VensimInputFile.cmd"
