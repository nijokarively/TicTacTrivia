-- phpMyAdmin SQL Dump
-- version 4.7.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Apr 23, 2018 at 03:30 AM
-- Server version: 10.1.25-MariaDB
-- PHP Version: 5.6.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `trivia`
--

-- --------------------------------------------------------

--
-- Table structure for table `gameMove`
--

CREATE TABLE `gameMove` (
  `gameID` int(11) NOT NULL,
  `positionP1` int(3) NOT NULL DEFAULT '-10',
  `positionP2` int(3) NOT NULL DEFAULT '-10'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `gameMove`
--

INSERT INTO `gameMove` (`gameID`, `positionP1`, `positionP2`) VALUES
(1, 0, 0),
(19, -10, -10),
(20, -10, -10),
(21, -10, -10),
(22, -10, -10),
(24, -10, -10),
(25, -10, -10),
(26, -10, -10),
(27, -10, 5),
(28, 0, 6),
(29, 15, 6),
(31, -10, -10),
(32, 3, 7),
(33, -1, 14),
(34, -1, -1),
(35, -1, -1),
(36, 10, 9),
(37, 12, -1),
(38, -1, -10),
(39, 0, -10),
(40, 0, -10),
(41, -1, -10),
(42, 2, -1),
(43, -2, -1),
(44, -6, -6),
(45, -9, 11),
(46, 8, 13),
(47, 5, 3),
(48, -3, 15),
(49, -4, 3),
(50, -10, -10),
(51, -10, -10),
(52, -2, 0),
(53, -1, -1),
(54, -999, -999),
(55, -999, 5),
(56, -10, -10),
(57, -10, -10),
(62, 13, -999),
(63, -2, -999),
(65, -10, -10),
(66, -1, -1),
(67, -1, 9),
(68, -999, -1),
(69, -999, -10),
(70, -999, 5),
(71, 0, -999),
(72, -10, -10),
(73, -999, 1);

-- --------------------------------------------------------

--
-- Table structure for table `gameSession`
--

CREATE TABLE `gameSession` (
  `sessionID` int(11) NOT NULL,
  `p1Name` varchar(20) NOT NULL,
  `p2Name` varchar(20) NOT NULL,
  `sessionActive` tinyint(1) NOT NULL,
  `sessionFull` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `gameSession`
--

INSERT INTO `gameSession` (`sessionID`, `p1Name`, `p2Name`, `sessionActive`, `sessionFull`) VALUES
(4, 'Ale', 'Nijo', 1, 1),
(5, 'Nijo', 'rrr', 1, 1),
(6, 'eer', '', 1, 1),
(7, '1111111', '', 1, 1),
(8, 'Empty', '', 1, 1),
(9, 'Empty', 'Empty', 1, 1),
(10, 'Empty', '', 1, 1),
(11, 'Empty', '', 1, 1),
(12, 'test1', 'test2', 1, 1),
(13, 'Empty', 'Empty', 1, 1),
(14, 'Sandra', 'Alex', 1, 1),
(15, 'Nijo', 'Ale', 1, 1),
(16, 'Rhys', 'Nijo', 1, 1),
(17, 'james', 'Jack', 1, 1),
(18, 'sdfsdf', 'sdfsdfsdfsdfsdfsfs', 1, 1),
(19, 'Anonymous', 'Anonymous', 1, 1),
(20, 'jj', 'tj', 1, 1),
(21, 'Anonymous', 'Anonymous', 1, 1),
(22, 'Anonymous', 'Anonymous', 1, 1),
(24, 'Anonymous', 'Anonymous', 1, 1),
(25, 'Anonymous', 'Anonymous', 1, 1),
(26, 'Anonymous', 'Anonymous', 1, 1),
(27, 'Anonymous', 'Anonymous', 1, 1),
(28, 'Anonymous', 'Anonymous', 1, 1),
(29, 'Anonymous', 'Anonymous', 1, 1),
(31, 'Anonymous', 'Anonymous', 1, 1),
(32, 'Anonymous', 'Anonymous', 1, 1),
(33, 'Anonymous', 'Anonymous', 1, 1),
(34, 'Anonymous', 'Anonymous', 1, 1),
(35, 'Anonymous', 'Anonymous', 1, 1),
(36, 'Anonymous', 'Anonymous', 1, 1),
(37, 'Anonymous', 'Anonymous', 1, 1),
(38, 'Anonymous', 'Anonymous', 1, 1),
(39, 'aaaa', 'bbbbb', 1, 1),
(40, 'Anonymous', 'Anonymous', 1, 1),
(41, 'aaaa', 'ssss', 1, 1),
(42, 'Anonymous', 'Anonymous', 1, 1),
(43, 'Anonymous', 'Anonymous', 1, 1),
(44, 'Anonymous', 'Anonymous', 1, 1),
(45, 'Anonymous', 'Anonymous', 1, 1),
(46, 'Anonymous', 'Anonymous', 1, 1),
(47, 'Anonymous', 'Anonymous', 1, 1),
(48, 'James', 'Ken', 1, 1),
(49, 'Ken', 'James', 1, 1),
(50, 'James', 'Ken', 1, 1),
(51, 'Anonymous', 'Anonymous', 1, 1),
(52, 'Anonymous', 'Anonymous', 1, 1),
(53, 'Anonymous', 'Anonymous', 1, 1),
(54, 'Anonymous', 'Anonymous', 1, 1),
(55, 'Anonymous', 'Anonymous', 1, 1),
(56, 'Anonymous', 'Anonymous', 1, 1),
(57, 'Anonymous', '', 1, 1),
(62, 'Anonymous', 'Anonymous', 1, 1),
(63, 'Anonymous', 'Anonymous', 1, 1),
(65, 'Anonymous', 'AnonymousA6B5E701-93', 1, 1),
(66, 'AnonymousA6B5E701-93', 'AnonymousE6F6A34A-99', 1, 1),
(67, 'AnonA6B', 'AnonE6F', 1, 1),
(68, 'AnonE6F6', 'AnonA6B5', 1, 1),
(69, 'AnonA6B5', 'AnonE6F6', 1, 1),
(70, 'dfghj', 'AnonE6F6', 1, 1),
(71, 'AnonE6F6', 'AnonA6B5', 1, 1),
(72, 'Player1', 'AnonE6F6', 1, 1),
(73, 'AnonE6F6', 'Player1', 1, 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `gameMove`
--
ALTER TABLE `gameMove`
  ADD PRIMARY KEY (`gameID`),
  ADD UNIQUE KEY `gameID` (`gameID`);

--
-- Indexes for table `gameSession`
--
ALTER TABLE `gameSession`
  ADD PRIMARY KEY (`sessionID`),
  ADD UNIQUE KEY `sessionID` (`sessionID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `gameSession`
--
ALTER TABLE `gameSession`
  MODIFY `sessionID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=74;COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
