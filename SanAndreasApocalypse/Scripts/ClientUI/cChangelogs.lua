local sx, sy = guiGetScreenSize()
local z = math.max(0.78, math.min(1.05, sx / 1920))

local fontHeader = dxCreateFont("files/fonts/black.ttf", 24 * z, false, "cleartype") or "default-bold"
local fontTitle  = dxCreateFont("files/fonts/bold.ttf", 13 * z, false, "cleartype") or "default-bold"
local fontText   = dxCreateFont("files/fonts/medium.ttf", 10 * z, false, "cleartype") or "default"
local fontMono   = dxCreateFont("files/fonts/medium.ttf", 9 * z, false, "cleartype") or "default"

local ui = {
    visible = false,
    anim = 0,
    target = 0,
    scroll = 0,
    maxScroll = 0,
    activeGroup = "all",
    selectedVersion = 1,
    search = "",
    typing = false,
    layoutDirty = true,
    layout = {},
    counts = {},
    listRT = nil,
    listRTW = 0,
    listRTH = 0,
}

local colors = {
    green = tocolor(90, 255, 148),
    cyan  = tocolor(82, 214, 255, 255),
    amber = tocolor(255, 184, 79, 255),
    red   = tocolor(255, 72, 91, 255),
}

local changelogs = {
    {
        version = "v.1.0.9",
        update = "UPDATE #42",
        date = "15 March 2026",
        subtitle = "Apocalypse Systems Patch",
        entries = {
            {"changed", "Spinosaurus Boss", "The dynamite the player has during the Spinosaurus boss fight is now displayed under the Spinosaurus health bar instead of above the player's head."},
            {"added", "Friend Notifications", "When you add or remove a friend, the affected player now receives a notification."},
            {"changed", "Party Window", "The party window has been moved slightly to the right so it no longer overlaps with the daily tasks and is now hidden when the daily tasks are opened."},
            {"fixed", "F11 Blip Legend", "Missing blip names in the blip legend under F11 have been added."},
            {"changed", "NPC Introductions", "Characters that previously had no introduction text now have one. Some NPC system texts that were not translated into Russian have also been translated."},
            {"fixed", "Chat Lock", "Chat is now disabled while the active bonus display is expanded."},
            {"added", "Zone Names", "All zones now have names."},
            {"fixed", "Prison Quest", "The markers in the prison quest are now visible and a hint is shown when walking down the stairs to the cells."},
            {"added", "Daily Rewards", "Text is now displayed above the daily reward pickups."},
            {"changed", "Friend XP", "The number of friends that are online is now considered when granting friend experience points."},
            {"added", "Mining Shop", "A shop has been added to the mining activity where you can purchase pickaxes and other items."},
            {"changed", "Character Skins", "All characters that previously had the CJ skin now have their own skin. Skins are no longer used multiple times."},
            {"fixed", "Window Close Button", "In some windows, clicking in certain places caused the close button to disappear. This has been fixed."},
            {"changed", "NPC Dialog Font", "The font used in NPC dialogs has been replaced because some letters and numbers were difficult to recognize."},
            {"changed", "Elite Team Base", "The Elite Team base has been moved and received a new interior."},
            {"fixed", "Lootable Garages", "Lootable garages have been fixed."},
            {"added", "Recruitment XP", "You now receive 75 experience points every minute for each player you recruited when they are online while you are also online."},
            {"changed", "Diving Suit", "When borrowing a diving suit, the system is now explained. Additionally, you can collect two oxygen bottles daily at the pier and fishing achievements are now granted correctly."},
            {"added", "Colony Payday", "A Colony Payday has been added. It takes into account the number of laboratories and whether you have the flag. You receive experience points, money and brain matter in the colony storage."},
            {"fixed", "Vest Shop Armor", "In the vest shop you can now see how much armor you already have during the purchase process. The issue where the wrong amount of armor was sometimes given has been fixed."},
            {"added", "Supply Package", "New item: Supply Package. Restores 50% hunger and 50% thirst."},
            {"fixed", "Animal Damage", "Animals could sometimes not be killed. This has been fixed."},
            {"added", "Sniper Headshot XP", "Killing a zombie with a sniper headshot now grants bonus experience points."},
            {"changed", "Community Tasks", "Missing texts in the community task system have been integrated into the language system."},
            {"added", "Mushrooms", "Mushrooms have been added. They can be found throughout San Andreas, can be collected with one click and respawn after 5 minutes. There are two different types of mushrooms. Mushrooms can be eaten and will be used to craft new items in the future."},
            {"added", "Cooked Meat", "Meat obtained from killing animals can now be cooked at a campfire to create cooked meat that can be eaten."},
            {"added", "Gym Experience", "Training in the gym now grants experience points and training achievements have been added."},
            {"changed", "Water Dispensers", "Water dispensers now restore more thirst."},
            {"fixed", "Inventory Water Bottles", "Fixed an issue where clicking a water bottle in the inventory sometimes removed two bottles."},
            {"changed", "Moon Quest Text", "The moon quest text now mentions that a quest chain must be completed."},
            {"added", "Character Slot", "New item: Character Slot – allows the creation of a new character."},
            {"added", "Treasure Maps", "Treasure maps purchased in fishing shops can now be opened from the inventory and show the location where a key is hidden."},
            {"added", "Excavator Map Markers", "Locations where objects can be purchased are now marked with an excavator on the map."},
            {"fixed", "Injury Outside Danger Zones", "Players could previously only get injured in Danger Zones, which was not intended. This has been fixed."},
            {"fixed", "AFK Respawn Freeze", "If you died while in AFK mode, you were no longer frozen after respawning. This has been fixed."},
            {"changed", "Tutorial", "The tutorial has been expanded and now shows images to make completing tasks easier. The keypad can now be closed again and the keypad code is displayed while it is open."},
            {"added", "Ocean Cleaner Skill", "A new skill has been added for the ocean cleaner activity that allows transporting up to 50,000 kilos of trash at once."},
            {"fixed", "Lootable Skin Shops", "Two unreachable crates in lootable skin shops have been removed."},
            {"fixed", "Steve Carter", "Steve Carter displayed the wrong text. This has been fixed."},
            {"fixed", "David Brown Quest", "The quest with David Brown could not be completed. This has been fixed."},
            {"added", "Spinosaurus Enclosure", "After completing the bone quest in the Spinosaurus Club, the key you receive can now be used to enter the new Spinosaurus enclosure. The Spinosaurus generates experience points while you are online."},
            {"added", "Pirate Island Buildings", "On Pirate Island you can now enter three buildings with the required keys and collect a daily reward."},
            {"changed", "Area 51 Laboratory", "The Area 51 laboratory has received a new interior."},
            {"added", "Colony Zombie Levels", "Colony zombies now have a level that can be increased with DNA chips, allowing them to generate more colony experience points."},
            {"added", "Emily Turner Quest", "A new quest has been added at Emily Turner in the back rooms of Dillimore’s Hope."},
            {"added", "Impala Event", "The Impala Event has been added in Zone 7. Killing a zombie there has a chance to drop an Impala Ticket. These can be exchanged at the event area opposite the House of Achievements for a Chevrolet Impala 67, a vehicle slot and the status 'Impala 67'."},
            {"changed", "Bonus / PvP Zones", "Entering a Bonus/PvP zone now shows a notification. There are now always two active Bonus/PvP zones instead of one."},
            {"changed", "F2 Collection View", "Under F2, achievements, documents and other items that you do not yet have are now displayed but greyed out."},
            {"added", "Object Owner Display", "The owner of placeable objects is now displayed when you are near them."},
            {"added", "Blueberry Safe Info", "An information pickup has been added at the safes in Blueberry."},
            {"added", "Lobby Player Count", "The bottom right of the screen now shows how many players are in each lobby: Apocalypse and Shooter Arena."},
            {"changed", "Leaderboard Performance", "Leaderboard data is now updated only once per hour to improve performance."},
            {"added", "Garage Vehicle Delivery Info", "Disassemblable vehicles found in garages now show the remaining delivery time and drop-off location while sitting in them."},
            {"added", "Grave Loot Counter", "The number of graves you have looted is now saved."},
            {"added", "Spinosaurus Achievements", "A Spinosaurus kill achievement series has been added."},
            {"added", "Achievement Trophies", "Trophies have been added for completing the Bigfoot and Spinosaurus achievement series."},
            {"changed", "Spinosaurus Caves", "Spinosaurus caves now close faster, 30 instead of 60 minutes, but can now also be opened with two pickaxes."},
            {"added", "Survivor Pass HUD", "The current tasks and their progress in the Survivor Pass are now displayed at the bottom right of the screen."},
            {"added", "Shooter Arena Map", "The Shooter Arena now has a new map."},
            {"changed", "Shooter Arena Vehicles", "Vehicles can now take three hits before exploding."},
            {"added", "Shooter Arena Destroy Notification", "A notification is shown on the right side of the screen when a player's vehicle is destroyed."},
            {"added", "Shooter Arena Power-ups", "Power-ups can now be collected: One additional hit and Nitro for 3.5 seconds."},
        }
    },
    {
        version = "v.1.0.8",
        update = "UPDATE #41",
        date = "1 March 2026",
        subtitle = "Bigfoot, Spinosaurus, XP Scaling and Combat Patch",
        entries = {
            {"added", "Spinosaurus Kill Counter", "The number of times you have killed the Spinosaurus is now saved."},
            {"added", "Bigfoot Jail Message", "A message is now displayed if you have already completed the Bigfoot Jail quest."},
            {"changed", "Bigfoot Head Turn-in", "When turning in five Bigfoot heads at the Bigfoot Club, you now receive an additional 25 XP × your level on top of the 6,250 XP."},
            {"changed", "Bigfoot Logging", "The entire Bigfoot system is now fully logged."},
            {"fixed", "Diving Suit Reactivation", "If you rented a diving suit and returned it, it was automatically reactivated after death. [NEEDS TESTING!]"},
            {"changed", "Respawn Health", "After dying, you now respawn with 25% health instead of 10%."},
            {"changed", "Reputation XP Bonus", "The experience bonus gained from Reputation Level is now 2 × your level."},
            {"changed", "Zombie Headshot Streak XP", "XP gained from zombie headshot streaks is now 0.5 × your level."},
            {"fixed", "Daily Task Zombie Kills", "Zombie kills were not counted towards the Daily Task."},
            {"changed", "Spinosaurus Kill XP", "Killing the Spinosaurus now grants XP even after the first kill: 750 + (25 × your level)."},
            {"changed", "Bigfoot Kill XP", "Killing Bigfoot now grants XP even after the first kill: 300 + (25 × your level)."},
            {"added", "Bigfoot Minigun Display", "Above the Minigun pickup in the Bigfoot quest, it now displays how many times you have killed Bigfoot."},
            {"changed", "Bigfoot Minigun Ammo", "For each time you have killed Bigfoot, the Minigun now has 5 additional bullets."},
            {"added", "Collectible Photo", "A new collectible photo can now be found in the Bigfoot quest cabin."},
            {"added", "Bigfoot Jail Minigun Pickup", "A new pickup has been added in Bigfoot Jail where you can collect the Minigun."},
            {"added", "Spinosaurus Bone / Club", "After killing the Spinosaurus, you can now collect a Spinosaurus bone. When collecting your first Spinosaurus bone, you will receive the coordinates of the new Spinosaurus Club on your radio. There you will find new quests and new ways to earn XP."},
            {"fixed", "Bicycle Engine Toggle", "Bicycles can no longer toggle their engine on and off. They now always move."},
            {"fixed", "Lootable Tanks", "You can no longer shoot with lootable tanks."},
            {"changed", "Compass Position", "The compass has been moved slightly downward."},
            {"changed", "Repeatable XP Scaling", "XP rewards for most repeatable activities now scale with your level."},
            {"changed", "Window Design", "The design of several windows has been reworked."},
            {"fixed", "Lab Fights", "Lab fights can now be started properly. Additionally, text messages now appear during attacks, and the remaining fight time is displayed in the fight UI."},
            {"fixed", "Mining Pickaxe", "During the mining activity, the pickaxe was not visible in hand."},
            {"fixed", "Shark Quest Requirement", "The Shark quest was obtainable even if you were not a member of the Bigfoot Club."},
            {"fixed", "PvP Damage", "PvP damage was calculated incorrectly, causing players to die too quickly."},
            {"fixed", "Zombie Armor Damage", "Zombies always dealt damage regardless of whether you had a vest or extra armor."},
            {"added", "Random Bonus System", "A new bonus system now generates a random bonus that lasts 30 minutes. After a 5-minute break, a new bonus is generated."},
        }
    },
	{
		version = "v.1.0.7",
		update = "UPDATE #40",
		date = "22 February 2026",
		subtitle = "Bug Fixes, Quality of Life and Russian Language Patch",
		entries = {
			{"fixed", "Bug Fixes", "Additional bugs have been fixed across multiple systems to improve overall gameplay stability."},
			{"changed", "Quality of Life", "Several quality-of-life improvements have been implemented to make gameplay smoother and more comfortable."},
			{"added", "Russian Language", "The Russian language is now available."},
		}
	},
	{
		version = "v.1.0.6",
		update = "UPDATE #39 / HOTFIX",
		date = "15 February 2026",
		subtitle = "System Stability, Activity Fixes and Airdrop Hotfix",
		entries = {
			{"fixed", "Colony Assignment", "Some players were assigned colonies that do not exist, causing zombie kills not to be counted and rewards not to be given."},
			{"fixed", "No Thirst System", "For some players, the No Thirst system did not work and shakes had no effect."},
			{"fixed", "Weekly Tasks", "Weekly tasks were sometimes not processed correctly."},
			{"fixed", "Colony Creation", "Creating colonies did not work properly."},
			{"fixed", "Street Cleaner First Reward", "In the Street-Cleaner activity, collecting trash for the first time did not grant experience points. Achievements, daily tasks and weekly tasks were also not counted correctly."},
			{"fixed", "ATMs", "ATMs could sometimes not be opened."},
			{"fixed", "Mining Markers", "Markers in the Mining activity sometimes did not work."},
			{"fixed", "Dr. Brain Shop", "Dr. Brain’s shop did not work when the language was set to Russian or Portuguese."},
			{"changed", "Pumpkin Mod", "The Pumpkin Mod now loads even when the Halloween event is not active."},

			{"fixed", "Airdrop Spawns", "Airdrops now spawn more reliably and consistently. An issue was fixed where no airdrop could appear even though spawn locations were still free."},
			{"fixed", "Airdrop Looting", "The looting process has been improved to prevent multiple players from looting the same airdrop at the same time."},
			{"fixed", "Airdrop Stability", "Rare cases where airdrops could disappear or behave incorrectly have been fixed."},
			{"changed", "Airdrop Cancel Key", "The cancel or abort key now only works while you are actively looting an airdrop crate."},
			{"changed", "Airdrop Reliability", "Overall stability and reliability of airdrops has been improved."},

			{"fixed", "Zombie Nest Dynamite Abort", "Players can now safely abort planting dynamite in a Zombie Nest if they die while planting."},
			{"changed", "Zombie Nest Dynamite", "Once the dynamite is placed in a Zombie Nest, it will explode automatically after 5 seconds, even if the player dies."},
			{"changed", "Zombie Nest Waves", "Zombies now spawn in waves in a Zombie Nest instead of all at once, making fights more natural."},
			{"fixed", "Zombie Nest Timers", "Cases where timers or player actions could interfere with each other when planting dynamite in a Zombie Nest have been fixed."},
			{"changed", "Zombie Nest Reliability", "Overall stability and reliability of the Zombie Nest system has been improved."},

			{"fixed", "Hurt Survivor Spawns", "The Hurt Survivor system now spawns survivors reliably every 5 seconds, even if some survivor IDs are already in use."},
			{"fixed", "Hurt Survivor Creation", "An issue was fixed where a survivor could fail to spawn because the creation function returned early."},
			{"changed", "Hurt Survivor Spawn Search", "The Hurt Survivor system now properly retries multiple candidate spawn points until a valid one is found."},
			{"fixed", "Hurt Survivor Timer", "The Hurt Survivor system timer now starts and stops correctly when the player enters, exits or dies, preventing missing spawns or duplicate timers."},
			{"fixed", "Hurt Survivor Vehicle Reset", "An issue was fixed where other players entering the vehicle could reset the Hurt Survivor progress for the active player."},

			{"fixed", "Progress Bar Overlap", "The Progress Bar system now safely prevents multiple progress bars from running at the same time."},
			{"fixed", "Progress Bar Closing", "The Progress Bar system now properly closes when an action finishes or is interrupted."},
			{"fixed", "Progress Bar Death Handling", "The Progress Bar system now reliably stops when the player dies, preventing stuck UI elements."},
			{"changed", "Progress Bar Reliability", "Overall stability and reliability of the Progress Bar system has been improved."},

			{"fixed", "Information Bar Animation", "The Information Bar system animation now runs smoothly, preventing visual glitches."},
			{"fixed", "Information Bar Timer", "The Information Bar system timer now only triggers the fade-out, ensuring smooth transitions."},
			{"fixed", "Information Bar Duplicate Rendering", "The Information Bar render function is no longer added multiple times, preventing duplicate rendering."},
			{"fixed", "Information Bar Death Cleanup", "The Information Bar panel and text are cleared properly when the player dies, preventing lingering UI elements."},
			{"changed", "Information Bar Code Cleanup", "The Information Bar system code has been cleaned up for readability and better performance."},

			{"changed", "Infected Survivor Performance", "Optimized the Infected Survivors System ped text rendering to work smoothly with hundreds of peds."},
			{"changed", "Infected Survivor Visibility", "Only the nearest visible peds in the Infected Survivors System are shown on screen to improve performance."},
			{"changed", "Infected Survivor Text Cache", "Ped texts in the Infected Survivors System are cached to reduce unnecessary calculations."},
			{"changed", "Infected Survivor Frame Skipping", "The Infected Survivors System now skips frames automatically to reduce CPU usage while keeping animations smooth."},
			{"changed", "Infected Survivor FPS", "The Infected Survivors System works seamlessly even with 500 to 1000 peds without affecting FPS."},

			{"fixed", "Fish Shop List", "The list in the fish shop was not updating correctly."},
			{"fixed", "Fishing Disconnect", "If a player disconnected while fishing, the fishing spot was not released."},
			{"fixed", "Fish Achievements", "Fish-catching achievements were awarded one fish too late."},
			{"fixed", "Treasure Hunter XP", "The treasure hunter activity awarded the wrong amount of experience points."},
			{"fixed", "Oil Delivery Vehicle Check", "In the oil delivery activity, deliveries could be submitted without a vehicle."},
			{"fixed", "Oil Delivery Achievements", "Oil delivery activity achievements were not granted."},
			{"fixed", "Oil Delivery Destroyed Vehicle", "If the vehicle in the oil delivery activity was destroyed, markers and blips were not removed."},
			{"fixed", "Sea Cleaner Money", "Money in the sea cleaner activity is no longer awarded with decimal points."},
			{"fixed", "Sea Cleaner Destroyed Vehicle", "If the vehicle in the sea cleaner activity was destroyed, the activity was not canceled."},
			{"fixed", "Sea Cleaner Achievements", "The calculation for achievements in the sea cleaner activity was incorrect."},
			{"fixed", "Sea Cleaner Pickup Text", "The text for the sea cleaner activity pickup was sometimes not displayed."},
			{"fixed", "Mining Daily Weekly Tasks", "Daily and weekly tasks in the mining activity were not functioning."},
			{"fixed", "Mining Double Money", "Double bonus money in the mining activity was awarded incorrectly."},
			{"fixed", "Metal Detector Freeze", "When searching a spot with the metal detector, players were not frozen and could run away."},
			{"fixed", "Metal Detector Pickup", "The pickup at the Kellet door for the metal detector was created twice."},
			{"changed", "Lumberjack Trees", "Trees in the lumberjack activity can now only be cut if the activity is active."},
			{"changed", "Street Cleaner Counting", "Street cleaner activity achievements are now awarded more slowly and trash is now counted correctly."},

			{"fixed", "Lootable Vehicle Timers", "Timers for lootable vehicles continued running when a player disconnected."},
			{"fixed", "Lootable Vehicle Rarity", "The rarity tier of lootable vehicles was not correctly considered when rewards were granted."},
			{"fixed", "Trash Can Search Cancel", "Cancelling a trash can search left the player frozen and the animation did not stop."},
			{"fixed", "Lootable Buildings", "Lootable buildings sometimes caused issues due to an incorrectly set ID."},

			{"fixed", "Evidence Room Keycard Drop", "The evidence room keycard did not always drop when a player died or left the server."},
			{"fixed", "Evidence Room Keycard Pickup", "The evidence room keycard could not be picked up after it had been dropped once."},
			{"fixed", "Casino Heist Timers", "Some timers during the casino heist did not function correctly."},
			{"fixed", "Bigfoot Achievements", "Bigfoot kill achievements were not being awarded."},
			{"fixed", "Bigfoot Cave Cleanup", "The Bigfoot cave was not properly destroyed when leaving."},
			{"fixed", "Bigfoot Prison Head Count", "The number of Bigfoot heads in the Bigfoot prison was not displayed correctly."},
			{"fixed", "Bigfoot Prison GUI", "The Bigfoot prison GUI showed 50 heads required instead of 5."},
			{"fixed", "Bigfoot Club XP Display", "Experience points in the Bigfoot Club are no longer displayed with decimal points."},

			{"fixed", "Weekly Task Completion", "Weekly tasks sometimes did not complete and just kept counting."},
			{"fixed", "Weekly Vault and Oil Tasks", "The 15 casino vaults and 10 oil deliveries weekly tasks were completed after just a single vault or delivery."},
			{"fixed", "Camera Query", "An issue when querying cameras has been fixed."},
			{"fixed", "Area Gate Explosion", "The gate to the area card gate could under certain circumstances not be blown up."},
			{"fixed", "Area Gate Bindkey", "The bindkey for blowing up the area card gate was not removed when the player died."},
			{"fixed", "Area Gate Dynamite", "Dynamite at the area card gate could be placed multiple times."},
			{"fixed", "Blowable Garage Vehicles", "Vehicles in blowable garages remained indestructible after the explosion."},
			{"fixed", "Camera Quest Code Marker", "The code marker in the camera quest was not deleted on reset and could be created twice."},
			{"changed", "Camera Quest Code Marker", "The code marker in the camera quest is no longer destroyed when a player picks up the code, since it is not guaranteed that they also open the door."},
			{"changed", "Camera Interaction", "Cameras can now only be clicked when standing directly in front of them."},
			{"fixed", "Prison Quest Gates", "The gates in the prison quest did not work correctly after the first reset."},
			{"changed", "Prison Quest Markers", "The markers in the prison quest are now slightly visible."},
			{"fixed", "Prison Quest Dynamite", "When blowing up prison quest gates, dynamite was not removed from the inventory."},

			{"fixed", "Survivor Pass Pickup Text", "The text for the pickup of the Survivor Pass subscription sometimes did not appear."},
			{"fixed", "Vehicle Quest Respawn", "Vehicles from vehicle quests did not respawn if destroyed with a player inside who died. Vehicle quest vehicles now always respawn 15 seconds after being destroyed."},
			{"fixed", "Vehicle Quest Turn-in Blip", "The blip for vehicle quest turn-in was not removed when exiting the vehicle."},
			{"changed", "Side Activity NPCs", "NPCs from side activities now all spawn immediately instead of at 1-hour intervals."},
			{"changed", "Side Quest Proximity", "Side quests from NPCs can now only be accepted when in immediate proximity to them."},
			{"changed", "Crate Reward Claim", "To claim a reward from a crate, players previously could click anywhere. Now it only works via the designated button."},
			{"fixed", "Infobox Animation", "Infoboxes sometimes had an animation bug."},
			{"fixed", "Diving Oxygen Limit", "Oxygen while diving can no longer exceed the maximum limit or drop below 0."},
			{"fixed", "Inventory Shakes", "Shakes could not be used via the inventory. This has been fixed."},
			{"changed", "Item Saving", "Items are now saved more efficiently."},
			{"fixed", "Dillimore Hope Keys", "The Dillimore Hope Zone 11 keys had the wrong name in the inventory. This has been corrected."},
			{"fixed", "Inventory Object Linking", "Objects in the inventory were incorrectly linked to the outfit section."},
			{"fixed", "Database Syntax Errors", "Several syntax errors in database functions have been resolved."},
			{"fixed", "Hunger and Thirst Bars", "The hunger and thirst bars were sometimes displayed incorrectly."},
			{"fixed", "Scoreboard Team Rank", "Team rank in the scoreboard was displayed in the wrong position."},
			{"fixed", "Nametag Health", "Health in the nametag was displayed incorrectly."},
			{"fixed", "Document Achievements", "Document achievements were granted one document too early."},
			{"changed", "Achievement Languages", "The achievement system now supports the language system and is available in Russian and Portuguese."},
			{"fixed", "Prestige Items", "Prestige items no longer generated experience points."},
			{"fixed", "Status Check", "The check for whether a player has a status always returned true."},
			{"fixed", "Status Saving", "Statuses that were earned were not being saved."},
		},
	},
	{
		version = "v.1.0.5",
		update = "UPDATE #38",
		date = "1 February 2026",
		subtitle = "Survivor Pass, Cemetery and Boss Fight Update",
		entries = {
			{"added", "Survivor Pass Subscription", "Players who own the Survivor Pass can now purchase a subscription to enter zones even without the required Survivor Pass level. Costs $1500 once and $750 every payday."},
			{"added", "Diving Suit Rental", "A diving suit can now be rented at the Yacht Harbor Pier and allows certain quests without owning a personal diving suit."},
			{"added", "Bonus Points", "Additional collectible bonus points added to Zones 21, 22, 23 and 24."},
			{"added", "Sewer Entrances", "Sewer entrances added in Las Venturas."},
			{"added", "Los Santos Bank", "The Los Santos bank can now be entered. Money can be stored there and automatically used to pay bills."},
			{"added", "Los Santos Cemetery", "The Los Santos cemetery is now a safe zone and discoverable location."},
			{"added", "Grave Looting", "Graves in the Las Venturas desert can now be looted to obtain bones required for cemetery rituals."},
			{"added", "Garden Shop", "A garden shop has been added at the cemetery where players can purchase gardening tools and fertilizer."},
			{"added", "Gravedigger Activity", "A new gravedigger activity has been added where players maintain graves and water flowers for experience points."},
			{"added", "Treasure Maps", "Treasure maps can now be opened and show areas where hidden keys can be found."},
			{"added", "Location Message", "A message is now displayed when entering a location."},
			{"changed", "Spinosaurus Boss Fight", "The Spinosaurus fight has been redesigned with collectible dynamite, new mechanics and sound effects."},
			{"added", "Bigfoot Sounds", "Sound effects have been added to the Bigfoot boss fight."},
			{"added", "Rebirth Kit", "New item added: Rebirth Kit. Allows players to respawn at the location of death."},

			{"fixed", "Registration Errors", "Missing error feedback during registration with invalid input has been fixed."},
			{"fixed", "Yacht Harbor NPC", "The information NPC at the Yacht Harbor Pier no longer changes position incorrectly."},
			{"fixed", "Weekly Zombie Challenge", "The weekly zombie challenge was not being evaluated correctly."},
			{"fixed", "Diving Blood Screen", "The blood screen no longer appears while diving."},
			{"fixed", "Decorative NPC Skins", "Decorative NPCs can no longer use the Bigfoot skin."},
			{"fixed", "Bigfoot Minigun", "The Minigun can no longer be collected before defeating Bigfoot."},
			{"fixed", "Generators", "Some generators that could not be interacted with have been fixed."},
			{"changed", "Smoking Movement", "Players can now move while smoking."},
			{"fixed", "Daily and Weekly Tasks", "Various daily and weekly tasks that were not working correctly have been fixed."},
			{"fixed", "Shell Shop Limit", "The shell shop daily limit has been fixed to 200 instead of 199."},
			{"fixed", "Gym Stats", "Gym stats were displayed behind the progress bar."},
			{"fixed", "Sprint Progress", "Sprint level progress is now saved correctly."},
			{"fixed", "Oil Delivery Quest", "The oil delivery quest can now be started properly."},
			{"fixed", "Side Quest Rewards", "Side quests where NPCs marked objects on the map now reward the player correctly."},
			{"fixed", "Armor and Health Login", "Armor and health are now restored correctly on login."},
			{"fixed", "Spinosaurus Photo", "The Spinosaurus photo can now be viewed."},

			{"changed", "Sprint Display", "Sprint level is no longer displayed while the F11 map is open."},
			{"added", "Valentine Event", "The Valentine’s Day event has been activated and runs until February 23."},
		}
	},
	{
		version = "v.1.0.4",
		update = "UPDATE #37",
		date = "15 November 2025",
		subtitle = "Race Arena and Inventory Fixes",
		entries = {
			{"fixed", "Inventory Chips", "Fixed an issue where chips in the inventory could not be clicked."},
			{"changed", "Race Level Bar", "The level bar is now hidden during an active race."},
			{"added", "Race Arena Safezone", "The Race Arena in San Fierro is now a discoverable location and safe zone."},
			{"fixed", "Progress Bar Cleanup", "The progress bar is now hidden correctly when cancelling airdrop looting or trash searches."},
		}
	},
	{
		version = "v.1.0.3",
		update = "UPDATE #36",
		date = "19 October 2025",
		subtitle = "Zombie Challenge and Exploration Update",
		entries = {
			{"fixed", "Free Spin Message", "Fixed an issue where the wrong message was displayed when claiming a free spin."},
			{"changed", "Respawn Delay", "Added a short respawn delay after death."},
			{"added", "Zombie Challenge Counter", "During active Zombie Challenges, the number of zombies already killed is now briefly displayed."},
			{"changed", "Metal Detector Quest", "The number of crowbars required for the Metal Detector quest has been reduced to 50."},
			{"fixed", "Classic Hot Dog Description", "Fixed an incorrect description for the Classic Hot Dog in the Hot Dog window."},
			{"changed", "Quest Giver Blips", "Quest givers now use orange person blips while regular characters use purple person blips."},
			{"added", "Fast Travel", "Three new fast travel destinations have been added."},
			{"fixed", "Zone 1 Radio Tower", "Fixed missing radio tower object in Zone 1."},
			{"fixed", "Lootable Vehicle Markers", "Markers for lootable vehicles are now hidden after towing."},
			{"changed", "Zombie Window Combat", "Zombies no longer attack players while a window is open."},
			{"added", "Safe Zone Generators", "Generators can now be found in all safe zones."},
			{"fixed", "Dillimore Storage Room", "The missing map objects in the storage room of Dillimore's Hope have been restored."},
			{"added", "Daily Weapon Bonus", "You can now claim a daily weapon bonus in the Dillimore's Hope base."},
			{"added", "Blueberry Shake Shop", "A shake shop can now also be found in Blueberry."},
		}
	},
	{
		version = "v.1.0.2",
		update = "UPDATE #35",
		date = "12 October 2025",
		subtitle = "Radio Towers and Zombie Challenges",
		entries = {
			{"changed", "Blip Visibility", "The visibility range for blips has been increased from 50 to 250 meters."},
			{"added", "Post-Apocalyptic World Quest", "A new quest has been added where players must visit all 24 radio towers."},
			{"added", "Radio Tower Info", "An info text is now displayed above the radio tower keypads indicating that they are clickable."},
			{"added", "Mini Zombie Challenge", "Every 30 minutes, all online players receive a zombie challenge to kill at least 200 zombies within 10 minutes."},
			{"fixed", "Lootable House Death Bug", "Players can no longer leave lootable houses after dying inside them."},
			{"fixed", "Dumpster Cooldown", "Dumpsters can now be searched again after the cooldown expired."},
			{"added", "Safe Explosion Message", "You now receive a message after blowing up a safe in lootable houses."},
			{"added", "Loot Completion Message", "You now receive a message when you have looted everything in a lootable house."},
			{"added", "Character Images", "Missing character images have been added."},
			{"added", "Blueberry Discovery", "Blueberry is now a discoverable location."},
			{"added", "Standard Quest", "A new standard quest has been added."},
		}
	},
	{
		version = "v.1.0.1",
		update = "UPDATE #34",
		date = "8 October 2025",
		subtitle = "Halloween, Radio and Mini-Race Update",
		entries = {
			{"changed", "Halloween Login Screen", "The Halloween logo variant is now displayed during the Halloween season."},
			{"fixed", "Duplicate Quest Vehicles", "Fixed a bug where stolen vehicles for quests would sometimes spawn twice."},
			{"fixed", "Indoor Campfires", "Campfires now work indoors."},
			{"fixed", "Infected Survivors", "Fixed an issue where infected survivors spawned multiple times in the same location."},
			{"added", "Weekly Online Rewards", "Players now receive rewards after script restarts if enough weekly playtime was accumulated."},
			{"added", "Weekly Dillimore Rewards", "Three weekly rewards can now be collected in the Dillimore's Hope base."},
			{"fixed", "Ask for Help Function", "The ask for help function now correctly updates the interacted character ID."},
			{"fixed", "Radio Tower Blips", "Radio tower blips are now correctly added after asking Dr. Brain for help."},
			{"fixed", "Quest NPC Blips", "Quest NPC blips are now correctly added after speaking with Ricky Jey."},
			{"changed", "Radio Cost", "The cost of the radio has been reduced to $5000."},
			{"changed", "Vehicle Survivor Message", "The survivor spotted message now only appears once when entering a vehicle."},
			{"added", "NPC Names", "All character NPCs now have names."},
			{"changed", "Window Chat", "The chat is now hidden when any window is open."},
			{"fixed", "Safe Zone Visibility", "Safe zones are no longer displayed before being unlocked."},
			{"added", "Radio Requirement Message", "Players now receive a message when trying to use a radio tower without owning a radio."},
			{"fixed", "Character Dialogues", "Fixed an issue where some characters had no dialogue."},
			{"changed", "Treasure Hunter Quest", "The number of treasures required for the Treasure Hunter quest has been reduced to 25."},
			{"fixed", "Nearby Zombie Count", "Nearby zombie count now updates immediately after purchasing a radio."},
			{"added", "Tutorial Pickups", "Two additional tutorial pickups have been added."},
			{"changed", "Christopher Brown Dialogue", "Christopher Brown now explains how safes work."},
			{"changed", "Vehicle Name Display", "Vehicle names are no longer displayed when entering a vehicle."},
			{"added", "Lootable House Interiors", "Two additional interiors for lootable houses have been added."},
			{"added", "Bonus Points", "40 new bonus points have been added."},
			{"fixed", "Tutorial Markers", "Fixed broken markers during the tutorial."},
			{"fixed", "Halloween Window", "Players can no longer click through the Halloween window."},
			{"fixed", "Safe UI", "Safes in lootable houses no longer open the Safe UI incorrectly."},
			{"fixed", "Info Message Colors", "Fixed incorrect color code display in some info messages."},
			{"changed", "Medkits", "Medkits can now be used."},
			{"changed", "Survivor Pass", "The Survivor Pass can now be requested again."},
			{"added", "Mini Races", "Mini-races can now be found throughout San Andreas."},
			{"added", "Doctor NPC", "A doctor can now be found in the Dillimore base."},
			{"fixed", "Dillimore Spawn", "Players now correctly receive the Dillimore Safezone spawn point."},
			{"changed", "Character Positions", "Players now receive the positions of all characters in the zone after visiting the radio tower."},
			{"changed", "Low Playtime Payday", "Players with less than 5 hours now receive 2 dynamite at payday."},
			{"added", "Towable Vehicles", "Towable vehicles have been placed around the towing activity area."},
			{"fixed", "Angel Pine Objects", "Missing map objects in Angel Pine have been restored."},
		},
	},
	{
		version = "v.1.0.0",
		update = "UPDATE #33",
		date = "3 October 2025",
		subtitle = "Release Update and Stability Improvements",
		entries = {
			{"changed", "Version 1.0.0", "San Andreas Apocalypse has officially reached version 1.0.0. All planned core systems have now been implemented."},
			{"changed", "Beta Status", "The project remains in beta to ensure bugs and overlooked issues can still be identified and fixed."},
			{"fixed", "General Bug Fixes", "Several bugs have been fixed and unfinished systems have been completed."},
			{"changed", "Feedback System", "Players can now submit bug reports, suggestions and feedback through the Discord server."},
		}
	},
	{
		version = "v.0.9.9Z4",
		update = "UPDATE #32",
		date = "1 October 2025",
		subtitle = "Halloween Event and Colony Update",
		entries = {
			{"added", "Halloween Event", "The Halloween event has been expanded with many new systems and is now active."},
			{"fixed", "Sprint Skill Exploit", "Fixed an exploit where sprint progress could be gained while standing still."},
			{"changed", "Elite Team Base Radio", "If you own the documents Diary of a Survivor 2 to 4, the Elite Team Base location is now transmitted to your radio."},
			{"changed", "Safe Zone Farming", "Seeds can no longer be planted inside safe zones."},
			{"added", "Colony Achievements", "Achievements for colony activities have been added."},
		}
	},
	{
		version = "v.0.9.9Z3",
		update = "UPDATE #31",
		date = "20 September 2025",
		subtitle = "Activities, Reputation and Crafting Expansion",
		entries = {
			{"added", "Job Activity Bonus", "Every 2 hours there is now a chance to activate a Job Activity Bonus with double rewards."},
			{"added", "Evacuation Driver Skill", "A new skill improves survivor spawn speed and rewards during vehicle missions."},
			{"added", "Reputation Level", "A new Reputation Level system has been added with XP bonuses based on zombie kills."},
			{"added", "Infected Survivor Bonus", "An hourly infected survivor bonus event can now activate automatically."},
			{"added", "Cooked Fish", "Caught fish can now be cooked at campfires and restore health."},
			{"added", "Achievements and Trophies", "Additional achievements and trophies have been added."},
			{"added", "Armor Recipes", "Crafting recipes for iron and gold armor can now be purchased."},
			{"added", "House of Achievements", "The House of Achievements location is now unlocked through the Survivor Pass."},
			{"added", "Oil Delivery Quest", "A new Oil Delivery main quest has been added."},
			{"added", "Vehicle Dismantling", "A new Vehicle Dismantling main quest has been added."},
			{"added", "Barber Shop", "The Barber Shop in Dillimore can now be entered for hairstyles."},
			{"added", "Tattoo Shop", "A Tattoo Shop has been added."},
			{"added", "Double Skillpoint Coupon", "A coupon for double skill points can now be purchased."},
			{"added", "Clothing Factory", "A clothing factory has been added in Las Venturas."},
			{"added", "Weapon Factory", "Weapon parts can now be crafted into ammunition."},
			{"added", "Motels", "Motels have been added and can be used as spawn points."},
			{"added", "Elite Team Base Access", "Players owning the required survivor diaries now gain access to the Elite Team Base."},

			{"changed", "Airdrop System", "Maximum concurrent airdrops increased and rewards improved."},
			{"changed", "Treasure Hunting", "Treasure hunting rewards and navigation have been improved."},
			{"changed", "Road Sweeper Activity", "Road sweeper vehicles now respawn automatically and quest requirements were reduced."},
			{"changed", "Oil Delivery Rewards", "Oil Delivery payouts now depend on distance."},
			{"changed", "Loot System", "Additional items can now appear in various activities."},
			{"changed", "Skill Menu UI", "The skill menu UI has been redesigned."},
			{"changed", "Achievement Rewards", "Achievement requirements and rewards have been adjusted."},
			{"changed", "Fishing Rewards", "Fish selling payouts are now dynamically updated daily."},
			{"changed", "Fishing System", "Fishing now supports a No Bait option and bait-specific fish behavior."},
			{"changed", "Quest Vehicles", "Stolen quest vehicles now spawn more frequently."},
			{"changed", "Loot Box Cooldown", "A cooldown has been added between opening loot boxes."},

			{"fixed", "Weekly Zombie Challenge", "The weekly zombie challenge now resets correctly every Sunday."},
			{"fixed", "Dinosaur Caves", "Dinosaur caves now close correctly."},
			{"fixed", "Lumberjack Activity", "The Lumberjack activity has been fixed and improved."},
			{"fixed", "Special Engine Quest", "Radio data for the special engine quest is now awarded correctly."},
			{"fixed", "Molotov Inventory Usage", "Molotovs can now be used directly via inventory."},
			{"fixed", "Offline XP", "Offline XP gain can now properly trigger level-ups."},

			{"added", "Additional Content", "More achievements, trophies and documents have been added."},
			{"changed", "Reward Balancing", "Experience points, money and rewards across multiple systems have been adjusted."},
			{"changed", "Updated Texts", "Various system texts have been updated."},
			{"fixed", "Minor Bug Fixes", "Various minor bug fixes and quality-of-life improvements have been implemented."},
		}
	},
	{
		version = "v.0.9.9Z2.3",
		update = "UPDATE #30",
		date = "7 September 2025",
		subtitle = "Gym, Tents and Daily Reward Update",
		entries = {
			{"changed", "Prestige Item Selling", "Prestige items can now be sold again for money and brain mass."},
			{"added", "San Fierro Chinatown Quest", "A new quest has been added in Chinatown requiring food and drinks."},
			{"added", "Bonus Point Shop", "A shop for spending collectible bonus points has been added in Dillimore."},
			{"added", "Tents", "Tents can now be placed and used as spawn points."},
			{"added", "Los Santos Gym", "The Los Santos Gym is now accessible with workout systems."},
			{"added", "Bike Rental", "A bike rental system has been added in Dillimore."},
			{"changed", "Documents", "Documents can now be collected again."},
			{"changed", "Tutorial Sprint Display", "Sprint level is no longer displayed during the tutorial."},
			{"changed", "Survivor Pass Upgrade I", "Requirements for Survivor Pass Upgrade I have been adjusted."},
			{"fixed", "Double Money Coupon", "The Double Money Coupon now works correctly."},
			{"fixed", "Decoration NPC Skins", "Decoration NPCs no longer use unintended skins."},
			{"added", "Pickup Descriptions", "Some pickups now include descriptions."},
			{"fixed", "Server Safes", "Server safes are now functional again."},
			{"fixed", "Rusty Chainsaws", "Rusty chainsaws can now be collected again."},
			{"fixed", "Quest Blips", "Missing quest blips have been added."},
			{"changed", "Zombie Nest Radio Data", "Radio data for zombie nests is now awarded during the related quest."},
			{"changed", "Towable Loot Vehicles", "Lootable vehicles can now be towed."},
			{"added", "Daily Rewards", "Daily rewards have been added."},
			{"added", "Purchasable Tasks", "Daily and weekly tasks can now be purchased."},
		}
	},
	{
		version = "v.0.9.9Z2.2",
		update = "UPDATE #29",
		date = "17 August 2025",
		subtitle = "Moon, Survivor Pass II and Side Mission Update",
		entries = {
			{"added", "Survivor Pass Upgrade II", "The second Survivor Pass upgrade has been added and unlocks Zone 19."},
			{"added", "Moon", "Players can now travel to the Moon after completing the rocket questline."},
			{"added", "Shakes", "A new shake shop with various drinks and effects has been added."},
			{"added", "Weekly Zombie Competition", "A weekly zombie kill competition has been added."},
			{"added", "Side Missions", "Random NPC side missions have been added."},
			{"added", "Spinosaurus Boss Fight", "The Spinosaurus boss fight can now be unlocked and completed."},
			{"added", "Fishing Shop", "A fishing shop has been added at the Yacht Harbor Pier."},

			{"fixed", "Survivor Pass Requirement", "Survivor Pass Upgrade I now correctly requires 2500 zombie kills."},
			{"fixed", "Task Scrolling", "Daily and weekly tasks can now be scrolled correctly."},
			{"fixed", "Dead Parking", "Players can no longer be parked dead."},
			{"fixed", "Desert Fishing Shop", "Objects blocking the desert fishing shop have been removed."},

			{"changed", "Standard Quests", "Standard quests can now be repeated unlimited times."},
			{"changed", "Help Menu Texts", "Texts in the help menu have been updated."},
			{"changed", "Movement Actions", "Players can now move while smoking, eating and drinking."},
		}
	},
	{
		version = "v.0.9.9Z2.1",
		update = "UPDATE #28",
		date = "27 July 2025",
		subtitle = "Fishing, Colonies and Achievement Expansion",
		entries = {
			{"added", "Documents and Achievements", "New documents, achievements and tasks have been added."},
			{"added", "Zombie Movement Styles", "New zombie movement styles have been added."},
			{"added", "Storage Crates", "Storage crates can now be purchased and placed."},
			{"added", "Bigfoot Club XP", "The Bigfoot now generates experience points for club members."},
			{"added", "Tank Rockets", "Abandoned tanks can now contain rockets."},
			{"added", "Sharks", "Sharks can now be found near Santa Maria Beach."},
			{"added", "Fishing System", "Fishing has been added with multiple fish types and bait mechanics."},
			{"changed", "Shooter Arena", "The shooter arena is now fenced in."},
			{"added", "Weapon Transport Activity", "A new group activity for transporting weapons has been added."},
			{"added", "Craftable Armor", "Armor can now be crafted from iron and gold bars."},
			{"added", "Searchable Vehicles and Trash", "Additional searchable vehicles and trash bins have been added."},
			{"added", "Metal Detector", "A metal detector can now be found and used to search for treasures."},
			{"added", "Syringe Crafting Items", "New syringe crafting materials have been added."},
			{"added", "Vehicle Crates", "Vehicle crates can now be opened and reclaimed."},
			{"added", "Area 51 Questline", "Dr. Brain’s photo can now be used to unlock Area 51 content."},
			{"added", "Area 51 Lab", "Area 51 now contains a zombie laboratory for colonies."},
			{"added", "Trash Compactor", "Colonies can now use trash compactors."},
			{"added", "Friendship System", "A friendship system with login notifications and XP bonuses has been added."},
			{"added", "Personal Menu", "A new personal menu has been added under /me."},
			{"added", "Hall of Achievements", "The Hall of Achievements has been added."},
			{"added", "Colony Warehouses", "Colonies can now buy warehouses."},
			{"changed", "Rocket Launcher Rewards", "Rocket launchers now grant money per zombie kill."},
			{"added", "Bayside Discovery", "Bayside is now a discoverable location."},
			{"changed", "Leaderboard", "The leaderboard now tracks NPCs gifted."},
			{"added", "Lootable House Safes", "Lootable houses can now contain safes."},
			{"changed", "Item Values", "All items now have XP and money values."},
			{"added", "Underground Garages", "Underground garages have been added."},
			{"added", "Oil Delivery Activity", "A new Oil Delivery activity has been added."},
			{"added", "Crafting Materials", "Many new crafting materials and items have been added."},
			{"added", "Earthquake Boss Caves", "Earthquakes can now open cave entrances leading to boss fights."},

			{"fixed", "15 Minute Info Message", "The info message displayed every 15 minutes now works correctly."},
			{"fixed", "Server Payday Display", "The server payday now correctly displays zombie kills."},
			{"fixed", "Vehicle Mileage", "Vehicle mileage is now displayed without decimal points."},
			{"fixed", "Trunk Key Message", "The trunk key requirement message is now shown correctly."},
			{"fixed", "Bigfoot Cave", "The Bigfoot cave can now be entered again."},
			{"fixed", "Police Badge Animation", "Picking up a police badge now triggers the correct animation."},
			{"fixed", "Bandage Quest", "The bandage quest can now be completed."},
			{"fixed", "Quest Texts", "Incorrect quest texts have been corrected."},
			{"fixed", "Activity Descriptions", "Some activity descriptions were displayed incorrectly."},
			{"fixed", "Trash Respawn Marker", "The red marker on respawned trash is no longer visible."},
			{"fixed", "Decorative Peds", "Decorative peds are now seated correctly."},
			{"fixed", "Dynamite Recipe Quest", "The Dynamite Recipe quest can now be completed."},
			{"fixed", "Crafting Recipes UI", "Crafting recipes are now displayed correctly under F2."},
			{"fixed", "Police and Firefighter Loot", "Police hats and firefighter helmets now spawn in the correct locations."},
			{"fixed", "Vehicle Dealer Images", "Missing vehicle dealer images have been added."},
			{"fixed", "Safe Keys", "Safe keys now work correctly for all safe sizes."},
			{"fixed", "Weapon Dealers", "Weapon dealers now work correctly."},
			{"fixed", "Red Zone Bonus XP", "Bonus XP in the red zone is now properly awarded."},
			{"fixed", "Sprint Login Progress", "Sprint progress is now displayed correctly after login."},
			{"fixed", "Vehicle Sprint Reset", "Sprint stamina now resets correctly inside vehicles."},
			{"fixed", "Trash Bin Markers", "Trash bin markers now display the correct color."},
			{"fixed", "Snake Farm", "The Snake Farm prestige object can now be purchased."},
			{"fixed", "Bike Shop Images", "All bikes in the bike shop now display images."},
			{"fixed", "Mechanic Skill Fuel Usage", "Mechanic skill level 2 now correctly reduces fuel usage."},
			{"fixed", "Info Box Line Breaks", "Long texts in the info box now display line breaks correctly."},
			{"fixed", "Double Money Coupons", "Double money coupons can now be activated again."},
			{"fixed", "Safe Key Counter", "The number of safe keys is now displayed correctly."},

			{"changed", "Special Engine Costs", "The cost of special engines has been adjusted."},
			{"changed", "Tuning Costs", "The cost of tuning parts has been adjusted."},
			{"changed", "Bayside Safe Zone", "The safe zone in Bayside has been expanded."},
		}
	},
	{
		version = "v.0.9.9Z1",
		update = "UPDATE #27",
		date = "19 May 2025",
		subtitle = "Mechanic Skill, Junkyard and Bigfoot Club Update",
		entries = {
			{"added", "Money Display", "Received money is now displayed similarly to experience points."},
			{"added", "Snake Farm", "A new prestige object has been added: Snake Farm."},
			{"added", "Explodable Garages", "Explodable garages with vehicles have been added."},
			{"added", "Mechanic Skill", "The mechanic skill now allows vehicle repairs and reduced fuel usage."},
			{"added", "Achievements", "145 new achievements have been added."},
			{"added", "Water Dispensers", "Placeable water dispensers can now be purchased from level 25."},
			{"added", "Airdrop Bonus", "Each hour there is now a chance for additional airdrops to spawn."},
			{"added", "Airdrop Crates", "Airdrops can now contain item or tool crates."},
			{"added", "Daily and Weekly Tasks", "5 new daily and weekly tasks have been added."},
			{"added", "Airdrop Spawn Points", "More possible airdrop spawn points have been added."},
			{"added", "Destroyable Tanks", "Additional destroyable tanks have been added."},
			{"added", "Saved Statistics", "Torn-off boards, Ocean Cleaner trash and collected airdrops are now saved."},
			{"added", "Apocalyptic Junkyard", "A new quest has been added in Palomino Creek."},
			{"added", "Sweeper Reward", "After collecting 1000 trash pieces, players receive a Sweeper."},
			{"added", "Vehicle Mission Markers", "All vehicle mission locations now have survivor drop-off markers."},
			{"added", "Rusty Chainsaw", "A new collectible item has been added: Rusty Chainsaw."},
			{"added", "Lumberjack Quest", "A new quest lets players unlock the Lumberjack activity."},
			{"added", "Colony Transport Activity", "Colonies can now transport goods for money and experience."},
			{"added", "Zombie Skins", "More zombie skins have been added."},
			{"added", "Zombie Throat Bite", "Zombies can now attack from behind and instantly kill players."},
			{"added", "Nearby Zombie Counter", "Players with a radio now see nearby zombie count."},
			{"added", "Vehicle Dealers", "Vehicle dealers now offer more vehicles."},
			{"added", "Dealer Location NPCs", "New NPCs can reveal vehicle dealer locations for money."},
			{"added", "Bigfoot Club Interiors", "Bigfoot Club now includes new interiors and Bigfoot Prison."},
			{"added", "Job Descriptions", "Starting a job activity now shows a description."},
			{"added", "Zone 24 Map", "Zone 24 has been mapped."},

			{"changed", "Respawn Time", "Respawn time after death is now 120 seconds and can be reduced with skills."},
			{"changed", "Airdrop Timing", "Airdrops are now generated every 5 minutes."},
			{"changed", "Rhino Spawns", "Rhinos now spawn at all available positions first, then refill over time."},
			{"changed", "Task Colors", "Daily tasks now use colors for completed, active and inactive states."},
			{"changed", "Vehicle Trunk Access", "Only the vehicle owner can remove items from the trunk."},
			{"fixed", "Market Stands", "Market stands now work properly."},
			{"fixed", "AFK Death Freeze", "Players no longer lose freeze state after dying in AFK mode."},
			{"fixed", "Oven", "The oven now works."},
		}
	},
	{
		version = "v.0.9.9Y",
		update = "UPDATE #26",
		date = "4 May 2025",
		subtitle = "Ocean Cleaner, Bigfoot Club and Prestige Update",
		entries = {
			{"added", "Ocean Cleaner", "A new Ocean Cleaner activity has been added at LS Docks from level 50."},
			{"added", "Bigfoot Photo", "Killing Bigfoot now grants a photo used to enter the Bigfoot Club."},
			{"added", "Bigfoot Club", "The Bigfoot Club location becomes available after completing the Bigfoot quest."},
			{"added", "Achievement", "One additional achievement has been added."},
			{"added", "Prestige Objects", "Mount Chiliad and UFO Bar prestige objects have been added."},
			{"added", "Colony Zombie Stats", "Zombie kills as colony member now count toward colony statistics."},
			{"added", "Colony Level Progress", "Colony management now shows level progress and unlocks."},
			{"added", "Airplane Graveyard Base", "The Las Venturas airplane graveyard is now discoverable and zombie-protected."},
			{"changed", "Billy Miller Drinks", "Drinks from Billy Miller now also restore a small amount of hunger."},
			{"added", "Character Overview", "F2 now shows characters already met."},
			{"added", "Mechanic Safe Zone", "The mechanic activity is now discoverable and a safe zone."},
			{"changed", "Towing XP", "Towing vehicles now rewards 100 XP."},
			{"changed", "Hot Dog Effects", "Hot Dogs now provide hunger-prevention effects."},
			{"added", "Teleport Marker Names", "Teleport markers now show which interior they lead to."},
			{"added", "Lab Overview", "F7 now shows all colony labs and benefits."},
			{"added", "Item Weight", "Items now have weight shown in the inventory."},
			{"added", "Animals", "Wolves and goats have been added."},
			{"changed", "Minigun Reward", "Killing zombies with a Minigun now gives $20."},
			{"added", "Vehicle Reposition Info", "Players now receive an info box when repositioning vehicles."},
			{"added", "Bonus Zones", "Every hour a random zone becomes a bonus XP zone."},

			{"changed", "AFK UI", "AFK mode info is now hidden when another interface is open."},
			{"changed", "Earthquake Chance", "The chance of earthquakes has been reduced."},
			{"changed", "Campfire Healing", "Campfires now only heal up to 50 HP."},
			{"changed", "Document UI", "The F2 document UI has been improved."},
			{"removed", "Zone 7 Radio Tower", "The non-functional radio tower in Zone 7 has been removed."},
			{"changed", "Prestige Income", "Prestige object money and XP generation has been reduced and capped."},
			{"changed", "Colony Shelter Limit", "Colonies can now only have one shelter."},
			{"changed", "Airplane Graveyard Map", "The Las Venturas airplane graveyard map has been reworked."},
			{"changed", "Activity Text Duration", "Activity info texts are now displayed longer."},
			{"changed", "Flag Blip", "The colony flag blip is now only visible nearby."},
			{"changed", "Parked Vehicles", "Parked vehicles only spawn after the player logs in."},

			{"fixed", "AFK Vehicle Freeze", "Player vehicles are now frozen when entering AFK mode."},
			{"fixed", "Level Unlock Display", "Unlocked systems after leveling up are now displayed correctly."},
			{"fixed", "Map Origin Blips", "Two faulty blips at the map origin have been removed."},
			{"fixed", "Zombie Killstreaks", "Zombies damaging other zombies no longer break killstreaks."},
			{"fixed", "Safe Zone Visibility", "Safe zones are no longer shown before discovery."},
			{"fixed", "Pay N Spray", "Pay 'N Sprays are usable again."},
			{"fixed", "Money Truck Bags", "Money bags can now be taken near shelters."},
			{"fixed", "Vehicle Garages", "Vehicles now spawn at the correct garage."},
			{"fixed", "Gas Stations", "Gas stations can now be used for refueling."},
			{"fixed", "Vehicle Kilometers", "Vehicle kilometers are now tracked and saved correctly."},
			{"fixed", "Duplicate XP Coupons", "Duplicate XP coupon issues have been fixed."},
			{"fixed", "Billy Miller Text", "Incorrect text at Billy Miller's Bar has been fixed."},
			{"fixed", "Prestige Purchase", "Prestige objects can now be purchased."},
			{"fixed", "Tow Marker", "The tow activity marker is no longer blocked."},
			{"fixed", "Hot Dog Purchase", "Hot Dogs can now be bought."},
			{"fixed", "Zone 13 Garage Marker", "The garage marker in Zone 13 is no longer stuck in the ground."},
			{"fixed", "Money Truck Rewards", "Submitting money bags now grants rewards."},
			{"fixed", "Incorrect Texts", "Various incorrect texts have been fixed."},
		}
	},
	{
		version = "v.0.9.9X",
		update = "UPDATE #25",
		date = "27 April 2025",
		subtitle = "Skills, Area 51 and Street Sweeper Update",
		entries = {
			{"changed", "Weapon Skill Window", "The weapon skill training window now clearly shows unlocks per class."},
			{"fixed", "Weapon Skill Activation", "Weapon skills now activate without reconnecting."},
			{"fixed", "Minigun Ammo", "Minigun ammunition is now deducted correctly."},
			{"fixed", "Sprint System", "The sprint level system now functions as intended."},
			{"removed", "Weather Types", "Fog and Sandstorm weather types have been removed."},
			{"added", "Earthquakes", "Earthquakes can now occur and influence gameplay."},
			{"fixed", "Weapon Boxes", "Weapon boxes can now be purchased."},
			{"added", "Black Board", "Players can now buy and customize a Black Board object in Zone 1."},
			{"changed", "Fisher Shop Help", "Fisher shop NPCs now provide locations when asked for help."},
			{"added", "New Items", "Meat, Leather and Trash have been added."},
			{"added", "Animals", "Cows have been added and can drop Meat and Leather."},
			{"added", "Achievements", "23 new achievements have been added."},
			{"added", "Tasks", "One new daily and one new weekly task have been added."},
			{"fixed", "Radio Locations", "Some locations can now be selected correctly using the radio."},
			{"added", "Area 51 Map", "Area 51 has been mapped."},
			{"changed", "Campfire Healing", "Campfire healing now works per campfire with its own cooldown."},
			{"changed", "Medic Skill", "Medic skill benefits have been updated across all levels."},
			{"fixed", "Lootable Vehicles", "Lootable vehicles no longer float in the air."},
			{"changed", "Task UI", "Daily and weekly task UI is hidden during Payday."},
			{"added", "Street Sweeper Trash", "Trash can now be collected using a street sweeper vehicle and sold."},
			{"added", "Los Santos Prison", "The prison in Los Santos can now be entered."},
			{"added", "Discoverable Locations", "More discoverable locations have been added."},
			{"changed", "Safe Zone Map", "Safe zones now only appear after discovering the location."},
			{"added", "Zone 3 Map", "Zone 3 has been mapped."},
			{"fixed", "Free Spin Time", "Incorrect free spin time display has been fixed."},
			{"fixed", "Bigfoot Minigun", "The Minigun from the Bigfoot quest can now be collected."},
			{"fixed", "Fast Travel", "Fast travel is functional again."},
			{"fixed", "Fuel Usage", "Fuel can now be used."},
			{"added", "Crate Opening", "Item, tool and SAA Coin crates can now be opened through inventory."},
			{"added", "Leaderboards", "New leaderboard categories for plants, trees and animals have been added."},
			{"changed", "Survivor Pass Upgrade", "The first Survivor Pass upgrade now requires any 5 quests."},
			{"fixed", "Plant Growth", "Plant growth time now works correctly."},
			{"changed", "Area 51 Requirement", "Entering Zone 19 now requires Survivor Pass Upgrade II."},
			{"changed", "Animal Combat", "Animals can no longer be killed from inside vehicles."},
			{"fixed", "Bigfoot Quest", "The Bigfoot quest can now be completed."},
			{"fixed", "Shooting Range Info", "Incorrect Shooting Range information has been corrected."},
			{"added", "Vehicle Shooter Arena", "A Vehicle Shooter Arena has been added at LS stadium."},
			{"added", "Zones 12 and 16", "Zones 12 and 16 have been mapped."},
			{"added", "Placeable Safes", "Safes can now be purchased as placeable objects."},
			{"added", "Cactus Farming", "Cacti can now be planted."},
			{"added", "Race Arena Blip", "The Race Arena now has a map blip."},
			{"fixed", "Building Exit", "A bug preventing players from leaving a building has been fixed."},
			{"fixed", "General Fixes", "Various other bug fixes, text adjustments and improvements have been implemented."},
		}
	},
	{
		version = "v.0.9.9W",
		update = "UPDATE #24",
		date = "20 April 2025",
		subtitle = "Mining, Lumberjack and Sprint System Update",
		entries = {
			{"added", "Achievements", "13 new achievements have been added."},
			{"added", "Fishing Shop Items", "Fishing shops now offer bait, hooks and fishing nets."},
			{"changed", "Mining Activity", "The Cave Explorer activity now includes iron and gold ore with a new mini-game."},
			{"added", "Lumberjack Activity", "A new Lumberjack activity has been added in Zone 1."},
			{"added", "Furnace", "Zone 1 now includes a furnace for smelting ores into bars."},
			{"added", "Sprint Level System", "A sprint level system has been introduced."},
			{"added", "Zone 1 Content", "Infected survivors, collectibles, lootable houses and zombie nests have been added to Zone 1."},
			{"changed", "Wheel of Fortune", "Wheel rewards now update after spinning and require confirmation."},
			{"added", "Zone 1 Garages", "Lootable garages are now available in Zone 1."},
			{"changed", "Saved Statistics", "Destroyed garages and mining completions are now saved."},
			{"fixed", "Zone Access", "Zones that couldn't be entered have been fixed."},
			{"fixed", "Task Counting", "Daily tasks now count correctly."},
			{"fixed", "Trash Bins", "Broken searchable trash bins have been fixed."},
			{"fixed", "Minor Issues", "Various other minor issues have been resolved."},
		}
	},
	{
		version = "v.0.9.9V",
		update = "UPDATE #23",
		date = "13 April 2025",
		subtitle = "Loot Activity and Garage Improvements",
		entries = {
			{"changed", "Supply Package Rewards", "Supply packages now also grant XP and skill points."},
			{"changed", "Supply Package Cancel", "Searching supply packages can now be cancelled with E."},
			{"changed", "Tank Limit", "The number of destructible tanks is now limited to 15."},
			{"changed", "Lootable Vehicles", "Lootable vehicles now use rarity tiers and improved item displays."},
			{"changed", "Vehicle Loot Cancel", "Looting vehicles can now be cancelled with E."},
			{"fixed", "Trash Bin Interaction", "Trash bins can no longer be clicked through windows."},
			{"changed", "Trash Search Cancel", "Searching trash bins can now be cancelled with E."},
			{"changed", "Prison Keycards", "Police station prison keycards can now only be found once per interior."},
			{"fixed", "Lootable Building Teleport", "Players are now correctly teleported into interiors after opening doors."},
			{"changed", "Garage Rewards", "Blowing up searchable garages now grants XP and skill points."},
			{"changed", "Garage Looting", "Each player can now search garages once."},
			{"added", "More Tasks", "Additional daily and weekly tasks have been added."},
			{"changed", "Task Amount", "Players now receive 5 daily and weekly tasks."},
			{"changed", "Loot Tables", "More items can now be found during loot activities."},
		}
	},
	{
		version = "v.0.9.9U",
		update = "UPDATE #22",
		date = "6 April 2025",
		subtitle = "Radio Towers, Treasure Hunter and Colony Update",
		entries = {
			{"changed", "Dr. Brain", "Dr. Brain now also offers syringe crafting recipes."},
			{"changed", "Radio Towers", "Radio towers now use interactive keypads and unlock all locations in a zone."},
			{"added", "Treasure Hunter Quest", "Henry Walton now grants access to the Treasure Hunter quest."},
			{"changed", "Radio Tower Help", "Dr. Brain can now reveal all radio tower locations."},
			{"changed", "Party XP", "Party members now receive shared XP from nearby zombie kills."},
			{"changed", "Treasure Hunter Requirement", "Players now need level 25 to start the Treasure Hunter activity."},
			{"added", "Rank Unlock Info", "Unlocked systems are now shown upon reaching a new rank."},
			{"changed", "Quest Help", "Survivor Pass NPCs can now reveal quest giver locations."},
			{"changed", "Bench XP", "Players now gain XP while sitting on benches in Dillimore's Hope."},
			{"changed", "Race Arena", "The Race Arena received a visual update and a new track."},
			{"added", "Money Transport Activity", "A new colony activity involving money transporters has been added."},
			{"added", "Gun Shop Blips", "Gun shops now appear on the map."},
			{"added", "Daily and Weekly Tasks", "Daily and weekly tasks have been added with automatic resets."},
		}
	},
	{
		version = "v.0.9.9T",
		update = "UPDATE #21",
		date = "30 March 2025",
		subtitle = "Colony and Zone System Rework",
		entries = {
			{"changed", "Colony Menu", "The colony menu has been completely redesigned."},
			{"added", "Member List", "Colonies now show member ranks, warnings, join dates and online status."},
			{"added", "Colony Ranks", "Leaders can now assign ranks and warnings."},
			{"changed", "Zone System", "The map is now divided into 24 zones."},
			{"added", "Laboratory Wars", "Colonies can now fight over laboratories."},
			{"added", "Weekly Playtime", "Weekly playtime is now saved and resets every Sunday."},
			{"added", "Vehicle Trunks", "Vehicles now have trunks."},
			{"added", "Developer Rank", "The Developer team rank has been added."},
			{"added", "Colony Levels", "Colonies now gain levels and unlock player and vehicle slots."},
		}
	},
	{
		version = "v.0.9.9S",
		update = "UPDATE #20",
		date = "23 March 2025",
		subtitle = "Party System and Storage Room Update",
		entries = {
			{"added", "Party System", "Players can now create temporary parties in Dillimore's Hope."},
			{"changed", "Party XP", "Party members now gain shared XP from nearby zombie kills."},
			{"added", "Party UI", "Party members are displayed on the screen and map."},
			{"changed", "Party Management", "Parties can now be managed through F7."},
			{"added", "Storage Rooms", "Storage rooms can now be found, blown up and looted."},
			{"added", "Collectibles", "Packages, horseshoes, tiki statues and GTA III logos have been added."},
			{"changed", "Server Restart", "The server now restarts every 24 hours with advance warnings."},
			{"added", "Shooting Range", "The shooting range is now fully functional."},
			{"changed", "Weapon Skills", "Weapon skills can now be unlocked through shooting practice."},
			{"fixed", "General Improvements", "Various adjustments, bug fixes and future preparations have been implemented."},
		}
	},
	{
		version = "v.0.9.9R",
		update = "UPDATE #19",
		date = "15 March 2025",
		subtitle = "Bigfoot, Diving and Safe Zone Update",
		entries = {
			{"changed", "HUD and Radar", "HUD and radar are now hidden during cinematic windows."},
			{"changed", "Weather System", "Indoor-breaking weather types were removed and weather now changes hourly."},
			{"changed", "Zombie Spawn Rate", "Fewer zombies now spawn in zones."},
			{"fixed", "Weapon Switching", "Players can now switch weapons correctly after dying."},
			{"changed", "Safe Zone Blips", "Small safe zones are no longer displayed on the map."},
			{"added", "Weapon Boxes", "All visible safe zones now contain weapon boxes."},
			{"changed", "Object Placement", "Objects can no longer be placed in safe zones."},
			{"added", "Fishing Shop Safe Zone", "The Los Santos fishing shop is now a safe zone and discoverable location."},
			{"added", "Explodable Vending Machines", "Snack and drink machines can now be blown up for rewards."},
			{"added", "Bigfoot Questline", "The prison inmate quest and new Bigfoot-related quests have been completed."},
			{"added", "Bears", "Bears can now be found around Mount Chiliad and drop bear pelts."},
			{"fixed", "Inventory Scrolling", "Inventory scrolling now works correctly after dying."},
			{"changed", "Weapon Ammo", "Buying weapons now adds ammo instead of duplicate weapons."},
			{"fixed", "Ammo Saving", "Weapon ammunition is now saved correctly."},
			{"added", "Diving Suit System", "Diving suits can now be equipped and use oxygen bottles."},
			{"changed", "Treasure Hunting", "Treasure hunting now rewards seashells."},
		}
	},
	{
		version = "v.0.9.9Q",
		update = "UPDATE #18",
		date = "9 March 2025",
		subtitle = "Fishing, Diving and Treasure Hunting Update",
		entries = {
			{"added", "Fishing Shops", "New fishing shops with unique inventories have been added."},
			{"added", "Treasure Maps", "Two more treasure maps have been added to fishing shops."},
			{"added", "Diving Equipment", "Fishing shops now offer diving equipment parts."},
			{"added", "Diving Suit Recipe", "Players now receive the diving suit recipe after buying diving gear."},
			{"added", "Treasure Hunter Activity", "A new treasure hunter activity has been implemented in Los Santos."},
			{"added", "Treasure Reward", "Finding 100 treasures now rewards a Marquis boat."},
			{"changed", "Leaderboard", "Leaderboards now also display the player's own position."},
			{"changed", "Harvest Rewards", "Harvesting hemp and trees now grants 25 XP."},
			{"changed", "Campfires", "Placed campfires are now saved and can heal players every 5 minutes."},
			{"added", "Weapon Boxes", "Weapon boxes can now be purchased from level 10."},
			{"changed", "Crafting Menu", "Crafting recipes now display all required items and support scrolling."},
			{"added", "Achievements", "More achievements have been added."},
			{"changed", "Leaderboard Stats", "Planted seeds and harvested plants are now saved and tracked."},
			{"added", "Crafting Recipe Viewer", "Crafting recipe combinations can now be viewed under F2."},
		}
	},
	{
		version = "v.0.9.9P",
		update = "UPDATE #17",
		date = "2 March 2025",
		subtitle = "Radio, Shelter and Vehicle Expert Update",
		entries = {
			{"changed", "Weapon Dealers", "Weapons now require weapon parts in addition to money."},
			{"changed", "Economy Balancing", "Various prices and Survivor Pass requirements have been adjusted."},
			{"changed", "Tuning Parts", "Tuning parts now cost both money and vehicle parts."},
			{"changed", "Radio Towers", "Radio towers now require a radio device and use floppy disk pickups."},
			{"changed", "Gas Pumps", "Gas pumps now have a fuel limit and refill hourly."},
			{"changed", "Fish Shop Help", "Fish shop characters now reveal all fish shop locations."},
			{"added", "Shelters", "More purchasable shelters have been added."},
			{"changed", "Colony Shelters", "Shelters can now become colony shelters."},
			{"added", "Snack Machines", "Snack and drink vending machines were added to Zones 2, 3 and 4."},
			{"added", "Hungry NPC Task", "A new mini-task involving hungry NPCs has been added."},
			{"added", "Vehicle Expert Skill", "A new skill increases maximum vehicle slots."},
			{"fixed", "Crafting Recipes", "Crafting recipes under F2 are now displayed correctly."},
			{"added", "Newsbox System", "Every 15 minutes a newsbox grants bonus XP to all players."},
			{"changed", "Leaderboards", "Leaderboards can now be viewed in all zones."},
			{"added", "Zone 4 Garage", "A new garage has been added to the Zone 4 safe zone."},
			{"fixed", "Shelter Spawn Reset", "Shelter spawn points can now be reset correctly."},
			{"changed", "Team Spawn", "Team members can now set their spawn to the current position."},
			{"changed", "Safe Storage", "A maximum of $50,000 can now be stored in safes."},
			{"added", "Achievements", "More achievements have been added."},
			{"fixed", "Fast Travel", "Fast travel is now working again."},
		}
	},
	{
		version = "v.0.9.9O",
		update = "UPDATE #16",
		date = "23 February 2025",
		subtitle = "Quest Series, Firefighters and Inventory Update",
		entries = {
			{"added", "Inventory Categories", "Inventory items can now be categorized."},
			{"added", "New Drinks", "More thirst-quenching drinks have been added."},
			{"fixed", "Fire Station Document", "The document inside the fire station can now be collected."},
			{"changed", "Safe Zones", "Explorable locations with shops are now safe zones."},
			{"changed", "Quest Rewards", "Quests now also grant Brain Mass and Skill Points."},
			{"added", "Quest Series", "Quest series can now be viewed under F4."},
			{"added", "Firefighter Missions", "Fire station fire truck rescue missions have been added."},
			{"added", "Zombie Sounds", "Zombies now produce sounds."},
			{"fixed", "Player Interaction Menu", "The interaction menu can no longer be opened on yourself."},
			{"added", "New Locations", "Three new explorable locations have been added."},
			{"fixed", "General Fixes", "Various adjustments and bug fixes have been implemented."},
		}
	},
	{
		version = "v.0.9.9N",
		update = "UPDATE #15",
		date = "16 February 2025",
		subtitle = "Radio, Valentine Event and Casino Update",
		entries = {
			{"fixed", "Zone Exit Warning", "The Survivor Pass exit warning now works correctly."},
			{"added", "Zone Name Display", "Zone names are now displayed when entering areas."},
			{"fixed", "Valentine Event", "The Valentine event window can now be closed and pralines count correctly."},
			{"changed", "Map Blips", "House, building and shelter blips are now hidden by default."},
			{"changed", "Help Icons", "Help icons can now only be clicked nearby."},
			{"changed", "House Search Message", "House search messages are now only displayed once."},
			{"changed", "Radio Requirement", "The map and radar now require a radio."},
			{"added", "New Interiors", "Additional gun shop and strip club interiors have been added."},
			{"added", "Tutorial Pickups", "New tutorial pickups for water dispensers and snack machines were added."},
			{"added", "Achievements", "Two new achievements have been added."},
			{"fixed", "Decorative NPC XP", "Decorative NPCs now correctly grant XP."},
			{"changed", "Skill Requirement", "Skills can now only be upgraded from level 25."},
			{"changed", "Character Tips", "Players now need level 5 to ask characters for tips."},
			{"changed", "Quest Requirement", "Players now need level 10 to receive standard quests."},
			{"changed", "Key Shop", "Keys can no longer be purchased twice and prices were adjusted."},
			{"added", "Decorative Peds", "Additional decorative peds have been added."},
			{"added", "Safe Key NPC", "Zone 2 now contains an NPC giving safe keys every 12 hours."},
			{"fixed", "Pay N Spray Camera", "Vehicles are now visible correctly in Pay N Spray garages."},
			{"added", "Heavy Weapon Shop", "A new rocket launcher and flamethrower shop has been added."},
			{"changed", "Favorite Character Reset", "Favorite characters can now be reset by double-clicking."},
			{"changed", "Dropped Crate Blips", "Dropped crate blips now require a radio to appear."},
			{"changed", "Valentine Info", "Valentine event information now appears only once."},
			{"added", "Player Interaction Menu", "Clicking players now opens a player interaction menu."},
			{"added", "Las Venturas Casinos", "Casinos in Las Venturas can now be entered and looted."},
			{"fixed", "Character Creation Names", "Players are now warned if a character name is already taken."},
			{"fixed", "General Improvements", "Further bug fixes, adjustments and quality-of-life changes were implemented."},
		}
	},
	{
		version = "v.0.9.9M",
		update = "UPDATE #14",
		date = "9 February 2025",
		subtitle = "Prison Cells, Farming and Supply Crates Update",
		entries = {
			{"added", "Police Station Cells", "Players can now find prison cell keys inside police stations."},
			{"added", "Prison Baton Reward", "Killing infected prisoners now grants a baton."},
			{"fixed", "Zone Requirement", "Players can no longer bypass zone requirements."},
			{"added", "Dillimore Prison Quest", "The Dillimore prison cells can now be blown up and contain a new quest NPC."},
			{"added", "Searchable Objects", "More searchable clickable world objects have been added."},
			{"added", "House Loot Bonus", "Players now receive XP bonuses for fully looting buildings."},
			{"added", "Questlines", "Item-delivery questlines with three stages are now available under F3."},
			{"added", "Water Dispensers", "Water dispensers have been added and can be used for drinking."},
			{"fixed", "Vehicle Shops", "Broken vehicle shops have been fixed."},
			{"added", "Planting System", "Players can now plant apple trees, orange trees and weed."},
			{"added", "Character Tips", "Characters can now provide tips during conversations."},
			{"added", "Vehicle Dealers", "Randomly generated vehicle dealers now appear across San Andreas."},
			{"added", "Junkyard Activity", "A junkyard and the Vehicle Recovery quest have been added."},
			{"added", "Decorative Campfires", "Decorative campfires have been placed around the world."},
			{"added", "Unlock Notifications", "Players now see unlock information when leveling up."},
			{"added", "Decorative NPCs", "Additional decorative NPCs have been added."},
			{"added", "Loot Streaks", "Loot streaks now reward players with skill points."},
			{"added", "Supply Crates", "Supply crates now fall from the sky and are marked on the map."},
			{"added", "Evidence Rooms", "Police stations now feature evidence rooms with rare loot."},
			{"changed", "Fast Travel", "Fast travel now costs brain mass and includes Pirate Island."},
			{"added", "Crafting Documents", "New documents unlock crafting recipes for handcuffs and fire extinguishers."},
			{"added", "Discoverable Locations", "Discoverable locations have been added and can be viewed under F2."},
			{"added", "Mining Cave", "A mining cave with stones and diamonds has been added."},
			{"added", "New Quests", "The quests Mission: Moon Flight and Fire Against Steel have been added."},
			{"added", "Soldier Safe Zone", "A new soldier faction safe zone has been added in the desert."},
			{"added", "Explodable Tanks", "Random tanks can now be destroyed with Molotovs and flamethrowers."},
			{"changed", "Safe Zone Generator", "The generator in Dillimore now refills automatically."},
			{"changed", "Inventory Scroll", "The inventory can now be scrolled."},
			{"added", "Brains and Hordes Quest", "Players now receive the Brains and Hordes quest at level 10."},
		}
	},
	{
		version = "v.0.9.9L",
		update = "UPDATE #13",
		date = "2 February 2025",
		subtitle = "Vehicles, Diving and Fast Travel Expansion",
		entries = {
			{"changed", "Loot Rarity", "Loot items are now divided into three rarity categories."},
			{"added", "Zone 4 Generator", "Zone 4 now appears on the map and includes a generator."},
			{"fixed", "Generator Progress", "Generator progress bars now display correctly."},
			{"fixed", "Quest Zombies", "Quest zombies are now visible to all players."},
			{"added", "Searchable Vehicles", "More searchable vehicle types have been added."},
			{"added", "Fast Travel Zone 4", "Fast travel to Zone 4 is now possible."},
			{"added", "Purchasable Garages", "Players can now purchase garages and open them with /mg."},
			{"changed", "World Expansion", "The map has been expanded with thousands of new objects."},
			{"added", "Fabric Factory Quest", "A new Fabric Factory questline has been added."},
			{"added", "Tattoo Studio Quest", "A Tattoo Studio questline has been added."},
			{"added", "Hair Salon Quest", "A Hair Salon questline has been added."},
			{"added", "Dynamite Recipe Quest", "Destroying zombie nests now unlocks the dynamite recipe."},
			{"added", "Tuning Expert Quest", "Killing infected survivors now unlocks tuning garages."},
			{"added", "Gas Stations", "Vehicles can now be refueled at gas stations."},
			{"added", "Crafting Recipe Viewer", "Crafting recipes can now be viewed under F2."},
			{"changed", "Infected Survivor Rewards", "Infected survivors now drop money instead of items."},
			{"added", "Colony Objects", "Colonies can now purchase placeable base objects."},
			{"added", "Toll Stations", "Toll stations have been added."},
			{"added", "Weapon Expert Skill", "The Weapon Expert skill has been added."},
			{"changed", "Vehicle Mileage", "Vehicle kilometers are now saved and shown on the speedometer."},
			{"changed", "Vehicle Coloring", "Changing vehicle colors now costs spray cans."},
			{"added", "Chips", "Zombies now have a chance to drop chips."},
			{"added", "Diving Gear", "Diving goggles, fins and oxygen have been added."},
			{"added", "Fisherman's Shop", "A fisherman’s shop with a diving suit quest has been added."},
			{"added", "Seashells", "Players can now collect seashells near water."},
			{"changed", "Race Arena Rewards", "Race rewards and player counts are now displayed correctly."},
			{"added", "Hotring Racers", "Players can now buy Hotring Racer vehicles."},
			{"fixed", "Performance Bug", "A major performance issue has been fixed."},
			{"changed", "House Zombies", "Zombie spawn rates inside houses have been adjusted."},
			{"changed", "Weapon Inventory Limit", "The weapon inventory limit is now 40."},
			{"changed", "XP Balancing", "Quest and activity XP rewards have been adjusted."},
			{"changed", "Fast Travel Levels", "Fast travel now unlocks progressively with higher levels."},
			{"added", "Fast Travel NPCs", "Fast travel NPCs are now stationed at all helicopters."},
			{"fixed", "Fast Travel Exit", "Players now automatically exit vehicles after fast travel."},
			{"added", "Lucky Wheel Rewards", "New Lucky Wheel rewards have been added."},
			{"added", "Lucky Wheels", "Lucky Wheels are now available in all zones."},
			{"added", "Spawn Protection", "Vehicles now have collision immunity after spawning."},
			{"added", "Shelters", "25 new purchasable shelters have been added."},
			{"added", "Bonus Codes", "Bonus codes can now be redeemed under F5."},
			{"changed", "Blip Legend", "Lootable house and building blips can now be toggled."},
			{"added", "Vehicle Shops", "Additional vehicle and weapon shops have been added."},
			{"changed", "Economy", "Vehicle and weapon prices have been adjusted."},
			{"added", "New Items", "New boxes, tools, engines and vehicle items have been added."},
			{"added", "Zone 2 Safes", "Players can now open safes in Zone 2 with keys."},
			{"added", "Bonus Code ANEWHOPE", "The ANEWHOPE bonus code has been added."},
		}
	},
	{
		version = "v.0.9.9K",
		update = "UPDATE #12",
		date = "26 January 2025",
		subtitle = "Race Arena and Firefighter Update",
		entries = {
			{"added", "Tattoo Radio Tower", "A new radio tower for tattoo studio locations has been added."},
			{"added", "New Quests", "New quests for firefighter helmets and bandages have been added."},
			{"added", "Crafting Recipes", "New crafting recipes for fire extinguishers and medkits are now available."},
			{"added", "Police Vehicle Missions", "Police vehicles now start survivor rescue missions."},
			{"fixed", "Hunger and Thirst", "Hunger and thirst are now deducted correctly."},
			{"fixed", "Pay N Spray", "Broken Pay N Spray gates have been fixed."},
			{"added", "Race Arenas", "Race arenas have been added in all major cities."},
			{"fixed", "Inventory Display", "Headwear and outfits now display correctly in the inventory."},
			{"changed", "Info Box", "Copying YT or Discord links now displays an info box."},
			{"changed", "Weapon Boxes", "Weapon boxes have been updated for the new weapon system."},
			{"added", "Spray Can", "The spray can item has been added."},
			{"changed", "Campfires", "Campfires are now destroyed after 5 minutes."},
			{"fixed", "General Fixes", "Various small fixes and adjustments were implemented."},
		}
	},
	{
		version = "v.0.9.9J",
		update = "UPDATE #11",
		date = "19 January 2025",
		subtitle = "Weapon Ammo and Lootable Interior Update",
		entries = {
			{"added", "Water Bottles and Chips", "Water bottles and chips can now be purchased from vending machines."},
			{"added", "Hot Dogs", "Hot dogs can now be purchased from hot dog stands."},
			{"changed", "Dropped Weapons", "Weapons dropped by dead players can now be picked up."},
			{"changed", "Ammo Usage", "Ammo is now deducted when shooting."},
			{"changed", "Shooting Range", "The shooting range has been moved to Zone 1."},
			{"added", "Ammo Items", "Ammo for multiple weapon classes has been added."},
			{"changed", "Campfire Healing", "Campfires now heal nearby players."},
			{"changed", "Vehicle Spawn", "Vehicles now spawn at their parking locations after restart."},
			{"fixed", "Radio", "The radio is now functional again."},
			{"changed", "Fuel System", "Vehicles now consume fuel."},
			{"added", "Radio Towers", "New radio towers for many shop types have been added."},
			{"added", "Vehicle Interaction Menu", "Vehicles now feature an interaction menu."},
			{"added", "Airplane Shops", "Players can now purchase airplanes at four locations."},
			{"changed", "Clickable Interiors", "Non-clickable objects inside interiors were replaced."},
			{"added", "Lootable Shops", "Many new lootable shop interiors have been added."},
			{"fixed", "HUD Ammo", "The HUD ammo display now works correctly."},
			{"fixed", "Dumpster Placement", "A misplaced dumpster in Zone 1 was removed."},
			{"added", "Shelters", "Purchasable shelters have been added."},
			{"fixed", "Command M", "The /m command now works correctly again."},
		}
	},
	{
		version = "v.0.9.9I",
		update = "UPDATE #10",
		date = "15 December 2024",
		subtitle = "Vehicles, Prestige Objects and Molotov Update",
		entries = {
			{"changed", "Character Gifts", "Characters can now receive gifts separately every four hours."},
			{"added", "Second Newcomer Questline", "Players can now complete the second newcomer questline."},
			{"changed", "Skill Point Rewards", "Activities now grant skill points."},
			{"changed", "Vehicle Shops", "Vehicle selections in Zones 1 and 2 have been expanded."},
			{"added", "Zone 4 Vehicle Shop", "A new vehicle shop has been added in Zone 4."},
			{"changed", "Vehicle Prices", "Vehicle prices have been adjusted."},
			{"added", "Vehicle Tuning", "Vehicles can now be tuned in workshops using vehicle parts."},
			{"added", "Engine Upgrades", "Garages now offer engine upgrades up to 150% speed."},
			{"changed", "Bayside Shop", "The Bayside vehicle shop now only sells the Dinghy."},
			{"added", "Zombie House Rush", "Breaking into houses can now trigger zombie ambushes."},
			{"added", "Character Dialogues", "Characters can now occasionally display dialogues."},
			{"added", "More Loot Objects", "More dumpsters, vehicles and houses were added to Zones 1, 2 and 3."},
			{"fixed", "Zone 1 Baton", "The trash bin blocking the baton has been removed."},
			{"added", "Zone 3 Church", "Zone 3 now includes a church."},
			{"changed", "Lootable Houses", "Lootable houses can now contain zombies."},
			{"added", "Bottle Item", "A new scavenging item called Bottle has been added."},
			{"added", "Molotov Crafting", "Players can now craft Molotovs."},
			{"added", "Zone 4", "A new Zone 4 near the San Fierro train station has been added."},
			{"changed", "Lootable Vehicles", "Lootable vehicles now use random vehicle models."},
			{"changed", "PvP Zones", "Los Santos and Las Venturas are now PvP danger zones."},
			{"changed", "Fall Damage", "Fall damage has returned."},
			{"added", "Hit Sounds", "Hitting another player now triggers a hit sound."},
			{"added", "Red Dot Sight", "Players can now toggle a red dot sight using /reddot."},
			{"added", "Decorative NPCs", "More decorative NPCs have been added to multiple zones."},
			{"added", "Prestige Objects", "Prestige objects generating XP and money have been added."},
			{"added", "Bloodscreen", "A bloodscreen effect has been added."},
		}
	},
	{
		version = "v.0.9.9H",
		update = "UPDATE #9",
		date = "8 December 2024",
		subtitle = "Crafting, Hunger and Nest Update",
		entries = {
			{"changed", "Zone 1 Mapping", "Zone 1 has been expanded."},
			{"changed", "Blip Legend", "Blips now only appear after discovering locations."},
			{"fixed", "Documents", "Document collection now works correctly."},
			{"changed", "Megaphone", "Using the megaphone now consumes one megaphone item."},
			{"added", "Hunger and Thirst", "Players now lose hunger and thirst over time."},
			{"changed", "Bandage Animation", "Using bandages now triggers an animation."},
			{"added", "Heavy Weapon Dealers", "New dealers now sell heavy weapons."},
			{"changed", "Weapons in Inventory", "Weapons are now stored directly in the inventory."},
			{"added", "Crafting Menu", "A crafting menu is now accessible through the inventory."},
			{"added", "Campfire Crafting", "Players can now craft and place campfires."},
			{"changed", "Leaderboard Money", "Leaderboard money now combines carried and stored cash."},
			{"added", "Zombie Nests", "Zombie nests can now be destroyed with dynamite."},
			{"changed", "XP Display", "Experience gain is now visually displayed above players."},
			{"changed", "Ambulance Missions", "Ambulance survivors now spawn within 1000 meters."},
			{"changed", "Reward Balancing", "XP and money rewards for activities have been rebalanced."},
		}
	},
	{
		version = "v.0.9.9G",
		update = "UPDATE #8",
		date = "1 December 2024",
		subtitle = "Boarded Houses and Fast Travel Update",
		entries = {
			{"added", "Wooden Boards", "Players must now remove boards before entering buildings."},
			{"changed", "Running Style", "The player running style has been changed."},
			{"fixed", "Ammunation Loot", "Ammunation stores now correctly give weapon parts."},
			{"changed", "Search Animations", "Building search animations now depend on object position."},
			{"changed", "Main Quest Display", "Main quests are now displayed under F4."},
			{"added", "Zone Numbers", "Holding TAB while viewing the map now shows zone numbers."},
			{"changed", "Dr. Brain", "Dr. Brain now gives syringes for collecting infected samples."},
			{"changed", "Nearby Blips", "Searchable building blips now only appear nearby."},
			{"added", "Colony Member Blips", "Colony members are now shown on the map."},
			{"added", "Fast Travel Helicopters", "Fast travel helicopters are now available in protection zones."},
			{"changed", "Loot Chance", "The chance of finding loot in houses has been increased."},
			{"changed", "Vehicle Loot", "More items can now be found in vehicles."},
			{"changed", "Loot XP", "Players now gain XP even when no loot is found."},
			{"changed", "Loot Display", "Looted items are now displayed more clearly."},
			{"added", "Christmas Gifts", "Christmas gifts can now be found while looting or killing zombies."},
			{"changed", "Snow Shader", "A snow shader has been activated for the Christmas season."},
		}
	},
	{
		version = "v.0.9.9F",
		update = "UPDATE #7",
		date = "24 November 2024",
		subtitle = "Hospitals, Hunger and Ambulance Update",
		entries = {
			{"added", "Hospital Radio Towers", "New radio towers for hospitals and weapon shops have been added."},
			{"added", "Lootable Hospitals", "Hospitals and weapon shops are now searchable."},
			{"added", "Bandages", "Bandages can now be found and used for healing."},
			{"added", "Hunger and Thirst System", "Hunger and thirst mechanics have been introduced."},
			{"added", "Ambulance Missions", "Ambulance rescue missions are now available."},
			{"changed", "Leaderboard", "The leaderboard has been redesigned with new categories."},
			{"added", "Information Pickups", "New information pickups help new players."},
			{"added", "New Zones", "Two additional zones have been added."},
			{"changed", "Help Markers", "Uncollected help menu items are now highlighted green."},
			{"added", "Pay N Spray", "Vehicles can now be repainted at Pay N Spray locations."},
			{"added", "Hot Dog Stand", "Hot dog stands have been added."},
			{"added", "Snack Machines", "Drink and snack vending machines are now usable."},
			{"added", "Standard Quest", "Another standard quest has been added."},
			{"fixed", "Shop Texts", "Shop texts now display correctly at lower resolutions."},
			{"changed", "Quest Vehicles", "Quest vehicle delivery points are now marked with flags."},
			{"changed", "Gift Dialogues", "Giving gifts to characters now opens a dialogue box."},
			{"changed", "Tutorial Protection", "Players are now immune to zombies during the tutorial."},
			{"added", "Pay N Spray Quest", "A new Pay N Spray quest and spawn point were added."},
			{"added", "Pizza Scooter Quest", "A new pizza delivery scooter quest has been added."},
			{"added", "Server Payday", "An hourly server payday system has been added."},
		}
	},
	{
		version = "v.0.9.9E",
		update = "UPDATE #6",
		date = "18 November 2024",
		subtitle = "Infected Survivors and Looting Update",
		entries = {
			{"added", "More Infected Survivors", "Zone 1 now contains 43 infected survivors."},
			{"changed", "Infected Tracking", "Infected kills are now tracked and infected respawn after 10 minutes."},
			{"added", "Achievements", "13 new infected-related achievements have been added."},
			{"changed", "Infected Labels", "Infected survivors now display text labels."},
			{"changed", "Dumpster Markers", "Searched dumpsters now show red markers."},
			{"added", "Progress Bars", "Searching now displays progress bars."},
			{"changed", "Search Animations", "Dumpster and item searching now trigger animations."},
			{"changed", "Search Rewards", "Players now gain XP and money even without finding loot."},
			{"changed", "Vehicle Markers", "Searchable vehicles now use red and white markers."},
			{"added", "Vehicle Loot Preview", "The next loot item is now previewed while searching vehicles."},
			{"added", "Vehicle Loot Records", "Players can now set loot click records."},
			{"changed", "Radar Visibility", "The radar is hidden while looting vehicles."},
			{"changed", "Vehicle Exit", "Players now automatically exit vehicles after looting."},
			{"changed", "Quest Names", "Quests now have proper names."},
			{"fixed", "Headshot Streaks", "Headshot streaks now reset correctly."},
			{"changed", "SAN News Unlock", "The SAN News location is now rewarded correctly."},
			{"changed", "Building Search Display", "Buildings now show searchable object counts."},
			{"added", "Photo Viewer", "Found photos can now be viewed under F2."},
			{"changed", "Radio Tower Rewards", "The first radio tower now unlocks all gas station locations."},
			{"changed", "Blip Legend", "The blip legend has been expanded."},
			{"added", "Lootable Gas Stations", "Gas stations can now be searched for wrenches."},
			{"fixed", "Outfits", "Farmer and leather mask outfits can now be removed again."},
			{"changed", "Inventory Display", "Numbers are no longer shown for keys and outfits."},
			{"added", "Backroom Quest", "A new quest has been added to the Dillimore storeroom backrooms."},
			{"added", "Second Beginner Tasks", "A second set of beginner tasks has been added."},
			{"changed", "Character Gifts", "Players can now give gifts with the P key during dialogues."},
		}
	},
	{
		version = "v.0.9.9D2",
		update = "UPDATE #5",
		date = "13 November 2024",
		subtitle = "Radio, Infected Survivors and Gas Station Update",
		entries = {
			{"fixed", "Key Shop", "Keys in the shop can no longer be purchased twice."},
			{"added", "Language Settings", "The language can now be changed via F5."},
			{"added", "Gas Station Quest Dialog", "A dialogue now appears when completing the gas station quest."},
			{"fixed", "Gas Station Exit", "The gas station can now be exited again."},
			{"added", "Gas Station Back Rooms", "The back rooms of the gas station can now be entered."},
			{"changed", "Radio Inventory Usage", "The radio can now be used through the inventory."},
			{"added", "Radio Coordinates", "Coordinates can now be received and managed via the radio."},
			{"changed", "Cigarette Requirement", "A lighter is now required to smoke a cigarette."},
			{"fixed", "AFK Benches", "Bench animations are no longer interrupted by AFK mode."},
			{"changed", "Zone Exit Damage", "Leaving the zone now causes health loss after 10 seconds."},
			{"added", "Camera Item", "New item added: Camera."},
			{"added", "Infected Survivors", "Infected survivors can now be found across San Andreas."},
			{"added", "Dynamite", "New item added: Dynamite."},
			{"added", "Photo Collectible", "Photos have been added as collectibles."},
			{"added", "Crafting Recipes", "Crafting recipes have been added as collectibles."},
			{"fixed", "Looted Buildings", "Looted buildings are now saved correctly."},
			{"added", "Cameras for Liam", "A new quest has been added: Cameras for Liam."},
			{"added", "Dynamite NPC", "A new NPC in the gas station back rooms now offers dynamite."},
			{"changed", "Radio Level Requirement", "The required level for the radio has been lowered to 15."},
			{"changed", "Blip Legend", "The blip legend has been expanded."},
		}
	},
	{
		version = "v.0.9.9D",
		update = "UPDATE #4",
		date = "10 November 2024",
		subtitle = "Zones, Colonies and Quest System Update",
		entries = {
			{"fixed", "Leaderboard", "The leaderboard now correctly displays the top ten players in each category."},
			{"fixed", "Experience Display", "The correct number of experience points is now shown."},
			{"fixed", "Money Display", "Money is no longer displayed with decimals."},
			{"fixed", "Item Shop Double Purchase", "The double purchase bug in the item shop has been fixed."},
			{"added", "Cigars", "New item added: Cigars."},
			{"added", "Joints", "New item added: Joints."},
			{"changed", "Info Box Timer", "The info box now shows a remaining time bar."},
			{"added", "Zones", "Zones have been added in addition to protection zones."},
			{"added", "Survivor Pass", "The Survivor Pass is now required to enter or leave zones."},
			{"added", "Radio Locations", "The radio now allows locations to be displayed."},
			{"changed", "Inventory Highlighting", "Clickable inventory items are now highlighted."},
			{"changed", "Scoreboard Team Highlight", "Team members are now highlighted in the scoreboard."},
			{"added", "Nametag", "A nametag has been added."},
			{"changed", "Halloween Candy", "Halloween candy can now be eaten and restores health and armor."},
			{"added", "Crazy Joe Farm", "A new protection zone has been added: Crazy Joe's Farm."},
			{"added", "Story Text", "A story text is now shown after character creation and login."},
			{"added", "Tutorial Helpers", "New information and helper markers have been added to the tutorial."},
			{"changed", "Coupons", "Double XP and double money coupons now only apply to zombie kills and headshot streaks."},
			{"added", "Crazy Joe Quest", "A new quest from Crazy Joe has been added."},
			{"changed", "Saved Statistics", "Searched trash cans, vehicles and broken-into houses are now saved."},
			{"added", "Documents", "Survivor Guide #1 and Survivor Guide #2 have been added."},
			{"added", "Key Shop Keys", "New keys have been added to the Key Shop."},
			{"added", "Gas Station Quest", "A new gas station quest with Crecky has been added."},
			{"changed", "Weapon Box Interaction", "Weapon boxes now use E interaction when speaking with John Jones."},
			{"added", "Spawn Point Category", "The spawn point category has been added under F5."},
			{"changed", "House Blips", "Lootable houses now use colored blips depending on their state."},
			{"added", "Lootable Buildings", "Buildings can now be entered and looted."},
			{"added", "Megaphone Command", "The /m command can now be used with a megaphone."},
			{"added", "Achievements", "More achievements have been added."},
			{"added", "Social Links", "Discord and YouTube links can now be copied through an icon."},
			{"added", "Colonies", "Players can now create their own colony."},
			{"changed", "Help Menu Rewards", "Help menu pickups now grant money and XP."},
			{"added", "Quest System", "Quests can now be obtained from characters and managed via F4."},
			{"fixed", "General Improvements", "Various minor adjustments, bug fixes and optimizations were implemented."},
		}
	},
	{
		version = "v.0.9.9C",
		update = "UPDATE #3",
		date = "13 October 2024",
		subtitle = "Vehicles, Outfits and Exploration Update",
		entries = {
			{"added", "Admin Ranks", "Four admin ranks and an F6 admin menu have been added."},
			{"added", "Outfits and Hats", "Outfits and hats can now be obtained through quests and events."},
			{"added", "Compass", "A compass has been added for players with radios."},
			{"added", "Trash Can Search", "Trash cans can now be searched."},
			{"changed", "Weather Cycle", "Weather now changes every 4 hours."},
			{"added", "Ronald Dark Quest", "A new quest with Ronald Dark has been added."},
			{"added", "Vehicle System", "Players can now buy, store and use vehicles."},
			{"added", "More Buildings", "More buildings can now be explored."},
			{"changed", "Character Interaction XP", "Character interactions now grant experience points."},
			{"added", "Toplist", "A new toplist feature has been added."},
			{"added", "Cigarettes", "Cigarettes can now be smoked to restore health."},
			{"added", "Coupons", "Coupons can now be purchased for temporary bonuses."},
			{"added", "Key Shop", "A key shop has been added for unlocking areas and chests."},
			{"fixed", "Quality of Life", "Various quality-of-life changes and bug fixes have been implemented."},
			{"added", "Achievements", "More achievements have been added."},
			{"added", "Document", "A new document has been added."},
			{"added", "Items", "New items have been added."},
			{"changed", "Dillimore Map", "The map in Dillimore has been improved."},
			{"added", "Help Menu Entries", "New help menu entries have been added."},
		}
	},
	{
		version = "v.0.9.9B",
		update = "UPDATE #2",
		date = "21 September 2024",
		subtitle = "Generator, Looting and AFK Update",
		entries = {
			{"fixed", "Security Improvements", "Several vulnerabilities have been patched to improve stability."},
			{"added", "AFK Mode", "Players are now automatically placed in AFK mode after 5 minutes."},
			{"added", "Scoreboard Details", "Hovering over a player's name now displays detailed information."},
			{"changed", "Payday Rewards", "Players now also receive money and SAA Coins on payday."},
			{"changed", "Payday UI", "Payday is now displayed with a graphical interface."},
			{"added", "NPC Reactions", "NPCs now react to specific player actions."},
			{"added", "New Items", "Oil, Gas Canister, Repair Kit and Crowbar have been added."},
			{"added", "Status Collectible", "Status has been added as a collectible."},
			{"added", "Generator System", "Generators now maintain colony safety zones and require fuel, oil and repairs."},
			{"added", "Looting System", "Vehicles and houses can now be looted."},
			{"fixed", "General Improvements", "Various minor adjustments, bug fixes and optimizations were implemented."},
		}
	},
	{
		version = "v.0.9.9A",
		update = "UPDATE #1",
		date = "8 September 2024",
		subtitle = "Inventory, Safes and First Systems Update",
		entries = {
			{"added", "Inventory System", "The inventory and item system has been added and can be opened with I."},
			{"added", "Achievements", "More achievements have been added, reaching a total of 40."},
			{"added", "Safes", "Safes for storing money are now available from level 5."},
			{"added", "Weapon Boxes", "Weapon boxes are now available from level 10."},
			{"added", "NPCs", "Additional NPCs have been added."},
			{"added", "Day System", "A day system has been added where one day lasts 4 hours."},
			{"added", "Free Spin", "Players can now claim a free spin every 4 hours."},
			{"added", "Shops", "Two shops have been added: one for vests and one for items."},
			{"changed", "Zombie Rewards", "Killing zombies now rewards brain matter."},
			{"added", "Shout Command", "The /s command has been added to increase chat range."},
			{"changed", "Help Menu", "More help menu entries have been added and the help menu has been redesigned."},
			{"added", "Keys", "Keys for unlocking doors and crates have been added."},
		}
	},
}

local groupOrder = {
    {id = "added",   label = "ADDED",   key = "+", rgb = {90, 255, 148}},
    {id = "fixed",   label = "FIXED",   key = "!", rgb = {82, 214, 255}},
    {id = "changed", label = "CHANGED", key = "~", rgb = {255, 184, 79}},
}

local ui = ui or {}

ui.visible = ui.visible or false
ui.target = ui.target or 0
ui.anim = ui.anim or 0
ui.scroll = ui.scroll or 0
ui.maxScroll = ui.maxScroll or 0
ui.versionScroll = ui.versionScroll or 0
ui.versionMaxScroll = ui.versionMaxScroll or 0
ui.selectedVersion = ui.selectedVersion or 1
ui.activeGroup = ui.activeGroup or "all"
ui.search = ui.search or ""
ui.typing = ui.typing or false
ui.layout = ui.layout or {}
ui.layoutDirty = true
ui.counts = ui.counts or {all = 0, added = 0, fixed = 0, changed = 0}
ui.stats = ui.stats or {versions = 0, all = 0, added = 0, fixed = 0, changed = 0}

local function isIn(x, y, w, h)
    if not isCursorShowing() then return false end
    local cx, cy = getCursorPosition()
    cx, cy = cx * sx, cy * sy
    return cx >= x and cx <= x + w and cy >= y and cy <= y + h
end

local function lerp(a, b, t)
    return a + (b - a) * t
end

local function clamp(v, mn, mx)
    return math.max(mn, math.min(mx, v))
end

local function wrap(text, maxWidth)
    local lines, current = {}, ""

    for word in tostring(text or ""):gmatch("%S+") do
        local test = current == "" and word or current .. " " .. word

        if dxGetTextWidth(test, 1, fontText) > maxWidth and current ~= "" then
            lines[#lines + 1] = current
            current = word
        else
            current = test
        end
    end

    if current ~= "" then
        lines[#lines + 1] = current
    end

    return lines
end

local function currentLog()
    return changelogs[ui.selectedVersion] or changelogs[1]
end

local function rebuildStats()
    ui.stats = {
        versions = #(changelogs or {}),
        all = 0,
        added = 0,
        fixed = 0,
        changed = 0,
    }

    for _, log in ipairs(changelogs or {}) do
        for _, e in ipairs(log.entries or {}) do
            local t = e[1]
            ui.stats.all = ui.stats.all + 1
            ui.stats[t] = (ui.stats[t] or 0) + 1
        end
    end
end

local function rebuildLayout()
    ui.layout = {}
    ui.counts = {all = 0, added = 0, fixed = 0, changed = 0}

    local W = 1160 * z
    local listW = W - 356 * z
    local textW = listW - 118 * z
    local query = string.lower(ui.search or "")
    local log = currentLog()

    for _, e in ipairs(log.entries or {}) do
        ui.counts.all = ui.counts.all + 1
        ui.counts[e[1]] = (ui.counts[e[1]] or 0) + 1
    end

    local totalHeight = 0

    for _, group in ipairs(groupOrder) do
        local bucket = {}

        for _, e in ipairs(log.entries or {}) do
            local typeId, title, desc = e[1], e[2], e[3]
            local haystack = string.lower(tostring(title or "") .. " " .. tostring(desc or ""))

            if typeId == group.id
            and (ui.activeGroup == "all" or ui.activeGroup == typeId)
            and (query == "" or string.find(haystack, query, 1, true)) then
                local lines = wrap(desc or "", textW)

                bucket[#bucket + 1] = {
                    kind = typeId,
                    title = title or "",
                    desc = desc or "",
                    lines = lines,
                    h = math.max(64 * z, 36 * z + #lines * 16 * z),
                }
            end
        end

        if #bucket > 0 then
            ui.layout[#ui.layout + 1] = {mode = "header", group = group, h = 46 * z}
            totalHeight = totalHeight + 46 * z

            for _, item in ipairs(bucket) do
                ui.layout[#ui.layout + 1] = {mode = "item", item = item, group = group, h = item.h}
                totalHeight = totalHeight + item.h + 8 * z
            end

            totalHeight = totalHeight + 16 * z
        end
    end

    ui.totalHeight = totalHeight
    ui.layoutDirty = false
end

local function ensureRT(name, w, h)
    w, h = math.floor(w), math.floor(h)

    if isElement(ui[name]) and ui[name .. "W"] == w and ui[name .. "H"] == h then
        return true
    end

    if isElement(ui[name]) then
        destroyElement(ui[name])
    end

    ui[name] = dxCreateRenderTarget(w, h, true)
    ui[name .. "W"] = w
    ui[name .. "H"] = h

    return isElement(ui[name])
end

local function drawPanel(x, y, w, h, A)
    dxDrawRectangle(x + 8*z, y + 8*z, w, h, tocolor(0, 0, 0, A * 0.38))
    dxDrawRectangle(x, y, w, h, tocolor(5, 8, 9, A * 0.94))
    dxDrawRectangle(x, y, w, 2*z, tocolor(220, 25, 25, A))
    dxDrawRectangle(x, y + h - 2*z, w, 2*z, tocolor(82, 214, 255, A * 0.55))
    dxDrawRectangle(x, y, 2*z, h, tocolor(255, 255, 255, A * 0.13))
    dxDrawRectangle(x + w - 2*z, y, 2*z, h, tocolor(255, 255, 255, A * 0.13))
end

local function drawVersionsRT(w, h, A)
    if not ensureRT("versionRT", w, h) then return false end

    dxSetRenderTarget(ui.versionRT, true)
    dxDrawRectangle(0, 0, w, h, tocolor(7, 10, 11, A * 0.94))

    local y = -ui.versionScroll

    for i, v in ipairs(changelogs or {}) do
        local active = ui.selectedVersion == i
        local hover = ui.versionAbsX and isIn(ui.versionAbsX, ui.versionAbsY + y, w, 42*z)

        dxDrawRectangle(
            0,
            y,
            w,
            42*z,
            active and tocolor(220, 25, 25, A * 0.18)
            or hover and tocolor(255, 255, 255, A * 0.07)
            or tocolor(255, 255, 255, A * 0.035)
        )

        if active then
            dxDrawRectangle(0, y, 3*z, 42*z, tocolor(220, 25, 25, A))
        end

        dxDrawText(
            v.version or "-",
            14*z,
            y + 3*z,
            w - 12*z,
            y + 22*z,
            tocolor(226, 238, 230, A),
            1,
            fontTitle,
            "left",
            "center",
            true
        )

        dxDrawText(
            tostring(v.update or "-") .. " / " .. tostring(v.date or "-"),
            14*z,
            y + 21*z,
            w - 12*z,
            y + 40*z,
            tocolor(116, 134, 125, A),
            1,
            fontMono,
            "left",
            "center",
            true
        )

        y = y + 48*z
    end

    dxSetRenderTarget()
    return true
end

local function drawListRT(w, h, A)
    if not ensureRT("listRT", w, h) then return false end

    dxSetRenderTarget(ui.listRT, true)
    dxDrawRectangle(0, 0, w, h, tocolor(8, 11, 12, A * 0.90))
    dxDrawRectangle(0, 0, w, 1*z, tocolor(255, 255, 255, A * 0.08))

    local contentY = 18*z - ui.scroll

    for _, row in ipairs(ui.layout or {}) do
        local rowH = row.h

        if contentY + rowH > 0 and contentY < h then
            if row.mode == "header" then
                local g = row.group
                local r, gg, b = g.rgb[1], g.rgb[2], g.rgb[3]

                dxDrawRectangle(18*z, contentY + 6*z, w - 36*z, 32*z, tocolor(r, gg, b, A * 0.11))
                dxDrawRectangle(18*z, contentY + 6*z, 4*z, 32*z, tocolor(r, gg, b, A))
                dxDrawText(g.key, 34*z, contentY + 6*z, 60*z, contentY + 38*z, tocolor(r, gg, b, A), 1, fontTitle, "left", "center")
                dxDrawText(g.label, 66*z, contentY + 6*z, 260*z, contentY + 38*z, tocolor(r, gg, b, A), 1, fontTitle, "left", "center")
            else
                local item = row.item
                local g = row.group
                local r, gg, b = g.rgb[1], g.rgb[2], g.rgb[3]
                local ix, iy, iw, ih = 28*z, contentY, w - 60*z, rowH

                dxDrawRectangle(ix, iy, iw, ih, tocolor(15, 19, 20, A * 0.92))
                dxDrawRectangle(ix, iy, 2*z, ih, tocolor(r, gg, b, A * 0.45))
                dxDrawRectangle(ix + 12*z, iy + 12*z, 28*z, 28*z, tocolor(r, gg, b, A * 0.15))
                dxDrawText(g.key, ix + 12*z, iy + 12*z, ix + 40*z, iy + 40*z, tocolor(r, gg, b, A), 1, fontTitle, "center", "center")

                dxDrawText(
                    item.title,
                    ix + 54*z,
                    iy + 8*z,
                    ix + iw - 18*z,
                    iy + 28*z,
                    tocolor(226, 238, 230, A),
                    1,
                    fontTitle,
                    "left",
                    "center",
                    true
                )

                local ty = iy + 31*z

                for i = 1, #item.lines do
                    dxDrawText(
                        item.lines[i],
                        ix + 54*z,
                        ty,
                        ix + iw - 18*z,
                        ty + 16*z,
                        tocolor(116, 134, 125, A),
                        1,
                        fontText,
                        "left",
                        "center",
                        true
                    )

                    ty = ty + 16*z
                end
            end
        end

        contentY = contentY + rowH + (row.mode == "item" and 8*z or 0)
    end

    dxSetRenderTarget()
    return true
end

function renderChangelog()
    if ui.layoutDirty then
        rebuildLayout()
    end

    rebuildStats()

    ui.anim = lerp(ui.anim, ui.target, 0.16)

    if ui.anim < 0.01 and not ui.visible then
        removeEventHandler("onClientRender", root, renderChangelog)
        return
    end

    local A = 255 * ui.anim

    local W = 1160 * z
    local H = 690 * z

    local X = (sx - W) / 2
    local Y = (sy - H) / 2 + (1 - ui.anim) * 24*z

    local log = currentLog()

    dxDrawRectangle(0, 0, sx, sy, tocolor(0, 0, 0, A * 0.46))
    drawPanel(X, Y, W, H, A)

    dxDrawRectangle(X + 24*z, Y + 24*z, W - 48*z, 58*z, tocolor(12, 18, 18, A * 0.88))
    dxDrawRectangle(X + 24*z, Y + 82*z, W - 48*z, 1*z, tocolor(220, 25, 25, A * 0.30))

    dxDrawText(log.update or "UPDATE", X + 42*z, Y + 28*z, X + 250*z, Y + 52*z, tocolor(255,255,255, A), 1, fontMono, "left", "center")
    dxDrawText("CHANGELOG", X + 40*z, Y + 46*z, X + 320*z, Y + 82*z, tocolor(226, 238, 230, A), 1, fontHeader, "left", "center")

    dxDrawText(
        tostring(log.version or "-") .. "  /  " .. tostring(log.date or "-") .. "  /  " .. tostring(log.subtitle or ""),
        X + 330*z,
        Y + 44*z,
        X + W - 92*z,
        Y + 76*z,
        tocolor(116, 134, 125, A),
        1,
        fontTitle,
        "left",
        "center",
        true
    )

    local closeX = X + W - 66*z
    local closeY = Y + 36*z
    local closeS = 34*z

    dxDrawRectangle(
        closeX,
        closeY,
        closeS,
        closeS,
        isIn(closeX, closeY, closeS, closeS) and tocolor(255, 72, 91, A) or tocolor(255, 255, 255, A * 0.08)
    )

    dxDrawText("X", closeX, closeY, closeX + closeS, closeY + closeS, tocolor(255, 255, 255, A), 1, fontTitle, "center", "center")

    local sideX = X + 24*z
    local sideY = Y + 104*z
    local sideW = 286*z
    local sideH = H - 128*z

    dxDrawRectangle(sideX, sideY, sideW, sideH, tocolor(9, 13, 14, A * 0.92))
    dxDrawRectangle(sideX + sideW - 1*z, sideY, 1*z, sideH, tocolor(220, 25, 25, A * 0.24))

    local pad = 18*z

    local versionsLabelY = sideY + 14*z
    local versionsX = sideX + pad
    local versionsY = sideY + 42*z
    local versionsW = sideW - pad * 2
    local versionsH = 100*z

    local filterLabelY = sideY + 154*z
    local filterY = sideY + 180*z
    local filterButtonH = 34*z
    local filterGap = 7*z

    local statsY = sideY + 352*z
    local statsH = 86*z

    local searchX = sideX + pad
    local searchY = sideY + sideH - 88*z
    local searchW = sideW - pad * 2
    local searchH = 40*z

    local footerY = sideY + sideH - 40*z

    dxDrawText("VERSIONS", sideX + 22*z, versionsLabelY, sideX + sideW, versionsLabelY + 20*z, tocolor(255,255,255, A), 1, fontMono, "left", "center")

    local versionContentH = #(changelogs or {}) * 48*z

    ui.versionAbsX = versionsX
    ui.versionAbsY = versionsY
    ui.versionMaxScroll = math.max(0, versionContentH - versionsH)
    ui.versionScroll = clamp(ui.versionScroll or 0, 0, ui.versionMaxScroll)

    if drawVersionsRT(versionsW, versionsH, A) then
        dxDrawImage(versionsX, versionsY, versionsW, versionsH, ui.versionRT)
    end

    dxDrawRectangle(versionsX, versionsY, versionsW, 1*z, tocolor(255, 255, 255, A * 0.08))
    dxDrawRectangle(versionsX, versionsY + versionsH - 1*z, versionsW, 1*z, tocolor(255, 255, 255, A * 0.08))

    if ui.versionMaxScroll > 0 then
        local trackX = versionsX + versionsW - 5*z
        local thumbH = math.max(20*z, versionsH * (versionsH / versionContentH))
        local thumbY = versionsY + (versionsH - thumbH) * (ui.versionScroll / ui.versionMaxScroll)

        dxDrawRectangle(trackX, versionsY + 4*z, 2*z, versionsH - 8*z, tocolor(255, 255, 255, A * 0.10))
        dxDrawRectangle(trackX, thumbY, 2*z, thumbH, tocolor(220, 25, 25, A * 0.85))
    end

    dxDrawText("FILTER", sideX + 22*z, filterLabelY, sideX + sideW, filterLabelY + 20*z, tocolor(255,255,255, A), 1, fontMono, "left", "center")

    local buttons = {
        {"all", "ALL", ui.counts.all or 0, 226, 238, 230},
        {"added", "ADDED", ui.counts.added or 0, 90, 255, 148},
        {"fixed", "FIXED", ui.counts.fixed or 0, 82, 214, 255},
        {"changed", "CHANGED", ui.counts.changed or 0, 255, 184, 79},
    }

    local by = filterY

    for _, b in ipairs(buttons) do
        local active = ui.activeGroup == b[1]
        local hover = isIn(sideX + pad, by, sideW - pad * 2, filterButtonH)

        dxDrawRectangle(
            sideX + pad,
            by,
            sideW - pad * 2,
            filterButtonH,
            active and tocolor(b[4], b[5], b[6], A * 0.18)
            or hover and tocolor(255, 255, 255, A * 0.07)
            or tocolor(255, 255, 255, A * 0.035)
        )

        if active then
            dxDrawRectangle(sideX + pad, by, 3*z, filterButtonH, tocolor(b[4], b[5], b[6], A))
        end

        dxDrawText(b[2], sideX + 34*z, by, sideX + 150*z, by + filterButtonH, tocolor(b[4], b[5], b[6], A), 1, fontTitle, "left", "center")
        dxDrawText(tostring(b[3]), sideX, by, sideX + sideW - 34*z, by + filterButtonH, tocolor(226, 238, 230, A), 1, fontTitle, "right", "center")

        by = by + filterButtonH + filterGap
    end

    local statsX = sideX + pad
    local statsW = sideW - pad * 2

    dxDrawText("TOTAL STATS", sideX + 22*z, statsY, sideX + sideW, statsY + 20*z, tocolor(255,255,255, A), 1, fontMono, "left", "center")

    local statsBoxY = statsY + 24*z
    local statsBoxH = statsH - 24*z

    dxDrawRectangle(statsX, statsBoxY, statsW, statsBoxH, tocolor(255, 255, 255, A * 0.045))
    dxDrawRectangle(statsX, statsBoxY, 3*z, statsBoxH, tocolor(220, 25, 25, A * 0.95))

    dxDrawText(
        tostring(ui.stats.all or 0),
        statsX + 14*z,
        statsBoxY + 3*z,
        statsX + 92*z,
        statsBoxY + 35*z,
        tocolor(226, 238, 230, A),
        1.05,
        fontHeader,
        "left",
        "center"
    )

    dxDrawText(
        "TOTAL UPDATES",
        statsX + 15*z,
        statsBoxY + 35*z,
        statsX + 106*z,
        statsBoxY + statsBoxH,
        tocolor(116, 134, 125, A),
        0.82,
        fontMono,
        "left",
        "center",
        true
    )

    local splitX = statsX + 114*z
    dxDrawRectangle(splitX - 8*z, statsBoxY + 10*z, 1*z, statsBoxH - 20*z, tocolor(255, 255, 255, A * 0.08))

    local mini = {
        {"+", ui.stats.added or 0, 90, 255, 148},
        {"!", ui.stats.fixed or 0, 82, 214, 255},
        {"~", ui.stats.changed or 0, 255, 184, 79},
    }

    for i, s in ipairs(mini) do
        local mx = splitX + (i - 1) * 43*z

        dxDrawText(s[1], mx, statsBoxY + 8*z, mx + 24*z, statsBoxY + 28*z, tocolor(s[3], s[4], s[5], A), 1, fontTitle, "left", "center")
        dxDrawText(tostring(s[2]), mx, statsBoxY + 30*z, mx + 38*z, statsBoxY + 52*z, tocolor(226, 238, 230, A), 0.95, fontTitle, "left", "center", true)
    end

    dxDrawRectangle(
        searchX,
        searchY,
        searchW,
        searchH,
        ui.typing and tocolor(220, 25, 25, A * 0.10) or tocolor(255, 255, 255, A * 0.04)
    )

    dxDrawRectangle(
        searchX,
        searchY + searchH - 1*z,
        searchW,
        1*z,
        ui.typing and tocolor(220, 25, 25, A) or tocolor(255, 255, 255, A * 0.13)
    )

    dxDrawText(
        ui.search ~= "" and ui.search or "search update...",
        searchX + 12*z,
        searchY,
        searchX + searchW - 12*z,
        searchY + searchH,
        ui.search ~= "" and tocolor(226, 238, 230, A) or tocolor(116, 134, 125, A),
        1,
        fontText,
        "left",
        "center",
        true
    )

    local listX = X + 332*z
    local listY = Y + 104*z
    local listW = W - 356*z
    local listH = H - 128*z

    ui.maxScroll = math.max(0, (ui.totalHeight or 0) - listH + 30*z)
    ui.scroll = clamp(ui.scroll or 0, 0, ui.maxScroll)

    if drawListRT(listW, listH, A) then
        dxDrawImage(listX, listY, listW, listH, ui.listRT, 0, 0, 0, tocolor(255, 255, 255, 255), false)
    else
        dxDrawRectangle(listX, listY, listW, listH, tocolor(8, 11, 12, A))
    end

    dxDrawRectangle(listX, listY, listW, 1*z, tocolor(255, 255, 255, A * 0.10))
    dxDrawRectangle(listX, listY + listH - 1*z, listW, 1*z, tocolor(255, 255, 255, A * 0.08))
    dxDrawRectangle(listX, listY, 1*z, listH, tocolor(255, 255, 255, A * 0.08))
    dxDrawRectangle(listX + listW - 1*z, listY, 1*z, listH, tocolor(255, 255, 255, A * 0.08))

    if ui.maxScroll > 0 then
        local trackX = listX + listW - 12*z
        local trackY = listY + 18*z
        local trackH = listH - 36*z
        local thumbH = math.max(42*z, trackH * (listH / (listH + ui.maxScroll)))
        local thumbY = trackY + (trackH - thumbH) * (ui.scroll / ui.maxScroll)

        dxDrawRectangle(trackX, trackY, 3*z, trackH, tocolor(255, 255, 255, A * 0.08))
        dxDrawRectangle(trackX, thumbY, 3*z, thumbH, tocolor(220, 25, 25, A * 0.85))
    end
end

function openChangelog(state)
	if(isWindowOpen() or ui.visible)then
		ui.visible = state ~= nil and state or not ui.visible
		ui.target = ui.visible and 1 or 0
		ui.typing = false

		setWindowData()
		showCursor(ui.visible)

		if(ui.visible)then
			ui.layoutDirty = true
			removeEventHandler("onClientRender", root, renderChangelog)
			addEventHandler("onClientRender", root, renderChangelog)
		end
	end
end

addEventHandler("onClientClick", root, function(button, state)
    if button ~= "left" or state ~= "down" or ui.anim < 0.75 then return end

    local W = 1160 * z
    local H = 690 * z
    local X = (sx - W) / 2
    local Y = (sy - H) / 2

    local closeX = X + W - 66*z
    local closeY = Y + 36*z
    local closeS = 34*z

    if isIn(closeX, closeY, closeS, closeS) then
        openChangelog(false)
		closeWindow()
        return
    end

    local sideX = X + 24*z
    local sideY = Y + 104*z
    local sideW = 286*z
    local sideH = H - 128*z
    local pad = 18*z

    local versionsX = sideX + pad
    local versionsY = sideY + 42*z
    local versionsW = sideW - pad * 2
    local versionsH = 100*z

    if isIn(versionsX, versionsY, versionsW, versionsH) then
        local _, cy = getCursorPosition()
        cy = cy * sy

        local relativeY = cy - versionsY + (ui.versionScroll or 0)
        local index = math.floor(relativeY / (48*z)) + 1

        if changelogs[index] then
            ui.selectedVersion = index
            ui.scroll = 0
            ui.typing = false
            ui.layoutDirty = true
            return
        end
    end

    local filterY = sideY + 180*z
    local filterButtonH = 34*z
    local filterGap = 7*z
    local ids = {"all", "added", "fixed", "changed"}

    local by = filterY

    for _, id in ipairs(ids) do
        if isIn(sideX + pad, by, sideW - pad * 2, filterButtonH) then
            ui.activeGroup = id
            ui.scroll = 0
            ui.typing = false
            ui.layoutDirty = true
            return
        end

        by = by + filterButtonH + filterGap
    end

    local searchX = sideX + pad
    local searchY = sideY + sideH - 88*z
    local searchW = sideW - pad * 2
    local searchH = 40*z

    ui.typing = isIn(searchX, searchY, searchW, searchH)
end)

addEventHandler("onClientKey", root, function(button, press)
    if not press or ui.anim < 0.05 then return end

    if button == "mouse_wheel_up" or button == "mouse_wheel_down" then
        local W = 1160 * z
        local H = 690 * z
        local X = (sx - W) / 2
        local Y = (sy - H) / 2

        local sideX = X + 24*z
        local sideY = Y + 104*z
        local sideW = 286*z
        local pad = 18*z

        local versionsX = sideX + pad
        local versionsY = sideY + 42*z
        local versionsW = sideW - pad * 2
        local versionsH = 100*z

        local dir = button == "mouse_wheel_up" and -1 or 1

        if isIn(versionsX, versionsY, versionsW, versionsH) then
            ui.versionScroll = clamp((ui.versionScroll or 0) + dir * 34*z, 0, ui.versionMaxScroll or 0)
        else
            ui.scroll = clamp((ui.scroll or 0) + dir * 60*z, 0, ui.maxScroll or 0)
        end
    elseif ui.typing and button == "backspace" then
        ui.search = string.sub(ui.search or "", 1, #(ui.search or "") - 1)
        ui.scroll = 0
        ui.layoutDirty = true
    end
end)

addEventHandler("onClientCharacter", root, function(char)
    if ui.typing and ui.anim > 0.9 and #(ui.search or "") < 36 then
        ui.search = (ui.search or "") .. char
        ui.scroll = 0
        ui.layoutDirty = true
    end
end)

addEventHandler("onClientPlayerWasted",root,function(player)
	if(player == localPlayer)then
		closeWindow()
	end
end)