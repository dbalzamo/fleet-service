-- =============================================================
-- Author      : Dario
-- Created at  : 2026-06-28
-- Database    : robofleet_db
-- Schema      : fleet
-- Description : Fleet schema - vehicle and vehicle_location
-- =============================================================

CREATE SCHEMA IF NOT EXISTS fleet;

CREATE TYPE fleet.vehicle_status AS ENUM (
    'available',
    'in_ride',
    'reserved',
    'charging',
    'maintenance',
    'offline',
    'out_of_service'
);

CREATE TABLE fleet.vehicle (
    id            BIGSERIAL PRIMARY KEY,
    license_plate CHAR(7)              NOT NULL UNIQUE,
    brand         VARCHAR(50)          NOT NULL,
    model         VARCHAR(50)          NOT NULL,
    color         VARCHAR(30),
    year          SMALLINT             NOT NULL,
    status        fleet.vehicle_status NOT NULL DEFAULT 'offline',
    battery_level SMALLINT             NOT NULL CHECK (battery_level BETWEEN 0 AND 100),
    autonomy_km   SMALLINT             NOT NULL CHECK (autonomy_km >= 0),
    created_at    TIMESTAMP            DEFAULT NOW(),
    updated_at    TIMESTAMP            DEFAULT NOW(),
    deleted_at    TIMESTAMP
);

-- abilitare estensione (una volta sola per database)
CREATE EXTENSION IF NOT EXISTS postgis;

CREATE TABLE fleet.vehicle_location (
    id          BIGSERIAL PRIMARY KEY,
    vehicle_id  BIGINT NOT NULL REFERENCES fleet.vehicle(id),
    location    GEOMETRY(POINT, 4326) NOT NULL,
    city        VARCHAR(100),
    recorded_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_vehicle_location_geom ON fleet.vehicle_location USING GIST (location);

INSERT INTO fleet.vehicle (license_plate, brand, model, color, year, status, battery_level, autonomy_km)
VALUES ('AB123CD', 'Tesla', 'Model 3', 'White', 2023, 'available', 85, 400);

INSERT INTO fleet.vehicle_location (vehicle_id, location, city)
VALUES (1, ST_MakePoint(9.1900, 45.4654), 'Milano');