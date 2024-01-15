CREATE TABLE IF NOT EXISTS `Zeta_bank` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `identifier` VARCHAR(46),
  `type` VARCHAR(50),
  `amount` INT,
  `timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `items` (name, label, weight) VALUES
	('cartadicredito', 'Carta di credito', 0)
;
