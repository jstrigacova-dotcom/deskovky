describe bgg_dataset_des; 
# kontrola struktury a datové typy
  
SELECT
COUNT(*) AS Total_Records,
SUM(CASE WHEN ID IS NULL THEN 1 ELSE 0 END) AS Null_ID,
SUM(CASE WHEN `Year Published` IS NULL THEN 1 ELSE 0 END) AS Null_Year_Published,
SUM(CASE WHEN `Min Players` IS NULL THEN 1 ELSE 0 END) AS Null_Min_Players,
SUM(CASE WHEN `Max Players` IS NULL THEN 1 ELSE 0 END) AS Null_Max_Players,
SUM(CASE WHEN `Play Time` IS NULL THEN 1 ELSE 0 END) AS Null_Play_Time,
SUM(CASE WHEN `Min Age` IS NULL THEN 1 ELSE 0 END) AS Null_Min_Age,
SUM(CASE WHEN `Users Rated` IS NULL THEN 1 ELSE 0 END) AS Null_Users_Rated,
SUM(CASE WHEN `Rating Average` IS NULL THEN 1 ELSE 0 END) AS Null_Rating_Average,
SUM(CASE WHEN `BGG Rank` IS NULL THEN 1 ELSE 0 END) AS Null_BGG_Rank,
SUM(CASE WHEN `Complexity Average` IS NULL THEN 1 ELSE 0 END) AS Null_Complexity_Average,
SUM(CASE WHEN `Owned Users` IS NULL THEN 1 ELSE 0 END) AS Null_Owned_Users,
SUM(CASE WHEN Name IS NULL THEN 1 ELSE 0 END) AS Null_Name,
SUM(CASE WHEN Mechanics IS NULL THEN 1 ELSE 0 END) AS Null_Mechanics,
SUM(CASE WHEN Domains IS NULL THEN 1 ELSE 0 END) AS Null_Domains
FROM
bgg_dataset_des;
# kontroluji NULL hodnoty pro všecky sloupce

SELECT * FROM bgg_dataset_des WHERE ID IS NULL;
 # filtruju si všech 16 řádku, které obsahují NULL hodnotu pro sloupec ID a rozhoduju se pro jejich smazání

SELECT * FROM bgg_dataset_des WHERE `Year Published` IS NULL;
 # chci filtrovat řádek ve sloupci roku vydání, jelikož vyšel v úvodu jeden řádek, ale spuštěním příkazu se nic nedohledá, tak se pravděpodobně jednalo o záznam, kde chybělo i ID z předchozího
dotazu

SELECT * FROM bgg_dataset_des WHERE `Min Players` IS NULL;
 # filtruju si sloupec s minimálním počtem hráčů a zjišťuju, že oproti datové sadě to sedí tak, jak je to v csv souboru

 #  ????????????????? 
Tady si nejsem vůbec jistá, co s tím? Ve 46 výsledcích je tedy minimální počet hráčů NULL, ale 10 záznamů má uvedený max. počet hráčů.
Mám tady využít update a tam, kde je uveden max. počet, tak nahodit pro min. players 0 a zbytek záznamů, kde není ani max. počet odstranit?
UPDATE bgg_dataset_des
SET `Min Players` = 0
WHERE `Min Players` IS NULL
AND `Max Players` IS NOT NULL;
DELETE FROM bgg_dataset_des WHERE `Min Players` IS NULL AND `Max Players` IS NULL ???? #  

SELECT `ID`, `Name`, `Min Players`, `Max Players`, `Mechanics`
FROM `bgg_dataset_des`
WHERE `Min Players` IS NULL
AND `Max Players` IS NOT NULL;
# zadávám si příkaz pro těch 10 her, co mají min players NULL, ale mají uvedenou hodnotu pro max players

#  ???? Tak tady fakt vím nic. Dle netu například hry Stonewall Jackson, Bitter Woods, Wagram jsou výhradně pro 2 hráče. Hra Somosierra 1808 má max players 1 a min by mělo být také 1. Narnia a China 2 - 4 hráči, tak mám
nastavit 2?
Čili UPDATE `bgg_dataset_des` SET `Min Players` = 1 WHERE `ID` = 39279; pro Somosierru ??????????????????
UPDATE `bgg_dataset_des` SET `Min Players` = 2 WHERE `Max Players` = 2 AND `Min Players` IS NULL; pro duelovky ???????
UPDATE `bgg_dataset_des` SET `Min Players` = 2 WHERE `ID` IN (20028, 26999); pro Narnia a China ????????????

SELECT `ID`, `Name`, `Year Published`, `Mechanics`
FROM `bgg_dataset_des`
WHERE `Max Players` IS NULL
LIMIT 25;
 # kontroluji NULL hodnoty u max players a zjišťuju, že to je validní, jelikož data neobsahují hry jako takové, ale třeba hrací doplňky jako kartičky, a nebo to jsou párty hry.

SELECT * FROM bgg_dataset_des WHERE `Owned users ` IS NULL;
# filtruju si sloupec owned users a zjišťuju, že záznamů je už jen 7. Ostatní sloupce mají řádky v pořádku vyplněny a tak se nedokážu rozhodnout, jestli pro budoucí analýzu, tam ponechám null
hodnoty a nebo je dám na 0 jako že nevlastní nikdo ??? UPDATE bgg_dataset_des SET `Owned Users` = 0 WHERE `Owned Users` IS NULL ??

SELECT * FROM bgg_dataset_des WHERE Domains IS NULL;
 # filtruju si sloupec domains a zjišťuju, že jde o chybně nahraná data (posun sloupců). V CSV souboru, to je ale dobře, čili se rozhoduju pro manuální opravu/posun dat dle CSV souboru, stále ale platí, že i po opravě mám NULL hodnoty v Domains u 3 řádků

SELECT COUNT(*) AS Empty_Domains_Count
FROM bgg_dataset_des
WHERE Domains = &#39;&#39; OR TRIM(Domains) = &#39;&#39;;
# tady teda zjišťuju, že prázdný text u sloupce domains mám u 10 140 záznamů a u 3 teda mám NULL
Tak teď úplně nevím jestli dát
1. UPDATE `bgg_dataset_des`
SET `Domains` = NULL
WHERE `Domains` = &#39;&#39; OR TRIM(`Domains`) = &#39;&#39;;
* převést na NULL
2. UPDATE `bgg_dataset_des`
SET `Domains` = &#39;&#39;
WHERE `Domains` IS NULL;
* 3 NULL převést na prázdno

A tady začíná zábava :)
 
SELECT `Name`, `Year Published`, `Rating Average`, `Users Rated`
FROM bgg_dataset_des
WHERE `Users Rated` &gt; 500
ORDER BY `Rating Average` DESC
LIMIT 50;
 # dívám se na 50 nejlépe hodnocených her

SELECT
MIN(`Year Published`) AS Min_Year,
MAX(`Year Published`) AS Max_Year,
MIN(`Min Players`) AS Min_Players,
MAX(`Max Players`) AS Max_Players,
MIN(`Play Time`) AS Min_Time,
MAX(`Play Time`) AS Max_Time,
MIN(`Min Age`) AS Min_Age,
MAX(`Min Age`) AS Max_Age,
MIN(`Rating Average`) AS Min_Rating,
MAX(`Rating Average`) AS Max_Rating
FROM `bgg_dataset_des`;
# zkouším si hledat nesmysly a výstup mám takový. Prvo-pohledově teda vidím, že rating je OK. Min Age může být nějaká hra pro batolata? nebo nebude vyplněná hodnota asi jako u času? Rok vydání, jako milovník deskových her vím, že se jedná o prastarou hru Senet, takže to považuju za validní, ale pro jistotu to ještě čeknu. Max počet hráčů 999? To je možná jako neomezenej počet hráčů, ale asi to nebude to pravý ořechový pro statistiku si myslím. Min Time 0 být nemůže, tak bude nějakej šotek a max time taky.

SELECT `Max Players`, COUNT(*) AS Pocet_Her
FROM `bgg_dataset_des`
WHERE `Max Players` &gt; 100
GROUP BY `Max Players`
ORDER BY `Max Players` DESC;
# dívám se na hry, které jsou pro více než 100 lidí. Trochu musím pátrat po internetu a rozšířit si obzory, ale zjišťuju, že se opravdu číslo 999 uvádí pro neomezený počet hráčů. Proto se rozhoduju, že těmto třem hrám to změním na NULL. Zbylé jsou spíš zajímavé řekněme anomálie, ne chyby.

SELECT `ID`, `Name`, `Year Published`
FROM `bgg_dataset_des`
WHERE `Year Published` &lt; 1900
ORDER BY `Year Published` ASC;
# pro jistotu kontroluju rok vydání her a ty co jsou se záporným znaménkem jsou opravdu historické. Co mi ale vadí je rok vydání 0. To neoznačuje skutečný rok vydání, ale spíš jako neznámý rok. Čili to převádím na NULL hodnoty.

SELECT `ID`, `Name`, `Play Time`
FROM `bgg_dataset_des`
WHERE `Play Time` &gt; 5000 OR `Play Time` = 0
ORDER BY `Play Time` DESC;
# tady se dívám na zoubek hrám, co se hrají i více než 100 hodin a výsledek mi vychází takovýto. Provádím si tedy research na webu a zjišťuju, že opravdu hra/hry, které se hrají i tisíc hodin
existují, whaaat? Ok, takže data jsou v pořádku, ale zase ty nuly …. nemilosrdně je měním na NULL


