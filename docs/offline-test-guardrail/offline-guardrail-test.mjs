// Offline-Test für den Knoten Ausgangs-Guardrail (K1 Support-Agent v11/v12).
// Aufruf: node offline-guardrail-test.mjs <code.js> <eingaben.json>
// code.js = der Inhalt des Feldes jsCode des Knotens (aus dem Export gezogen), eingaben.json = Offline-Eingaben Guardrail W07T05.json.
// Je Fall läuft der Knotencode unverändert mit einem Item { output, tools_called }. Verglichen wird guardrail_treffer mit dem erwarteten Muster.
// Ausgabe: eine Zeile je Fall, danach die Summen je Gruppe. Exit 0 = alle Erwartungen erfüllt, 1 = mindestens eine Abweichung, 2 = Aufruf- oder Lesefehler.
import { readFileSync } from 'node:fs';
const [codeDatei, eingabenDatei] = process.argv.slice(2);
if (!codeDatei || !eingabenDatei) { console.error('Aufruf: node offline-guardrail-test.mjs <code.js> <eingaben.json>'); process.exit(2); }
let code, daten;
try { code = readFileSync(codeDatei, 'utf8'); daten = JSON.parse(readFileSync(eingabenDatei, 'utf8')); }
catch (e) { console.error('Lesefehler: ' + e.message); process.exit(2); }
const AsyncFn = Object.getPrototypeOf(async function () {}).constructor;
const knoten = new AsyncFn('$input', code);
const summe = {};
let abweichungen = 0;
for (const f of daten.faelle) {
  // Adressen stehen in der Datei nur als Platzhalter [Mailadresse] plus Feld adresse [Name, Domain]; hier wird die Eingabe zusammengesetzt.
  const text = f.adresse ? f.text.replace('[Mailadresse]', f.adresse[0] + String.fromCharCode(64) + f.adresse[1]) : f.text;
  const item = { output: text, tools_called: f.tools_called ?? '' };
  const erg = await knoten({ first: () => ({ json: item }) });
  const j = erg[0].json;
  const treffer = j.guardrail_treffer;
  let ok = treffer === f.erwartet;
  let zusatz = '';
  if (ok && f.erwartet_absatz !== undefined) {
    ok = j.aktionsabsatz === f.erwartet_absatz;
    if (!ok) zusatz = ' (Absatz: ' + JSON.stringify(j.aktionsabsatz) + ')';
  }
  const g = (summe[f.gruppe] ??= { gesamt: 0, ok: 0, treffer: 0 });
  g.gesamt++; if (ok) g.ok++; if (treffer) g.treffer++;
  if (!ok) abweichungen++;
  console.log((ok ? 'OK   ' : 'ABW  ') + f.id.padEnd(5) + f.gruppe.padEnd(11) + ('erwartet=' + (f.erwartet || '-')).padEnd(38) + ('ist=' + (treffer || '-')) + zusatz);
}
console.log('---');
for (const [name, g] of Object.entries(summe)) console.log(name.padEnd(11) + 'Fälle ' + g.gesamt + ', wie erwartet ' + g.ok + ', mit Treffer ' + g.treffer);
console.log('Abweichungen von der Erwartung: ' + abweichungen + ', Fälle gesamt: ' + daten.faelle.length);
process.exit(abweichungen === 0 ? 0 : 1);
