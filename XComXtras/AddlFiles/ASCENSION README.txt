XCom: Ascension

A modification for the 2012 game XCom: Enemy Unknown that has been added to the popular XCom: Long War overhaul.  This modification uses the Enemy Within version of Long War.
version Alpha2.00 * this is a preview version for an overhaul that is under development *

****	Chief Programmer: Azxeus
****	Chief Designer: Dethraker/Alandauron
****	Programmer: Kababi
****	Additional Assistance From: TheProfessional

You must have a legitimate version of Enemy Within to play this mod.
We're always open to feedback from those playing our mod, please post any suggestions, bug reports, concerns on the modpage on nexusmods.

http://www.nexusmods.com/xcom/mods/690

Installation: this can also be found in the INSTALL.txt from the download
1. Make sure you have a fresh install of Long War 1.0.  We have not tested for compatibility with most of the other mods for Enemy Within or Long War and it's very likely
with all the changes we have made that other Long War mods are incompatible with Ascension currently.

2. Copy the Ascension folder(the folder downloaded) into your XCom Enemy Unknown folder.  
   e.g. C:\Program Files (x86)\Steam\SteamApps\Common\XCom-Enemy-Unknown

3. Run(Double Click) the AscInstall.bat file.  This is a batch fille that will open a cmd window that does all the necessary changes to your Long War install to make Ascension
work.  If you're curious what it is doing right click it and select edit.

	NOTE: This is the mod installer and will install the files necessary into the appropriate locations.  It may not run properly if you do not have a fresh Long War 1.0
	install which will prevent the mod from working.  This Creates a backup of your existing Long War files to be used for the uninstall.  Also if you download Ascension
	from anywhere besides nexusmods.com it's not advised to trust any .bat files you see inside.


UNINSTALLATION

1. Run(Double Click) the AscLWRestore.bat file.  This is a batch fille that will open a cmd window that will uninstall the Ascension mod and will restore your Long War 1.0.
If you're curious what it is doing right click it and select edit.

	NOTE: This is the mod uninstaller and will restore all the files that our installer made changes to.  Do not delete any of the backup files created, these can be found
	in the AscBackup folder.  Before your first install this folder should be empty.  Also if you download Ascension from anywhere besides nexusmods.com it's not advised
	to trust any .bat files you see inside.


New Features

version: Alpha2.00

-Adjusted arrival time of Soldiers and Mercenaries
-Addition of new Mercenary Class, the Fury, with a pop up for you to decide if you take them over a standard Mercenary
-Addition of new perks: 'Resistance'; 'Corrupt'
-Addition of Rookie Perk System that gives each new Rookie a random perk
-Addition of new OTS projects: 'Leave Out the Trash'; 'I Expect the Best'; 'Mandatory Screening'; 'Extended Bootcamp'; 'Improved Facilities'; 'Best of the Best'

version: Alpha1.00

-Inclusion of Marksman Scope on all classes with weapons restrictions
-Removal of Squad Sight as a Class Perk
-Addition of an ammunition specific slot in the soldier loadout and removal of ammo type perks
-Addition of new perks: 'For The Cause'; 'Gun-Slinger'; 'This Is The Life'; 'Weapon Specialist'; 'Amnesia'; 'You Ain't Nuthin'; 'Xenocide'; 'Weakpoint Analysis'; 'Incapacitation'
-New system for Hiring Mercenaries
-New Soldier Class: Mercenary
-Modification of Icons
-Addition of a Checkpoint system to allow saving and transferring of new data back and forth from strategy and tactical
-Modification of stat values for weapons including a rework of ranges
-Addition of a new system for detecting enemies that are within the adjusted range values

Functions Modified

XComGame.upk (33)
-XGAbility_Targeted.GraduatedOdds
-XGCharacter.HasUpgrade
-XGUnit.OnTurnBeginHook
-UITacticalHUD_PerkContainer.UpdatePerks
-XGTacticalGameCore.GetBasicKillXP
-XGTacticalGameCore.GetBetterAlienKillXP
-XGUnit.ActiveWeaponHasAmmoForShot
-XGAbilityTree.ApplyActionCost
-XGAbility.ApplyCost
-XGTacticalGameCore.GetOverheatIncrement
-XGUnit.SecondaryWeaponHasAmmoForShot
-UITacticalHUD_WeaponPanel.SetWeaponAndAmmo
-UIUtilities.GetClassLabel
-XGUnit.DrawRanges
-XGUnit.AbsorbDamage
-XGAbility_Targeted.GetCriticalChance
-XGAbility_Targeted.GetCritSummaryModFromPerks
-XGAbility_Targeted.GetHitChance
-XGAbility_Targeted.GetShotSummary
-XGAbility_Targeted.GetShotSummaryModFromPerks
-XGAbility_Targeted.TShotInfo_ToString
-XGBattle_SP.PutSoldiersOnDropship
-XGTacticalGameCore.GetInventoryStatModifiers
-XGUnit.OnKill
-XGUnit.OnTakeDamage
-XGUnit.OnTurnEndHook
-XGUnit.ApplyInventoryStatModifiers
-XGBattle_SP.InitPlayers
-XGUnit.BecomePossessed
-XGUnit.BecomeUnpossessed
-XGUnit.GetMoveModifierCost
-XGUnit.Panic
-XGUnitNativeBase.ApplyPsiEffectsToTarget

XComStrategyGame.upk (46)
-XGStrategySoldier.GivePerk
-XGStrategySoldier.HasPerk
-XGSoldierUI.UpdateAbilities
-XGSoldierUI.GetHighlightedPerkDescription
-XGStrategySoldier.LevelUpStats
-XGFacility_Barracks.DetermineTimeOut
-XGStorage.ClaimItem
-XGStorage.ReleaseItem
-XGFacility_Barracks.CanAwardMedalToSoldier
-XGBarracksUI.OnChooseMainMenuOption
-XGFacility_Barracks.CreateSoldier
-XGStrategySoldier.GetPerkInClassTree
-XGBarracksUI.OnAcceptHiringOrder
-XGSoldierUI.OnAcceptPromotion
-XGHeadQuarters.OrderStaff
-XGStrategySoldier.SetSoldierClass
-XGBarracksUI.UpdateHiring
-XGHeadQuarters.UpdateHiringOrders
-XGBarracksUI.UpdateMainMenu
-XGFacility_Lockers.GetLockerItem
-XGStrategySoldier.LevelUp
-XGHeadQuarters.PayOverhead
-XGHeadQuarters.GetSalaryCost
-XGWorld.GetNetIncome
-XGFinanceUI.BuildSalaryUI
-XGFacility_Lockers.GetLockerItems
-XGSoldierUI.UpdateGear
-XGSoldierUI.UpdateLocker
-UIStrategyComponent_SoldierInfo.UpdateData
-XGStorage.AreReaperRoundsValid
-XGItemTree.BuildItems
-XGFacility_Lockers.GetSmallInventorySlots
-XGSoldierUI.UpdateHeader
-XGStrategySoldier.ClearPerks
-XGFacility_Barracks.InitNewGame
-XGFacility_Barracks.AddNewSoldier
-XGTechTree.BuildOTSTech
-XGTechTree.BuildOTSTechs
-XGTechTree.HasOTSPrereqs
-XGTechTree.ApplyOTSTech
-XGTechTree.GetAvailableOTSTechs
-XGFacility_Barracks.UpdateOTSFlags
-XGOTSUI.BuildTechList
-XGItemTree.GetFacility
-XGStrategySoldier.AssignRandomPerks
-XGStrategySoldier.IsRandomPerkValidToAdd
