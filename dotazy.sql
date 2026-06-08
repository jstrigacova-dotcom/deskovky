#kontrola struktury a datových typů

    describe bgg_dataset_des;
 	
#kontroluji NULL hodnoty pro všecky sloupce 

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
    SUM(CASE WHEN Domains IS NULL THEN 1 ELSE 0 END) AS Null_Domains,
    FROM
    bgg_dataset_des;

#filtruji si všech 16 řádků, které obsahují NULL hodnotu pro sloupec ID 

    SELECT * FROM bgg_dataset_des WHERE ID IS NULL;
 	 
#mažu všech 16 řádků, kde chybí ID

    DELETE FROM bgg_dataset_des WHERE ID IS NULL;

#tímto příkazem si filtruju ten jeden řádek ze sloupce roku vydání co vyšel s NULL hodnotou, ale nic se nedohledá, jelikož tam chybělo ID z předchozího dotazu

    SELECT * FROM bgg_dataset_des WHERE `Year Published` IS NULL;

#filtruju si sloupec s minimálním počtem hráčů a zjišťuju, že oproti datové sadě to sedí tak, jak je to v csv souboru

    SELECT * FROM bgg_dataset_des WHERE `Min Players` IS NULL;

#tady ale zjišťuju, že celkem 46 záznamů má sice NULL hodnoty, ale 10 z nich má uvedený max. počet hráčů

#zadávám si příkaz pro těch 10 her, co mají min players NULL, ale mají uvedenou hodnotu pro max players
    
    SELECT `ID`, `Name`, `Min Players`, `Max Players`, `Mechanics`
    FROM `bgg_dataset_des`
    WHERE `Min Players` IS NULL
    AND `Max Players` IS NOT NULL;
    
#provádím si research na internetu a zjišťuju, že například hra Stonewall Jackson, Bitter Woods a Wagram jsou výhradně pro dva hráče
#hra Somosierra 1808 má max players jednoho hráče a tedy min players by mělo být také jedna
#hra Narnia a China pak například 2 až 4 hráči

#pro duelové hry nastavuji minimální počet hráčů na hodnotu 2

    SET `Min Players` = 2 
    WHERE `Max Players` = 2 
    AND `Min Players` IS NULL

#u sólové hry Somosierra 1808 měním min players také na hodnotu 1
    
    UPDATE `bgg_dataset_des` 
    SET `Min Players` = 1 
    WHERE `ID` = 39279;

#pro hru Narnia a China měním null hodnotu u min players na 2

    UPDATE `bgg_dataset_des` 
    SET `Min Players` = 2 
    WHERE `ID` IN (20028, 26999);

#kontroluji NULL hodnoty u max players a zjišťuju, že to je validní, jelikož data neobsahují jen hry jako takové, ale třeba i hrací doplňky jako kartičky, anebo se jedná o párty hry

    SELECT `ID`, `Name`, `Year Published`, `Mechanics`
    FROM `bgg_dataset_des`
    WHERE `Max Players` IS NULL
    LIMIT 25;
 
#kontroluju sloupec owned users a NULL hodnoty ponechávám, jelikož změna na 0 by nebyla vlastně pravdivá a mohla by ovlivňovat statistiku, průměr atd.

    SELECT * FROM bgg_dataset_des WHERE `Owned users ` IS NULL;


#filtruju si sloupec domains a opět kontroluju NULL hodnoty

    SELECT * 
    FROM bgg_dataset_des 
    WHERE  Domains IS NULL;

#tady přicházím na to, že jde o chybně nahraná data (posun sloupců), ale v csv souboru to je dobře, čili provedu manuální posun dle CSV
 
#příkazy pro opravu/posunutí na základě csv datasetu

    UPDATE `bgg_dataset_des` 
    SET `Name` = 'Level 7 [Omega Protocol]', 
    `Year Published` = 2013, 
    `Min Players` = 2, 
    `Max Players` = 6, 
    `Play Time` = 90, 
    `Min Age` = 14, 
    `Users Rated` = 1971, 
    `Rating Average` = 7.46, 
    `BGG Rank` = 908, 
    `Complexity Average` = 3.1, 
    `Owned Users` = 3849, 
    `Mechanics` = 'Action Points, Dice Rolling, Grid Movement, Modular Board, Player Elimination, Scenario / Mission / Campaign Game, Team-Based Game, Variable Player Powers', 
    `Domains` = 'Strategy Games, Thematic Games' 
    WHERE `ID` = 137649;
    
    UPDATE `bgg_dataset_des` 
    SET `Name` = '\\91\\kosmopoli:t\\93\\',
    `Year Published` = 2020, 
    `Min Players` = 4, 
    `Max Players` = 8, 
    `Play Time` = 6, 
    `Min Age` = 10, 
    `Users Rated` = 180, 
    `Rating Average` = 8.23, 
    `BGG Rank` = 4103, 
    `Complexity Average` = 1.11, 
    `Owned Users` = 425, 
    `Mechanics` = 'Cooperative Game', 
    `Domains` = NULL 
    WHERE `ID` = 297658;
    
    UPDATE `bgg_dataset_des` 
    SET `Name` = '\\91\\redacted\\93\\',
    `Year Published` = 2014, 
    `Min Players` = 2, 
    `Max Players` = 6, 
    `Play Time` = 45, 
    `Min Age` = 12, 
    `Users Rated` = 682, 
    `Rating Average` = 6.2, 
    `BGG Rank` = 4856, 
    `Complexity Average` = 2.93, 
    `Owned Users` = 1796, 
    `Mechanics` = 'Area Movement, Hand Management, Hidden Roles, Rock-Paper-Scissors, Team-Based Game', 
    `Domains` = 'Strategy Games, Thematic Games' 
    WHERE `ID` = 161578;
    
    
    UPDATE `bgg_dataset_des` 
    SET `Name` = 'Level 7 \\91\\Escape\\93\\', 
    `Year Published` = 2012, 
    `Min Players` = 1, 
    `Max Players` = 4, 
    `Play Time` = 45, 
    `Min Age` = 14, 
    `Users Rated` = 854, 
    `Rating Average` = 6.02, 
    `BGG Rank` = 5721, 
    `Complexity Average` = 2.84, 
    `Owned Users` = 2018, 
    `Mechanics` = 'Cooperative Game, Dice Rolling, Modular Board, Solo / Solitaire Game, Variable Player Powers', 
    `Domains` = 'Thematic Games' 
    WHERE `ID` = 125658;
    
    UPDATE `bgg_dataset_des` 
    SET `Name` = 'Level 7 \\91\\Invasion\\93\\', 
    `Year Published` = 2014, 
    `Min Players` = 3, 
    `Max Players` = 5, 
    `Play Time` = 240, 
    `Min Age` = 14, 
    `Users Rated` = 192, 
    `Rating Average` = 6.8, 
    `BGG Rank` = 5956, 
    `Complexity Average` = 3.46, 
    `Owned Users` = 741, 
    `Mechanics` = 'Area Majority / Influence, Cooperative Game, Dice Rolling, Trading', 
    `Domains` = 'Strategy Games, Thematic Games' 
    WHERE `ID` = 155636;
    
    UPDATE `bgg_dataset_des` 
    SET `Name` = '\\91\\microfilms\\93\\', 
    `Year Published` = 2015, 
    `Min Players` = 2, 
    `Max Players` = 6, 
    `Play Time` = 30, 
    `Min Age` = 12, 
    `Users Rated` = 120, 
    `Rating Average` = 5.92, 
    `BGG Rank` = 13420, 
    `Complexity Average` = 1.82, 
    `Owned Users` = 526, 
    `Mechanics` = 'Hand Management, Memory, Team-Based Game', 
    `Domains` = NULL 
    WHERE `ID` = 175867;
    
    UPDATE `bgg_dataset_des` 
    SET `Name` = '\\91\\[BLANK\\]\\93\\', 
    `Year Published` = 2012, 
    `Min Players` = 4, 
    `Max Players` = 15, 
    `Play Time` = 30, 
    `Min Age` = 18, 
    `Users Rated` = 34, 
    `Rating Average` = 6.43, 
    `BGG Rank` = 14362, 
    `Complexity Average` = 1.0, 
    `Owned Users` = 57, 
    `Mechanics` = 'Hand Management, Simultaneous Action Selection, Storytelling, Voting', 
    `Domains` = NULL 
    WHERE `ID` = 131812;

#kontroluji NULL hodnoty pro domains
    
    SELECT COUNT(*) AS Empty_Domains_Count
    FROM bgg_dataset_des
    WHERE Domains = '' OR TRIM(Domains) = '';

#tady zjišťuju, že NULL hodnota je pouze u 3 záznamů a 10 140 záznamů má prázdno

#měním prázdné hodnoty na NULL u domains     

    UPDATE `bgg_dataset_des` 
    SET `Domains` = NULL 
    WHERE `Domains` = '' OR TRIM(`Domains`) = '';


#a tady začíná už ta zábavní část, kdy hledám 50 nejlépe hodnocených her

    SELECT `Name`, `Year Published`, `Rating Average`, `Users Rated`
    FROM bgg_dataset_des
    WHERE `Users Rated` > 500
    ORDER BY `Rating Average` DESC
    LIMIT 50;

#tady se snažím kontrolovat nesmysly

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

#zjišťuju, že rating je OK
#hodnota 0, která je u sloupce min age může znamenat nějakou hru pro batolata nebo nebude vyplněná hodnota asi jako u času min time?
#rok vydání -3500 vím, že je validní, jelikož jako milovník deskovek vím, že se jedná o hru Senet
#max počet hráčů 999 může znamenat neomezený počet hráčů, jen nevím jestli to bude to pravý ořechový pro statistiku

#filtruji si hry pro více než 100 lidí 

    SELECT `Max Players`, COUNT(*) AS Pocet_Her
    FROM `bgg_dataset_des`
    WHERE `Max Players` > 100
    GROUP BY `Max Players`
    ORDER BY `Max Players` DESC;

#pátrám po internetu, rozšiřuju si obzory a přicházím na to, že číslo 999 se opravdu dává jako neomezený počet hráčů a proto se rozhoduju, že těm dohledaným 3 hrám to změním na NULL, jelikož ten zbytek je spíš taková zajímavá anomálie

#měním hodnotu max players z 999 na NULL hodnoty
    
    UPDATE `bgg_dataset_des` 
    SET `Max Players` = NULL 
    WHERE `Max Players` = 999;


#teď pro jistotu zkontroluji rok vydání se záporným znaménkem

    SELECT `ID`, `Name`, `Year Published`
    FROM `bgg_dataset_des`
    WHERE `Year Published` < 1900
    ORDER BY `Year Published` ASC;

#ty hry co mají záporné znaménko jsou skutečně historické
#vadí mi ale u některých her rok vydání s hodnotou 0, jelikož to neoznačuje skutečný rok vydání, ale spíš jako neznámý rok a proto to změním na NULL hodnotu

#měním rok vydání her z hodnoty 0 na NULL

    UPDATE `bgg_dataset_des` 
    SET `Year Published` = NULL 
    WHERE `Year Published` = 0;

#jdu se podívat na zoubek hrám, co se hrají více než 100 hodin

    SELECT `ID`, `Name`, `Play Time`
    FROM `bgg_dataset_des`
    WHERE `Play Time` > 5000 OR `Play Time` = 0
    ORDER BY `Play Time` DESC;
    
#tady zjišťuju, že jsou opravdu hry co se hrají i tisíc hodin, čili to je v pořádku, ale zase tam vyběhly hodnoty 0, takže je nemilosrdně změním na NULL

#měním u play time hodnotu 0 na NULL

UPDATE `bgg_dataset_des`
SET `Play Time` = NULL
WHERE `Play Time` = 0;

