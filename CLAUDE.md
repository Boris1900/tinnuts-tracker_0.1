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

v3.0 ist der aktuelle Stand. Tester-Toggles repariert (Rollback auf v2.4-Basis). APK-Update-Flow verbessert: Update-Button öffnet apk.html statt direkt github.com.

**Landingpage (index.html):** Alle Grünflächen auf Markengrün `#7ed957` umgestellt (war vorher dunkles `#5c7a5c`/`#3d5c3d`). Betrifft: Nav-Button, CTA-Buttons, Schritt-Nummern, CTA-Sektion, Footer-Streifen, Quentn-Formular.

### Zusätzliche Dateien im Repo (kein App-Bestandteil)
- `apk.html` – Auto-Download-Weiterleitung für APK-Updates (kein GitHub-App-Konflikt)
- `download.html` – APK-Download-Seite für Erstinstallation
- `tester.html` – **Standalone Tinnitus-Klang-Tester** (Vorschau: app.tinnituspraxis-seedorf.de/tester.html)
  → Wird als eigenes Projekt ausgelagert: `C:\Users\Boris\Projekte\TinnitusTester\`
  → Eigene Domain geplant: `tester.tinnituspraxis-seedorf.de`
  → Neues GitHub-Repo + DNS-Eintrag bei all-inkl nötig

---

## Offene Punkte / Ideen

🔴 hoch / 🟡 mittel / 🟢 niedrig

- 🔴 Verlauf-Tab: Verhalten bei nur 1–2 Einträgen/Tag prüfen (Diagramm, Auswertung)
- 🟡 PDF-Export im Querformat anlegen (Diagramm braucht Breite)
- 🟡 Wochenübersicht / Monatsdurchschnitte ausbauen (30-Tage-Schnitt schon vorhanden)
- 🟢 Backup-Erinnerung alle 4 Wochen (Backup-Funktion selbst ist schon drin)
- 🟢 Morgen/Abend-Vergleich
- 🟢 Tester-Tab verbessern – erst nach Bewerbung der App priorisieren
