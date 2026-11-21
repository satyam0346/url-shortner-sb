-- ═══════════════════════════════════════════════════════════════
--  LinkShrink Database Schema
--  Hibernate will auto-create/update tables via ddl-auto=update
--  This script is for reference / manual setup.
--  Run against: url_shortener (PostgreSQL)
-- ═══════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS users (
    id          BIGSERIAL    PRIMARY KEY,
    full_name   VARCHAR(100) NOT NULL,
    username    VARCHAR(50)  NOT NULL UNIQUE,
    email       VARCHAR(255) NOT NULL UNIQUE,
    password    VARCHAR(255) NOT NULL,
    role        VARCHAR(30)  NOT NULL DEFAULT 'ROLE_USER',
    enabled     BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at  TIMESTAMP    NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS urls (
    id           BIGSERIAL     PRIMARY KEY,
    original_url VARCHAR(2048) NOT NULL,
    short_code   VARCHAR(10)   NOT NULL UNIQUE,
    custom_alias VARCHAR(50)   UNIQUE,
    title        VARCHAR(255),
    is_active    BOOLEAN       NOT NULL DEFAULT TRUE,
    expiry_date  TIMESTAMP,
    created_at   TIMESTAMP     NOT NULL DEFAULT NOW(),
    user_id      BIGINT        NOT NULL REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS url_clicks (
    id          BIGSERIAL    PRIMARY KEY,
    url_id      BIGINT       NOT NULL REFERENCES urls(id) ON DELETE CASCADE,
    clicked_at  TIMESTAMP    NOT NULL DEFAULT NOW(),
    ip_address  VARCHAR(50),
    user_agent  VARCHAR(512),
    referer     VARCHAR(512)
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_urls_short_code    ON urls(short_code);
CREATE INDEX IF NOT EXISTS idx_urls_custom_alias  ON urls(custom_alias);
CREATE INDEX IF NOT EXISTS idx_urls_user_id       ON urls(user_id);
CREATE INDEX IF NOT EXISTS idx_clicks_url_id      ON url_clicks(url_id);
CREATE INDEX IF NOT EXISTS idx_clicks_clicked_at  ON url_clicks(clicked_at DESC);
