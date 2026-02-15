SELECT * 
FROM customers_churn
LIMIT 10;

-- ============================
-- 1. Vérifications de base
-- ============================

-- Nombre total de clients
SELECT COUNT(*) AS nb_clients
FROM customers_churn;

-- Aperçu des âges
SELECT 
  MIN(Age) AS age_min,
  MAX(Age) AS age_max,
  AVG(Age) AS age_moyen
FROM customers_churn;

-- Taux de churn global
SELECT 
  AVG(CASE WHEN Exited = 1 THEN 1.0 ELSE 0 END) AS churn_rate
FROM customers_churn;

-- ============================
-- 2. Churn par pays (Geography)
-- ============================

SELECT 
  Geography,
  COUNT(*) AS nb_clients,
  SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS nb_clients_churn,
  ROUND(AVG(CASE WHEN Exited = 1 THEN 1.0 ELSE 0 END) * 100, 2) AS churn_rate_pct
FROM customers_churn
GROUP BY Geography
ORDER BY churn_rate_pct DESC;

-- ============================
-- 3. Churn par genre (Gender)
-- ============================

SELECT 
  Gender,
  COUNT(*) AS nb_clients,
  SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS nb_clients_churn,
  ROUND(AVG(CASE WHEN Exited = 1 THEN 1.0 ELSE 0 END) * 100, 2) AS churn_rate_pct
FROM customers_churn
GROUP BY Gender
ORDER BY churn_rate_pct DESC;

-- ============================
-- 4. Churn par tranche d'âge
-- ============================

-- Création d'une vue avec des tranches d'âge
CREATE VIEW IF NOT EXISTS v_churn_age_band AS
SELECT
  *,
  CASE
    WHEN Age < 30 THEN '18-29'
    WHEN Age BETWEEN 30 AND 39 THEN '30-39'
    WHEN Age BETWEEN 40 AND 49 THEN '40-49'
    WHEN Age BETWEEN 50 AND 59 THEN '50-59'
    ELSE '60+'
  END AS age_band
FROM customers_churn;

-- Churn par tranche d'âge
SELECT 
  age_band,
  COUNT(*) AS nb_clients,
  SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS nb_clients_churn,
  ROUND(AVG(CASE WHEN Exited = 1 THEN 1.0 ELSE 0 END) * 100, 2) AS churn_rate_pct
FROM v_churn_age_band
GROUP BY age_band
ORDER BY churn_rate_pct DESC;

-- ============================
-- 5. Churn par nombre de produits
-- ============================

SELECT
  NumOfProducts,
  COUNT(*) AS nb_clients,
  SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS nb_clients_churn,
  ROUND(AVG(CASE WHEN Exited = 1 THEN 1.0 ELSE 0 END) * 100, 2) AS churn_rate_pct
FROM customers_churn
GROUP BY NumOfProducts
ORDER BY NumOfProducts;

-- ============================
-- 6. Churn selon l'activité
-- ============================

SELECT
  IsActiveMember,
  COUNT(*) AS nb_clients,
  SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS nb_clients_churn,
  ROUND(AVG(CASE WHEN Exited = 1 THEN 1.0 ELSE 0 END) * 100, 2) AS churn_rate_pct
FROM customers_churn
GROUP BY IsActiveMember
ORDER BY IsActiveMember;

-- ============================
-- 7. Clients très rentables à risque
--    (balance élevée + churn)
-- ============================

-- Top 20 clients churnés avec le plus gros solde
SELECT
  CustomerId,
  Geography,
  Gender,
  Age,
  Balance,
  NumOfProducts,
  IsActiveMember
FROM customers_churn
WHERE Exited = 1
ORDER BY Balance DESC
LIMIT 20;

-- ============================
-- 8. Fenêtres : top balance par pays
-- ============================

SELECT *
FROM (
  SELECT
    CustomerId,
    Geography,
    Balance,
    Exited,
    ROW_NUMBER() OVER (
      PARTITION BY Geography
      ORDER BY Balance DESC
    ) AS rn
  FROM customers_churn
) t
WHERE rn <= 10;
