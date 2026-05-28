# Same-Origin Policy and CORS

## What is an Origin?

An **origin** is the combination of three components from a URL:

```text
scheme://host:port
https://app.example.com:443
  │         │              │
scheme     host           port
```

The **scheme** (`http`, `https`), the **host** (full hostname including subdomains), and the **port** together define one origin. If any of the three differ, the URLs belong to different origins.

**Examples with `https://app.example.com:443` as the reference:**

| URL                            | Same origin? | Reason                     |
|--------------------------------|--------------|----------------------------|
| `https://app.example.com/path` | Yes          | Same scheme, host, port    |
| `http://app.example.com`       | No           | Different scheme           |
| `https://api.example.com`      | No           | Different host (subdomain) |
| `https://example.com`          | No           | Different host             |
| `https://app.example.com:8443` | No           | Different port             |

The `Origin` header is set by the browser automatically — it cannot be overridden by JavaScript.

---

## Same-Origin Policy (SOP)

The **Same-Origin Policy** is a browser security mechanism that restricts how a document or script loaded from one origin can interact with resources from another origin.

Two URLs have the **same origin** if they share the same:

- **Scheme** (`http` vs `https`)
- **Host** (`example.com` vs `api.example.com`)
- **Port** (`443` vs `8443`)

### What SOP blocks by default

- JavaScript `fetch()` / `XMLHttpRequest` to a different origin
- Access to `localStorage`, `sessionStorage`, `IndexedDB` of another origin
- Access to a cross-origin `iframe`'s DOM
- Reading cookies scoped to another origin

### What SOP does NOT block

- Loading images, scripts, CSS, and iframes via HTML tags (embedding is allowed, reading is not)
- Form `POST` submissions to another origin
- Redirects

---

## CORS (Cross-Origin Resource Sharing)

CORS is the mechanism that allows servers to **explicitly relax** the Same-Origin Policy for specific origins, methods, and headers. It works through HTTP headers negotiated between the browser and the server.

### Preflight request

For "non-simple" requests (e.g. `PUT`, `DELETE`, custom headers, `Content-Type: application/json`), the browser first sends an `OPTIONS` preflight:

```http
OPTIONS /api/resource HTTP/1.1
Origin: https://app.example.com
Access-Control-Request-Method: POST
Access-Control-Request-Headers: Content-Type, Authorization
```

The server must respond with the appropriate CORS headers:

```http
HTTP/1.1 204 No Content
Access-Control-Allow-Origin: https://app.example.com
Access-Control-Allow-Methods: GET, POST, DELETE
Access-Control-Allow-Headers: Content-Type, Authorization
Access-Control-Max-Age: 3600
```

### Key CORS response headers

| Header                             | Purpose                                                                          |
|------------------------------------|----------------------------------------------------------------------------------|
| `Access-Control-Allow-Origin`      | Which origin(s) are permitted. Use a specific origin, never `*` with credentials |
| `Access-Control-Allow-Methods`     | Allowed HTTP methods                                                             |
| `Access-Control-Allow-Headers`     | Allowed request headers                                                          |
| `Access-Control-Allow-Credentials` | Whether cookies/auth headers are included (`true`/`false`)                       |
| `Access-Control-Expose-Headers`    | Headers the browser is allowed to read from the response                         |
| `Access-Control-Max-Age`           | How long (seconds) to cache preflight response                                   |

---

## Security Best Practices

### Never use wildcard with credentials

`Access-Control-Allow-Origin: *` combined with `Access-Control-Allow-Credentials: true` is rejected by browsers but also signals misconfiguration. Always set a specific origin when credentials are involved.

### Maintain an explicit allowlist

Validate the request `Origin` header against a server-side allowlist and reflect it back only if it matches. Never blindly reflect the incoming `Origin` value.

### Avoid overly permissive methods

Restrict `Access-Control-Allow-Methods` to only the methods your API actually needs.

### Avoid `null` origin

Never allowlist `Origin: null`. It can be sent by sandboxed iframes and local HTML files and is trivially exploitable.

### Limit `Access-Control-Max-Age`

Short preflight cache times (e.g. `600` seconds) reduce the window where a stale policy is applied after a configuration change.

---

## Where CORS is configured

| Layer                     | Tool / Component                                                                                               | How                                                                                                                                               |
|---------------------------|----------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------|
| **Ingress controller**    | NGINX Ingress                                                                                                  | Annotations: `nginx.ingress.kubernetes.io/enable-cors`, `cors-allow-origin`, `cors-allow-methods`, `cors-allow-headers`, `cors-allow-credentials` |
| **Service mesh**          | Istio `VirtualService`                                                                                         | `corsPolicy` block: `allowOrigins`, `allowMethods`, `allowHeaders`, `allowCredentials`                                                            |
| **Application framework** | Express (`cors` package), Spring Boot (`@CrossOrigin` / `WebMvcConfigurer`), FastAPI/Django (`CORSMiddleware`) | Use when origins are dynamic (e.g. per-tenant)                                                                                                    |

### Content Security Policy complement

CORS controls what the server allows. **CSP** (`Content-Security-Policy` header) controls what the browser loads. Use both for defense in depth.

---

## Common misconfigurations

| Misconfiguration                              | Risk                                                        |
|-----------------------------------------------|-------------------------------------------------------------|
| `Access-Control-Allow-Origin: *` with cookies | Credential theft — browser blocks it but signals bad config |
| Blindly reflecting `Origin` header            | Any origin can read the response                            |
| Allowing `null` origin                        | Enables cross-site data reads from sandboxed contexts       |
| Trusting `Origin` without HTTPS               | Origin header is user-controlled over HTTP                  |
| Overly broad `Allow-Headers: *`               | May expose internal routing or auth headers                 |
