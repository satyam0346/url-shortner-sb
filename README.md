# 🔗 URL Shortener — Spring Boot

A full-featured URL shortener web application built with **Spring Boot 3**, **Spring MVC**, **Spring Security**, **Hibernate/JPA**, **JSP/JSTL**, and **PostgreSQL**.

## ✨ Features

| Feature | Description |
|---|---|
| **Authentication** | Register / Login with Spring Security (BCrypt) |
| **Shorten URLs** | Generate a 7-char random code or use a custom alias |
| **Dashboard** | View, edit, enable/disable, and delete your URLs |
| **Click Analytics** | Per-URL click count, IP, user-agent, referrer tracking |
| **Redirect** | `/s/{code}` redirects to the original URL & records a click |

## 🛠️ Tech Stack

- **Backend:** Java 21, Spring Boot 3.3.5, Spring MVC, Spring Security
- **ORM:** Hibernate / Spring Data JPA
- **View:** JSP + JSTL (Tomcat Jasper embedded)
- **Database:** PostgreSQL 16
- **Build:** Maven (WAR packaging)
- **Container:** Docker + Docker Compose

## 🚀 Quick Start

### Prerequisites
- Java 21+
- Maven 3.9+
- PostgreSQL 16+ (or Docker)

### 1. Clone & configure

```bash
git clone https://github.com/satyam0346/url-shortner-sb.git
cd url-shortner-sb
cp .env.example .env        # then edit .env with your DB credentials
```

### 2a. Run locally (PostgreSQL required)

```bash
# Create the database first
psql -U postgres -c "CREATE DATABASE url_shortener;"

# Run with dev profile (verbose SQL logging)
./mvnw spring-boot:run -Dspring-boot.run.profiles=dev
```

App available at: `http://localhost:8080`

### 2b. Run with Docker Compose (recommended)

```bash
# Start DB + App together
docker compose up --build

# Stop & remove containers
docker compose down
```

App available at: `http://localhost:8080`

## ⚙️ Configuration

All sensitive settings are externalised via **environment variables**:

| Variable | Default | Description |
|---|---|---|
| `DB_URL` | `jdbc:postgresql://localhost:5432/url_shortener` | JDBC connection URL |
| `DB_USERNAME` | `postgres` | Database user |
| `DB_PASSWORD` | `changeme` | Database password |
| `DDL_AUTO` | `update` | Hibernate DDL mode (`update`/`validate`/`none`) |
| `PORT` | `8080` | HTTP port |
| `LOG_LEVEL` | `INFO` | Log level for `com.urlshortener` |

Override them in `.env` (local) or as container/cloud environment variables in production.

## 📁 Project Structure

```
src/
 └─ main/
     ├─ java/com/urlshortener/
     │   ├─ config/          # Spring Security & MVC config
     │   ├─ controller/      # AuthController, UrlController, RedirectController
     │   ├─ dto/             # Form objects (UrlForm, RegisterForm)
     │   ├─ model/           # JPA entities (User, Url, UrlClick)
     │   ├─ repository/      # Spring Data JPA repositories
     │   └─ service/         # Business logic (UrlService, UserService)
     ├─ resources/
     │   ├─ application.properties       # Base config
     │   ├─ application-dev.properties   # Dev profile overrides
     │   ├─ schema.sql                   # Reference DDL
     │   └─ static/                      # CSS / JS
     └─ webapp/WEB-INF/views/            # JSP templates
```

## 🔒 Security Notes

- Passwords hashed with **BCrypt** (strength 12)
- CSRF protection enabled by default via Spring Security
- Stack traces hidden in production (`server.error.include-stacktrace=never`)
- Credentials loaded from env vars — `.env` is git-ignored
- Docker image runs as a **non-root** user

## 📜 Database Schema

The schema is managed by Hibernate (`ddl-auto=update`).  
A reference DDL is provided at [`src/main/resources/schema.sql`](src/main/resources/schema.sql).

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/my-feature`)
3. Commit your changes (`git commit -m 'Add my feature'`)
4. Push to the branch (`git push origin feature/my-feature`)
5. Open a Pull Request

## 📄 License

MIT License — see [LICENSE](LICENSE) for details.
