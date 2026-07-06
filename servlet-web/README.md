# servlet-web

Java Servlet web application (Jakarta EE 9 / Servlet 6.0) built with Maven and
ready to deploy on NEC **WebOTX Application Server**.

The UI is a small admin-style dashboard with a fixed sidebar and top bar,
served by plain JSPs. No JavaScript frameworks or external CDNs.

## Requirements

| Tool          | Version                              |
|---------------|--------------------------------------|
| JDK           | 21 (Temurin / Homebrew `openjdk@21`) |
| Maven         | 3.8+                                 |
| WebOTX        | V10.x or V11.x (Jakarta EE 9 profile)|
| Browser       | Any modern browser                   |

> Servlet 6.0 (Jakarta EE 9) is supported by WebOTX V10.1 and later.
> If you are on a WebOTX V9 / Java EE 8 profile, swap the
> `jakarta.*` coordinates for `javax.servlet:javax.servlet-api:4.0.1` and rename
> every `jakarta.servlet.*` import to `javax.servlet.*`.

## Build & test

```bash
# Local smoke run: JDK 21
export JAVA_HOME=$(brew --prefix openjdk@21)/libexec/openjdk.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"

mvn clean test                       # run unit tests
mvn -DskipTests clean package        # produces target/servlet-web.war
mvn -Pwebotx-deploy clean package    # builds and redeploys via webuipack
```

`-Pwebotx-deploy` is opt-in; without it, only the WAR is built and no server is
touched.

## Deploy on WebOTX

1. Install WebOTX and create a domain (the default is `domain1`).
2. Start the domain:
   ```bash
   $WEBOTX_HOME/bin/otxadmin start-domain domain1
   ```
3. Put the otxadmin password into `conf/webotx-password.txt` (one-time):
   ```bash
   echo "AS_ADMIN_PASSWORD=YOUR_PASSWORD" > conf/webotx-password.txt
   ```
4. Export `WEBOTX_HOME` and deploy:
   ```bash
   export WEBOTX_HOME=/opt/nec/webotx
   mvn -Pwebotx-deploy clean package
   ```
5. Browse to:
   ```
   http://localhost:8080/servlet-web/
   ```

You can also drop `target/servlet-web.war` into
`$WEBOTX_HOME/domains/domain1/autodeploy/` and let WebOTX hot-deploy it.

## Pages

| Path                | Description                                                  |
|---------------------|--------------------------------------------------------------|
| `/`                 | Landing dashboard (`home.jsp`) with live counters            |
| `/dashboard`        | Stats page: users, sessions, JVM uptime, server info         |
| `/users`            | CRUD list + create form for in-memory users                  |
| `/users/{id}`       | Edit form for one user                                       |
| `/api-docs`         | Human-readable API documentation                             |
| `/hello?name=X`     | Quick greeting demo                                          |
| `/api/health`       | JSON health probe                                            |
| `/api/echo`         | JSON echo of the request                                     |
| `/api/stats`        | JSON runtime stats                                           |
| `/users?format=json`| List users as JSON                                           |

Every page uses a shared layout (`sidebar.jsp` + `topbar.jsp`) included via
`<jsp:include>`. The active item is highlighted by passing an `active`
parameter.

## Layout

```
src/main/java/com/example/web/
├── HelloServlet.java
├── UserServlet.java
├── ApiServlet.java
├── ApiDocsServlet.java
├── DashboardServlet.java
├── filter/
│   ├── CharacterEncodingFilter.java
│   └── RequestLoggingFilter.java
├── listener/
│   ├── AppContextListener.java
│   └── AppSessionListener.java
├── model/
│   └── User.java
└── util/
    └── Json.java          # thin Jackson facade

src/main/webapp/
├── home.jsp               # landing page (also the welcome file)
├── css/site.css
├── error/{404,500}.jsp
└── WEB-INF/
    ├── web.xml
    └── views/
        ├── layout/{sidebar,topbar}.jsp
        ├── hello.jsp
        ├── dashboard.jsp
        ├── api-docs.jsp
        └── users/{list,form}.jsp
```

## Libraries

| Coordinate                                                       | Why                                      |
|------------------------------------------------------------------|------------------------------------------|
| `jakarta.servlet:jakarta.servlet-api:6.0.0`                      | Servlet 6.0 (Jakarta EE 9)               |
| `jakarta.servlet.jsp:jakarta.servlet.jsp-api:3.1.1`             | JSP 3.1                                  |
| `jakarta.el:jakarta.el-api:5.0.0`                                | EL 5.0                                   |
| `jakarta.annotation:jakarta.annotation-api:2.1.1`                | `@WebServlet` etc.                       |
| `jakarta.servlet.jsp.jstl:jakarta.servlet.jsp.jstl-api:3.0.0`   | JSTL 3.0 (Jakarta, API + impl)           |
| `com.fasterxml.jackson.core:jackson-databind:2.17.2`             | JSON read/write                          |
| `com.fasterxml.jackson.datatype:jackson-datatype-jsr310:2.17.2`  | `java.time` (Instant)                    |
| `org.slf4j:slf4j-api:2.0.13` + `slf4j-simple`                    | Logging                                  |
| `org.junit.jupiter:junit-jupiter:5.10.3`                         | Tests (JUnit 5)                          |

## Testing

```bash
mvn test
```

Only container-free unit tests live in `src/test/java`. The JSP views and
servlet behaviour should be verified against a real WebOTX domain or a
Jakarta Servlet 6.0 container.
