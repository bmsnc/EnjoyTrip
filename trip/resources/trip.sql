-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema trip
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema trip
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `trip` DEFAULT CHARACTER SET utf8mb3 ;
USE `trip` ;

-- -----------------------------------------------------
-- Table `trip`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `trip`.`user` ;

CREATE TABLE IF NOT EXISTS `trip`.`user` (
  `user_id` VARCHAR(20) NOT NULL,
  `user_pw` VARCHAR(20) NOT NULL,
  `user_name` VARCHAR(30) NOT NULL,
  `user_email` VARCHAR(30) NOT NULL,
  `user_domain` VARCHAR(30) NOT NULL,
  `register_time` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `role` VARCHAR(10) NULL DEFAULT 'user',
  PRIMARY KEY (`user_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `trip`.`follower`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `trip`.`follower` ;

CREATE TABLE IF NOT EXISTS `trip`.`follower` (
  `user_id` VARCHAR(20) NOT NULL,
  `follower_id` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`user_id`, `follower_id`),
  INDEX `follow_to_user_follow_id_fk_idx` (`follower_id` ASC) VISIBLE,
  CONSTRAINT `follow_to_user_follow_id_fk`
    FOREIGN KEY (`follower_id`)
    REFERENCES `trip`.`user` (`user_id`)
    ON DELETE CASCADE,
  CONSTRAINT `follow_to_user_user_id_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `trip`.`user` (`user_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `trip`.`following`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `trip`.`following` ;

CREATE TABLE IF NOT EXISTS `trip`.`following` (
  `user_id` VARCHAR(20) NOT NULL,
  `following_id` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`user_id`, `following_id`),
  INDEX `follow_to_user_follow_id_fk_idx` (`following_id` ASC) VISIBLE,
  CONSTRAINT `follow_to_user_follow_id_fk0`
    FOREIGN KEY (`following_id`)
    REFERENCES `trip`.`user` (`user_id`)
    ON DELETE CASCADE,
  CONSTRAINT `follow_to_user_user_id_fk0`
    FOREIGN KEY (`user_id`)
    REFERENCES `trip`.`user` (`user_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `trip`.`travel_plan`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `trip`.`travel_plan` ;

CREATE TABLE IF NOT EXISTS `trip`.`travel_plan` (
  `plan_id` INT NOT NULL AUTO_INCREMENT,
  `user_id` VARCHAR(20) NOT NULL,
  `title` VARCHAR(200) NOT NULL,
  `content` VARCHAR(500) NOT NULL,
  `register_time` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `like` INT NULL DEFAULT '0',
  `hit` INT NULL DEFAULT '0',
  `start_date` VARCHAR(100) NOT NULL,
  `end_date` VARCHAR(100) NOT NULL,
  `store` VARCHAR(10) NULL DEFAULT 'NO',
  PRIMARY KEY (`plan_id`),
  INDEX `travel_plan_to_user_user_id_fk_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `travel_plan_to_user_user_id_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `trip`.`user` (`user_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 101
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `trip`.`travel_review`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `trip`.`travel_review` ;

CREATE TABLE IF NOT EXISTS `trip`.`travel_review` (
  `review_id` INT NOT NULL AUTO_INCREMENT,
  `user_id` VARCHAR(20) NOT NULL,
  `title` VARCHAR(200) NOT NULL,
  `content` VARCHAR(500) NOT NULL,
  `register_time` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `plan_id` INT NULL DEFAULT NULL,
  `like` INT NULL DEFAULT NULL,
  `hit` INT NULL DEFAULT NULL,
  `first_image` VARCHAR(300) NULL DEFAULT NULL,
  PRIMARY KEY (`review_id`),
  INDEX `travel_review_to_user_user_id_fk_idx` (`user_id` ASC) VISIBLE,
  INDEX `travel_review_to_travel_plan_plan_id_fk_idx` (`plan_id` ASC) VISIBLE,
  CONSTRAINT `travel_review_to_travel_plan_plan_id_fk`
    FOREIGN KEY (`plan_id`)
    REFERENCES `trip`.`travel_plan` (`plan_id`)
    ON DELETE CASCADE,
  CONSTRAINT `travel_review_to_user_user_id_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `trip`.`user` (`user_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `trip`.`image`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `trip`.`image` ;

CREATE TABLE IF NOT EXISTS `trip`.`image` (
  `image_id` INT NOT NULL AUTO_INCREMENT,
  `review_id` INT NOT NULL,
  `image_name` VARCHAR(150) NULL DEFAULT NULL,
  `image_path` VARCHAR(300) NULL DEFAULT NULL,
  PRIMARY KEY (`image_id`, `review_id`),
  INDEX `image_to_travel_review_review_id_fk_idx` (`review_id` ASC) VISIBLE,
  CONSTRAINT `image_to_travel_review_review_id_fk`
    FOREIGN KEY (`review_id`)
    REFERENCES `trip`.`travel_review` (`review_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `trip`.`notice`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `trip`.`notice` ;

CREATE TABLE IF NOT EXISTS `trip`.`notice` (
  `notice_id` INT NOT NULL AUTO_INCREMENT,
  `user_id` VARCHAR(20) NOT NULL,
  `title` VARCHAR(200) NOT NULL,
  `content` VARCHAR(500) NOT NULL,
  `register_time` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `hit` INT NULL DEFAULT NULL,
  PRIMARY KEY (`notice_id`),
  INDEX `notice_to_user_user_id_fk_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `notice_to_user_user_id_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `trip`.`user` (`user_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `trip`.`place_info`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `trip`.`place_info` ;

CREATE TABLE IF NOT EXISTS `trip`.`place_info` (
  `place_id` VARCHAR(300) NOT NULL,
  `formatted_address` VARCHAR(300) NULL DEFAULT NULL,
  `formatted_phone_number` VARCHAR(300) NULL DEFAULT NULL,
  `url` VARCHAR(300) NULL DEFAULT NULL,
  `name` VARCHAR(300) NULL DEFAULT NULL,
  `international_phone_number` VARCHAR(300) NULL DEFAULT NULL,
  `photoreference` VARCHAR(300) NULL DEFAULT NULL,
  `overview` VARCHAR(300) NULL DEFAULT NULL,
  PRIMARY KEY (`place_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `trip`.`plan_comment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `trip`.`plan_comment` ;

CREATE TABLE IF NOT EXISTS `trip`.`plan_comment` (
  `comment_id` INT NOT NULL AUTO_INCREMENT,
  `plan_id` INT NOT NULL,
  `user_id` VARCHAR(20) NULL DEFAULT NULL,
  `content` VARCHAR(45) NULL DEFAULT NULL,
  `register_time` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `like` INT NULL DEFAULT '0',
  PRIMARY KEY (`comment_id`, `plan_id`),
  INDEX `plan_comment_to_user_user_id_fk_idx` (`user_id` ASC) VISIBLE,
  INDEX `plan_comment_to_travel_plan_plan_id_fk` (`plan_id` ASC) VISIBLE,
  CONSTRAINT `plan_comment_to_travel_plan_plan_id_fk`
    FOREIGN KEY (`plan_id`)
    REFERENCES `trip`.`travel_plan` (`plan_id`)
    ON DELETE CASCADE,
  CONSTRAINT `plan_comment_to_user_user_id_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `trip`.`user` (`user_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 9
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `trip`.`plan_comment_like`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `trip`.`plan_comment_like` ;

CREATE TABLE IF NOT EXISTS `trip`.`plan_comment_like` (
  `comment_id` INT NOT NULL,
  `user_id` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`comment_id`, `user_id`),
  INDEX `plan_comment_like_to_ user_user_id_fk_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `plan_comment_like_to_ plan_comment_comment_id_fk`
    FOREIGN KEY (`comment_id`)
    REFERENCES `trip`.`plan_comment` (`comment_id`)
    ON DELETE CASCADE,
  CONSTRAINT `plan_comment_like_to_ user_user_id_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `trip`.`user` (`user_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `trip`.`plan_like`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `trip`.`plan_like` ;

CREATE TABLE IF NOT EXISTS `trip`.`plan_like` (
  `plan_id` INT NOT NULL,
  `user_id` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`plan_id`, `user_id`),
  INDEX `user_id_to_user_user_id_fk_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `plan_like_to_travel_plan_plan_id_fk`
    FOREIGN KEY (`plan_id`)
    REFERENCES `trip`.`travel_plan` (`plan_id`)
    ON DELETE CASCADE,
  CONSTRAINT `user_id_to_user_user_id_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `trip`.`user` (`user_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `trip`.`plan_place_info`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `trip`.`plan_place_info` ;

CREATE TABLE IF NOT EXISTS `trip`.`plan_place_info` (
  `plan_id` INT NOT NULL,
  `place_id` VARCHAR(100) NOT NULL,
  `sequence` INT NOT NULL,
  PRIMARY KEY (`plan_id`, `sequence`),
  INDEX `plan_info_to_travel_plan_plan_id_fk_idx` (`plan_id` ASC) VISIBLE,
  INDEX `plan_info_to_search_info_place_id_fk_idx` (`place_id` ASC) VISIBLE,
  CONSTRAINT `plan_info_to_search_info_place_id_fk`
    FOREIGN KEY (`place_id`)
    REFERENCES `trip`.`place_info` (`place_id`),
  CONSTRAINT `plan_info_to_travel_plan_plan_id_fk`
    FOREIGN KEY (`plan_id`)
    REFERENCES `trip`.`travel_plan` (`plan_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `trip`.`plan_plane`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `trip`.`plan_plane` ;

CREATE TABLE IF NOT EXISTS `trip`.`plan_plane` (
  `plan_id` INT NOT NULL,
  `sequence` INT NOT NULL,
  `departure` VARCHAR(300) NULL DEFAULT NULL,
  `arrival` VARCHAR(300) NULL DEFAULT NULL,
  `price` VARCHAR(300) NULL DEFAULT NULL,
  `carrierCode` VARCHAR(300) NULL DEFAULT NULL,
  `numberOfBookableSeats` VARCHAR(300) NULL DEFAULT NULL,
  `numberOfStops` VARCHAR(300) NULL DEFAULT NULL,
  `start` VARCHAR(300) NULL,
  `end` VARCHAR(300) NULL,
  `plan_planecol` VARCHAR(45) NULL,
  PRIMARY KEY (`plan_id`, `sequence`),
  INDEX `plan_plane_to_travel_plan_fk_plan_id_idx` (`plan_id` ASC) VISIBLE,
  CONSTRAINT `plan_plane_to_travel_plan_fk_plan_id`
    FOREIGN KEY (`plan_id`)
    REFERENCES `trip`.`travel_plan` (`plan_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `trip`.`plan_route`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `trip`.`plan_route` ;

CREATE TABLE IF NOT EXISTS `trip`.`plan_route` (
  `plan_id` INT NOT NULL,
  `sequence` INT NOT NULL,
  `idx` INT NOT NULL,
  `formatted_address` VARCHAR(300) NULL DEFAULT NULL,
  `place_id` VARCHAR(300) NULL DEFAULT NULL,
  `url` VARCHAR(300) NULL DEFAULT NULL,
  `photo` VARCHAR(300) NULL DEFAULT NULL,
  PRIMARY KEY (`plan_id`, `sequence`, `idx`),
  CONSTRAINT `plan_route_to_travel_plan_fk_plan_id`
    FOREIGN KEY (`plan_id`)
    REFERENCES `trip`.`travel_plan` (`plan_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `trip`.`review_comment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `trip`.`review_comment` ;

CREATE TABLE IF NOT EXISTS `trip`.`review_comment` (
  `comment_id` INT NOT NULL AUTO_INCREMENT,
  `review_id` INT NOT NULL,
  `user_id` VARCHAR(20) NULL DEFAULT NULL,
  `content` VARCHAR(45) NULL DEFAULT NULL,
  `register_time` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `like` INT NULL DEFAULT '0',
  PRIMARY KEY (`comment_id`, `review_id`),
  INDEX `review_comment_to_user_user_id_fk_idx` (`user_id` ASC) VISIBLE,
  INDEX `review_comment_to_travel_review_review_id_fk` (`review_id` ASC) VISIBLE,
  CONSTRAINT `review_comment_to_travel_review_review_id_fk`
    FOREIGN KEY (`review_id`)
    REFERENCES `trip`.`travel_review` (`review_id`)
    ON DELETE CASCADE,
  CONSTRAINT `review_comment_to_user_user_id_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `trip`.`user` (`user_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `trip`.`review_like`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `trip`.`review_like` ;

CREATE TABLE IF NOT EXISTS `trip`.`review_like` (
  `review_id` INT NOT NULL,
  `user_id` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`review_id`, `user_id`),
  INDEX `user_id_to_user_user_id_fk_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `review_like_to_travel_review_review_id_fk`
    FOREIGN KEY (`review_id`)
    REFERENCES `trip`.`travel_review` (`review_id`)
    ON DELETE CASCADE,
  CONSTRAINT `reviewl_like_to_user_user_id_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `trip`.`user` (`user_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `trip`.`user_plan_info`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `trip`.`user_plan_info` ;

CREATE TABLE IF NOT EXISTS `trip`.`user_plan_info` (
  `plan_id` INT NOT NULL,
  `name` VARCHAR(300) NULL DEFAULT NULL,
  `vicinity` VARCHAR(300) NULL DEFAULT NULL,
  `photo` VARCHAR(300) NULL DEFAULT NULL,
  `url` VARCHAR(300) NULL DEFAULT NULL,
  `sequence` INT NOT NULL,
  PRIMARY KEY (`plan_id`, `sequence`),
  CONSTRAINT `user_plan_info_to_trave_plan_plan_id_fk`
    FOREIGN KEY (`plan_id`)
    REFERENCES `trip`.`travel_plan` (`plan_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

insert into user (user_id, user_pw, user_name, user_email, user_domain, role)
values ("admin", "admin", "운영자", "admin", "admin", "admin");