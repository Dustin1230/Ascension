del ..\XEW\XComGame\Config\DefaultAscension.ini
del ..\XEW\XComGame\Config\DefaultMercenary.ini
del ..\XEW\XComGame\Config\DefaultCheckpoint.ini

del ..\XEW\XComGame\Localization\INT\MercenaryAscension.int
del ..\XEW\XComGame\Localization\INT\Ascension.int

del ..\XEW\XComGame\CookedPCConsole\Ascension.u
del ..\XEW\XComGame\CookedPCConsole\MercenaryAscension.u
del ..\XEW\XComGame\CookedPCConsole\XComModBridge.u



copy /Y AscBackup\DefaultInput.ini ..\XEW\XComGame\Config\DefaultInput.ini
copy /Y AscBackup\DefaultGame.ini ..\XEW\XComGame\Config\DefaultGame.ini
copy /Y AscBackup\DefaultGameCore.ini ..\XEW\XComGame\Config\DefaultGameCore.ini
copy /Y AscBackup\DefaultEngine.ini ..\XEW\XComGame\Config\DefaultEngine.ini
copy /Y AscBackup\DefaultCheckpoint.ini ..\XEW\XComGame\Config\DefaultCheckpoint.ini
copy /Y AscBackup\DefaultMutatorLoader.ini ..\XEW\XComGame\Config\DefaultMutatorLoader.ini

copy /Y AscBackup\XComGame.int ..\XEW\XComGame\Localization\INT\XComGame.int
copy /Y AscBackup\XComStrategyGame.int ..\XEW\XComGame\Localization\INT\XComStrategyGame.int

copy /Y AscBackup\XComGame.upk ..\XEW\XComGame\CookedPCConsole\XComGame.upk 
copy /Y AscBackup\XComStrategyGame.upk ..\XEW\XComGame\CookedPCConsole\XComStrategyGame.upk
copy /Y AscBackup\Command1.upk ..\XEW\XComGame\CookedPCConsole\Command1.upk
copy /Y AscBackup\UICollection_Common_SF.upk ..\XEW\XComGame\CookedPCConsole\UICollection_Common_SF.upk
copy /Y AscBackup\UICollection_Strategy_SF.upk ..\XEW\XComGame\CookedPCConsole\UICollection_Strategy_SF.upk
copy /Y AscBackup\UICollection_Tactical_SF.upk ..\XEW\XComGame\CookedPCConsole\UICollection_Tactical_SF.upk
pause