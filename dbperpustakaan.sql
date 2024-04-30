-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 09, 2024 at 08:56 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `dbperpustakaan`
--

-- --------------------------------------------------------

--
-- Table structure for table `akun`
--

CREATE TABLE `akun` (
  `id` int(5) NOT NULL,
  `nama` varchar(256) NOT NULL,
  `email` text NOT NULL,
  `password` varchar(32) NOT NULL,
  `tanggal_masuk` date NOT NULL DEFAULT current_timestamp(),
  `tanggal_lahir` date DEFAULT NULL,
  `gambar` varchar(256) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `akun`
--

INSERT INTO `akun` (`id`, `nama`, `email`, `password`, `tanggal_masuk`, `tanggal_lahir`, `gambar`) VALUES
(14, 'Kelvin Riyanto', 'penguin555.kr@gmail.com', 'Hello', '2023-12-30', '1985-01-09', '659ce2a5b6d3f.png');

-- --------------------------------------------------------

--
-- Table structure for table `buku`
--

CREATE TABLE `buku` (
  `gambar` varchar(256) NOT NULL,
  `ISBN` int(11) NOT NULL,
  `judulBuku` varchar(256) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `buku`
--

INSERT INTO `buku` (`gambar`, `ISBN`, `judulBuku`) VALUES
('65990dec35838.png', 123121, 'Crime And Punishment'),
('65990df127498.png', 123122, 'Crime And Punishment'),
('65990de7b520e.png', 123124, 'Crime And Punishment'),
('65990deead332.png', 123125, 'Crime And Punishment'),
('65990e43ea882.png', 123126, 'Crime And Punishment'),
('65990d7ba8ade.png', 1231234, 'Crime and Punishment'),
('65990dba90734.png', 1231236, 'Crime and Punishment'),
('659cf3835c09f.png', 12312333, 'Mihi'),
('65990f15889ea.png', 12314513, 'Crime And Punishment'),
('65990f4f90a12.png', 12341231, 'Crime And Punishment'),
('65990f4953cd0.png', 12341232, 'Crime And Punishment'),
('65990f55cb210.png', 12341238, 'Crime And Punishment'),
('659910af4208d.png', 123121231, 'Gambler\'s choice'),
('659c276e97b5a.png', 1231231222, 'Mihaly');

-- --------------------------------------------------------

--
-- Table structure for table `pinjamkembali`
--

CREATE TABLE `pinjamkembali` (
  `idPinjam` int(5) NOT NULL,
  `ISBN` int(11) NOT NULL,
  `namaPeminjam` varchar(128) NOT NULL,
  `tanggalPeminjaman` date NOT NULL DEFAULT current_timestamp(),
  `tanggalPengembalian` date DEFAULT NULL,
  `penalty` tinyint(1) NOT NULL DEFAULT 0,
  `selesai` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pinjamkembali`
--

INSERT INTO `pinjamkembali` (`idPinjam`, `ISBN`, `namaPeminjam`, `tanggalPeminjaman`, `tanggalPengembalian`, `penalty`, `selesai`) VALUES
(1016, 123124, 'Kelvin Riyanto', '2024-01-09', '2024-01-09', 0, 1),
(1019, 123121, 'Kelvin Riyanto', '2024-01-01', '2024-01-09', 1, 1),
(1023, 12312333, 'kajsdsa', '2024-01-09', NULL, 0, 0),
(1024, 123121, 'Kelin', '2024-01-09', '2024-01-09', 0, 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `akun`
--
ALTER TABLE `akun`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `buku`
--
ALTER TABLE `buku`
  ADD PRIMARY KEY (`ISBN`);

--
-- Indexes for table `pinjamkembali`
--
ALTER TABLE `pinjamkembali`
  ADD PRIMARY KEY (`idPinjam`),
  ADD KEY `idx_isbn` (`ISBN`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `akun`
--
ALTER TABLE `akun`
  MODIFY `id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `buku`
--
ALTER TABLE `buku`
  MODIFY `ISBN` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1231231223;

--
-- AUTO_INCREMENT for table `pinjamkembali`
--
ALTER TABLE `pinjamkembali`
  MODIFY `idPinjam` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1025;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `pinjamkembali`
--
ALTER TABLE `pinjamkembali`
  ADD CONSTRAINT `fk_buku` FOREIGN KEY (`ISBN`) REFERENCES `buku` (`ISBN`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
