copy ..\XEW\XComGame\CookedPCConsole\XComGame.upk AscBackup\XComGame.upk
copy ..\XEW\XComGame\CookedPCConsole\XComStrategyGame.upk AscBackup\XComStrategyGame.upk
copy ..\XEW\XComGame\CookedPCConsole\Command1.upk AscBackup\Command1.upk
copy ..\XEW\XComGame\CookedPCConsole\Command1.upk.uncompressed_size AscBackup\Command1.upk.uncompressed_size
copy ..\XEW\XComGame\CookedPCConsole\UICollection_Common_SF.upk AscBackup\UICollection_Common_SF.upk
copy ..\XEW\XComGame\CookedPCConsole\UICollection_Strategy_SF.upk AscBackup\UICollection_Strategy_SF.upk
copy ..\XEW\XComGame\CookedPCConsole\UICollection_Tactical_SF.upk AscBackup\UICollection_Tactical_SF.upk

copy ..\XEW\XComGame\Config\DefaultGame.ini AscBackup\DefaultGame.ini
copy ..\XEW\XComGame\Config\DefaultGameCore.ini AscBackup\DefaultGameCore.ini
copy ..\XEW\XComGame\Config\DefaultInput.ini AscBackup\DefaultInput.ini
copy ..\XEW\XComGame\Config\DefaultEngine.ini AscBackup\DefaultEngine.ini
copy ..\XEW\XComGame\Config\DefaultMutatorLoader.ini AscBackup\DefaultMutatorLoader.ini
copy ..\XEW\XComGame\Config\DefaultCheckpoint.ini AscBackup\DefaultCheckpoint.ini

copy ..\XEW\XComGame\Localization\INT\XComStrategyGame.int AscBackup\XComStrategyGame.int
copy ..\XEW\XComGame\Localization\INT\XComGame.int AscBackup\XComGame.int



copy /Y InstallFiles\Ascension.u ..\XEW\XComGame\CookedPCConsole\Ascension.u
copy /Y InstallFiles\MercenaryAscension.u ..\XEW\XComGame\CookedPCConsole\MercenaryAscension.u
copy /Y InstallFiles\XComModBridge.u ..\XEW\XComGame\CookedPCConsole\XComModBridge.u

copy /Y InstallFiles\DefaultAscension.ini ..\XEW\XComGame\Config\DefaultAscension.ini
copy /Y InstallFiles\DefaultCheckpoint.ini ..\XEW\XComGame\Config\DefaultCheckpoint.ini
copy /Y InstallFiles\DefaultEngine.ini ..\XEW\XComGame\Config\DefaultEngine.ini
copy /Y InstallFiles\DefaultGame.ini ..\XEW\XComGame\Config\DefaultGame.ini
copy /Y InstallFiles\DefaultGameCore.ini ..\XEW\XComGame\Config\DefaultGameCore.ini
copy /Y InstallFiles\DefaultInput.ini ..\XEW\XComGame\Config\DefaultInput.ini
copy /Y InstallFiles\DefaultMercenary.ini ..\XEW\XComGame\Config\DefaultMercenary.ini
copy /Y InstallFiles\DefaultMutatorLoader.ini ..\XEW\XComGame\Config\DefaultMutatorLoader.ini

copy /Y InstallFiles\XComGame.int ..\XEW\XComGame\Localization\INT\XComGame.int
copy /Y InstallFiles\XComStrategyGame.int ..\XEW\XComGame\Localization\INT\XComStrategyGame.int
copy /Y InstallFiles\MercenaryAscension.int ..\XEW\XComGame\Localization\INT\MercenaryAscension.int
copy /Y InstallFiles\Ascension.int ..\XEW\XComGame\Localization\INT\Ascension.int

DecompressLZO ..\XEW\XComGame\CookedPCConsole\Command1.upk
del /f ..\XEW\XComGame\CookedPCConsole\Command1.upk
del /f ..\XEW\XComGame\CookedPCConsole\Command1.upk.uncompressed_size
rename ..\XEW\XComGame\CookedPCConsole\Command1.upk.uncompr Command1.upk

PatchUPK InstallFiles\AscensionOverhaulInstall.txt ..\XEW\XComGame\CookedPCConsole
PatchUPK InstallFiles\GivePerkNew.txt ..\XEW\XComGame\CookedPCConsole
pause