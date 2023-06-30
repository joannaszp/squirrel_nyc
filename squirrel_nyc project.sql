SELECT * FROM squirrel.data;

-- 1. Firstly I will count how many unique squirrels were observed: --

SELECT COUNT(DISTINCT(`Unique Squirrel ID`)) AS `Total_number of squirrels` FROM squirrel.data;
-- Total number of squirrels is 3018. Some of them were reported more than once: --

SELECT `Unique Squirrel ID`, COUNT(`Unique Squirrel ID`)
FROM squirrel.data
GROUP BY `Unique Squirrel ID`
HAVING COUNT(`Unique Squirrel ID`) > 1;

-- Squirrels with ID's: '37E-PM-1006-03', '7D-PM-1010-01', '40B-AM-1019-06', '4C-PM-1010-05', '1F-AM-1010-04' were reported twice --

SELECT * FROM squirrel.data
WHERE `Unique Squirrel ID` IN ('37E-PM-1006-03', '7D-PM-1010-01', '40B-AM-1019-06', '4C-PM-1010-05', '1F-AM-1010-04');
-- There rows are not duplicated, it shows the same part of the day, unfortunately without exact hour it is not possible to tell if is different route or the same one. I will keep it as it will not have big impact on the whole dataset. --

SELECT `Shift`, COUNT(`Shift`) FROM squirrel.data
WHERE `Shift` IS NOT NULL
GROUP BY `Shift`;
-- 2. More squirrels were observed during afternoon hours 1676 (than at the mornings 1347) --

-- 3. This is at what day was the biggest number of squirrels observed--
SELECT Date, COUNT(`Unique Squirrel ID`)  AS `Total number of observations`
FROM squirrel.data
WHERE Date IS NOT NULL
GROUP BY Date
ORDER BY COUNT(`Unique Squirrel ID`) DESC;

-- 4. The age of the squirrels presents itself as follows: --
SELECT AGE, COUNT(DISTINCT(`Unique Squirrel ID`)) AS 'Number of squirrels'
FROM squirrel.data
WHERE AGE IS NOT NULL
GROUP BY AGE
ORDER BY COUNT(DISTINCT(`Unique Squirrel ID`)) DESC;

-- 5. The same with fur colour:--
SELECT `Primary Fur Color`, COUNT(`Primary Fur Color`) AS `Number of observations`
FROM squirrel.data
WHERE `Primary Fur Color` IS NOT NULL
GROUP BY `Primary Fur Color`
ORDER BY `Number of observations` DESC;

-- 6. I will check who runs more? Adult or young squirrels?--
SELECT AGE, COUNT(RUNNING) AS RUNNING
FROM squirrel.data
WHERE RUNNING = 'true'
GROUP BY AGE
ORDER BY RUNNING DESC;
-- Adults squirrels run more than young juvenile squirrels.--

-- 7. I will check if squirrel approached human more times--
SELECT AGE, APPROACHES, COUNT(APPROACHES) AS `Number of APPROACHES`
FROM squirrel.data
WHERE AGE IS NOT NULL AND APPROACHES = 'true'
GROUP BY AGE, APPROACHES
ORDER BY `Number of APPROACHES` DESC, AGE DESC;
-- Adult ones approached more often.--

-- 8. Let's take a look which squirrel is likely run from human:--
SELECT AGE, `Runs from`, COUNT(`Runs from`) AS RUNS, COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS PERCENTAGE
FROM squirrel.data
WHERE AGE IS NOT NULL AND AGE = 'Adult'
GROUP BY AGE, `Runs from`;

SELECT AGE, `Runs from`, COUNT(`Runs from`) AS RUNS, COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS PERCENTAGE
FROM squirrel.data
WHERE AGE = 'Juvenile'
GROUP BY AGE, `Runs from`;
-- Juvenile squirrels are slightly more likely to runs from human ( 24.5% vs 22.3%)--
