# Tinnitus Tracker – Projektdokumentation

## Zweck

Progressive Web App (PWA) für Patienten der Tinnituspraxis Seedorf in Ahrensburg.
Patienten tracken täglich ihre Tinnitus-Intensität und können ihren Tinnitus-Sound matchen.

**Live-URL:** https://app.tinnituspraxis-seedorf.de
**GitHub:** https://github.com/Boris1900/tinnuts-tracker_0.1

---

## Aktueller Stand (Cache v18 / App v1.3)

### Dateien im Repo

```
TinnitusTracker/
├── TinnitusTracker_Seedorf.html  ← Haupt-App (alles-in-einem)
├── index.html                    ← Landingpage
├── manifest.json                 ← PWA-Konfiguration
├── sw.js                         ← Service Worker (Cache: tinnitus-tracker-v14)
├── icon-192.png / icon-512.png   ← App-Icons
├── CNAME                         ← GitHub Pages Domain: app.tinnituspraxis-seedorf.de
└── CLAUDE.md                     ← Diese Datei
```

Alle App-Logik ist in `TinnitusTracker_Seedorf.html` – Vanilla JS/HTML/CSS, kein Build-Schritt.

### Tech-Stack

- **Vanilla JS + HTML/CSS** (kein React, kein npm – direkt im Browser)
- **Web Audio API** – für Tinnitus-Tester (Soundgenerator)
- **localStorage** – für Datenpersistenz (Einträge überleben Reload)
- **PWA** mit Service Worker (offline-fähig, auf Android/iOS installierbar)
- Sprache: Deutsch, Lokalisierung: de-DE
- Deployed via: GitHub Pages

### Zuletzt umgesetzt (Session Mai 2026 – v1.3)

**Update-Prüfung für iOS (v1.3):**
- Button "Auf Update prüfen" in Einstellungen → Über die App
- Lädt sw.js frisch aus dem Netz, vergleicht CACHE-Version mit CURRENT_CACHE-Konstante
- Bei veralteter Version: "🆕 Update verfügbar → Jetzt laden" → löscht alle Caches + reload
- Bei aktueller Version: "✅ Du hast bereits die aktuelle Version."
- WICHTIG: CURRENT_CACHE in HTML muss immer mit CACHE in sw.js übereinstimmen

**Verlauf-Diagramm: Datumsanzeige und Aggregation (v1.2):**
- X-Achse zeigt Datum jetzt tagesbasiert (beim ersten Eintrag jedes Tages) statt index-basiert
- 7-Tage-Ansicht: alle Einzelpunkte wie bisher
- 30-Tage-Ansicht: Tagesdurchschnitt + Hinweistext "Angezeigt wird der Tagesdurchschnitt..."
- Alles-Ansicht: adaptiv – ≤14 Tage: Einzelpunkte, ≤60 Tage: Tagesdurchschnitt, >60 Tage: Wochendurchschnitt + jeweiliger Hinweistext
- Hilfsfunktionen aggregateByDay() und aggregateByWeek() ergänzt

**Tester-Tab komplett neu gebaut (v1.1):**
- 6 neue Klangtypen: Hochtonpiepen, Tiefes Brummen, Pulsieren, Klingeln, Grillenzirpen, Gefiltertes Rauschen
- Bug behoben: `tKanals` hatte `'piepen'` doppelt – zweite Instanz war toter Code
- Lautstärke-Standard auf 1% gesenkt (war 5%)
- Klangprofil speichern / laden via localStorage
- Result-Box zeigt aktive Klänge mit Einstellungen

**PDF-Export komplett überarbeitet:**
- Klick auf "Als PDF exportieren" öffnet jetzt ein Modal mit Auswahl
- Zeitraum: 7 / 14 / 30 / 60 Tage / Alle
- Inhalt: Verlauf & Tagebuch · Nur Verlauf (Diagramm) · Nur Tagebuch
- Das Verlaufsdiagramm wird auf einem temporären Canvas neu gezeichnet und als Bild eingebettet – funktioniert unabhängig vom aktiven Tab
- Exportiert wird gefiltert nach gewähltem Zeitraum (nicht mehr immer alle Daten)

### Navigation (6 Views)

| Tab | View-ID | Beschreibung |
|-----|---------|--------------|
| Eintragen | `view-track` | Intensität 1–10 erfassen, Ereignisnotiz |
| Verlauf | `view-chart` | Liniendiagramm, Statistiken |
| Tagebuch | `view-log` | Alle Einträge nach Datum gruppiert |
| Blog | `view-blog` | Praxis-Artikel / Tipps |
| Tester | `view-tester` | Tinnitus-Sound matching (Frequenz, Lautstärke) |
| ⚙️ | `view-settings` | Einstellungen |

### Features im Detail

**Eintragen (track)**
- Intensitäts-Slider 1–10 mit deutschen Labels (Kaum hörbar → Unerträglich)
- 10 Schnell-Buttons für direkte Auswahl
- Farbkodierung: grün (1) → rot (10)
- Optionale Ereignisnotiz
- Maximal 3 Einträge pro Tag

**Verlauf (chart)**
- Statistik-Karten: Gesamteinträge, Ø Intensität, Maximum
- Liniendiagramm mit farbigen Datenpunkten
- Intelligente X-Achsenbeschriftung je nach Zeitraum:
  - 7 Tage: pro Tag einmal (nicht pro Eintrag – mehrfach-Einträge am selben Tag werden zusammengefasst)
  - 30 Tage: alle 5 Punkte
  - Alles: alle 10 Punkte
  - Mindestabstand 28px verhindert Überlappungen
- **Offen:** Noch nicht live getestet – Boris' Einträge wurden beim Cache-Löschen gelöscht

**Tagebuch (log)**
- Alle Einträge nach Datum, neueste zuerst
- Farbiger linker Rand je nach Intensität
- Uhrzeit, Intensitätslabel, Ereignisnotiz

**Tester**
- Tinnitus-Sound-Generator (Web Audio API)
- Frequenz-Matching (verschiedene Tinnitus-Klangtypen: Piepen etc.)
- Lautstärke-Einstellung
- Kopfhörer-Hinweis für Nutzer

**Blog**
- Praxis-Artikel werden gerendert (renderManualArticles)
- iOS-optimierte Darstellung

**Einstellungen (⚙️)**
- Über Zahnrad-Icon erreichbar

### Design

- Grünes Farbschema (#5c7a5c primary, #3d5c3d dark)
- Branding: "Tinnituspraxis Seedorf · Ahrensburg"
- Responsive, max-width 480px (Mobile-First)
- Open Sans Font (Google Fonts CDN)
- Custom EarIcon SVG

---

## Versionierungs-Regel (WICHTIG)

Bei **jeder** Änderung die deployed wird:

1. Cache-Version in `sw.js` hochzählen: `tinnitus-tracker-v18` → `v19`
2. App-Version in `TinnitusTracker_Seedorf.html` hochzählen: `v1.3` → `v1.4`
3. CURRENT_CACHE-Konstante in TinnitusTracker_Seedorf.html ebenfalls hochzählen (muss mit sw.js übereinstimmen)
   - Steht an **zwei Stellen**: in den Einstellungen (Über die App) und im Footer
3. Commit + Push

**Warum:** Boris sieht die App-Version auf dem Handy (Einstellungen → Über die App, oder ganz unten im Footer). So kann er sofort prüfen ob das Update geladen wurde – ohne raten zu müssen.

**Achtung:** "Browserdaten löschen" in Chrome löscht auch den localStorage (= alle Einträge der App). Nutzer NIE dazu anleiten, es sei denn sie wollen wirklich alles löschen.

---

## Deployment

```bash
cd C:\Users\Boris\Projekte\TinnitusTracker
git add TinnitusTracker_Seedorf.html sw.js
git commit -m "Kurze Beschreibung"
git push
```
GitHub Pages deployed automatisch auf https://app.tinnituspraxis-seedorf.de (~1 Minute)

---

## Entwicklungs-Workflow

1. Änderungen in `TinnitusTracker_Seedorf.html` machen
2. Cache-Version in `sw.js` hochzählen
3. App-Version in `TinnitusTracker_Seedorf.html` an beiden Stellen hochzählen
4. `git commit` + `git push` → live in ~1 Minute

---

## Session-Workflow

Jede Arbeitseinheit als neue Claude Code Session starten.
Am Ende jeder Session: CLAUDE.md aktualisieren ("Was haben wir heute gemacht, was ist offen?").
Erste Frage in neuer Session: "Lies die CLAUDE.md und sag mir kurz wo wir stehen."

---

## Nächstes Feature (PRIORITÄT)

**Tester-Tab Feinschliff – konkrete Änderungen aus Boris' Feedback (Mai 2026)**

Der Tester läuft (v1.1), ist aber noch nicht final. Folgende Änderungen beim nächsten Mal umsetzen – KEIN weiteres Konzeptgespräch nötig, einfach direkt machen:

1. **Pulsieren entfernen** – Boris braucht diesen Klangtyp nicht, Platz sparen.

2. **Klingeln überarbeiten** – Der aktuelle Klang (Sinuston + inharmonische Obertöne) klingt nicht nach dem, was Menschen als "Klingeln" kennen (Telefon, Türklingel). Neu implementieren: pulsierender Hochton mit kurzen An/Aus-Bursts (~4–6 Hz Pulsrate), evtl. mit leicht ansteigender Hüllkurve. Oder: zwei Töne im Wechsel (wie Telefon-Doppelklingeln). Boris entscheidet nach Probe.

3. **Grillenzirpen – Zirprate anpassen** – Aktuell 10–80 /Sek, wirkt zu langsam. Bereich auf 30–200 /Sek erhöhen, Standardwert auf ~80 /Sek setzen. Grillen zirpen deutlich schneller als der aktuelle Default.

4. **Gefiltertes Rauschen – Frequenzbereich erweitern** – Aktuell Mittenton bis 8000 Hz → auf 12.000 Hz erhöhen.

5. **Gefiltertes Rauschen – Bandpassfilter schmaler machen** – Aktuell Q max 20. Auf Q max 60–80 erhöhen. Beschriftung: Breit / Mittel / Schmal / Sehr schmal (statt nur 3 Stufen). Grenzwerte anpassen:
   - Q ≤ 2 → Breit
   - Q 3–8 → Mittel
   - Q 9–25 → Schmal
   - Q > 25 → Sehr schmal

6. **Result-Box live aktualisieren** – Aktuell wird `tUpdateResult()` nur bei Toggle aufgerufen. Zusätzlich in `tUpdateF()`, `tUpdateV()` und `tUpdateR()` am Ende aufrufen, damit die Box sofort mitzieht wenn Regler bewegt wird.

---

**PDF-Export – Beobachtungsphase**

Der neue PDF-Export (Zeitraum + Diagramm + Inhaltsauswahl) ist live. Boris muss erst Daten ansammeln, um zu sehen wie der Ausdruck mit vielen Einträgen (30/60 Tage) aussieht. Offene Überlegung: Querformat für Diagramm-Exporte – aber erst entscheiden wenn klar ist ob es ein Problem gibt.

---

## Offene Punkte / Ideen

- [ ] Tester-Tab Feinschliff (PRIORITÄT – nächste Session, Änderungen oben dokumentiert)
- [ ] PDF-Export: Drucklayout bei vielen Daten beobachten (Querformat ggf. nachrüsten)
- [ ] JSON-Export als Backup-Funktion (nach Cache-Löschen-Vorfall dringend empfohlen)
- [ ] Automatische Backup-Erinnerung alle 4 Wochen
- [ ] Einträge löschen können (einzeln oder alle)
- [ ] Wochenübersicht / Monatsdurchschnitte
- [ ] Erinnerungs-Notifications
- [ ] Morgen/Abend-Vergleich
