# krasosu.de

Statische Landingpage für krasosu.de — Terminal-Optik, Link-Übersicht zu
Hobbyprojekten und Infrastruktur, inkl. Cookie-Consent-Banner (Akzeptieren/
Ablehnen, nur lokal in `localStorage` gespeichert). Reiner Static-Content,
kein Backend — ausgeliefert über `nginx:alpine`.

## Lokal starten (ohne Docker)

Einfach `public/index.html` im Browser öffnen, oder mit einem beliebigen
Static-Server:

```bash
npx serve public
```

## Lokal starten (mit Docker)

```bash
docker build -t krasosu-landingpage:latest .
docker compose up -d
```

Danach im Browser: http://localhost:8080

## Deployment auf dem vServer

1. Projektverzeichnis auf den vServer kopieren (z.B. `scp` oder `git`).
2. `docker build -t krasosu-landingpage:latest .` auf dem Server ausführen.
3. `docker compose up -d` auf dem Server ausführen.
4. Reverse Proxy (nginx/Caddy/Traefik) mit TLS davorschalten und auf
   Port 8080 dieses Containers zeigen lassen, damit `https://krasosu.de`
   direkt auf die Landingpage geht (ohne Port in der URL). Das LCARS-Projekt
   bleibt wie bisher separat unter `krasosu.de:3001` erreichbar.

## Vor dem Go-Live: offene Pflichtangaben

Die Seite enthält bereits ein Impressum (`public/imprint.html`) und eine
Datenschutzerklärung (`public/privacy.html`), beide aber noch mit
**TODO-Platzhaltern** markiert:

- **Postanschrift** (§ 5 TMG) — in beiden Seiten nachtragen.
- **Hosting-Angaben** (Provider des vServers, tatsächliche Log-Aufbewahrungsfrist)
  — in `privacy.html` nachtragen.

Die Seite sollte nicht live gehen, solange diese Platzhalter noch sichtbar
sind (im Code als `<span class="todo">…</span>` markiert, auf der Seite
gelb hervorgehoben).

## Struktur

```
public/
  index.html    Landingpage
  imprint.html  Impressum (§ 5 TMG)
  privacy.html  Datenschutzerklärung (Art. 13 DSGVO)
```

## Platzhalter-Links, die noch geprüft werden sollten

- `docker-image-downloader` → https://docker-image-downloader.de, Kurzbeschreibung
  ("Pull Docker images without a local Docker daemon") ist eine Annahme —
  bei Bedarf in `public/index.html` anpassen.
