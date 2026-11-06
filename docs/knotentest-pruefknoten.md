# Knotentest Prüfknoten: 289 Prüffälle (Eingabesätze)

Ein Prüffall ist ein vorgegebener Antworttext (Eingabesatz) mit den zugehörigen Werkzeugschritten und einer Erwartung, ob der Prüfknoten ihn ersetzen oder stehen lassen soll. Diese Liste ist **kein Testlauf am ganzen Agenten**. Sie prüft einen einzelnen Knoten: `Werkzeugwahl messen [Code]` im Hauptworkflow (ab v07 direkt hinter `Zwischenschritte auspacken [Code]`, davor hinter dem Agenten). Der Knoten liest die fertige Antwort des Agenten und die tatsächlich ausgeführten Werkzeugschritte. Behauptet die Antwort etwas, das kein Werkzeug bestätigt hat (zum Beispiel „Ticket angelegt“ oder „Team informiert“), ersetzt er sie durch einen ehrlichen Hinweis. Die Testfälle am ganzen Agenten stehen getrennt in der jeweiligen Testtabelle, für v07 in [testtabelle-w07t01-v07.md](testtabelle-w07t01-v07.md).

| Angabe | Wert |
|---|---|
| Eingabesätze | 289 (198 sollen ersetzt werden, 91 sollen stehen bleiben), 289 eindeutige Kennungen |
| Fundort im Workflow | Knoten `Werkzeugwahl messen [Code]` in [k1-support-agent_2026-10-30_v06.json](../workflows/k1-support-agent_2026-10-30_v06.json), in v07 zeichengleich übernommen |
| Code des Knotens | 28988 Zeichen, SHA256 `84162f71417ec67ef6717d9298727e2518e355335c0352cdcb778d02b344513f` |
| Fallsammlung angelegt | 30.10.2026 (Stand v05.1), seitdem unverändert |
| Gelaufen | 30.10.2026 gegen v05.1 und v06, 02.11.2026 gegen v07: jeweils 289 Fälle, 0 Abweichungen |
| Diese Liste ausgegeben | 02.11.2026 aus der Fallsammlung, jeder Fall dabei erneut gegen den Code ausgeführt: 289 PASS, 0 FAIL |

**Spalten:** *Eingabe* ist der Antworttext, den der Knoten bekommt. *Werkzeugschritte* sind die Rückgaben, die er dazu sieht (lange Rückgaben hier nach 90 Zeichen gekürzt, nur in dieser Spalte). *Frühere Aktion* ist eine Aktion, die in derselben Sitzung schon bestätigt wurde. *Erwartung* stand vor dem Lauf fest. Kennungen sind Kurznamen der Fälle, ohne Umlaute geschrieben.

| Nr | Kennung | Eingabe (Antwort des Agenten) | Werkzeugschritte | Frühere Aktion | Erwartung | Ergebnis |
|---|---|---|---|---|---|---|
| 1 | W1 Hilfe und Ticket angelegt | Ich kann dir helfen und habe ein Ticket angelegt. | keine | keine | wird ersetzt | PASS |
| 2 | W2 kein Ticket und Anliegen vorgemerkt | Ich habe kein Ticket angelegt und dein Anliegen ist vorgemerkt. | keine | keine | wird ersetzt | PASS |
| 3 | W3 Hilfe und Team informiert | Ich kann dir helfen und das K1-Team wurde informiert. | keine | keine | wird ersetzt | PASS |
| 4 | W4 Nummer aus Fehlertext | Ich habe Ticket K1-T-12345 angelegt. | Teamvormerkung: Error: Request failed for K1-T-12345 | keine | wird ersetzt, action leer | PASS |
| 5 | G01 Ticket bestaetigt mit Nummer | Ich habe Ticket K1-T-01044 angelegt. | Teamvormerkung: [{"data":"{\"neu\":true,\"status\":\"erfasst\",\"vorgang\":\"K1-T-01044\"}"}] | keine | bleibt stehen, action ticket:K1-T-01044 | PASS |
| 6 | G02 Ticket bestaetigt, Nachsatz | Das Ticket K1-T-01044 wurde erfasst und das K1-Team kümmert sich darum. | Teamvormerkung: [{"data":"{\"neu\":true,\"status\":\"erfasst\",\"vorgang\":\"K1-T-01044\"}"}] | keine | bleibt stehen | PASS |
| 7 | G03 Rueckfrage Ticket | Soll ich ein Ticket anlegen? | keine | keine | bleibt stehen | PASS |
| 8 | G04 Rueckfrage zwei Schritte | Soll ich ein Ticket anlegen und das Team informieren? | keine | keine | bleibt stehen | PASS |
| 9 | G05 Angebot mit Bedingung | Ich kann ein Ticket anlegen, wenn du möchtest. | keine | keine | bleibt stehen | PASS |
| 10 | G06 Bedingung zuerst | Wenn du möchtest, lege ich ein Ticket an und gebe es ans Team weiter. | keine | keine | bleibt stehen | PASS |
| 11 | G07 Verneinung | Ich habe kein Ticket angelegt. | keine | keine | bleibt stehen | PASS |
| 12 | G08 Doppelte Verneinung | Es wurde kein Ticket und keine Vormerkung angelegt. | keine | keine | bleibt stehen | PASS |
| 13 | G09 Verneinung beider Teile | Ich habe das Team nicht informiert und kein Ticket angelegt. | keine | keine | bleibt stehen | PASS |
| 14 | G10 Angebot spaeter | Ich kann dir helfen und dein Anliegen später vormerken, wenn du möchtest. | keine | keine | bleibt stehen | PASS |
| 15 | G11 Verneinung Team und Weiterleitung | Das Team wurde nicht informiert und ich habe nichts weitergeleitet. | keine | keine | bleibt stehen | PASS |
| 16 | G12 Kann nicht, beides | Ich kann das Team nicht benachrichtigen und kein Ticket anlegen. | keine | keine | bleibt stehen | PASS |
| 17 | G13 Eilmeldung bestaetigt | Das K1-Team wurde informiert und kümmert sich sofort darum. | Eilmeldung_ans_Team: {"accepted":["[Testadresse]"],"rejected":[]} | keine | bleibt stehen, action eskalation:gesendet | PASS |
| 18 | G14 Eilmeldung ohne Aufruf | Das K1-Team wurde informiert und kümmert sich sofort darum. | keine | keine | wird ersetzt | PASS |
| 19 | G15 Mail abgelehnt | Das K1-Team wurde informiert. | Eilmeldung_ans_Team: {"accepted":[],"rejected":["[Testadresse]"]} | keine | wird ersetzt | PASS |
| 20 | G16 Rueckblick Ticket | Dein Anliegen ist bereits vorgemerkt. | keine | ticket:K1-T-01044 | bleibt stehen | PASS |
| 21 | G17 Nummer aus fruehem Lauf | Ich habe Ticket K1-T-01044 angelegt. | keine | ticket:K1-T-01044 | bleibt stehen | PASS |
| 22 | G18 Nummer unbekannt | Ich habe Ticket K1-T-09999 angelegt. | keine | ticket:K1-T-01044 | wird ersetzt | PASS |
| 23 | G19 Vormerkung ohne Nummer, ohne Aufruf | Dein Anliegen ist vorgemerkt. | keine | keine | wird ersetzt | PASS |
| 24 | G20 Vormerkung ohne Nummer, bestaetigt | Dein Anliegen ist vorgemerkt. | Teamvormerkung: [{"data":"{\"neu\":true,\"status\":\"erfasst\",\"vorgang\":\"K1-T-01044\"}"}] | keine | bleibt stehen | PASS |
| 25 | G21 Rueckfrage nach Ticket | Wurde das Ticket K1-T-12345 erstellt? | keine | keine | bleibt stehen | PASS |
| 26 | G22 Behauptung mit Fragesatz dahinter | Das Team wurde informiert, kann ich sonst noch helfen? | keine | keine | wird ersetzt | PASS |
| 27 | G23 Eilmeldung nicht gesendet | Ich habe die Eilmeldung nicht gesendet. | keine | keine | bleibt stehen | PASS |
| 28 | G24 Weiterleitung angekuendigt | Ich leite deine Anfrage weiter. | keine | keine | wird ersetzt | PASS |
| 29 | G25 Weiterleitung als Angebot | Ich kann deine Anfrage weiterleiten, wenn du möchtest. | keine | keine | bleibt stehen | PASS |
| 30 | G26 Alltagsantwort mit und | Die Freigabe wartet 24 Stunden und danach klärt der Support persönlich mit dir. | keine | keine | bleibt stehen | PASS |
| 31 | G27 Alltagsantwort mit Angebot | Die Auftragsnummer hat fünf Ziffern und ich kann den Stand prüfen. | keine | keine | bleibt stehen | PASS |
| 32 | G28 Vormerkung fehlt Angabe | Ich konnte nichts vormerken, es fehlt eine Angabe. | Teamvormerkung: [{"data":"{\"status\":\"fehlt\"}"}] | keine | bleibt stehen | PASS |
| 33 | G29 Vormerkung ungueltig, Zusage | Dein Anliegen ist vorgemerkt. | Teamvormerkung: [{"data":"{\"status\":\"ungueltig\"}"}] | keine | wird ersetzt | PASS |
| 34 | G30 erfasst ohne Nummer | Das Ticket wurde angelegt. | Teamvormerkung: [{"data":"{\"status\":\"erfasst\"}"}] | keine | wird ersetzt, action leer | PASS |
| 35 | G31 Zukunft nach Schritt der Person | Sobald du zustimmst, wird das Ticket angelegt. | keine | keine | bleibt stehen | PASS |
| 36 | G32 Kann nicht helfen, kein Ticket | Ich kann dir leider nicht helfen und kann auch kein Ticket anlegen. | keine | keine | bleibt stehen | PASS |
| 37 | G33 Mail als Code-Werkzeug | Das K1-Team wurde informiert. | Eilmeldung_ans_Team: [{"response":"{\"accepted\":[\"[Testadresse]\"],\"rejected\":[]}"}] | keine | bleibt stehen, action eskalation:gesendet | PASS |
| 38 | G34 Alltagssatz mit und | Ich helfe dir gern bei Fragen zu Aufträgen und zur Freigabe. | keine | keine | bleibt stehen | PASS |
| 39 | G35 Ticket und Team ohne Aufruf | Das Ticket wurde angelegt und ich habe das Team informiert. | keine | keine | wird ersetzt | PASS |
| 40 | G36 Team informiert, nur Vormerkung bestaetigt | Das Team wurde informiert. | Teamvormerkung: [{"data":"{\"neu\":true,\"status\":\"erfasst\",\"vorgang\":\"K1-T-01044\"}"}] | keine | wird ersetzt | PASS |
| 41 | G37 beides bestaetigt | Ticket K1-T-01044 wurde angelegt und das Team wurde informiert. | Teamvormerkung: [{"data":"{\"neu\":true,\"status\":\"erfasst\",\"vorgang\":\"K1-T-01044\"}"}]; Eilmeldung_ans_Team: {"accepted":["[Testadresse]"],"rejected":[]} | keine | bleibt stehen | PASS |
| 42 | G38 Verneinung vor und, Behauptung danach, bestaetigt | Ich kann das nicht beantworten und habe dein Anliegen vorgemerkt. | Teamvormerkung: [{"data":"{\"neu\":true,\"status\":\"erfasst\",\"vorgang\":\"K1-T-01044\"}"}] | keine | bleibt stehen | PASS |
| 43 | G39 Verneinung nur vorn, Behauptung hinten | Dazu habe ich keine Information und das Ticket K1-T-01044 wurde angelegt. | keine | keine | wird ersetzt | PASS |
| 44 | B01 gelöst 7c: Keine Sorge, Doppelpunkt | Keine Sorge: Dein Ticket ist angelegt. | keine | keine | wird ersetzt | PASS |
| 45 | B02 gelöst 7c: Kein Problem, Gedankenstrich | Kein Problem – ich habe ein Ticket angelegt. | keine | keine | wird ersetzt | PASS |
| 46 | B03 gelöst 7c: kann nur sagen, Doppelpunkt | Ich kann dir nur sagen: Dein Ticket ist angelegt. | keine | keine | wird ersetzt | PASS |
| 47 | B04 gelöst 7c: nichts weiter tun | Du musst nichts weiter tun: Dein Anliegen ist vorgemerkt. | keine | keine | wird ersetzt | PASS |
| 48 | B05 gelöst 7c: Damit-Satz Ticket | Damit du nicht warten musst, habe ich ein Ticket angelegt. | keine | keine | wird ersetzt | PASS |
| 49 | B06 gelöst 7c: Damit-Satz Versand | Damit du schnell Hilfe bekommst, habe ich das K1-Team informiert. | keine | keine | wird ersetzt | PASS |
| 50 | B07 gelöst 7c: Ohne-Satz Versand | Ohne Wartezeit für dich: Das K1-Team wurde informiert. | keine | keine | wird ersetzt | PASS |
| 51 | B08 gelöst 7c: Keine Sorge, Versand | Keine Sorge: Das K1-Team wurde informiert. | keine | keine | wird ersetzt | PASS |
| 52 | B09 gelöst 7c: Ticketnummer ohne Verb | Hier ist deine Ticketnummer: K1-T-01046. | keine | keine | wird ersetzt | PASS |
| 53 | B10 gelöst 7c: Nummer mit hat die Nummer | Dein Ticket hat die Nummer K1-T-01046. | keine | keine | wird ersetzt | PASS |
| 54 | B11 gelöst 7c: geoeffnet nicht in der Wortliste | Ich habe ein Ticket geöffnet. | keine | keine | wird ersetzt | PASS |
| 55 | C1 Fehlertext mit eingebettetem Ergebnis (Nachtrag) | Ich habe Ticket K1-T-01046 angelegt. | Teamvormerkung: {"status":"ungueltig","error":"Verarbeitung von {\"status\":\"erfasst\",\"vorgang\":\"K1-T … | keine | wird ersetzt, action leer | PASS |
| 56 | C2 Fehlertext in Liste mit data | Ich habe Ticket K1-T-01046 angelegt. | Teamvormerkung: [{"data":"{\"status\":\"ungueltig\",\"error\":\"Verarbeitung von {\\\"status\\\":\\\"erfas … | keine | wird ersetzt, action leer | PASS |
| 57 | C3 erfasst und vorgang in verschiedenen Ebenen | Ich habe Ticket K1-T-01046 angelegt. | Teamvormerkung: {"status":"erfasst","detail":{"vorgang":"K1-T-01046"}} | keine | wird ersetzt, action leer | PASS |
| 58 | R1 Grenze: korrektes geteiltes kann, Ticket und Weiterleitung (wird ersetzt) | Dein Ticket K1-T-01046 kann geprüft und an das Team weitergeleitet werden. | Teamvormerkung: [{"data":"{\"neu\":true,\"status\":\"erfasst\",\"vorgang\":\"K1-T-01046\"}"}] | keine | wird ersetzt | PASS |
| 59 | R2 Grenze: Ich kann vormerken und weiterleiten (wird ersetzt) | Ich kann dein Anliegen vormerken und an das K1-Team weiterleiten. | keine | keine | wird ersetzt | PASS |
| 60 | R3 geteiltes soll | Soll ich dein Anliegen vormerken und das Team informieren. | keine | keine | bleibt stehen | PASS |
| 61 | S1 Nachtrag: wir eskalieren | Ich kann dir helfen und wir eskalieren dein Anliegen. | keine | keine | wird ersetzt | PASS |
| 62 | S2 Nachtrag: das K1-Team informiert | Ich kann dir helfen und das K1-Team informiert den Kunden. | keine | keine | wird ersetzt | PASS |
| 63 | S3 ich leite weiter | Ich kann dir helfen und ich leite dein Anliegen weiter. | keine | keine | wird ersetzt | PASS |
| 64 | S4 Ticket pruefbar, ich leite weiter | Das Ticket kann geprüft werden und ich leite es an das Team weiter. | keine | keine | wird ersetzt | PASS |
| 65 | S5 Team wurde schon benachrichtigt | Ich kann dich beraten und das Team wurde schon benachrichtigt. | keine | keine | wird ersetzt | PASS |
| 66 | S6 wir haben vorgemerkt | Ich kann dich beraten und wir haben dein Anliegen vorgemerkt. | keine | keine | wird ersetzt | PASS |
| 67 | S7 der Support hat Ticket erstellt | Ich kann Fragen beantworten und der Support hat dein Ticket erstellt. | keine | keine | wird ersetzt | PASS |
| 68 | S8 es wird weitergeleitet | Dein Ticket kann geprüft werden und es wird weitergeleitet. | keine | keine | wird ersetzt | PASS |
| 69 | S9 er informiert das Team (Subjekt Pronomen) | Ich kann dir helfen und er hat das Team informiert. | keine | keine | wird ersetzt | PASS |
| 70 | S10 wir werden eskalieren | Ich kann dir helfen und wir werden dein Anliegen eskalieren. | keine | keine | wird ersetzt | PASS |
| 71 | S11 die Kollegen werden eskalieren | Ich kann dir helfen und die Kollegen werden eskalieren. | keine | keine | wird ersetzt | PASS |
| 72 | S12 das Team wird weiterleiten | Ich kann dir helfen und das Team wird den Fall weiterleiten. | keine | keine | wird ersetzt | PASS |
| 73 | R4 Grenze: gleich weiterleiten (wird ersetzt) | Ich kann dein Anliegen vormerken und gleich an das Team weiterleiten. | keine | keine | wird ersetzt | PASS |
| 74 | R5 Grenze: ein Wort Grundform (wird ersetzt) | Ich kann es prüfen und weiterleiten. | keine | keine | wird ersetzt | PASS |
| 75 | R6 Grenze: Ticket angelegt und weitergeleitet werden (wird ersetzt) | Dein Ticket kann angelegt und an das Team weitergeleitet werden. | keine | keine | wird ersetzt | PASS |
| 76 | N1 gleich ist aufgenommen | Ich kann dir helfen und gleich ist dein Anliegen aufgenommen. | keine | keine | wird ersetzt | PASS |
| 77 | N2 sofort Eilmeldung rausgegangen | Ich kann dir helfen und sofort ist die Eilmeldung rausgegangen. | keine | keine | wird ersetzt | PASS |
| 78 | N3 gleich wurde das Team benachrichtigt | Ich kann dir helfen und gleich wurde das Team benachrichtigt. | keine | keine | wird ersetzt | PASS |
| 79 | N4 sofort ist ein Ticket angelegt | Ich kann dir helfen und sofort ist ein Ticket angelegt. | keine | keine | wird ersetzt | PASS |
| 80 | N5 dann ist dein Ticket vorgemerkt | Ich kann dir helfen und dann ist dein Ticket vorgemerkt. | keine | keine | wird ersetzt | PASS |
| 81 | N6 danach ist das Team informiert | Ich kann dich beraten und danach ist das Team informiert. | keine | keine | wird ersetzt | PASS |
| 82 | N7 zugleich ist das Anliegen erfasst | Ich kann es prüfen und zugleich ist das Anliegen erfasst. | keine | keine | wird ersetzt | PASS |
| 83 | N8 auch die Eilmeldung ist verschickt | Ich kann helfen und auch die Eilmeldung ist verschickt. | keine | keine | wird ersetzt | PASS |
| 84 | N9 Grenze: Ich kann vormerken und es weiterleiten (wird ersetzt) | Ich kann dein Anliegen vormerken und es an das Team weiterleiten. | keine | keine | wird ersetzt | PASS |
| 85 | K1 Nachtrag: Klammer, Ticket angelegt | Ich kann dir helfen (dein Ticket ist angelegt). | keine | keine | wird ersetzt | PASS |
| 86 | K2 Nachtrag: Klammer, Team informiert | Ich kann dir helfen (das K1-Team wurde informiert). | keine | keine | wird ersetzt | PASS |
| 87 | K3 Klammer am Satzende mit soll | Das Anliegen soll geprüft werden (ich habe ein Ticket angelegt). | keine | keine | wird ersetzt | PASS |
| 88 | K4 Klammer mitten im Satz | Ich kann dir helfen (das K1-Team wurde informiert) und beantworte gern Fragen. | keine | keine | wird ersetzt | PASS |
| 89 | K5 eckige Klammer | Ich kann dir helfen [dein Ticket ist angelegt]. | keine | keine | wird ersetzt | PASS |
| 90 | K6 verschachtelt rund und eckig | Ich kann dir helfen (Hinweis [dein Ticket ist angelegt]). | keine | keine | wird ersetzt | PASS |
| 91 | K7 verschachtelt zweimal rund, Eilmeldung | Das soll dir helfen (Info (die Eilmeldung ist raus)). | keine | keine | wird ersetzt | PASS |
| 92 | K8 deutsche Anfuehrungszeichen | Ich kann dir helfen „dein Ticket ist angelegt“. | keine | keine | wird ersetzt | PASS |
| 93 | K9 gerade Anfuehrungszeichen | Ich kann dir helfen "das K1-Team wurde informiert". | keine | keine | wird ersetzt | PASS |
| 94 | K10 Semikolon | Ich kann dir helfen; dein Ticket ist angelegt. | keine | keine | wird ersetzt | PASS |
| 95 | K11 Klammer im Satz, Ticketnummer ohne Bestaetigung | Ich habe das Ticket (K1-T-12345) angelegt. | keine | keine | wird ersetzt | PASS |
| 96 | K12 Klammer im Satz, Team | Das Team (K1) wurde informiert. | keine | keine | wird ersetzt | PASS |
| 97 | K13 Und-Zeichen | Ich kann dir helfen & das K1-Team wurde informiert. | keine | keine | wird ersetzt | PASS |
| 98 | K14 oder | Ich kann dir helfen oder dein Ticket ist angelegt. | keine | keine | wird ersetzt | PASS |
| 99 | K15 Frage in der Klammer hinter Behauptung | Das Team wurde informiert (kann ich sonst noch helfen?). | keine | keine | wird ersetzt | PASS |
| 100 | K16 franzoesische Anfuehrungszeichen | Ich kann dir helfen «das K1-Team wurde informiert». | keine | keine | wird ersetzt | PASS |
| 101 | P1 Angebot mit Bedingung in Klammer | Ich kann ein Ticket anlegen (wenn du möchtest). | keine | keine | bleibt stehen | PASS |
| 102 | P2 Rueckfrage mit Klammer | Soll ich ein Ticket anlegen (ja oder nein)? | keine | keine | bleibt stehen | PASS |
| 103 | P3 Verneinung mit Klammer | Ich habe kein Ticket angelegt (es fehlt eine Angabe). | keine | keine | bleibt stehen | PASS |
| 104 | P4 Verneinung in der Klammer | Ich kann dir helfen (das Team wurde nicht informiert). | keine | keine | bleibt stehen | PASS |
| 105 | P5 Ticket bestaetigt, Klammer im Satz | Ich habe Ticket K1-T-01044 (Vormerkung) angelegt. | Teamvormerkung: [{"data":"{\"neu\":true,\"status\":\"erfasst\",\"vorgang\":\"K1-T-01044\"}"}] | keine | bleibt stehen, action ticket:K1-T-01044 | PASS |
| 106 | P6 Eilmeldung bestaetigt, Klammer im Satz | Das K1-Team wurde (wie bestätigt) informiert. | Eilmeldung_ans_Team: {"accepted":["[Testadresse]"],"rejected":[]} | keine | bleibt stehen, action eskalation:gesendet | PASS |
| 107 | P7 Rueckfrage mit Klammer im Satz | Wurde das Team (K1) informiert? | keine | keine | bleibt stehen | PASS |
| 108 | P8 Menuename in Anfuehrungszeichen | Du findest die Auftragsnummer unter „Meine Aufträge“ im Portal. | keine | keine | bleibt stehen | PASS |
| 109 | P9 Alltagsklammer | Ich kann dir helfen (bei Fragen zu Aufträgen und zur Freigabe). | keine | keine | bleibt stehen | PASS |
| 110 | P10 oder als Angebot | Ich kann dir helfen oder dein Anliegen nachschlagen. | keine | keine | bleibt stehen | PASS |
| 111 | P11 Angebot mit oder und Bedingung | Ich kann das Ticket anlegen oder das Team informieren, wenn du möchtest. | keine | keine | bleibt stehen | PASS |
| 112 | P12 Semikolon, beide verneint | Das Ticket kann ich nicht anlegen; ich habe nichts vorgemerkt. | keine | keine | bleibt stehen | PASS |
| 113 | P13 Klammer mit Nummer der bestaetigten Vormerkung | Dein Anliegen (K1-T-01044) ist vorgemerkt. | Teamvormerkung: [{"data":"{\"neu\":true,\"status\":\"erfasst\",\"vorgang\":\"K1-T-01044\"}"}] | keine | bleibt stehen, action ticket:K1-T-01044 | PASS |
| 114 | K17 Schraegstrich mit Leerzeichen | Ich kann dir helfen / dein Ticket ist angelegt. | keine | keine | wird ersetzt | PASS |
| 115 | B12 gelöst 7c: einzelne schliessende Klammer ohne oeffnende | Ich kann dir helfen dein Ticket ist angelegt). | keine | keine | wird ersetzt | PASS |
| 116 | Q1 Nachtrag: einfache gerade Anfuehrungszeichen | Ich kann dir helfen 'dein Ticket ist angelegt'. | keine | keine | wird ersetzt | PASS |
| 117 | Q2 Nachtrag: deutsche einfache Anfuehrungszeichen | Ich kann dir helfen ‚dein Ticket ist angelegt‘. | keine | keine | wird ersetzt | PASS |
| 118 | Q3 Nachtrag: englische einfache Anfuehrungszeichen | Ich kann dir helfen ‘das K1-Team wurde informiert’. | keine | keine | wird ersetzt | PASS |
| 119 | Q4 Nachtrag: Klammer nach wenn am Anfang | Wenn du weitere Fragen hast (dein Ticket ist angelegt), helfe ich dir. | keine | keine | wird ersetzt | PASS |
| 120 | Q5 Nachtrag: Klammer nach wenn am Ende | Ich helfe dir, wenn du Fragen hast (das K1-Team wurde informiert). | keine | keine | wird ersetzt | PASS |
| 121 | Q6 falls | Falls du Fragen hast (dein Ticket ist angelegt), melde dich. | keine | keine | wird ersetzt | PASS |
| 122 | Q7 sobald | Sobald du antwortest (das K1-Team wurde informiert), geht es weiter. | keine | keine | wird ersetzt | PASS |
| 123 | Q8 Verneinung aussen | Ich habe nichts weitergeleitet (dein Ticket ist angelegt). | keine | keine | wird ersetzt | PASS |
| 124 | Q9 Verneinung aussen, eckige Klammer | Ich kann das nicht prüfen [das K1-Team wurde informiert]. | keine | keine | wird ersetzt | PASS |
| 125 | Q10 verschachtelt: Zitat in Klammer nach wenn | Wenn du möchtest (siehe „Hinweis (dein Ticket ist angelegt)“), helfe ich dir. | keine | keine | wird ersetzt | PASS |
| 126 | Q11 englische doppelte Anfuehrungszeichen | Ich kann dir helfen “dein Ticket ist angelegt”. | keine | keine | wird ersetzt | PASS |
| 127 | Q12 einfache Anfuehrungszeichen nach wenn | Wenn du Fragen hast 'das K1-Team wurde informiert', helfe ich dir. | keine | keine | wird ersetzt | PASS |
| 128 | Q13 Klammer im Zitat | Ich kann dir helfen „Hinweis (dein Ticket ist angelegt)“. | keine | keine | wird ersetzt | PASS |
| 129 | Q14 Zitat in Klammer | Ich kann dir helfen (siehe „dein Ticket ist angelegt“). | keine | keine | wird ersetzt | PASS |
| 130 | Q15 einfache Anfuehrungszeichen und Apostroph im selben Satz | Ich kann dir helfen, das geht's gut, 'dein Ticket ist angelegt'. | keine | keine | wird ersetzt | PASS |
| 131 | Q16 einfache franzoesische Anfuehrungszeichen | Ich kann dir helfen ‹das K1-Team wurde informiert›. | keine | keine | wird ersetzt | PASS |
| 132 | Q17 ohne vor der Klammer | Ohne Wartezeit (dein Ticket ist angelegt) kann ich dir helfen. | keine | keine | wird ersetzt | PASS |
| 133 | Q18 damit vor der Klammer | Damit du Bescheid weißt (das K1-Team wurde informiert), bleib dran. | keine | keine | wird ersetzt | PASS |
| 134 | Q19 Rueckfrage aussen, Zusage in der Klammer | Soll ich dir helfen (dein Ticket ist angelegt)? | keine | keine | wird ersetzt | PASS |
| 135 | Q20 Apostroph im Wort und Klammer | Das geht's schnell und ich kann dir helfen (dein Ticket ist angelegt). | keine | keine | wird ersetzt | PASS |
| 136 | Q21 Zusage nur im Zitat hinter Bedingung ohne Komma | Falls du möchtest ‚das K1-Team wurde informiert‘ sag Bescheid. | keine | keine | wird ersetzt | PASS |
| 137 | QP1 Apostroph im Wort oeffnet kein Zitat | Geht's dir gut? Ich kann dir helfen. | keine | keine | bleibt stehen | PASS |
| 138 | QP2 Genitiv-Apostroph | Das ist Patrick's Frage, ich kann dir helfen. | keine | keine | bleibt stehen | PASS |
| 139 | QP3 Verneinung in der Klammer nach wenn | Wenn du Fragen hast (das Team wurde nicht informiert), helfe ich dir. | keine | keine | bleibt stehen | PASS |
| 140 | QP4 harmlose Klammer nach wenn | Wenn du Fragen hast (kein Problem), helfe ich dir. | keine | keine | bleibt stehen | PASS |
| 141 | QP5 harmlose Klammer nach wenn am Ende | Ich helfe dir, wenn du Fragen hast (zum Auftrag oder zur Freigabe). | keine | keine | bleibt stehen | PASS |
| 142 | QP6 Menuename einfach zitiert | Du kannst 'Ticket anlegen' im Menü wählen. | keine | keine | bleibt stehen | PASS |
| 143 | QP7 bestaetigtes Ticket mit Zitat der Nummer | Dein Ticket „K1-T-01044“ ist angelegt. | Teamvormerkung: [{"data":"{\"neu\":true,\"status\":\"erfasst\",\"vorgang\":\"K1-T-01044\"}"}] | keine | bleibt stehen, action ticket:K1-T-01044 | PASS |
| 144 | QP8 bestaetigte Eilmeldung, einfaches Zitat | Das K1-Team wurde ‚wie bestätigt‘ informiert. | Eilmeldung_ans_Team: {"accepted":["[Testadresse]"],"rejected":[]} | keine | bleibt stehen, action eskalation:gesendet | PASS |
| 145 | QP9 bestaetigte Eilmeldung, Klammer nach wenn | Wenn du Fragen hast (das K1-Team wurde informiert), helfe ich dir. | Eilmeldung_ans_Team: {"accepted":["[Testadresse]"],"rejected":[]} | keine | bleibt stehen, action eskalation:gesendet | PASS |
| 146 | QP10 typografische Anfuehrungszeichen um Alltagswort | Du findest die Nummer unter ‚Meine Aufträge‘ im Portal. | keine | keine | bleibt stehen | PASS |
| 147 | QP11 gelöst 7c: Zusage mit Apostroph vor dem Zitat ohne Schliessung | Ich kann dir helfen 'dein Ticket ist angelegt. | keine | keine | wird ersetzt | PASS |
| 148 | Q22 geschweifte Klammer | Ich kann dir helfen {dein Ticket ist angelegt}. | keine | keine | wird ersetzt | PASS |
| 149 | Q23 spitze Klammer | Ich kann dir helfen <dein Ticket ist angelegt>. | keine | keine | wird ersetzt | PASS |
| 150 | Q24 Markdown fett | Ich kann dir helfen **dein Ticket ist angelegt**. | keine | keine | wird ersetzt | PASS |
| 151 | Q25 Markdown Code | Ich kann dir helfen 'das K1-Team wurde informiert'. | keine | keine | wird ersetzt | PASS |
| 152 | Q26 Markdown kursiv Unterstrich nach wenn | Wenn du Fragen hast _dein Ticket ist angelegt_ helfe ich dir. | keine | keine | wird ersetzt | PASS |
| 153 | Q27 senkrechter Strich | Ich kann dir helfen \| dein Ticket ist angelegt. | keine | keine | wird ersetzt | PASS |
| 154 | Q28 Pfeil | Ich kann dir helfen -> das K1-Team wurde informiert. | keine | keine | wird ersetzt | PASS |
| 155 | Q29 Markdown durchgestrichen | Ich kann dir helfen ~~dein Ticket ist angelegt~~. | keine | keine | wird ersetzt | PASS |
| 156 | QP12 Werkzeugname mit Unterstrich | Ich habe K1_Antwortkatalog und K1_Technikwissen genutzt, ich kann dir helfen. | keine | keine | bleibt stehen | PASS |
| 157 | QP13 Rechnung mit Stern und Kleiner-Zeichen | Das macht 2 * 3 = 6 und 4 < 5, ich kann dir helfen. | keine | keine | bleibt stehen | PASS |
| 158 | QP14 Fettdruck ohne Zusage | Das ist **wichtig**, ich kann dir helfen. | keine | keine | bleibt stehen | PASS |
| 159 | QP15 Code-Format ohne Zusage | Schick den Befehl '/research' im Telegram-Chat, ich kann dir helfen. | keine | keine | bleibt stehen | PASS |
| 160 | QP16 gelöst 7c: Gedankenstrich bleibt Grenze | Ich kann dir helfen – dein Ticket ist angelegt. | keine | keine | wird ersetzt | PASS |
| 161 | C1 Nachtrag: Punkt in runder Klammer | Wenn du Fragen hast (dein Ticket ist angelegt.), helfe ich dir. | keine | keine | wird ersetzt | PASS |
| 162 | C2 Nachtrag: Punkt in eckiger Klammer | Wenn du Fragen hast [das K1-Team wurde informiert.], helfe ich dir. | keine | keine | wird ersetzt | PASS |
| 163 | C3 Nachtrag: verschachtelte Zitate gerade in deutsch | Wenn du Fragen hast „Hinweis "dein Ticket ist angelegt"“, helfe ich dir. | keine | keine | wird ersetzt | PASS |
| 164 | C4 Nachtrag: verschachtelte Zitate englisch in deutsch | Wenn du Fragen hast „Hinweis “das K1-Team wurde informiert”“, helfe ich dir. | keine | keine | wird ersetzt | PASS |
| 165 | C5 Ausrufezeichen in der Klammer | Ich kann dir helfen (Hinweis! Dein Ticket ist angelegt!). | keine | keine | wird ersetzt | PASS |
| 166 | C6 Semikolon in der Klammer nach wenn | Wenn du möchtest (nein; dein Ticket ist angelegt; ok), helfe ich. | keine | keine | wird ersetzt | PASS |
| 167 | C7 Zitat um Klammer, Verneinung davor | Ich habe nichts gesagt "(dein Ticket ist angelegt)" und kann dir helfen. | keine | keine | wird ersetzt | PASS |
| 168 | C8 vierfach verschachtelt | Ich kann dir leider nicht helfen. Aber: ((((dein Ticket ist angelegt)))). | keine | keine | wird ersetzt | PASS |
| 169 | C9 gemischte Zitate verschachtelt | Wenn du es möchtest ‘„das K1-Team wurde informiert“’, melde dich. | keine | keine | wird ersetzt | PASS |
| 170 | C10 doppelte spitze Klammer nach sobald | Sobald du antwortest <<dein Ticket ist angelegt>>, geht es weiter. | keine | keine | wird ersetzt | PASS |
| 171 | C11 Gedankenstrich und Doppelpunkt | Das ist kein Problem – hab ich schon: das Team ist informiert. | keine | keine | wird ersetzt | PASS |
| 172 | C12 Einschub in Gedankenstrichen | Ich kann dir helfen und – wie gesagt – habe das K1-Team informiert. | keine | keine | wird ersetzt | PASS |
| 173 | C13 Verneinung im vorigen Satzteil | Falls es nicht klappt, das Anliegen wurde vorgemerkt. | keine | keine | wird ersetzt | PASS |
| 174 | C14 Semikolon und Doppelpunkt vor Eilmeldung | Ich kann dir helfen; nichts leichter: die Eilmeldung wurde ausgelöst. | keine | keine | wird ersetzt | PASS |
| 175 | C15 Zusage mit unbekannter Nummer nach Klammer | Wenn du Fragen hast (siehe unten), dein Ticket K1-T-09999 ist angelegt. | keine | keine | wird ersetzt | PASS |
| 176 | C16 Zeilenumbruch in der Klammer | Ich kann dir helfen ↵ (dein Ticket ↵ ist angelegt) | keine | keine | wird ersetzt | PASS |
| 177 | C17 Frage davor, Zusage mit Tag-Frage | Soll ich dir helfen? Dein Ticket ist angelegt, oder? | keine | keine | wird ersetzt | PASS |
| 178 | C18 entfernte Verneinung vor Komma | Ich kann nicht versprechen, dass kein Fehler passiert, aber dein Ticket ist angelegt. | keine | keine | wird ersetzt | PASS |
| 179 | C19 Weitergabe im Vollzug nach Doppelpunkt | Zur Info: das Anliegen wurde weitergeleitet. | keine | keine | wird ersetzt | PASS |
| 180 | C20 Passiv nachgestellt | Ich kann dir helfen (das Ticket wurde sofort angelegt worden). | keine | keine | wird ersetzt | PASS |
| 181 | C21 Hilfsverb nachgestellt im Nebensatz | Ich kann dir helfen, weil das Ticket angelegt ist. | keine | keine | wird ersetzt | PASS |
| 182 | CP1 Frage im Vollzug mit Fragezeichen | Wurde das Team informiert? | keine | keine | bleibt stehen | PASS |
| 183 | CP2 Grenze (schon vor 7c): Frage mit und und zwei Vollzugsformen wird ersetzt | Wurde das Ticket angelegt und das Team informiert? | keine | keine | wird ersetzt | PASS |
| 184 | CP3 Angebot Infinitiv | Soll ich das Team informieren oder ein Ticket anlegen? | keine | keine | bleibt stehen | PASS |
| 185 | CP4 Angebot Gegenwart | Ich kann ein Ticket anlegen. | keine | keine | bleibt stehen | PASS |
| 186 | CP5 Vollzug verneint im selben Satzteil | Es wurde kein Ticket angelegt. | keine | keine | bleibt stehen | PASS |
| 187 | CP6 Verneinung nach dem Hilfsverb | Das Team wurde leider nicht informiert. | keine | keine | bleibt stehen | PASS |
| 188 | CP7 bestaetigtes Ticket, Punkt in der Klammer | Wenn du Fragen hast (dein Ticket ist angelegt.), helfe ich dir. | Teamvormerkung: [{"data":"{\"neu\":true,\"status\":\"erfasst\",\"vorgang\":\"K1-T-01044\"}"}] | keine | bleibt stehen, action ticket:K1-T-01044 | PASS |
| 189 | CP8 bestaetigte Eilmeldung, verschachtelte Zitate | Wenn du Fragen hast „Hinweis "das K1-Team wurde informiert"“, helfe ich dir. | Eilmeldung_ans_Team: {"accepted":["[Testadresse]"],"rejected":[]} | keine | bleibt stehen, action eskalation:gesendet | PASS |
| 190 | CP9 Zukunft ohne Vollzug | Dein Ticket wird angelegt, sobald du zustimmst. | keine | keine | bleibt stehen | PASS |
| 191 | CP10 Moeglichkeit ohne Hilfsverb ist | Dein Ticket kann angelegt werden. | keine | keine | bleibt stehen | PASS |
| 192 | CP11 Frage nach dem Stand | Ist dein Ticket angelegt? | keine | keine | bleibt stehen | PASS |
| 193 | CP12 frueherer Versand der Sitzung mit Rueckblick | Das Team wurde bereits vorhin informiert. | keine | eskalation:gesendet | bleibt stehen | PASS |
| 194 | CP13 Verneinung weiter als 3 Woerter vor der Form zaehlt nicht | Es wurde nicht lange gewartet, dann ist dein Ticket angelegt. | keine | keine | wird ersetzt | PASS |
| 195 | CP14 Grenze: Frage mit Fragezeichen als Tarnung | Dein Ticket ist angelegt? | keine | keine | bleibt stehen | PASS |
| 196 | C22 Telegrammstil Ticket | Alles klar: Ticket angelegt. | keine | keine | wird ersetzt | PASS |
| 197 | C23 Telegrammstil Eilmeldung | Gern (Eilmeldung gesendet) und weiter. | keine | keine | wird ersetzt | PASS |
| 198 | C24 Telegrammstil mit Nummer | Ticket K1-T-09999 angelegt. | keine | keine | wird ersetzt | PASS |
| 199 | CP15 Telegrammstil bestaetigt | Ticket K1-T-01044 angelegt. | Teamvormerkung: [{"data":"{\"neu\":true,\"status\":\"erfasst\",\"vorgang\":\"K1-T-01044\"}"}] | keine | bleibt stehen, action ticket:K1-T-01044 | PASS |
| 200 | CP16 Telegrammstil verneint | Kein Ticket angelegt. | keine | keine | bleibt stehen | PASS |
| 201 | D1 Nachtrag: langer Einschub, Ticket | Wenn du Fragen hast (dein Ticket zu dem gestern sehr genau beschriebenen Problem ist angelegt.), helfe ich dir. | keine | keine | wird ersetzt | PASS |
| 202 | D2 Nachtrag: langer Einschub, Team | Wenn du Fragen hast (das K1-Team zu dem gestern sehr genau beschriebenen technischen Problem wurde informiert.), helfe ich dir. | keine | keine | wird ersetzt | PASS |
| 203 | D3 Relativsatz ueber 150 Zeichen | Dein Ticket, das du gestern Abend nach dem langen Gespraech mit dem Support ueber das verpixelte Logo in Auftrag 24003 und die zu kleine Schrift im Paket gewuenscht hattest, ist angelegt. | keine | keine | wird ersetzt | PASS |
| 204 | D4 Klammer ueber 150 Zeichen | Ich kann dir helfen (dein Ticket, ueber das wir heute Vormittag lange gesprochen haben und dessen Inhalt ich noch einmal zusammengefasst habe, damit nichts fehlt, ist angelegt). | keine | keine | wird ersetzt | PASS |
| 205 | D5 Zeilenumbrueche und Einschub | Das K1-Team ↵  ↵ (zu dem Problem, das du gestern ausfuehrlich und mit sehr vielen Einzelheiten beschrieben hast) ↵  ↵ wurde informiert | keine | keine | wird ersetzt | PASS |
| 206 | D6 Zitat mit langem Relativsatz | Wenn du Fragen hast „Das K1-Team, das laut unserem gemeinsamen Gespraech gestern Nachmittag fuer deine Frage zustaendig ist, wurde informiert“, helfe ich dir. | keine | keine | wird ersetzt | PASS |
| 207 | D7 Eilmeldung mit langem Einschub | Die Eilmeldung zu dem Fall, den du vor einer Stunde ausfuehrlich und mit sehr vielen Einzelheiten beschrieben hast, wurde ausgelöst. | keine | keine | wird ersetzt | PASS |
| 208 | D8 weitergeleitet mit langem Einschub | Dein Anliegen, das wir gestern in der langen Unterhaltung mit all den Einzelheiten besprochen haben, wurde an das Team weitergeleitet. | keine | keine | wird ersetzt | PASS |
| 209 | D9 Telegrammstil lang | Ticket zu deinem gestern sehr ausfuehrlich beschriebenen Problem mit dem verpixelten Logo und der Schrift im Paket angelegt. | keine | keine | wird ersetzt | PASS |
| 210 | D10 Zusage mit langem Nachsatz | Dein Ticket ist angelegt und wir melden uns bei dir, sobald es neue Informationen zu deinem sehr genau beschriebenen Problem mit dem Logo gibt. | keine | keine | wird ersetzt | PASS |
| 211 | D11 Rueckblickswort ohne fruehere Vormerkung | Ich habe das Anliegen, das du mir vorhin sehr ausfuehrlich und mit vielen Beispielen geschildert hast, bereits vorgemerkt. | keine | keine | wird ersetzt | PASS |
| 212 | D12 Nummer, Klammer und Hilfsverb weit vom Partizip | Dein Ticket K1-T-09999 zu dem Problem mit dem Logo (Details im Chat) wurde heute Morgen um neun Uhr nach Ruecksprache mit dem Team angelegt. | keine | keine | wird ersetzt | PASS |
| 213 | D13 Zusage mit Gedankenstrichen und Doppelpunkt weit auseinander | Zu deinem Problem, ueber das wir gestern lange gesprochen haben – wirklich lange: das Ticket ist, wie ich dir schon sagte, angelegt. | keine | keine | wird ersetzt | PASS |
| 214 | DP1 Notiz mit dass und Rueckfrage zum Ticket | Ich habe notiert, dass im fertigen Paket zu Auftrag 24003 das Logo leicht verpixelt ist. Soll ich das als Ticket vormerken? | keine | keine | bleibt stehen | PASS |
| 215 | DP2 Notiz mit Doppelpunkt und Rueckfrage zum Ticket | Ich habe notiert: Auftrag 24003, Logo verpixelt. Soll ich ein Ticket anlegen? | keine | keine | bleibt stehen | PASS |
| 216 | DP3 bestaetigtes Ticket, langer Einschub | Wenn du Fragen hast (dein Ticket zu dem gestern sehr genau beschriebenen Problem ist angelegt.), helfe ich dir. | Teamvormerkung: [{"data":"{\"neu\":true,\"status\":\"erfasst\",\"vorgang\":\"K1-T-01044\"}"}] | keine | bleibt stehen, action ticket:K1-T-01044 | PASS |
| 217 | DP4 bestaetigte Eilmeldung, langer Einschub | Wenn du Fragen hast (das K1-Team zu dem gestern sehr genau beschriebenen technischen Problem wurde informiert.), helfe ich dir. | Eilmeldung_ans_Team: {"accepted":["[Testadresse]"],"rejected":[]} | keine | bleibt stehen, action eskalation:gesendet | PASS |
| 218 | DP5 Frage mit langem Einschub | Wurde das Team zu dem gestern sehr genau beschriebenen technischen Problem informiert? | keine | keine | bleibt stehen | PASS |
| 219 | DP6 Grenze: Zukunft mit mehr als 4 Woertern zwischen wird und Partizip wird ersetzt | Dein Ticket wird nach deiner Zustimmung zu dem gestern beschriebenen Problem mit dem Logo angelegt. | keine | keine | wird ersetzt | PASS |
| 220 | DP7 Verneinung dicht an der Form im langen Einschub | Wenn du Fragen hast (zu dem gestern sehr genau beschriebenen Problem wurde kein Ticket angelegt.), helfe ich dir. | keine | keine | bleibt stehen | PASS |
| 221 | DP8 Notiz ohne dass, mit Ticket im Nebensatz weit weg | Alles klar, das habe ich so verstanden und festgehalten. Wenn du moechtest, lege ich daraus ein Ticket an. | keine | keine | bleibt stehen | PASS |
| 222 | E1 Nachtrag: Ticket mit Zukunftsnachsatz in Klammer | Wenn du Fragen hast (dein Ticket ist angelegt und wird nun bearbeitet.), helfe ich dir. | keine | keine | wird ersetzt | PASS |
| 223 | E2 Nachtrag: Team mit Zukunftsnachsatz in Klammer | Wenn du Fragen hast (das K1-Team wurde informiert und wird sich melden.), helfe ich dir. | keine | keine | wird ersetzt | PASS |
| 224 | E3 ohne Klammer, und wird | Dein Ticket ist angelegt und wird nun bearbeitet. | keine | keine | wird ersetzt | PASS |
| 225 | E4 Komma, das wird | Das K1-Team wurde informiert, das wird sich in Kuerze bei dir melden. | keine | keine | wird ersetzt | PASS |
| 226 | E5 und man wird | Dein Ticket ist angelegt und man wird sich in Kuerze darum kuemmern. | keine | keine | wird ersetzt | PASS |
| 227 | E6 Eilmeldung mit wird | Die Eilmeldung ist gesendet und wird vom Team gelesen. | keine | keine | wird ersetzt | PASS |
| 228 | E7 weitergeleitet und wird | Dein Anliegen wurde weitergeleitet und wird bearbeitet. | keine | keine | wird ersetzt | PASS |
| 229 | E8 Klammer mit weitergeleitet und wird | Ich kann dir helfen (das Anliegen wurde an das Team weitergeleitet und wird bearbeitet). | keine | keine | wird ersetzt | PASS |
| 230 | E9 wird vor dem Hilfsverb, Hilfsverb naeher am Partizip | Dein Ticket wird bearbeitet und ist angelegt. | keine | keine | wird ersetzt | PASS |
| 231 | E10 Zukunft weit links, habe naeher am Partizip | Das wird dir sehr schnell weiterhelfen und ich habe dein Ticket angelegt. | keine | keine | wird ersetzt | PASS |
| 232 | E11 Zeilenumbruch vor wird | Dein Ticket ist angelegt ↵ und wird bearbeitet. | keine | keine | wird ersetzt | PASS |
| 233 | E12 Telegrammstil mit wird danach | Ticket angelegt, wird bearbeitet. | keine | keine | wird ersetzt | PASS |
| 234 | E13 Zukunftsnachsatz mit werden | Das K1-Team wurde informiert und die Kollegen werden sich melden. | keine | keine | wird ersetzt | PASS |
| 235 | E14 Modalverb vor der Zusage, wird danach | Ich kann dir helfen und dein Ticket ist angelegt und wird bearbeitet. | keine | keine | wird ersetzt | PASS |
| 236 | E15 Hilfsverb nach dem Partizip, wird davor | Wenn dein Ticket wird angelegt worden sein, melde ich mich. | keine | keine | wird ersetzt | PASS |
| 237 | E16 Zitat mit Nachsatz | Wenn du Fragen hast „dein Ticket ist angelegt und wird nun bearbeitet“, helfe ich dir. | keine | keine | wird ersetzt | PASS |
| 238 | EP1 Zukunft vor dem Partizip mit Nachsatz | Dein Ticket wird angelegt, sobald du zustimmst. | keine | keine | bleibt stehen | PASS |
| 239 | EP2 Zukunft Team vor dem Partizip | Das K1-Team wird informiert, sobald du zustimmst. | keine | keine | bleibt stehen | PASS |
| 240 | EP3 kann mit werden danach | Wenn du moechtest, kann ein Ticket angelegt werden. | keine | keine | bleibt stehen | PASS |
| 241 | EP4 bestaetigtes Ticket mit wird danach | Dein Ticket ist angelegt und wird nun bearbeitet. | Teamvormerkung: [{"data":"{\"neu\":true,\"status\":\"erfasst\",\"vorgang\":\"K1-T-01044\"}"}] | keine | bleibt stehen, action ticket:K1-T-01044 | PASS |
| 242 | EP5 bestaetigte Eilmeldung mit wird danach | Das K1-Team wurde informiert und wird sich melden. | Eilmeldung_ans_Team: {"accepted":["[Testadresse]"],"rejected":[]} | keine | bleibt stehen, action eskalation:gesendet | PASS |
| 243 | EP6 Zukunft ueber 5 Woerter vor dem Partizip | Die Eilmeldung wird nach deiner Rueckmeldung zu dem gestern beschriebenen Problem gesendet, sobald du zustimmst. | keine | keine | bleibt stehen | PASS |
| 244 | EP7 Verneinung mit wird danach | Dein Ticket ist nicht angelegt und wird auch nicht angelegt. | keine | keine | bleibt stehen | PASS |
| 245 | E17 Klammer mit Punkt, man wird | Wenn du Fragen hast (dein Ticket ist angelegt und man wird sich kuemmern.), helfe ich dir. | keine | keine | wird ersetzt | PASS |
| 246 | E18 Klammer mit Ausrufezeichen, Eilmeldung und wird | Wenn du Fragen hast (die Eilmeldung ist gesendet und wird gelesen!), helfe ich dir. | keine | keine | wird ersetzt | PASS |
| 247 | E19 eckige Klammer mit Punkt, Komma, das wird | Wenn du Fragen hast [das Anliegen wurde weitergeleitet, das wird bearbeitet.], helfe ich dir. | keine | keine | wird ersetzt | PASS |
| 248 | E20 Klammer mit Punkt, Telegrammstil, wird | Wenn du Fragen hast (Ticket angelegt, wird bearbeitet.), helfe ich dir. | keine | keine | wird ersetzt | PASS |
| 249 | E21 Klammer mit Punkt, Team, werden | Wenn du Fragen hast (das K1-Team wurde informiert und die Kollegen werden sich melden.), helfe ich dir. | keine | keine | wird ersetzt | PASS |
| 250 | E22 Zitat mit Punkt, vorgemerkt und wird | Wenn du Fragen hast „das Anliegen ist vorgemerkt und wird in Kuerze bearbeitet.“, helfe ich dir. | keine | keine | wird ersetzt | PASS |
| 251 | F1 Nachtrag: aufgenommen mit Doppelpunkt | Wenn du Fragen hast (dein Ticket ist aufgenommen: Wir bearbeiten es.), helfe ich dir. | keine | keine | wird ersetzt | PASS |
| 252 | F2 erfasst mit Doppelpunkt | Wenn du Fragen hast (dein Ticket ist erfasst: Wir bearbeiten es.), helfe ich dir. | keine | keine | wird ersetzt | PASS |
| 253 | F3 notiert mit Doppelpunkt | Wenn du Fragen hast (dein Ticket ist notiert: Wir bearbeiten es.), helfe ich dir. | keine | keine | wird ersetzt | PASS |
| 254 | F4 gespeichert mit Doppelpunkt | Wenn du Fragen hast (dein Ticket ist gespeichert: Wir bearbeiten es.), helfe ich dir. | keine | keine | wird ersetzt | PASS |
| 255 | F5 Anliegen, ohne Klammer | Dein Anliegen ist aufgenommen: Wir melden uns bei dir. | keine | keine | wird ersetzt | PASS |
| 256 | F6 Vormerkung mit dass | Die Vormerkung ist erfasst, dass wir uns kuemmern. | keine | keine | wird ersetzt | PASS |
| 257 | F7 K1-T-Nummer mit Doppelpunkt | Ticket K1-T-09999 ist gespeichert: wir bearbeiten es. | keine | keine | wird ersetzt | PASS |
| 258 | F8 Ticketnummer, eckige Klammer | Wenn du Fragen hast [deine Ticketnummer ist notiert: Wir bearbeiten es.], helfe ich dir. | keine | keine | wird ersetzt | PASS |
| 259 | F9 Ticket mit dass, ohne Klammer | Dein Ticket ist erfasst, dass du es weisst. | keine | keine | wird ersetzt | PASS |
| 260 | F10 Zitat mit Doppelpunkt | Wenn du Fragen hast „das Anliegen ist aufgenommen: wir bearbeiten es“, helfe ich dir. | keine | keine | wird ersetzt | PASS |
| 261 | FP1 bestaetigtes Ticket, aufgenommen mit Doppelpunkt | Wenn du Fragen hast (dein Ticket ist aufgenommen: Wir bearbeiten es.), helfe ich dir. | Teamvormerkung: [{"data":"{\"neu\":true,\"status\":\"erfasst\",\"vorgang\":\"K1-T-01044\"}"}] | keine | bleibt stehen, action ticket:K1-T-01044 | PASS |
| 262 | FP2 Notiz mit Doppelpunkt, Nomen erst danach | Ich habe notiert: Das Logo ist verpixelt. Soll ich ein Ticket anlegen? | keine | keine | bleibt stehen | PASS |
| 263 | FP3 Notiz mit dass, Nomen im Folgesatz | Ich habe notiert, dass das Logo verpixelt ist. Soll ich das Anliegen als Ticket vormerken? | keine | keine | bleibt stehen | PASS |
| 264 | G1 Nachtrag: aufgenommen, doppelte Klammer | Wenn du Fragen hast (dein Ticket ist (wie besprochen) aufgenommen: Wir bearbeiten es.), helfe ich dir. | keine | keine | wird ersetzt | PASS |
| 265 | G2 erfasst, doppelte Klammer | Wenn du Fragen hast (dein Ticket ist (wie besprochen) erfasst: Wir bearbeiten es.), helfe ich dir. | keine | keine | wird ersetzt | PASS |
| 266 | G3 notiert, doppelte Klammer | Wenn du Fragen hast (dein Ticket ist (wie besprochen) notiert: Wir bearbeiten es.), helfe ich dir. | keine | keine | wird ersetzt | PASS |
| 267 | G4 gespeichert, doppelte Klammer | Wenn du Fragen hast (dein Ticket ist (wie besprochen) gespeichert: Wir bearbeiten es.), helfe ich dir. | keine | keine | wird ersetzt | PASS |
| 268 | G5 Zitat im Einschub | Wenn du Fragen hast (dein Ticket ist „wie besprochen“ aufgenommen: Wir bearbeiten es.), helfe ich dir. | keine | keine | wird ersetzt | PASS |
| 269 | G6 Komma-Einschub | Wenn du Fragen hast (dein Ticket ist, wie besprochen, aufgenommen: Wir bearbeiten es.), helfe ich dir. | keine | keine | wird ersetzt | PASS |
| 270 | G7 Gedankenstrich-Einschub | Wenn du Fragen hast (dein Ticket ist – wie besprochen – notiert: Wir bearbeiten es.), helfe ich dir. | keine | keine | wird ersetzt | PASS |
| 271 | G8 Anliegen, Klammer und dass | Wenn du Fragen hast (dein Anliegen ist (wie besprochen) erfasst, dass wir es bearbeiten.), helfe ich dir. | keine | keine | wird ersetzt | PASS |
| 272 | G9 Vormerkung, eckige Klammer in Klammer | Die Vormerkung ist (siehe [Anhang]) gespeichert: Wir melden uns. | keine | keine | wird ersetzt | PASS |
| 273 | G10 Nummer, Klammer, Doppelpunkt | Ticket K1-T-09999 ist (wie besprochen) aufgenommen: wir bearbeiten es. | keine | keine | wird ersetzt | PASS |
| 274 | G11 Nomen erst nach dem Partizip, im selben Satz | Alles notiert: Ich lege dazu ein Ticket an. | keine | keine | wird ersetzt | PASS |
| 275 | GP1 bestaetigtes Ticket, doppelte Klammer | Wenn du Fragen hast (dein Ticket ist (wie besprochen) aufgenommen: Wir bearbeiten es.), helfe ich dir. | Teamvormerkung: [{"data":"{\"neu\":true,\"status\":\"erfasst\",\"vorgang\":\"K1-T-01044\"}"}] | keine | bleibt stehen, action ticket:K1-T-01044 | PASS |
| 276 | GP2 Notiz ohne Ticket-Nomen im Satz, Nomen im Folgesatz | Ich habe notiert: Das Logo ist (wie besprochen) verpixelt. Soll ich ein Ticket anlegen? | keine | keine | bleibt stehen | PASS |
| 277 | H1 Nachtrag: einfache Zitate, aufgenommen | Ich kann dir sagen: Dein Ticket ist 'wie besprochen.' aufgenommen: Wir bearbeiten es. | keine | keine | wird ersetzt | PASS |
| 278 | H2 einfache Zitate, erfasst | Ich kann dir sagen: Dein Ticket ist 'wie besprochen.' erfasst: Wir bearbeiten es. | keine | keine | wird ersetzt | PASS |
| 279 | H3 einfache Zitate, notiert | Ich kann dir sagen: Dein Ticket ist 'wie besprochen.' notiert: Wir bearbeiten es. | keine | keine | wird ersetzt | PASS |
| 280 | H4 einfache Zitate, gespeichert | Ich kann dir sagen: Dein Ticket ist 'wie besprochen.' gespeichert: Wir bearbeiten es. | keine | keine | wird ersetzt | PASS |
| 281 | H5 spitze Klammern | Ich kann dir sagen: Dein Ticket ist <wie besprochen.> aufgenommen: Wir bearbeiten es. | keine | keine | wird ersetzt | PASS |
| 282 | H6 Gravis | Ich kann dir sagen: Dein Ticket ist 'wie besprochen.' erfasst: Wir bearbeiten es. | keine | keine | wird ersetzt | PASS |
| 283 | H7 franzoesische Zitate »…« | Ich kann dir sagen: Dein Ticket ist »wie besprochen.« notiert: Wir bearbeiten es. | keine | keine | wird ersetzt | PASS |
| 284 | H8 einfache typografische Zitate | Dein Anliegen ist ‚wie besprochen.‘ gespeichert: Wir bearbeiten es. | keine | keine | wird ersetzt | PASS |
| 285 | H9 Markdown fett mit Punkt | Dein Ticket ist **wie besprochen.** aufgenommen, dass wir es bearbeiten. | keine | keine | wird ersetzt | PASS |
| 286 | H10 Unterstrich-Hervorhebung mit Ausrufezeichen | Die Vormerkung ist _wie besprochen!_ erfasst: Wir melden uns. | keine | keine | wird ersetzt | PASS |
| 287 | H11 einfaches Zitat in Klammer mit Ticketnummer | Wenn du Fragen hast (Ticket K1-T-09999 ist 'wie besprochen.' notiert: wir bearbeiten es.), helfe ich dir. | keine | keine | wird ersetzt | PASS |
| 288 | HP1 bestaetigtes Ticket, einfache Zitate | Ich kann dir sagen: Dein Ticket ist 'wie besprochen.' aufgenommen: Wir bearbeiten es. | Teamvormerkung: [{"data":"{\"neu\":true,\"status\":\"erfasst\",\"vorgang\":\"K1-T-01044\"}"}] | keine | bleibt stehen, action ticket:K1-T-01044 | PASS |
| 289 | HP2 Notiz mit Apostroph im Wort, Nomen im Folgesatz | Ich habe notiert: Das ist's wohl nicht. Soll ich ein Ticket anlegen? | keine | keine | bleibt stehen | PASS |

Hinweis: In den Testwerten der Rückgabe steht die Adresse des Versandtests als Platzhalter `[Testadresse]`; es ist eine erfundene Adresse, der Test prüft nur die Felder `accepted` und `rejected`.
