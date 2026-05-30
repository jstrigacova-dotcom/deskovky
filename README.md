# 🎲 Analýza a čištění dat deskových her z BoardGameGeek (BGG)
Tento projekt vznikl jako závěrečná práce zaměřená na proces zpracování, čištění a explorativní analýzy rozsáhlého datasetu deskových her. Cílem projektu bylo vzít surová data, importovat je do relační databáze MySQL a vyčistit je od chyb, anomálií a nekonzistencí.

# 📊 O datasetu
Zdrojový soubor `bgg_dataset_des.csv` obsahuje celkem *20 343 záznamů* o deskových hrách. Sleduje metriky jako hodnocení uživatelů, herní čas, doporučený věk, herní mechaniky a popularitu.

# 🛠️ Průběh projektu

### 1. Prvotní opravy a import dat
Při importu CSV souboru bylo nutné nejprve vyřešit chybné kódování a upravit datové typy u sloupců, které se původně načítaly jako TEXT namísto číselných hodnot. K úpravě byl použit Notepad++ a Excel. Po importu databáze nahlásila 15 varování (chyby typu 1261 a 1366 – chybějící sloupce a posun dat na 7 konkrétních řádcích). Tyto řádky byly manuálně zkontrolovány a opraveny přímo v SQL podle zdrojového CSV.

### 2. Čištění dat (Data Cleaning)
Následně proběhla detailní kontrola `NULL` hodnot napříč všemi sloupci s těmito zásahy.
* **Chybějící ID:** Odfiltrováno a smazáno 16 řádků, které neměly vyplněné unikátní ID.
* **Minimální počet hráčů (`Min Players`):** Detekováno 46 prázdných hodnot. U 10 her, které měly vyplněný maximální počet hráčů, bylo provedeno dohledání reálných dat (např. hry *Stonewall Jackson*, *Wagram* či *Somosierra 1808*) a hodnoty byly ručně aktualizovány pomocí příkazů `UPDATE`.
* **Počet vlastníků (`Owned Users`):** 7 chybějících hodnot bylo nahrazeno nulou.
* **Kategorie (`Domains`):** Vyřešen posun dat u her jako *Level 7 [Escape]* nebo *Omega Protocol*. Zjištěno, že 10 140 záznamů obsahuje prázdný textový řetězec namísto `NULL` – provedena standardizace dat.

### 3. Detekce anomálií a validace (EDA)
Pomocí agregačních funkcí (`MIN`, `MAX`) byly v datech vyhledány nelogické hodnoty a zástupné symboly.
* **Rok vydání 0:** Rok 0 byl vyhodnocen jako neznámý údaj a transformován na `NULL`.
* **Historické roky:** Roky se záporným znaménkem (např. hra *Senet* z roku -3500) byly ověřeny jako historicky validní.
* **Herní čas (`Play Time`):** Hodnoty rovnající se 0 byly změněny na `NULL`. Extrémní hodnoty (hry s časem nad 5 000 hodin, např. *The Campaign for North Africa* s 12 000 hodinami) byly podrobeny rešerši a potvrzeny jako správné.
* **Maximální počet hráčů:** Hodnota 999 se v komunitě BGG používá pro "neomezený počet hráčů", u těchto záznamů byla hodnota upravena na `NULL` pro zachování čistoty budoucích statistik.

## 💻 Ukázky mých SQL příkazů

**Kontrola NULL hodnot v celém datasetu:**

SELECT 
    COUNT(*) AS Total_Records,
    SUM(CASE WHEN ID IS NULL THEN 1 ELSE 0 END) AS Null_ID,
    SUM(CASE WHEN `Min Players` IS NULL THEN 1 ELSE 0 END) AS Null_Min_Players,
    SUM(CASE WHEN `Play Time` IS NULL THEN 1 ELSE 0 END) AS Null_Play_Time
FROM bgg_dataset_des;


**Úprava duelových her na základě rešerše:** 
UPDATE `bgg_dataset_des` 
SET `Min Players` = 2 
WHERE `Max Players` = 2 AND `Min Players` IS NULL;

**Manuální oprava konkrétní hry:**  
UPDATE `bgg_dataset_des` SET `Min Players` = 1 WHERE `ID` = 39279; -- Somosierra 1808
