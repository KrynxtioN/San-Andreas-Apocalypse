-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Nov 21, 2026 at 08:07 PM
-- Server version: 8.0.30
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `s2757_sanandreasapocalypse`
--

-- --------------------------------------------------------

--
-- Table structure for table `accounts`
--

CREATE TABLE `accounts` (
  `ID` int NOT NULL,
  `name` text COLLATE utf8mb4_general_ci NOT NULL,
  `serial` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `password` text COLLATE utf8mb4_general_ci NOT NULL,
  `autologin` int NOT NULL DEFAULT '0',
  `favoritecharacter` int NOT NULL DEFAULT '0',
  `skipintro` int NOT NULL DEFAULT '0',
  `language` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'EN',
  `recruitedplayers` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `card_bonus` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `account_bans`
--

CREATE TABLE `account_bans` (
  `ID` int NOT NULL,
  `owner_account_id` int NOT NULL,
  `ban_time` varchar(255) NOT NULL,
  `reason` text NOT NULL,
  `serial` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `bonuscodes`
--

CREATE TABLE `bonuscodes` (
  `ID` int NOT NULL,
  `code` text NOT NULL,
  `player_used_code` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `bonuscodes`
--

INSERT INTO `bonuscodes` (`ID`, `code`, `player_used_code`) VALUES
(1, 'ANEWHOPE', ''),
(2, 'izerman', ''),
(3, 'AGOODSTART', ''),
(4, 'HAPPYHALLOWEEN2026', '');

-- --------------------------------------------------------

--
-- Table structure for table `characters`
--

CREATE TABLE `characters` (
  `ID` int NOT NULL,
  `owner_account_id` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `banned` int NOT NULL DEFAULT '0',
  `name` text COLLATE utf8mb4_general_ci NOT NULL,
  `model` int NOT NULL DEFAULT '0',
  `money` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
  `level` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
  `experiencepoints` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
  `experiencepointstotal` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
  `helpmenu` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `achievements` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `clothes` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `health` int NOT NULL DEFAULT '100',
  `armor` int NOT NULL DEFAULT '0',
  `npcData` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `documents` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `lastlogin` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `zombiekills` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
  `tutorialtask` int NOT NULL DEFAULT '1',
  `grandfathershat` int NOT NULL DEFAULT '0',
  `dailyspin` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
  `freespins` int NOT NULL DEFAULT '0',
  `savedweapons` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
  `saacoins` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
  `playerkeys` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `safemoney` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
  `weaponbox` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `items` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `adminlevel` int NOT NULL DEFAULT '0',
  `status` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `colony` int NOT NULL DEFAULT '0',
  `activestatus` int NOT NULL DEFAULT '1',
  `playerquests` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `police_badges` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `police_batons` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `outfits` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `heads` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `vehicle_slots` int NOT NULL DEFAULT '0',
  `playtime` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
  `double_experience` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
  `double_money` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
  `zombie_immune` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
  `standardquest_timer` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
  `blips` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `spawns` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `spawn_id` int NOT NULL DEFAULT '0',
  `craftrecepts` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `radiodata` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `player_cameras` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `photos` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `hunger` int NOT NULL DEFAULT '100',
  `thirst` int NOT NULL DEFAULT '100',
  `survivorpass_level` int NOT NULL DEFAULT '0',
  `skillpoints` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
  `npc_stats` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `playerskills` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `spawn_shelter_id` int NOT NULL DEFAULT '0',
  `craftrecipes` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `places` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `safeKeyTime` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `spawn_x` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
  `spawn_y` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
  `spawn_z` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
  `spawn_rot` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
  `spawn_int` int NOT NULL DEFAULT '0',
  `spawn_dim` int NOT NULL DEFAULT '0',
  `colony_join_date` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `colonyrang` int NOT NULL DEFAULT '0',
  `colony_warns` int NOT NULL DEFAULT '0',
  `friendlist` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `nofoodtimer` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
  `collectible_chainsaw` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `friends` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `sharks` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `extra_armor` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
  `trophys` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `quest_wood_removed` int NOT NULL DEFAULT '0',
  `nothirsttimer` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
  `weekly_zombie_kills` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
  `player_fat` int NOT NULL DEFAULT '0',
  `player_muscles` int NOT NULL DEFAULT '0',
  `daily_zombie_kills` int NOT NULL DEFAULT '0',
  `daily_zombie_kills_bonus` int NOT NULL DEFAULT '0',
  `furniture` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `halloween_totems` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `double_skillpoints` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
  `motel` int NOT NULL DEFAULT '0',
  `motel_dim` int NOT NULL DEFAULT '0',
  `WeeklyReward1` int NOT NULL DEFAULT '0',
  `WeeklyReward2` int NOT NULL DEFAULT '0',
  `WeeklyReward3` int NOT NULL DEFAULT '0',
  `daily_weapon_bonus` int NOT NULL DEFAULT '0',
  `npc_trade_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `equippedBadge` int NOT NULL DEFAULT '0',
  `badges` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `character_stats`
--

CREATE TABLE `character_stats` (
  `ID` int NOT NULL,
  `character_id` int NOT NULL,
  `looted_dumpsters` int NOT NULL DEFAULT '0',
  `looted_houses` int NOT NULL DEFAULT '0',
  `looted_vehicles` int NOT NULL DEFAULT '0',
  `finished_quest` int NOT NULL DEFAULT '0',
  `looted_places` int NOT NULL DEFAULT '0',
  `killed_infected_survivors` int NOT NULL DEFAULT '0',
  `vehicle_loot_record` int NOT NULL DEFAULT '0',
  `destroyed_nest` int NOT NULL DEFAULT '0',
  `valentine_coins` int NOT NULL DEFAULT '0',
  `valentine_quest_finished` int NOT NULL DEFAULT '0',
  `valentine_task` int NOT NULL DEFAULT '0',
  `valentine_collected_chocolate` int NOT NULL DEFAULT '0',
  `rhinos_destroyed` int NOT NULL DEFAULT '0',
  `junkyard_vehicles` int NOT NULL DEFAULT '0',
  `found_treasures` int NOT NULL DEFAULT '0',
  `planted` int NOT NULL DEFAULT '0',
  `harvested` int NOT NULL DEFAULT '0',
  `killed_bigfoot` int NOT NULL DEFAULT '0',
  `minigun_timer` int NOT NULL DEFAULT '0',
  `bottle_oxygen` int NOT NULL DEFAULT '0',
  `deagleskills` int NOT NULL DEFAULT '0',
  `shotgunskills` int NOT NULL DEFAULT '0',
  `mp5skills` int NOT NULL DEFAULT '0',
  `m4skills` int NOT NULL DEFAULT '0',
  `WeekTime` int NOT NULL DEFAULT '0',
  `WeekTimeAFK` int NOT NULL DEFAULT '0',
  `mining` int NOT NULL DEFAULT '0',
  `looted_garages` varchar(255) NOT NULL DEFAULT '0',
  `sprintlevel` varchar(255) NOT NULL DEFAULT '0',
  `sprintlevel_process` varchar(255) NOT NULL DEFAULT '0',
  `killed_animals` varchar(255) NOT NULL DEFAULT '0',
  `bigfoot_heads` varchar(255) NOT NULL DEFAULT '0',
  `bigfoot_exp` varchar(255) NOT NULL DEFAULT '0',
  `airdrops_collected` varchar(255) NOT NULL DEFAULT '0',
  `destroyed_vehicles` varchar(255) NOT NULL DEFAULT '0',
  `destroyed_wood` varchar(255) NOT NULL DEFAULT '0',
  `ocean_cleaned` varchar(255) NOT NULL DEFAULT '0',
  `sweeper_trash` varchar(255) NOT NULL DEFAULT '0',
  `saved_survivors` varchar(255) NOT NULL DEFAULT '0',
  `cut_trees` varchar(255) NOT NULL DEFAULT '0',
  `trees_to_wood` varchar(255) NOT NULL DEFAULT '0',
  `flowers` varchar(255) NOT NULL DEFAULT '',
  `marketplace_money` varchar(255) NOT NULL DEFAULT '0',
  `bigfootexp` varchar(255) NOT NULL DEFAULT '0',
  `npc_gifted` varchar(255) NOT NULL DEFAULT '0',
  `metal_detector_looted` varchar(255) NOT NULL DEFAULT '0',
  `playerkills` int NOT NULL DEFAULT '0',
  `playerdeath` int NOT NULL DEFAULT '0',
  `hearse_delivered` int NOT NULL DEFAULT '0',
  `catched_fish` int NOT NULL DEFAULT '0',
  `skeletons_taxi` int NOT NULL DEFAULT '0',
  `cooked_fish` int NOT NULL DEFAULT '0',
  `oil_delivery` int NOT NULL DEFAULT '0',
  `casino_safe_destroyed` int NOT NULL DEFAULT '0',
  `bonuspoints_collectibles` int NOT NULL DEFAULT '0',
  `shooter_arena_killed_players` int NOT NULL DEFAULT '0',
  `races_top3` int NOT NULL DEFAULT '0',
  `killed_pumpkin_zombies` varchar(255) NOT NULL DEFAULT '0',
  `collected_pumpkins` int NOT NULL DEFAULT '0',
  `radio_tower` varchar(255) NOT NULL DEFAULT '',
  `survivor_pass_abo` int NOT NULL DEFAULT '0',
  `bank_money` varchar(255) NOT NULL DEFAULT '0',
  `valentine_quest_timer` varchar(255) NOT NULL DEFAULT '',
  `flower_exp` varchar(255) NOT NULL DEFAULT '0',
  `killed_spinosaurus` int NOT NULL DEFAULT '0',
  `spinosaurusexp` int NOT NULL DEFAULT '0',
  `looted_graves` int NOT NULL DEFAULT '0',
  `delivered_money_bags_cash_transporter` int NOT NULL DEFAULT '0',
  `delivered_warehouse_transporter` int NOT NULL DEFAULT '0',
  `delivered_weapon_transporter` int NOT NULL DEFAULT '0',
  `finished_zombie_waves` int NOT NULL DEFAULT '0',
  `special_airdrops` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `chest_vehicles`
--

CREATE TABLE `chest_vehicles` (
  `ID` int NOT NULL,
  `character_id_owner` int NOT NULL,
  `model` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `collectible_pickups`
--

CREATE TABLE `collectible_pickups` (
  `ID` int NOT NULL,
  `character_id` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `collectible_type` text COLLATE utf8mb4_general_ci NOT NULL,
  `collectible_id` varchar(255) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `colonyareas`
--

CREATE TABLE `colonyareas` (
  `ID` int NOT NULL,
  `x1` varchar(50) NOT NULL,
  `x2` varchar(50) NOT NULL,
  `y1` varchar(50) NOT NULL,
  `y2` varchar(50) NOT NULL,
  `px` varchar(50) NOT NULL,
  `py` varchar(50) NOT NULL,
  `pz` varchar(50) NOT NULL,
  `owner` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `colonyareas`
--

INSERT INTO `colonyareas` (`ID`, `x1`, `x2`, `y1`, `y2`, `px`, `py`, `pz`, `owner`) VALUES
(1, '-2203.8640136719', '-2093.1296386719', '-283.39456176758', '-76.585304260254', '-2185.5258789062', '-218.23043823242', '36.51481628418', 0),
(2, '-1494.2794189453', '-1336.6267089844', '1434.4106445313', '1531.5936279297', '-1376.3942871094', '1491.3725585938', '10.8523', 0);

-- --------------------------------------------------------

--
-- Table structure for table `colonybuildings`
--

CREATE TABLE `colonybuildings` (
  `ID` int NOT NULL,
  `posx` int NOT NULL,
  `posy` int NOT NULL,
  `posz` int NOT NULL,
  `owner_id` int NOT NULL,
  `price_money` int NOT NULL,
  `price_brainmass` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `colonys`
--

CREATE TABLE `colonys` (
  `ID` int NOT NULL,
  `name` text NOT NULL,
  `level` int NOT NULL DEFAULT '0',
  `experiencepoints` varchar(255) NOT NULL DEFAULT '0',
  `player_slots` int NOT NULL DEFAULT '0',
  `vehicle_slots` int NOT NULL DEFAULT '0',
  `experiencepointstotal` varchar(255) NOT NULL DEFAULT '0',
  `exp_distance` int NOT NULL DEFAULT '20',
  `killed_zombies` varchar(255) NOT NULL DEFAULT '0',
  `tasks` longtext NOT NULL,
  `trash_kilo` varchar(255) NOT NULL DEFAULT '0',
  `trash` varchar(255) NOT NULL DEFAULT '0',
  `trash_started` varchar(255) NOT NULL DEFAULT '0',
  `trash_status` int NOT NULL DEFAULT '100',
  `trash_timer` longtext NOT NULL,
  `money` varchar(255) NOT NULL DEFAULT '0',
  `saved_experience_from_trash` varchar(255) NOT NULL DEFAULT '0',
  `saved_money_from_trash` varchar(255) NOT NULL DEFAULT '0',
  `color_r` int NOT NULL DEFAULT '0',
  `color_g` int NOT NULL DEFAULT '0',
  `color_b` int NOT NULL DEFAULT '0',
  `brainmass` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `colony_bonus_timer`
--

CREATE TABLE `colony_bonus_timer` (
  `ID` int NOT NULL,
  `colony_id` int NOT NULL,
  `bonus_id` int NOT NULL,
  `active_until` bigint NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `colony_missions`
--

CREATE TABLE `colony_missions` (
  `id` int NOT NULL,
  `colony` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `mission_id` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `progress` int NOT NULL DEFAULT '0',
  `active` tinyint NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `colony_mission_collects`
--

CREATE TABLE `colony_mission_collects` (
  `id` int NOT NULL,
  `colony` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `mission_id` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `collect_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `colony_warehouse`
--

CREATE TABLE `colony_warehouse` (
  `ID` int NOT NULL,
  `colony` int NOT NULL,
  `warehouse_id` int NOT NULL,
  `items` longtext COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `colony_zombies`
--

CREATE TABLE `colony_zombies` (
  `ID` int NOT NULL,
  `colony` int NOT NULL,
  `zombie_id` int NOT NULL,
  `reward_timer` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `level` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `dailylogin`
--

CREATE TABLE `dailylogin` (
  `ID` int NOT NULL,
  `character_id` int NOT NULL,
  `claimed` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `canclaim` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `lastclaimdate` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `weeklyStreak` int NOT NULL DEFAULT '0',
  `weekStartDate` varchar(10) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `dailytasks`
--

CREATE TABLE `dailytasks` (
  `ID` int NOT NULL,
  `character_id` int NOT NULL,
  `task` int NOT NULL,
  `status` int NOT NULL,
  `progress_data` varchar(255) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `fabrikwars`
--

CREATE TABLE `fabrikwars` (
  `ID` int NOT NULL,
  `Spawnx` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Spawny` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Spawnz` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Besitzer` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Blipx` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Blipy` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Interior` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Dimension` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `fabrikwars`
--

INSERT INTO `fabrikwars` (`ID`, `Spawnx`, `Spawny`, `Spawnz`, `Besitzer`, `Blipx`, `Blipy`, `Interior`, `Dimension`) VALUES
(1, '2543.2336425781', '-1318.9847412109', '1031.421875', '0', '-2095.7846679688', '-2299.0588378906', '2', '1'),
(2, '2580.0126953125', '-1285.4128417969', '1044.125', '0', '-61.589290618896', '-1121.8610839844', '2', '1'),
(3, '2520.1525878906', '-1281.2653808594', '1054.640625', '0', '2372.0036621094', '2760.150390625', '2', '1'),
(4, '958.70465087891', '2098.9301757813', '1011.0242919922', '0', '207.87173461914', '-61.688751220703', '1', '1');

-- --------------------------------------------------------

--
-- Table structure for table `factoryfights`
--

CREATE TABLE `factoryfights` (
  `ID` int NOT NULL,
  `spawnx` varchar(255) NOT NULL,
  `spawny` varchar(255) NOT NULL,
  `spawnz` varchar(255) NOT NULL,
  `owner` text NOT NULL,
  `interior` int NOT NULL,
  `dimension` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `factoryfights`
--

INSERT INTO `factoryfights` (`ID`, `spawnx`, `spawny`, `spawnz`, `owner`, `interior`, `dimension`) VALUES
(1, '960.80834960938', '2101.0485839844', '1011.0263671875', '0', 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `garages`
--

CREATE TABLE `garages` (
  `ID` int NOT NULL,
  `owner` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `garages`
--

INSERT INTO `garages` (`ID`, `owner`) VALUES
(1, '0'),
(2, '0'),
(3, '0'),
(4, '0'),
(5, '0'),
(6, '0'),
(7, '0'),
(8, '0'),
(9, '0'),
(10, '0'),
(11, '0');

-- --------------------------------------------------------

--
-- Table structure for table `generators`
--

CREATE TABLE `generators` (
  `ID` int NOT NULL,
  `generatorID` int NOT NULL,
  `fuel` float NOT NULL,
  `oil` float NOT NULL,
  `status` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `generators`
--

INSERT INTO `generators` (`ID`, `generatorID`, `fuel`, `oil`, `status`) VALUES
(1, 1, 100, 100, 100),
(2, 2, 100, 100, 100),
(3, 3, 100, 100, 100),
(4, 4, 100, 100, 100),
(5, 5, 100, 100, 100),
(6, 6, 100, 100, 100),
(7, 7, 100, 100, 100),
(8, 8, 100, 100, 100),
(9, 9, 100, 100, 100),
(10, 10, 100, 100, 100),
(11, 11, 100, 100, 100),
(12, 12, 100, 100, 100),
(13, 13, 100, 100, 100),
(14, 14, 100, 100, 100),
(15, 15, 100, 100, 100),
(16, 16, 100, 100, 100),
(17, 17, 100, 100, 100),
(18, 18, 100, 100, 100),
(19, 19, 100, 100, 100);

-- --------------------------------------------------------

--
-- Table structure for table `halloween_data`
--

CREATE TABLE `halloween_data` (
  `ID` int NOT NULL,
  `character_id` int NOT NULL,
  `deliveredPumpkins` varchar(255) NOT NULL,
  `shopLevel` int NOT NULL,
  `chest1` int NOT NULL DEFAULT '0',
  `chest2` int NOT NULL DEFAULT '0',
  `chest3` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `logs`
--

CREATE TABLE `logs` (
  `ID` int NOT NULL,
  `log_type` text COLLATE utf8mb4_general_ci NOT NULL,
  `text` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `character_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `market`
--

CREATE TABLE `market` (
  `ID` int NOT NULL,
  `status` int NOT NULL,
  `seller_character_id` int NOT NULL,
  `items` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `market`
--

INSERT INTO `market` (`ID`, `status`, `seller_character_id`, `items`) VALUES
(1, 0, 0, ''),
(2, 0, 0, ''),
(3, 0, 0, ''),
(4, 0, 0, ''),
(5, 0, 0, ''),
(6, 0, 0, ''),
(7, 0, 0, ''),
(8, 0, 0, ''),
(9, 0, 0, ''),
(10, 0, 0, ''),
(11, 0, 0, ''),
(12, 0, 0, ''),
(13, 0, 0, ''),
(14, 0, 0, ''),
(15, 0, 0, ''),
(16, 0, 0, ''),
(17, 0, 0, ''),
(18, 0, 0, ''),
(19, 0, 0, ''),
(20, 0, 0, ''),
(21, 0, 0, ''),
(22, 0, 0, ''),
(23, 0, 0, ''),
(24, 0, 0, ''),
(25, 0, 0, ''),
(26, 0, 0, ''),
(27, 0, 0, ''),
(28, 0, 0, ''),
(29, 0, 0, ''),
(30, 0, 0, ''),
(31, 0, 0, '');

-- --------------------------------------------------------

--
-- Table structure for table `objects`
--

CREATE TABLE `objects` (
  `ID` int NOT NULL,
  `owner` int NOT NULL,
  `pos_x` varchar(255) NOT NULL,
  `pos_y` varchar(255) NOT NULL,
  `pos_z` varchar(255) NOT NULL,
  `rot_x` varchar(255) NOT NULL,
  `rot_y` varchar(255) NOT NULL,
  `rot_z` varchar(255) NOT NULL,
  `spawn_int` int NOT NULL,
  `spawn_dim` int NOT NULL,
  `model` int NOT NULL,
  `text` longtext NOT NULL,
  `money` varchar(255) NOT NULL DEFAULT '0',
  `storage` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `offlinemessages`
--

CREATE TABLE `offlinemessages` (
  `ID` int NOT NULL,
  `character_id` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `text` text COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `oven`
--

CREATE TABLE `oven` (
  `ID` int NOT NULL,
  `character_id` int NOT NULL,
  `stime` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `barstype` text COLLATE utf8mb4_general_ci NOT NULL,
  `amount` varchar(255) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `plants`
--

CREATE TABLE `plants` (
  `ID` int NOT NULL,
  `model` int NOT NULL,
  `spawnx` varchar(255) NOT NULL,
  `spawny` varchar(255) NOT NULL,
  `spawnz` varchar(255) NOT NULL,
  `rotz` varchar(255) NOT NULL,
  `owner_character_id` int NOT NULL,
  `stime` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `player_notepad`
--

CREATE TABLE `player_notepad` (
  `ID` int NOT NULL,
  `character_id` varchar(64) COLLATE utf8mb4_general_ci NOT NULL,
  `pages` int NOT NULL,
  `data` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `waypoint_slots` int NOT NULL,
  `waypoint_data` longtext COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `player_questseries`
--

CREATE TABLE `player_questseries` (
  `ID` int NOT NULL,
  `character_id` int NOT NULL,
  `questseries_id` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `player_weapons`
--

CREATE TABLE `player_weapons` (
  `ID` int NOT NULL,
  `character_id` int NOT NULL,
  `weapon_id` int NOT NULL,
  `ammo` int NOT NULL,
  `durability` int NOT NULL,
  `inHand` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `prestige`
--

CREATE TABLE `prestige` (
  `ID` int NOT NULL,
  `owner_character_id` int NOT NULL,
  `money` varchar(255) NOT NULL DEFAULT '0',
  `experience` varchar(255) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `prestige`
--

INSERT INTO `prestige` (`ID`, `owner_character_id`, `money`, `experience`) VALUES
(1, 0, '0', '0'),
(2, 0, '0', '0'),
(3, 0, '0', '0'),
(4, 0, '0', '0'),
(5, 0, '0', '0'),
(6, 0, '0', '0'),
(7, 0, '0', '0'),
(8, 0, '0', '0'),
(9, 0, '0', '0'),
(10, 0, '0', '0'),
(11, 0, '0', '0'),
(12, 0, '0', '0'),
(13, 0, '0', '0');

-- --------------------------------------------------------

--
-- Table structure for table `questseries`
--

CREATE TABLE `questseries` (
  `ID` int NOT NULL,
  `character_id` int NOT NULL,
  `questseries_id` int NOT NULL,
  `stage` int NOT NULL,
  `stage_progress` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `server_event_data`
--

CREATE TABLE `server_event_data` (
  `ID` int NOT NULL,
  `event` text NOT NULL,
  `community_progress` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `server_event_data`
--

INSERT INTO `server_event_data` (`ID`, `event`, `community_progress`) VALUES
(1, 'valentine', '0'),
(2, 'halloween', '0');

-- --------------------------------------------------------

--
-- Table structure for table `shelter`
--

CREATE TABLE `shelter` (
  `ID` int NOT NULL,
  `posx` varchar(255) NOT NULL,
  `posy` varchar(255) NOT NULL,
  `posz` varchar(255) NOT NULL,
  `owner` text NOT NULL,
  `price_money` varchar(255) NOT NULL,
  `price_brainmass` varchar(255) NOT NULL,
  `colony` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `shelter`
--

INSERT INTO `shelter` (`ID`, `posx`, `posy`, `posz`, `owner`, `price_money`, `price_brainmass`, `colony`) VALUES
(1, '331.254883', '-40.235352', '2.225523', '0', '50000', '7500', 0),
(2, '253.351562', '-22.284180', '1.633689', '0', '20000', '3000', 0),
(3, '747.113281', '278.258789', '27.218750', '0', '10000', '1500', 0),
(4, '748.126953', '257.113281', '27.085938', '0', '10000', '1500', 0),
(5, '723.710938', '269.668945', '22.453125', '0', '10000', '1500', 0),
(6, '705.420898', '292.092773', '20.421875', '0', '10000', '1500', 0),
(7, '719.063477', '300.627930', '20.376562', '0', '10000', '1500', 0),
(8, '746.407227', '305.034180', '20.234375', '0', '10000', '1500', 0),
(9, '772.927734', '348.215820', '20.152744', '0', '5000', '750', 0),
(10, '748.445312', '350.866211', '20.585802', '0', '10000', '1500', 0),
(11, '758.888672', '375.073242', '23.392187', '0', '10000', '1500', 0),
(12, '751.726562', '375.213867', '23.374865', '0', '5000', '750', 0),
(13, '783.916016', '352.597656', '19.593750', '0', '10000', '1500', 0),
(14, '805.320312', '358.377930', '19.762119', '0', '10000', '1500', 0),
(15, '808.059570', '372.273438', '19.452990', '0', '5000', '750', 0),
(16, '1242.384766', '211.388672', '19.554688', '0', '50000', '7500', 0),
(17, '783.198242', '377.546875', '21.296740', '0', '5000', '750', 0),
(18, '-255.146484', '2603.251953', '62.858154', '0', '100000', '15000', 0),
(19, '-300.514648', '2658.240234', '63.198917', '0', '50000', '7500', 0),
(20, '-910.949219', '2685.927734', '42.370262', '0', '100000', '15000', 0),
(21, '-1668.133789', '2486.289062', '87.172562', '0', '10000', '1500', 0),
(22, '-1802.643555', '2037.750000', '9.590245', '0', '10000', '1500', 0),
(23, '-1827.051758', '2042.319336', '8.660557', '0', '10000', '1500', 0),
(24, '-1500.079102', '1960.086914', '49.023438', '0', '20000', '3000', 0),
(25, '-1061.810547', '1562.036133', '33.431252', '0', '20000', '3000', 0),
(26, '-369.790039', '1169.526367', '20.271875', '0', '50000', '7500', 0),
(27, '-2083.606445', '-2266.110352', '30.797279', '0', '100000', '15000', 0),
(28, '1283.302734', '158.414062', '20.793369', '0', '7500', '1125', 0),
(29, '1295.416016', '174.555664', '20.910557', '0', '7500', '1125', 0),
(30, '1300.461914', '193.288086', '20.523302', '0', '7500', '1125', 0),
(31, '1303.586914', '186.082031', '20.538927', '0', '7500', '1125', 0),
(32, '1315.634766', '180.183594', '20.554552', '0', '7500', '1125', 0),
(33, '1311.821289', '169.551758', '20.631060', '0', '7500', '1125', 0),
(34, '1307.282227', '153.299805', '20.492052', '0', '7500', '1125', 0),
(35, '1299.184570', '140.340820', '20.538927', '0', '7500', '1125', 0),
(36, '1294.524414', '157.594727', '20.577990', '0', '7500', '1125', 0),
(37, '-2152.521484', '1232.802734', '33.929688', '0', '20000', '3000', 0),
(38, '-2238.317383', '1154.191406', '59.692127', '0', '10000', '1500', 0),
(39, '-2238.316406', '1135.846680', '67.260796', '0', '10000', '1500', 0),
(40, '-2238.318359', '1117.546875', '74.819305', '0', '10000', '1500', 0),
(41, '-2227.966797', '1108.045898', '80.007812', '0', '10000', '1500', 0),
(42, '-2208.163086', '1108.046875', '80.007812', '0', '10000', '1500', 0),
(43, '-2188.065430', '1108.048828', '80.007812', '0', '10000', '1500', 0),
(44, '-2168.166016', '1108.046875', '80.007812', '0', '10000', '1500', 0),
(45, '-2158.360352', '1117.635742', '74.486465', '0', '10000', '1500', 0),
(46, '-2158.360352', '1148.722656', '61.849232', '0', '10000', '1500', 0),
(47, '-2172.815430', '1163.746094', '55.726562', '0', '10000', '1500', 0),
(48, '-2189.307617', '1163.747070', '55.726562', '0', '10000', '1500', 0),
(49, '-2205.858398', '1163.749023', '55.726562', '0', '10000', '1500', 0),
(50, '-2222.311523', '1163.746094', '55.726562', '0', '10000', '1500', 0),
(51, '-2280.840820', '1149.306641', '61.609375', '0', '10000', '1500', 0),
(52, '-2280.839844', '1131.033203', '69.226562', '0', '10000', '1500', 0),
(53, '-2280.840820', '1112.595703', '76.984375', '0', '10000', '1500', 0),
(54, '-2282.424805', '1089.012695', '80.406105', '0', '10000', '1500', 0),
(55, '-2282.420898', '1070.318359', '81.703140', '0', '10000', '1500', 0),
(56, '-2282.420898', '1046.717773', '84.120750', '0', '10000', '1500', 0),
(57, '-2282.420898', '1023.058594', '84.112869', '0', '10000', '1500', 0),
(58, '-2282.418945', '979.208008', '70.816032', '0', '10000', '1500', 0),
(59, '-2295.030273', '969.981445', '65.335808', '0', '10000', '1500', 0),
(60, '-2282.418945', '999.503906', '79.253983', '0', '10000', '1500', 0),
(61, '2488.393555', '11.762695', '28.441643', '0', '15000', '2250', 0),
(62, '2509.513672', '11.760742', '28.441645', '0', '15000', '2250', 0),
(63, '2551.222656', '57.161133', '27.675646', '0', '15000', '2250', 0),
(64, '2438.794922', '-54.964844', '28.153549', '0', '15000', '2250', 0),
(65, '2367.331055', '-49.125977', '28.153547', '0', '15000', '2250', 0),
(66, '2157.153320', '-1072.408203', '40.496204', '0', '10000', '1500', 0),
(67, '2049.090820', '-987.279297', '44.979874', '0', '10000', '1500', 0),
(68, '2122.060547', '-970.278320', '58.207432', '0', '10000', '1500', 0),
(69, '2131.941406', '-974.049805', '59.785557', '0', '10000', '1500', 0),
(70, '2142.699219', '-978.115234', '61.379307', '0', '10000', '1500', 0),
(71, '2154.106445', '-979.920898', '63.293369', '0', '10000', '1500', 0),
(72, '-2623.432617', '-99.344727', '7.203125', '0', '20000', '3000', 0),
(73, '-2625.849609', '-105.285156', '7.203125', '0', '20000', '3000', 0),
(74, '-2622.361328', '-112.371094', '4.342579', '0', '20000', '3000', 0),
(75, '-2620.715820', '-120.211914', '7.203125', '0', '20000', '3000', 0),
(76, '-2621.015625', '-134.698242', '5', '0', '20000', '3000', 0),
(77, '-2620.753906', '-146.212891', '7.203125', '0', '20000', '3000', 0),
(78, '-2625.848633', '-162.411133', '7.203125', '0', '20000', '3000', 0),
(79, '-2622.359375', '-169.473633', '4.342579', '0', '20000', '3000', 0),
(80, '-2621.010742', '-173.266602', '5', '0', '20000', '3000', 0),
(81, '-2620.770508', '-185.897461', '7.203125', '0', '20000', '3000', 0),
(82, '-2625.842773', '-191.002930', '7.203125', '0', '20000', '3000', 0),
(83, '-2622.352539', '-198.126953', '4.335938', '0', '20000', '3000', 0),
(84, '-127.425781', '974.503906', '19.851562', '0', '10000', '1500', 0),
(85, '-92.625000', '970.012695', '19.981564', '0', '10000', '1500', 0),
(86, '-66.957031', '971.505859', '19.886629', '0', '10000', '1500', 0),
(87, '-151.166016', '933.981445', '19.723057', '0', '10000', '1500', 0),
(88, '-153.221680', '907.105469', '19.301182', '0', '10000', '1500', 0),
(89, '-152.528320', '881.812500', '18.440250', '0', '10000', '1500', 0),
(90, '-123.082031', '874.794922', '18.730869', '0', '10000', '1500', 0),
(91, '-121.031250', '857.509766', '18.582432', '0', '10000', '1500', 0),
(92, '-91.944336', '887.095703', '21.254307', '0', '10000', '1500', 0),
(93, '-123.461914', '917.743164', '19.956699', '0', '10000', '1500', 0),
(94, '-86.680664', '915.734375', '21.104042', '0', '10000', '1500', 0),
(95, '-83.051758', '933.128906', '20.692860', '0', '10000', '1500', 0),
(96, '-56.459961', '935.258789', '21.207432', '0', '10000', '1500', 0),
(97, '-54.646484', '918.719727', '22.371494', '0', '10000', '1500', 0),
(98, '-52.920898', '894.157227', '22.387119', '0', '10000', '1500', 0),
(99, '-15.369141', '934.292969', '21.105869', '0', '10000', '1500', 0),
(100, '17.852539', '908.982422', '23.957237', '0', '10000', '1500', 0),
(101, '31.410156', '923.849609', '23.600859', '0', '10000', '1500', 0),
(102, '20.699219', '948.829102', '20.316807', '0', '10000', '1500', 0),
(103, '-4.132812', '950.990234', '19.703125', '0', '10000', '1500', 0),
(104, '22.740234', '968.134766', '19.838314', '0', '10000', '1500', 0),
(105, '-12.840820', '974.893555', '19.797388', '0', '10000', '1500', 0),
(106, '-37.681641', '962.466797', '20.051182', '0', '10000', '1500', 0),
(107, '1921.743164', '2665.195312', '10.820312', '0', '35000', '5250', 0),
(108, '1950.599609', '2664.665039', '11.298933', '0', '35000', '5250', 0),
(109, '1969.660156', '2664.507812', '10.820312', '0', '35000', '5250', 0),
(110, '1989.185547', '2665.192383', '10.820312', '0', '35000', '5250', 0),
(111, '2017.981445', '2664.665039', '11.298933', '0', '35000', '5250', 0),
(112, '2037.097656', '2664.504883', '10.820312', '0', '35000', '5250', 0),
(113, '2056.558594', '2665.195312', '10.820312', '0', '35000', '5250', 0),
(114, '2533.955078', '997.625977', '14.272457', '0', '10000', '1500', 0),
(115, '2473.953125', '997.632812', '14.272459', '0', '10000', '1500', 0),
(116, '2440.832031', '968.847656', '14.272459', '0', '10000', '1500', 0),
(117, '2500.831055', '968.822266', '14.272457', '0', '10000', '1500', 0),
(118, '1549.360352', '2125.553711', '11.460938', '0', '35000', '5250', 0),
(119, '1550.266602', '2096.368164', '11.460938', '0', '35000', '5250', 0),
(120, '1554.358398', '2074.052734', '11.359375', '0', '35000', '5250', 0),
(121, '1298.474609', '-797.987305', '84.140625', '0', '2500000', '375000', 0),
(122, '1496.825195', '-666.739258', '95.601257', '0', '1000000', '150000', 0);

-- --------------------------------------------------------

--
-- Table structure for table `tents`
--

CREATE TABLE `tents` (
  `ID` int NOT NULL,
  `pos_x` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `pos_y` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `pos_z` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `pos_rot_z` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `character_owner_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `trophy_timer`
--

CREATE TABLE `trophy_timer` (
  `ID` int NOT NULL,
  `character_owner_id` int NOT NULL,
  `trophyTimer` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `trophyID` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `vehicles`
--

CREATE TABLE `vehicles` (
  `ID` int NOT NULL,
  `owner_character_id` int NOT NULL,
  `model` int NOT NULL,
  `exploded` int NOT NULL DEFAULT '0',
  `parkstatus` int NOT NULL DEFAULT '0',
  `fuel` int NOT NULL DEFAULT '100',
  `color` varchar(255) NOT NULL DEFAULT '0|0|0',
  `tunings` longtext NOT NULL,
  `special_engine` int NOT NULL DEFAULT '0',
  `x` varchar(255) NOT NULL DEFAULT '0',
  `y` varchar(255) NOT NULL DEFAULT '0',
  `z` varchar(255) NOT NULL DEFAULT '0',
  `rotz` varchar(255) NOT NULL DEFAULT '0',
  `kilometre` varchar(255) NOT NULL DEFAULT '0',
  `trunk` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `weeklytasks`
--

CREATE TABLE `weeklytasks` (
  `ID` int NOT NULL,
  `character_id` int NOT NULL,
  `task` int NOT NULL,
  `status` int NOT NULL,
  `progress_data` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `account_bans`
--
ALTER TABLE `account_bans`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `bonuscodes`
--
ALTER TABLE `bonuscodes`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `characters`
--
ALTER TABLE `characters`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `character_stats`
--
ALTER TABLE `character_stats`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `chest_vehicles`
--
ALTER TABLE `chest_vehicles`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `collectible_pickups`
--
ALTER TABLE `collectible_pickups`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `colonyareas`
--
ALTER TABLE `colonyareas`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `colonybuildings`
--
ALTER TABLE `colonybuildings`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `colonys`
--
ALTER TABLE `colonys`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `colony_bonus_timer`
--
ALTER TABLE `colony_bonus_timer`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `colony_missions`
--
ALTER TABLE `colony_missions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `colony_mission_collects`
--
ALTER TABLE `colony_mission_collects`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `colony_warehouse`
--
ALTER TABLE `colony_warehouse`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `colony_zombies`
--
ALTER TABLE `colony_zombies`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `dailylogin`
--
ALTER TABLE `dailylogin`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `dailytasks`
--
ALTER TABLE `dailytasks`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `fabrikwars`
--
ALTER TABLE `fabrikwars`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `factoryfights`
--
ALTER TABLE `factoryfights`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `garages`
--
ALTER TABLE `garages`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `generators`
--
ALTER TABLE `generators`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `halloween_data`
--
ALTER TABLE `halloween_data`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `logs`
--
ALTER TABLE `logs`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `market`
--
ALTER TABLE `market`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `objects`
--
ALTER TABLE `objects`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `offlinemessages`
--
ALTER TABLE `offlinemessages`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `oven`
--
ALTER TABLE `oven`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `plants`
--
ALTER TABLE `plants`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `player_notepad`
--
ALTER TABLE `player_notepad`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `player_questseries`
--
ALTER TABLE `player_questseries`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `player_weapons`
--
ALTER TABLE `player_weapons`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `prestige`
--
ALTER TABLE `prestige`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `questseries`
--
ALTER TABLE `questseries`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `server_event_data`
--
ALTER TABLE `server_event_data`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `shelter`
--
ALTER TABLE `shelter`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `tents`
--
ALTER TABLE `tents`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `trophy_timer`
--
ALTER TABLE `trophy_timer`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `vehicles`
--
ALTER TABLE `vehicles`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `weeklytasks`
--
ALTER TABLE `weeklytasks`
  ADD PRIMARY KEY (`ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accounts`
--
ALTER TABLE `accounts`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `account_bans`
--
ALTER TABLE `account_bans`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `characters`
--
ALTER TABLE `characters`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `character_stats`
--
ALTER TABLE `character_stats`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `chest_vehicles`
--
ALTER TABLE `chest_vehicles`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `collectible_pickups`
--
ALTER TABLE `collectible_pickups`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `colonybuildings`
--
ALTER TABLE `colonybuildings`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `colonys`
--
ALTER TABLE `colonys`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `colony_bonus_timer`
--
ALTER TABLE `colony_bonus_timer`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=71;

--
-- AUTO_INCREMENT for table `colony_missions`
--
ALTER TABLE `colony_missions`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `colony_mission_collects`
--
ALTER TABLE `colony_mission_collects`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `colony_warehouse`
--
ALTER TABLE `colony_warehouse`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `colony_zombies`
--
ALTER TABLE `colony_zombies`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `dailylogin`
--
ALTER TABLE `dailylogin`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `dailytasks`
--
ALTER TABLE `dailytasks`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `fabrikwars`
--
ALTER TABLE `fabrikwars`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `garages`
--
ALTER TABLE `garages`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `halloween_data`
--
ALTER TABLE `halloween_data`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `logs`
--
ALTER TABLE `logs`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `objects`
--
ALTER TABLE `objects`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `offlinemessages`
--
ALTER TABLE `offlinemessages`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `oven`
--
ALTER TABLE `oven`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `plants`
--
ALTER TABLE `plants`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `player_notepad`
--
ALTER TABLE `player_notepad`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `player_questseries`
--
ALTER TABLE `player_questseries`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `player_weapons`
--
ALTER TABLE `player_weapons`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `questseries`
--
ALTER TABLE `questseries`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `server_event_data`
--
ALTER TABLE `server_event_data`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `shelter`
--
ALTER TABLE `shelter`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=123;

--
-- AUTO_INCREMENT for table `tents`
--
ALTER TABLE `tents`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `trophy_timer`
--
ALTER TABLE `trophy_timer`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `vehicles`
--
ALTER TABLE `vehicles`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `weeklytasks`
--
ALTER TABLE `weeklytasks`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
