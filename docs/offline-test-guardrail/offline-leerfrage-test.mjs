// Offline-Test für den Knoten Sitzung auswerten (Feld frage_vorhanden). Aufruf: node offline-leerfrage-test.mjs <code.js> <eingaben.json>
// Exit 0 = alle Erwartungen erfüllt, 1 = Abweichung, 2 = Lesefehler.
import { readFileSync } from 'node:fs';
const [codeDatei, eingabenDatei] = process.argv.slice(2);
if (!codeDatei || !eingabenDatei) { console.error('Aufruf: node offline-leerfrage-test.mjs <code.js> <eingaben.json>'); process.exit(2); }
let code, daten;
try { code = readFileSync(codeDatei, 'utf8'); daten = JSON.parse(readFileSync(eingabenDatei, 'utf8')); }
catch (e) { console.error('Lesefehler: ' + e.message); process.exit(2); }
const AsyncFn = Object.getPrototypeOf(async function () {}).constructor;
const knoten = new AsyncFn('$input', '$', code);
let ok = 0, abw = 0, leer = 0, nichtLeer = 0;
for (const f of daten.faelle) {
  const cfg = { max_nachrichten: 20, question: f.frage };
  const erg = await knoten({ all: () => [] }, (name) => ({ first: () => ({ json: cfg }) }));
  const ist = erg[0].json.frage_vorhanden;
  const gut = ist === f.frage_vorhanden_erwartet;
  if (f.frage_vorhanden_erwartet) nichtLeer++; else leer++;
  if (gut) ok++; else abw++;
  console.log((gut ? 'OK   ' : 'ABW  ') + f.id.padEnd(5) + ('erwartet=' + f.frage_vorhanden_erwartet).padEnd(22) + ('ist=' + ist).padEnd(12) + f.beschreibung);
}
console.log('---\nEingaben ' + daten.faelle.length + ' (ohne Inhalt ' + leer + ', mit Inhalt ' + nichtLeer + '), wie erwartet ' + ok + ', Abweichungen ' + abw);
process.exit(abw === 0 ? 0 : 1);
