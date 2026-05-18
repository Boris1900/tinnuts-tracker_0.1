# Tinnitus Tracker – Projektdokumentation

## Zweck
PWA + Android APK für Patienten der Tinnituspraxis Seedorf in Ahrensburg.
Patienten tracken täglich ihre Tinnitus-Intensität und können ihren Tinnitus-Sound matchen.

**Live-URL:** https://app.tinnituspraxis-seedorf.de
**GitHub:** https://github.com/Boris1900/tinnuts-tracker_0.1

---

## Aktueller Stand (Cache v28 / App v2.3)

Alle App-Logik in `TinnitusTracker_Seedorf.html` – Vanilla JS/HTML/CSS, kein Build-Schritt.
Service Worker: `sw.js` · PWA + Capacitor Android APK · localStorage für Datenpersistenz.

### Navigation (6 Views)

| Tab | View-ID | Beschreibung |
|-----|---------|--------------|
| Eintragen | `view-track` | Intensität 1–10, bis zu 3×/Tag |
| Verlauf | `view-chart` | Liniendiagramm, 7/30/Alles |
| Tagebuch | `view-log` | Alle Einträge nach Datum |
| Blog | `view-blog` | Praxis-Artikel |
| Tester | `view-tester` | Tinnitus-Sound-Generator |
| ⚙️ | `view-settings` | Einstellungen |

---

## Versionierungs-Regel (PFLICHT – NIEMALS VERGESSEN)

⚠️ **Claude muss das bei JEDER Änderung selbstständig erledigen – nicht auf Boris warten!**

Bei **jeder** Änderung die deployed wird:

1. Cache-Version in `sw.js` hochzählen: `tinnitus-tracker-v28` → `v29` + `// APP_VERSION: v2.3` → `v2.4`
2. `CURRENT_CACHE` in `TinnitusTracker_Seedorf.html` hochzählen (muss mit sw.js übereinstimmen)
3. App-Version in `TinnitusTracker_Seedorf.html` hochzählen – steht an **zwei Stellen** (Einstellungen + Footer)
4. `CLAUDE.md` aktualisieren: "Aktueller Stand (Cache vXX / App vX.X)"
5. Commit + Push
6. Bei APK: `.\build-android.ps1` → Android Studio → APK bauen → umbenennen → `gh release create` → `download.html` aktualisieren

**Wichtig:** CURRENT_CACHE in HTML muss immer mit CACHE in sw.js übereinstimmen.
**Achtung:** "Browserdaten löschen" in Chrome löscht auch localStorage. Nutzer NIE dazu anleiten.

---

## Android APK – Build-Workflow

⚠️ **Reihenfolge zwingend einhalten – sonst landet alte Version in der APK!**

1. Änderungen in `TinnitusTracker_Seedorf.html` + Versionsnummern hochzählen
2. `.\build-android.ps1` – kopiert HTML als `www/index.html` + cap sync
3. Android Studio: **Shift+Shift → „Generate APKs"**
4. APK liegt in: `android/app/build/outputs/apk/debug/app-debug.apk`
5. Umbenennen → `gh release create` → `download.html` aktualisieren

**Neue Datei hinzugefügt?** → Auch in `build-android.ps1` eintragen!

### Update-Mechanismus (APK)
- Update-Button lädt `sw.js` von Live-URL, liest `APP_VERSION`
- Bei Update: zeigt APK-Download-Link → `github.com/.../releases/download/vX.X/TinnitusTracker-vX.X.apk`
- Nach Klick: Hinweis „Downloads-Ordner öffnen und installieren"
- Einträge/Einstellungen bleiben bei Update erhalten (localStorage wird nicht angefasst)

---

## Session-Workflow

Am Ende jeder Session: CLAUDE.md aktualisieren. Neue Session starten mit: „Lies die CLAUDE.md und sag mir kurz wo wir stehen."

---

## Offene Aufgaben

### Tester-Tab Feinschliff (PRIORITÄT – direkt umsetzen, kein Konzeptgespräch)
1. **Pulsieren entfernen** – nicht gebraucht
2. **Klingeln überarbeiten** – pulsierender Hochton mit An/Aus-Bursts (~5 Hz, square LFO), Pulsrate-Slider hinzufügen
3. **Grillenzirpen** – Zirprate: min 30 / max 200 / default 80 /Sek (war 10–80)
4. **Gefiltertes Rauschen** – Mittenton max auf 12.000 Hz (war 8.000)
5. **Gefiltertes Rauschen** – Q max 80, 4 Labels: Breit (≤2) / Mittel (3–8) / Schmal (9–25) / Sehr schmal (>25)
6. **Result-Box live** – `tUpdateResult()` am Ende von `tUpdateF()`, `tUpdateV()`, `tUpdateR()` aufrufen
7. **Tester-Button Farbe** – ✅ erledigt (v2.3)

### Verlaufsdiagramm testen
Noch keine echten Daten vorhanden – Boris trägt seit v2.2 echte Einträge ein. Dann prüfen: X-Achse, Aggregation (7/30/Alles), Datumsanzeige.

---

## Offene Punkte / Ideen
- [ ] Automatische Backup-Erinnerung alle 4 Wochen
- [ ] Einträge löschen können (einzeln oder alle)
- [ ] Wochenübersicht / Monatsdurchschnitte
- [ ] Erinnerungs-Notifications
- [ ] Morgen/Abend-Vergleich
- [ ] PDF-Export: Drucklayout bei vielen Daten beobachten (Querformat ggf. nachrüsten)
- [ ] APK-Download-URL verschönern – eigene Weiterleitung statt github.com/Boris1900/...
