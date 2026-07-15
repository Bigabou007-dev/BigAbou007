-- Keystone Economy schema. Applied automatically by MariaDB on first container start.
-- Indexed for the write-heavy hot path; the ledger is append-only (audit trail).

CREATE TABLE IF NOT EXISTS keystone_commodities (
  id      VARCHAR(64)  NOT NULL PRIMARY KEY,
  base    INT          NOT NULL,
  supply  DOUBLE       NOT NULL,
  demand  DOUBLE       NOT NULL,
  price   INT          NOT NULL,
  updated TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS keystone_ledger (
  id         BIGINT       NOT NULL AUTO_INCREMENT PRIMARY KEY,
  player_src INT          NOT NULL,
  commodity  VARCHAR(64)  NOT NULL,
  qty        INT          NOT NULL,
  side       ENUM('buy','sell') NOT NULL,
  unit_price INT          NOT NULL,
  tax        INT          NOT NULL DEFAULT 0,
  created    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_commodity_time (commodity, created),
  INDEX idx_player_time (player_src, created)
) ENGINE=InnoDB;
