-- ==========================================
-- База данных: Тёплый дом
-- Версия модели: v2 (с обновлёнными названиями)
-- ==========================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =======================
-- Таблица: Пользователи
-- =======================
CREATE TABLE "User" (
    User_ID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    Email VARCHAR(255) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    FullName VARCHAR(255),
    Phone VARCHAR(50),
    Role VARCHAR(50) CHECK (Role IN ('Пользователь', 'Администратор')) DEFAULT 'Пользователь',
    CreatedDt TIMESTAMP NOT NULL DEFAULT NOW(),
    Status VARCHAR(50) CHECK (Status IN ('Активен', 'Заблокирован')) DEFAULT 'Активен'
);

-- =======================
-- Таблица: Дома
-- =======================
CREATE TABLE House (
    House_ID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    User_ID UUID NOT NULL,
    Address TEXT NOT NULL,
    Name VARCHAR(255),
    CreatedDt TIMESTAMP NOT NULL DEFAULT NOW(),
    Status VARCHAR(50) CHECK (Status IN ('Активен', 'Отключён')) DEFAULT 'Активен',
    CONSTRAINT fk_house_user FOREIGN KEY (User_ID) REFERENCES "User"(User_ID) ON DELETE CASCADE
);

-- =======================
-- Таблица: Типы устройств
-- =======================
CREATE TABLE DeviceType (
    DeviceType_ID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    Name VARCHAR(255) NOT NULL,
    Protocol VARCHAR(100),
    Description TEXT
);

-- =======================
-- Таблица: Устройства
-- =======================
CREATE TABLE Device (
    Device_ID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    DeviceType_ID UUID NOT NULL,
    House_ID UUID NOT NULL,
    SerialNumber VARCHAR(255) UNIQUE NOT NULL,
    Name VARCHAR(255),
    Status VARCHAR(50) CHECK (Status IN ('Включено', 'Выключено', 'Ошибка', 'Оффлайн')) DEFAULT 'Оффлайн',
    LastUpdated TIMESTAMP,
    CONSTRAINT fk_device_type FOREIGN KEY (DeviceType_ID) REFERENCES DeviceType(DeviceType_ID) ON DELETE CASCADE,
    CONSTRAINT fk_device_house FOREIGN KEY (House_ID) REFERENCES House(House_ID) ON DELETE CASCADE
);

-- =======================
-- Таблица: Телеметрия
-- =======================
CREATE TABLE TelemetryData (
    Telemetry_ID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    Device_ID UUID NOT NULL,
    Timestamp TIMESTAMP NOT NULL DEFAULT NOW(),
    MetricType VARCHAR(100),
    Value DOUBLE PRECISION,
    Unit VARCHAR(50),
    RawData JSONB,
    CONSTRAINT fk_telemetry_device FOREIGN KEY (Device_ID) REFERENCES Device(Device_ID) ON DELETE CASCADE
);

-- =======================
-- Таблица: Команды
-- =======================
CREATE TABLE Command (
    Command_ID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    Device_ID UUID NOT NULL,
    CommandType VARCHAR(100) NOT NULL,
    Payload JSONB,
    Status VARCHAR(50) CHECK (Status IN ('Ожидает', 'Выполнена', 'Ошибка')) DEFAULT 'Ожидает',
    CreatedDt TIMESTAMP NOT NULL DEFAULT NOW(),
    ExecDt TIMESTAMP,
    CONSTRAINT fk_command_device FOREIGN KEY (Device_ID) REFERENCES Device(Device_ID) ON DELETE CASCADE
);

-- =======================
-- Таблица: Регистрация устройств
-- =======================
CREATE TABLE DeviceRegistration (
    Registration_ID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    Device_ID UUID NOT NULL UNIQUE,
    AuthKey VARCHAR(255) NOT NULL,
    Status VARCHAR(50) CHECK (Status IN ('Ожидает', 'Активировано', 'Ошибка')) DEFAULT 'Ожидает',
    CreatedDt TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_registration_device FOREIGN KEY (Device_ID) REFERENCES Device(Device_ID) ON DELETE CASCADE
);

-- =======================
-- Таблица: Журнал событий
-- =======================
CREATE TABLE EventLog (
    EventLog_ID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    User_ID UUID,
    SourceType VARCHAR(50) CHECK (SourceType IN ('Устройство', 'Система', 'Команда')),
    Source_ID UUID,
    EventType VARCHAR(100),
    Payload JSONB,
    Timestamp TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_event_user FOREIGN KEY (User_ID) REFERENCES "User"(User_ID) ON DELETE SET NULL
);

-- =======================
-- Индексы
-- =======================
CREATE INDEX idx_telemetry_device_timestamp ON TelemetryData (Device_ID, Timestamp);
CREATE INDEX idx_command_device_status ON Command (Device_ID, Status);
CREATE INDEX idx_event_user_timestamp ON EventLog (User_ID, Timestamp);