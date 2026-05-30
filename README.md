# 🎲 Analýza deskových her z BoardGameGeek

Tento projekt byl zaměřen na kompletní proces zpracování, čištění a vizualizace datasetu deskových her pocházejícího z platformy BoardGameGeek (BGG). Projekt demonstruje schopnost transformovat surová data z formátu CSV do strukturované relační databáze MySQL, provést datový audit, nápravu chyb a následně data modelovat a vizualizovat v nástroji Power BI.

## 🎯 Hlavní cíle projektu
* **Návrh struktury a import:** Správné nastavení datových typů a úspěšný import datasetu do MySQL.
* **Datový audit a čištění:** Identifikace anomálií, ošetření chybějících hodnot a náprava chyb vzniklých při importu.
* **Datové modelování a vizualizace:** Propojení vyčištěných dat a tvorba interaktivního dashboardu v Power BI pro přehledný reporting klíčových metrik.

## 💻 Klíčové fáze projektu

### 1. Inicializace a kontrola struktury
Prvním krokem bylo vytvoření databázového schématu a validace datových typů. Pomocí SQL příkazů byla ověřena konzistence importovaných dat vůči očekávané struktuře.

### 2. Validace a čištění dat (SQL)
V této fázi byl surový dataset zbaven šumu a nekonzistencí, které by mohly zkreslit výsledné analýzy. 
Proces zahrnoval:

* **Ošetření chybějících (NULL) hodnot:** Detekce prázdných polí napříč datasetem a jejich standardizace či logické doplnění na základě doménových znalostí.
* **Oprava importních anomálií:** Řešení strukturálních chyb a posunů sloupců, které generovaly importní varování.
* **Eliminace datového šumu:** Převod nestandardních zástupných hodnot na čisté hodnoty `NULL` pro zachování čistoty statistických výpočtů.

### 3. Explorativní analýza dat (SQL)
Po vyčištění databáze byly sestaveny SQL dotazy pro získání základního přehledu o herním trhu, vyhledávání validních datových extrémů (historické hry, extrémní herní doby) a přípravu agregovaných dat pro následný report.

### 4. Datové modelování a vizualizace (Power BI)
Závěrečná fáze projektu probíhala v nástroji Power BI, kam byla vyčištěná data z MySQL importována. Nad těmito daty bylo vytvořeno datové modelování a následně sestaven interaktivní manažerský dashboard. Tento report umožňuje:
* Sledovat klíčové metriky a trendy v přehledných grafech a tabulkách.
* Dynamicky filtrovat a analyzovat data podle různých herních parametrů a kategorií.
* Snadno interpretovat výsledky analýzy díky čistému a profesionálnímu vizuálnímu zpracování.

<img width="2688" height="1500" alt="PBI" src="https://github.com/user-attachments/assets/d97a48ab-324e-48e1-94ef-08780279960d" />


*Tento projekt byl součástí mé závěrečné práce v kurzu Datová analýza - SQL a PowerBi od Praha Coding school.*

