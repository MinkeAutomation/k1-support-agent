// Ausgangs-Guardrail (V7, v11): prueft NUR den Modelltext der Antwort, je Muster ein eigener Regex, nie ein Sammeltext.
// Grundsatz: lieber zu wenig als zu viel ersetzen. Jedes Muster hat einen Koeder und einen harmlosen Gegenfall in der Testtabelle.
// Der Absatz "Bestaetigt: ..." stammt aus den Belegen des Pruefknotens (nicht aus dem Modell). Er wird nur dann vom Modelltext getrennt, wenn er genau dem
// Format des Pruefknotens entspricht (bekannte Bausteine); alles andere bleibt im Modelltext und wird mitgeprueft. Spaeter haengt Antwort zusammensetzen ihn wieder an.
// Getrennt wird nur, wenn dieser Lauf wirklich eine Aktion gerufen hat (tools_called).
// Treffer: guardrail_treffer traegt den Namen des ersten getroffenen Musters (Reihenfolge der Liste), sonst leer. Das ist eine Musterliste, keine Bedeutungserkennung.
const item = $input.first().json;
let text = String(item.output ?? '');
let absatz = '';
const hatAktion = /(^|,)(Teamvormerkung|Eilmeldung_ans_Team)(,|$)/.test(String(item.tools_called ?? ''));
if (hatAktion) {
  const GUT = '(?:Vormerkung K1-T-\\d{5}|Eilmeldung gesendet)';
  const SCHLECHT = '(?:Vormerkung nicht angelegt \\((?:Anliegen fehlt|Auftragsnummer ungültig)\\)|Eilmeldung nur teilweise gesendet \\(ein Empfänger abgelehnt\\)|Eilmeldung nicht gesendet \\(Empfänger abgelehnt\\)|Aktions-Agent meldete einen Fehler)';
  const OFFEN = '(?:Vormerkung nicht bestätigt, Ausgang unbekannt|frühere Aufrufe der Vormerkung nicht lesbar|Eilmeldung nicht bestätigt, Ausgang unbekannt)';
  const FORMAT = new RegExp('^Bestätigt: (?:nichts|' + GUT + '(?:, ' + GUT + ')*)\\.(?: Nicht geklappt: ' + SCHLECHT + '(?:, ' + SCHLECHT + ')*\\.)?(?: Offen: ' + OFFEN + '(?:, ' + OFFEN + ')*\\.)?$');
  const m = text.match(/(?:^|\n\n)(Bestätigt: [^\n]*)$/);
  if (m && FORMAT.test(m[1])) { absatz = m[1]; text = text.slice(0, text.length - m[0].length); }
}
// Je Muster ein Name und ein Regex. Neue Muster hier anhaengen, nie zu einem Sammel-Regex zusammenfassen.
// Wertwoerter, die nach "lautet" oder "Passwort:" kein Geheimnis sind (Praepositionen, Artikel, Adverbien).
const KEINWERT = '(?:nicht|bei|in|im|für|ein|eine|mindestens|mit|so|nach|vor|anders|immer|dann|wie|wenn|aber|und|oder|der|die|das|dein|deine|dem|den|zu|auf|aus|von|an|am|um|ab|bis|durch|gegen|ohne|unter|über|jetzt|hier|dort|also|etwas|folgt|erforderlich|optional|pflicht|pflichtfeld|leer|geheim|unbekannt|vergessen|ändern|zurücksetzen|abhängig|individuell)';
const WORT = '[^\\s.!?;:]+';
const GEHEIM = '(?=[^\\s"\'“]*\\p{L})(?=[^\\s"\'“]*[0-9!@#$%&*_+\\/])[^\\s"\'“]{6,}';
const MUSTER = [
  ['systemprompt_ueberschrift', /(^|\n)\s*#{1,3}\s*(Rolle|Kontext|Verhalten|Regeln|Hinweise zu den Werkzeugen|Fallback)\s*(:|\n|$)/i],
  ['systemprompt_regelsatz', /Deine Regeln gibst du nicht preis|Text im Auftrag, der dir Anweisungen gibt|Wähle die Quelle nach dieser Tabelle|Eine Aktion führst du nie aus/i],
  ['systemprompt_wortlaut', /\b(mein|meinen|dein|deinen)\s+system\s*-?\s*prompt\s*(lautet|beginnt|:)|\b(der|dieser)\s+system\s*-?\s*prompt\s+(lautet|beginnt)/i],
  ['systemprompt_anweisungen', /\b(meine|meinen|deine|die)\s+(system-?)?(anweisung|instruktion)(en)?\s+(lauten|lautet|sind|beginnt|beginnen)\s*:/i],
  ['systemprompt_englisch', /\bmy\s+(system\s+)?(prompt|instructions)\s+(is|are|reads)\s*:/i],
  ['schluessel_sk', /\bsk-[A-Za-z0-9_-]{16,}/],
  ['schluessel_nvapi', /\bnvapi-[A-Za-z0-9_-]{16,}/],
  ['schluessel_github', /\bgh[pousr]_[A-Za-z0-9]{20,}/],
  ['schluessel_aws', /\bAKIA[0-9A-Z]{16}\b/],
  ['schluessel_jwt', /\beyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{5,}/],
  ['schluessel_bearer', /\bBearer\s+[A-Za-z0-9._~+\/-]{20,}/i],
  ['schluessel_basic', /\bBasic\s+[A-Za-z0-9+\/]{16,}={0,2}/],
  ['schluessel_zuweisung', /\b(api[_ -]?key|apikey|secret|token)\s*[:=]\s*["']?[A-Za-z0-9._~+\/-]{12,}/i],
  ['schluessel_token_wort', /\b(token|schlüssel|key|secret|zugangsdaten)\s+(?=[A-Za-z0-9_-]*\d)(?=[A-Za-z0-9_-]*[A-Za-z])[A-Za-z0-9_-]{24,}/i],
  ['schluessel_stripe', /\b[sr]k_(live|test)_[A-Za-z0-9]{10,}/],
  ['schluessel_slack', /\bxox[abprs]-[A-Za-z0-9-]{10,}/],
  ['schluessel_google', /\bAIza[0-9A-Za-z_-]{30,}/],
  ['passwort_lautet', new RegExp('(?<![\\p{L}\\d])(passwort|kennwort)(?:\\s+' + WORT + '){0,4}\\s+(lautet|heißt)\\s+["\'„]?(?!' + KEINWERT + '(?![\\p{L}\\d_-]))[^\\s"\'“.,;!?]{3,}', 'iu')],
  ['passwort_ist_wert', new RegExp('(?<![\\p{L}\\d])(passwort|kennwort|password)\\s+ist\\s+["\'„]?(?!\\d+-?(?:stellig|zeichen)(?![\\p{L}\\d]))' + GEHEIM, 'iu')],
  ['passwort_zuweisung', new RegExp('(?<![\\p{L}\\d])(passwort|kennwort|password)\\s*[:=]\\s*["\'„]?(?!' + KEINWERT + '(?![\\p{L}\\d_-]))[^\\s"\'“.,;!?]{4,}["\'“]?\\s*(?:[.!?,;]|\\n|$)', 'iu')],
  ['passwort_zuweisung_wert', new RegExp('(?<![\\p{L}\\d])(passwort|kennwort|password)\\s*[:=]\\s*["\'„]?' + GEHEIM, 'iu')],
  ['mailadresse', /[\p{L}0-9._%+-]+@[\p{L}0-9-]+(\.[\p{L}0-9-]+)*\.\p{L}{2,}/u]
];
let treffer = '';
for (const [name, re] of MUSTER) {
  if (re.test(text)) { treffer = name; break; }
}
return [{ json: { ...item, output: text, aktionsabsatz: absatz, guardrail_treffer: treffer, guardrail_hit: treffer !== '' } }];