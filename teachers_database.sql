-- phpMyAdmin SQL Dump
-- version 5.1.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Oct 04, 2024 at 03:27 AM
-- Server version: 5.7.36
-- PHP Version: 8.1.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `teachers_database`
--

-- --------------------------------------------------------

--
-- Table structure for table `atividade`
--

CREATE TABLE `atividade` (
  `id` int(11) NOT NULL,
  `nome` varchar(50) NOT NULL,
  `descricao` varchar(300) NOT NULL,
  `id_professor` int(11) DEFAULT NULL,
  `id_turma` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `atividade`
--

INSERT INTO `atividade` (`id`, `nome`, `descricao`, `id_professor`, `id_turma`) VALUES
(1, 'Introdução Python', 'Fazer o primeiro programa em Python.', 1, 1),
(2, 'CRUD', 'Desenvolver um sistema CRUD.', 1, 1),
(3, 'Banco de dados', 'Criar um banco de dados e popular as tabelas.', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `professor`
--

CREATE TABLE `professor` (
  `id` int(11) NOT NULL,
  `nome` varchar(50) NOT NULL,
  `id_usuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `professor`
--

INSERT INTO `professor` (`id`, `nome`, `id_usuario`) VALUES
(1, 'Daniel', 1),
(2, 'Camila', 2),
(3, 'Cristina', 3);

-- --------------------------------------------------------

--
-- Table structure for table `turma`
--

CREATE TABLE `turma` (
  `id` int(11) NOT NULL,
  `nome` varchar(50) NOT NULL,
  `id_professor` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `turma`
--

INSERT INTO `turma` (`id`, `nome`, `id_professor`) VALUES
(1, 'Análise e Desenvolvimento de Sistemas', 1),
(2, 'Logística', 2),
(3, 'Robótica', 3);

-- --------------------------------------------------------

--
-- Table structure for table `usuario`
--

CREATE TABLE `usuario` (
  `id` int(11) NOT NULL,
  `email` varchar(50) DEFAULT NULL,
  `senha` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `usuario`
--

INSERT INTO `usuario` (`id`, `email`, `senha`) VALUES
(1, 'daniel@email.com', '1234'),
(2, 'camila@email.com', '1234'),
(3, 'cristina@email.com', '1234');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `atividade`
--
ALTER TABLE `atividade`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_professor` (`id_professor`),
  ADD KEY `id_turma` (`id_turma`);

--
-- Indexes for table `professor`
--
ALTER TABLE `professor`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Indexes for table `turma`
--
ALTER TABLE `turma`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_professor` (`id_professor`);

--
-- Indexes for table `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `atividade`
--
ALTER TABLE `atividade`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `professor`
--
ALTER TABLE `professor`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `turma`
--
ALTER TABLE `turma`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `atividade`
--
ALTER TABLE `atividade`
  ADD CONSTRAINT `atividade_ibfk_1` FOREIGN KEY (`id_professor`) REFERENCES `professor` (`id`),
  ADD CONSTRAINT `atividade_ibfk_2` FOREIGN KEY (`id_turma`) REFERENCES `turma` (`id`);

--
-- Constraints for table `professor`
--
ALTER TABLE `professor`
  ADD CONSTRAINT `professor_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id`);

--
-- Constraints for table `turma`
--
ALTER TABLE `turma`
  ADD CONSTRAINT `turma_ibfk_1` FOREIGN KEY (`id_professor`) REFERENCES `professor` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
