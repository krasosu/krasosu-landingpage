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

`docker-compose.yml` ist auf den produktiven Traefik-Betrieb ausgelegt (siehe
unten) und veröffentlicht daher **keinen** Host-Port mehr. Für einen
schnellen lokalen Check reicht ein direkter `docker run`, ganz ohne Compose:

```bash
docker build -t krasosu-landingpage:latest .
docker run --rm -p 8080:80 krasosu-landingpage:latest
```

Danach im Browser: http://localhost:8080

## Deployment auf dem vServer

Die Seite läuft produktiv hinter dem zentralen Traefik-Reverse-Proxy aus
[`../deployment`](../deployment) — Details, Labels und die Anbindung der
anderen Container (LCARS, ownCloud, docker-image-downloader) stehen in
dessen README. Kurzfassung für dieses Projekt:

1. Einmalig (falls noch nicht geschehen): `docker network create proxy`
   und den Traefik-Stack aus `../deployment` starten.
2. Projektverzeichnis auf den vServer kopieren (z.B. `scp` oder `git`).
3. `docker build -t krasosu-landingpage:latest .` auf dem Server ausführen.
4. `docker compose up -d` auf dem Server ausführen — das Compose-File hängt
   den Container an das externe Netzwerk `proxy` und trägt Traefik-Labels
   für `krasosu.de` / `www.krasosu.de`, TLS inklusive.
5. LCARS bleibt wie bisher separat unter `krasosu.de:3001` erreichbar
   (eigener Traefik-Entrypoint, siehe `../deployment/README.md`).

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
