# 🔗 LinkShrink — URL Shortener

> A full-stack URL shortening web application built with **Java 21**, **Spring Boot 3**, **Spring MVC**, **Spring Security**, **Hibernate/JPA**, **JSP/JSTL**, and **PostgreSQL**.

[![CI](https://github.com/satyam0346/url-shortner-sb/actions/workflows/ci.yml/badge.svg)](https://github.com/satyam0346/url-shortner-sb/actions/workflows/ci.yml)
![Java](https://img.shields.io/badge/Java-21-orange)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.3.5-brightgreen)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-blue)
![License](https://img.shields.io/badge/License-MIT-yellow)

---

## 📌 Project Title & Description

**LinkShrink** is a production-ready URL shortener that lets authenticated users:
- Shorten any long URL into a compact, shareable link
- Optionally define a custom alias (e.g. `/s/my-brand`)
- Track every click with IP address, referrer, and browser details
- Manage all links from a personal dashboard (view, edit, enable/disable, delete)

---

## 🛠️ Technologies & Tools

| Layer | Technology |
|---|---|
| **Language** | Java 21 |
| **Framework** | Spring Boot 3.3.5 |
| **Web MVC** | Spring MVC (DispatcherServlet, @Controller, @ModelAttribute) |
| **Security** | Spring Security 6 (session-based, BCrypt, CSRF) |
| **ORM** | Hibernate 6 / Spring Data JPA |
| **View Layer** | JSP + JSTL (Jakarta EE) + Tomcat Jasper |
| **Database** | PostgreSQL 16 |
| **Build Tool** | Apache Maven 3 (WAR packaging) |
| **Testing** | JUnit 5, Spring Boot Test, H2 (in-memory, test profile) |
| **Container** | Docker (multi-stage) + Docker Compose |
| **CI/CD** | GitHub Actions |
| **Frontend** | Vanilla HTML5, CSS3, JavaScript (no framework) |

---

## ✨ Features & Functionalities

### 🔐 Authentication
- **User Registration** — full name, username (unique), email (unique), password with BCrypt hashing
- **User Login** — Spring Security form login with session tracking
- **Logout** — POST-based with CSRF protection; session invalidated
- **Session Management** — single concurrent session per user; expired session redirect

### 🔗 URL Management (CRUD)
- **Create Short URL** — random 7-char alphanumeric code or custom alias
- **Dashboard** — paginated list of all your links with status badges
- **Quick Shorten** — inline form on dashboard for one-click creation
- **Edit** — update title and custom alias of an existing link
- **Enable / Disable** — toggle link active status without deleting
- **Delete** — permanent deletion with confirmation prompt

### 📊 Analytics
- **Click Tracking** — every redirect records: IP address, User-Agent, Referrer, timestamp
- **Link Stats Page** — total click count, click log table with all recorded events
- **Dashboard Summary** — total links created, total clicks across all links, member-since date

### 🌐 Redirect
- `GET /s/{code}` — resolves short code or custom alias → HTTP 302 redirect
- Handles disabled links (410 Gone) and not-found links (404)
- Correctly extracts real client IP from `X-Forwarded-For` header (proxy-aware)

### 🔒 Security
- Passwords hashed with BCrypt (default strength 12)
- CSRF tokens on every form
- Server-side input validation (Jakarta Bean Validation + custom business rules)
- Client-side validation (HTML5 + JavaScript — dual-layer)
- Stack traces hidden in production
- Credentials never hardcoded — all loaded from environment variables

---

## 📁 Project Structure

```
url-shortner-sb/
├── src/
│   ├── main/
│   │   ├── java/com/urlshortener/
│   │   │   ├── UrlShortnerSbApplication.java      # Entry point (extends SpringBootServletInitializer)
│   │   │   ├── config/
│   │   │   │   ├── AppConfig.java                 # Bean definitions (BCryptPasswordEncoder)
│   │   │   │   └── SecurityConfig.java            # Spring Security filter chain
│   │   │   ├── controller/
│   │   │   │   ├── AuthController.java            # GET/POST /login, /register
│   │   │   │   ├── UrlController.java             # Dashboard, CRUD, analytics
│   │   │   │   └── RedirectController.java        # GET /s/{code}
│   │   │   ├── dto/
│   │   │   │   ├── RegisterForm.java              # Registration form DTO
│   │   │   │   └── UrlForm.java                   # URL creation/edit DTO
│   │   │   ├── model/
│   │   │   │   ├── User.java                      # JPA entity → users table
│   │   │   │   ├── Url.java                       # JPA entity → urls table
│   │   │   │   └── UrlClick.java                  # JPA entity → url_clicks table
│   │   │   ├── repository/
│   │   │   │   ├── UserRepository.java            # Spring Data JPA + custom queries
│   │   │   │   ├── UrlRepository.java             # findByCode JPQL, countClicksByUser
│   │   │   │   └── UrlClickRepository.java        # Click analytics queries
│   │   │   └── service/
│   │   │       ├── UserService.java               # UserDetailsService + register/findByUsername
│   │   │       └── UrlService.java                # Shorten, CRUD, resolveAndTrack
│   │   ├── resources/
│   │   │   ├── application.properties             # Base config (env-var driven)
│   │   │   ├── application-dev.properties         # Dev profile (verbose logging)
│   │   │   ├── schema.sql                         # Reference DDL (manual use)
│   │   │   └── static/
│   │   │       ├── css/style.css                  # Global stylesheet (CSS variables)
│   │   │       └── js/validation.js               # Client-side validation helpers
│   │   └── webapp/WEB-INF/views/
│   │       ├── index.jsp                          # Home / landing page
│   │       ├── auth/
│   │       │   ├── login.jsp                      # Login form
│   │       │   └── register.jsp                   # Registration form
│   │       ├── url/
│   │       │   ├── dashboard.jsp                  # Main dashboard
│   │       │   ├── shorten.jsp                    # Create short URL form
│   │       │   ├── edit.jsp                       # Edit title/alias form
│   │       │   └── stats.jsp                      # Click analytics table
│   │       └── error/
│   │           └── not-found.jsp                  # 404/410 error page
│   └── test/
│       ├── java/com/urlshortener/
│       │   └── UrlShortnerSbApplicationTests.java # Context smoke test
│       └── resources/
│           └── application-test.properties        # H2 in-memory DB (CI/testing)
├── .github/
│   └── workflows/
│       └── ci.yml                                 # GitHub Actions CI pipeline
├── .env.example                                   # Environment variable template
├── .gitignore                                     # Ignores target/, .env, IDE files
├── Dockerfile                                     # Multi-stage Docker build
├── docker-compose.yml                             # App + PostgreSQL orchestration
├── LICENSE                                        # MIT License
├── pom.xml                                        # Maven dependencies & build config
└── README.md                                      # This file
```

---

## 🚀 Installation & Execution Instructions

### Prerequisites

| Tool | Version | Purpose |
|---|---|---|
| Java JDK | 21+ | Compile & run |
| Maven | 3.9+ | Build tool |
| PostgreSQL | 16+ | Database (or use Docker) |
| Docker | 24+ | Optional — containerised run |
| Git | any | Clone repository |

---

### Option A — Run Locally (PostgreSQL installed)

**1. Clone the repository**
```bash
git clone https://github.com/satyam0346/url-shortner-sb.git
cd url-shortner-sb
```

**2. Configure environment**
```bash
cp .env.example .env
# Edit .env — set your DB_USERNAME and DB_PASSWORD
```

**3. Create the PostgreSQL database**
```bash
psql -U postgres -c "CREATE DATABASE url_shortener;"
```

**4. Run the application (dev profile — verbose SQL)**
```bash
./mvnw spring-boot:run -Dspring-boot.run.profiles=dev
```

**5. Access the app**
```
http://localhost:8080
```

---

### Option B — Run with Docker Compose (Recommended)

No PostgreSQL installation needed — Docker handles everything.

**1. Clone & configure**
```bash
git clone https://github.com/satyam0346/url-shortner-sb.git
cd url-shortner-sb
cp .env.example .env
# Set DB_PASSWORD in .env (optional — defaults to "changeme")
```

**2. Start the full stack**
```bash
docker compose up --build
```

**3. Access the app**
```
http://localhost:8080
```

**4. Stop the stack**
```bash
docker compose down
# To also remove the database volume:
docker compose down -v
```

---

### Option C — Build WAR & deploy to external Tomcat

```bash
./mvnw clean package -DskipTests
# WAR file is created at: target/url-shortener.war
# Copy it to your Tomcat webapps/ directory
```

---

## ⚙️ Configuration

All sensitive settings are externalised via **environment variables**. Never hardcode credentials.

| Variable | Default | Description |
|---|---|---|
| `DB_URL` | `jdbc:postgresql://localhost:5432/url_shortener` | JDBC connection URL |
| `DB_USERNAME` | `postgres` | Database user |
| `DB_PASSWORD` | `changeme` | Database password |
| `DDL_AUTO` | `update` | Hibernate DDL (`update` / `validate` / `none`) |
| `PORT` | `8080` | HTTP server port |
| `LOG_LEVEL` | `INFO` | Log level for `com.urlshortener` package |

Set them in `.env` for local runs, or as container/cloud environment variables in production.

**Spring Profiles:**

| Profile | How to activate | Purpose |
|---|---|---|
| *(default)* | — | Production-safe config |
| `dev` | `-Dspring-boot.run.profiles=dev` | Verbose SQL logging, stack traces |
| `test` | Activated automatically by `@ActiveProfiles("test")` | H2 in-memory DB for unit tests |

---

## 🗄️ Database Setup Instructions

### Automatic (recommended)
Hibernate's `ddl-auto=update` creates/updates all tables automatically on first startup. No manual SQL needed.

### Manual (reference)
If you prefer to run DDL manually, use the provided script:

```bash
psql -U postgres -d url_shortener -f src/main/resources/schema.sql
```

**Tables created:**

```sql
-- users: stores registered accounts
CREATE TABLE users (
    id          BIGSERIAL    PRIMARY KEY,
    full_name   VARCHAR(100) NOT NULL,
    username    VARCHAR(50)  NOT NULL UNIQUE,
    email       VARCHAR(255) NOT NULL UNIQUE,
    password    VARCHAR(255) NOT NULL,       -- BCrypt hash
    role        VARCHAR(30)  NOT NULL DEFAULT 'ROLE_USER',
    enabled     BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at  TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- urls: stores shortened links
CREATE TABLE urls (
    id           BIGSERIAL     PRIMARY KEY,
    original_url VARCHAR(2048) NOT NULL,
    short_code   VARCHAR(10)   NOT NULL UNIQUE,   -- 7-char random code
    custom_alias VARCHAR(50)   UNIQUE,             -- optional user-defined alias
    title        VARCHAR(255),
    is_active    BOOLEAN       NOT NULL DEFAULT TRUE,
    expiry_date  TIMESTAMP,
    created_at   TIMESTAMP     NOT NULL DEFAULT NOW(),
    user_id      BIGINT        NOT NULL REFERENCES users(id) ON DELETE CASCADE
);

-- url_clicks: click analytics per link
CREATE TABLE url_clicks (
    id          BIGSERIAL    PRIMARY KEY,
    url_id      BIGINT       NOT NULL REFERENCES urls(id) ON DELETE CASCADE,
    clicked_at  TIMESTAMP    NOT NULL DEFAULT NOW(),
    ip_address  VARCHAR(50),
    user_agent  VARCHAR(512),
    referer     VARCHAR(512)
);
```

**Indexes (created automatically by schema.sql):**
```sql
CREATE INDEX idx_urls_short_code    ON urls(short_code);
CREATE INDEX idx_urls_custom_alias  ON urls(custom_alias);
CREATE INDEX idx_urls_user_id       ON urls(user_id);
CREATE INDEX idx_clicks_url_id      ON url_clicks(url_id);
CREATE INDEX idx_clicks_clicked_at  ON url_clicks(clicked_at DESC);
```

---

## 🌐 Application Endpoints

| Method | URL | Description | Auth? |
|---|---|---|---|
| `GET` | `/` | Home / landing page | Public |
| `GET` | `/login` | Login page | Public |
| `POST` | `/login` | Spring Security processes login | Public |
| `POST` | `/logout` | Logout + session invalidate | ✅ |
| `GET` | `/register` | Registration page | Public |
| `POST` | `/register` | Create new account | Public |
| `GET` | `/dashboard` | URL dashboard | ✅ |
| `GET` | `/shorten` | Shorten URL form | ✅ |
| `POST` | `/shorten` | Create short URL | ✅ |
| `GET` | `/url/{id}/edit` | Edit link form | ✅ |
| `POST` | `/url/{id}/edit` | Save link edits | ✅ |
| `POST` | `/url/{id}/toggle` | Enable/disable link | ✅ |
| `POST` | `/url/{id}/delete` | Delete link | ✅ |
| `GET` | `/url/{id}/stats` | Click analytics | ✅ |
| `GET` | `/s/{code}` | Redirect to original URL | Public |

---

## 🧪 Running Tests

```bash
# Run all tests (uses H2 in-memory DB, no PostgreSQL needed)
./mvnw test

# Run tests + package (CI-equivalent)
./mvnw verify
```

---

## 🔒 Security Notes

- Passwords hashed with **BCrypt** (strength 12) — never stored in plain text
- **CSRF protection** enabled on all state-changing requests (login, forms, logout)
- Stack traces and exception class names **hidden** in production responses
- Credentials loaded from env vars — `.env` is git-ignored and never committed
- Short URL owner validated on every edit/delete/stats request (no IDOR)
- Docker image runs as a **non-root user** (`spring:spring`)
- `X-Forwarded-For` header parsed to get real client IP behind reverse proxies

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Make your changes and add tests
4. Run the test suite: `./mvnw test`
5. Commit: `git commit -m 'feat: add my feature'`
6. Push: `git push origin feature/my-feature`
7. Open a Pull Request

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

<p align="center">Built with ❤️ using Spring Boot · Hibernate · JSP · PostgreSQL</p>
