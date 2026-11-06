// Wertet die Protokollzeilen der Sitzung aus: wie viele Nachrichten gab es schon, ist es die erste Antwort, ist die Obergrenze erreicht.
// Gezaehlt wird jede Protokollzeile der Sitzung (jeder Weg schreibt genau eine Zeile je Nachricht).
// Gefahr fuer Personen hat Vorrang vor der Obergrenze: Eine Nachricht mit einem Gefahrwort (Feuer, Brand, verletzt, Notfall, Unfall und aehnliche) geht
// auch ueber der Grenze weiter zu Jev und zum Agenten, damit die Eilmeldung ausgeloest wird, hoechstens fuer 5 Nachrichten ueber der Grenze
// (sonst liesse sich die Obergrenze mit einem Gefahrwort beliebig umgehen). Das ist eine Wortliste, keine Bedeutungserkennung.
// v11 (V6): frage_vorhanden ist false, wenn nach Abzug von Leerzeichen, Tabs, Zeilenumbruechen, Steuer- und Format-Zeichen (Unicode Cc, Cf), kombinierenden Zeichen (Mn),
// Variationsselektoren und den Fuellzeichen U+115F, U+1160, U+3164, U+FFA0, U+17B4, U+17B5, U+2800, U+034F, U+FFFC nichts uebrig bleibt. Das ist eine Zeichenliste, keine Garantie fuer jedes denkbare unsichtbare Zeichen.
// Die Weiche Frage vorhanden? liest nur dieses Feld. Eine leere Frage zaehlt als Nachricht der Sitzung (sie bekommt eine Protokollzeile mit route leer).
const cfg = $('Konfiguration [Edit Fields]').first().json;
const rows = $input.all().map(i => i.json).filter(r => Number(r.id ?? 0) > 0);
const bisher = rows.length;
const grenze = Number(cfg.max_nachrichten);
const puffer = 5;
const BUCH = 'A-Za-zÄÖÜäöüß';
const gefahrWort = new RegExp('(?<![' + BUCH + '])(feuer|brand|brennt|brennen|qualm|rauch|explosion|verletzt\\w*|verletzung|notfall|unfall|bewusstlos|ohnmächtig|herzinfarkt|blutet|blutung|lebensgefahr|notruf|gasgeruch|zusammengebrochen)', 'i');
const gefahr = gefahrWort.test(String(cfg.question ?? ''));
const ueberGrenze = bisher >= grenze;
const gefahrVorrang = ueberGrenze && gefahr && bisher < grenze + puffer;
const frageRest = String(cfg.question ?? '').replace(/[\s\p{Cf}\p{Cc}\p{Mn}ᅟᅠㅤﾠ឴឵⠀͏￼︀-️]/gu, '');
return [{ json: {
  nachrichten_bisher: bisher,
  erste_antwort: bisher === 0,
  limit_erreicht: ueberGrenze && !gefahrVorrang,
  gefahr_vorrang: gefahrVorrang,
  frage_vorhanden: frageRest.length > 0,
  grenze
} }];