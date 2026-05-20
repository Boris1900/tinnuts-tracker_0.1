# Tinnitus Tracker – Projektdokumentation

## Zweck
PWA + Android APK für Patienten der Tinnituspraxis Seedorf in Ahrensburg.
Patienten tracken täglich ihre Tinnitus-Intensität und können ihren Tinnitus-Sound matchen.

**Live-URL:** https://app.tinnituspraxis-seedorf.de
**GitHub:** https://github.com/Boris1900/tinnuts-tracker_0.1

---

## Aktueller Stand (Cache v35 / App v3.0)

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

1. Cache-Version in `sw.js` hochzählen: `tinnitus-tracker-v35` → `v36` + `// APP_VERSION: v3.0` → `v3.1`
2. `CURRENT_CACHE` in `TinnitusTracker_Seedorf.html` hochzählen (muss mit sw.js übereinstimmen)
3. App-Version in `TinnitusTracker_Seedorf.html` hochzählen – steht an **zwei Stellen** (Einstellungen + Footer)
4. `CLAUDE.md` aktualisieren: "Aktueller Stand (Cache vXX / App vX.X)"
5. Commit + Push
6. Bei APK: `.\build-android.ps1` → Android Studio → APK bauen → umbenennen → `gh release create` → `download.html` aktualisieren

**Wichtig:** CURRENT_CACHE in HTML muss immer mit CACHE in sw.js übereinstimmen.
**Achtung:** "Browserdaten löschen" in Chrome löscht auch localStorage. Nutzer NIE dazu anleiten.

---

## Android APK – Build-Workflow

🚨 **CLAUDE MUSS `.\build-android.ps1` IMMER SELBST STARTEN – BEVOR Boris in Android Studio baut!**
🚨 **Ohne build-android.ps1 landet die alte HTML-Version in der APK! Ist bereits 2× passiert (v2.5, v2.8)!**

1. Änderungen in `TinnitusTracker_Seedorf.html` + Versionsnummern hochzählen
2. **`.\build-android.ps1` ausführen** – kopiert HTML als `www/index.html` + cap sync ← CLAUDE MACHT DAS
3. Erst dann Boris sagen: „Jetzt Android Studio → Generate APKs"
4. APK liegt in: `android/app/build/outputs/apk/debug/app-debug.apk`
5. Boris sagt „fertig" → Claude: Umbenennen (Rename-Item!) → `gh release create` → `download.html` aktualisieren

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

## Letzter Stand

v3.0 ist der aktuelle Stand. Tester-Toggles repariert (Rollback auf v2.4-Basis). APK-Update-Flow verbessert: Update-Button in der App öffnet jetzt app.tinnituspraxis-seedorf.de/apk.html statt direkt github.com – kein GitHub-App-Konflikt mehr auf Android.

---

## Offene Aufgaben

### Tester-Tab Feinschliff
✅ Alle Punkte erledigt in v2.6:
- Pulsieren entfernt
- Klingeln: square LFO An/Aus-Bursts, Pulsrate-Slider
- Grillenzirpen: Zirprate min 30 / max 200 / default 80
- Gefiltertes Rauschen: Mittenton max 12.000 Hz, Q max 80, 4 Labels
- Result-Box live bei jedem Slider-Update

### Verlaufsdiagramm testen
Noch keine echten Daten vorhanden – Boris trägt seit v2.2 echte Einträge ein. Dann prüfen: X-Achse, Aggregation (7/30/Alles), Datumsanzeige.

### „Gut gemacht"-Meldung ersetzen
✅ Erledigt in v2.4 – zeigt jetzt „Tiptop!"

### Tageswechsel-Bug (KRITISCH)
✅ Erledigt in v2.4 – `getToday()` nutzte `toISOString()` (UTC). In Deutschland (UTC+2) war nach Mitternacht lokal noch 2h UTC "gestern", deshalb wurden die 3 alten Einträge noch gefunden. Gefixt: `getToday()` nutzt jetzt lokales Datum via `getFullYear()/getMonth()/getDate()`.

---

## Offene Punkte / Ideen
- [ ] Automatische Backup-Erinnerung alle 4 Wochen
- [ ] Einträge löschen können (einzeln oder alle)
- [ ] Wochenübersicht / Monatsdurchschnitte
- [ ] Erinnerungs-Notifications
- [ ] Morgen/Abend-Vergleich
- [ ] PDF-Export: Drucklayout bei vielen Daten beobachten (Querformat ggf. nachrüsten)
- [ ] APK-Download-URL verschönern – eigene Weiterleitung statt github.com/Boris1900/...
