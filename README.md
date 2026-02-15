# Analyse du churn clients bancaires (SQL)

Ce projet analyse les données de 10 000 clients d'une banque européenne afin de comprendre **quels profils de clients quittent la banque (churn)** et d'identifier des pistes pour améliorer la rétention. [web:35][web:68]

L'objectif est de répondre à des questions comme :
- Quel est le taux de churn global ?
- Quels pays et quels segments (âge, genre, nombre de produits, activité) sont les plus à risque ?
- Quels clients à forte valeur (gros soldes) quittent la banque ?

## Données

- **Source** : jeu de données *Bank Customer Churn* (Maven Analytics / Kaggle).
- **Volume** : ~10 000 clients.
- **Variables clés** :
  - Données démographiques : `Geography`, `Gender`, `Age`, `Tenure`.
  - Données financières : `CreditScore`, `Balance`, `NumOfProducts`, `EstimatedSalary`.
  - Comportement client : `HasCrCard`, `IsActiveMember`.
  - Cible : `Exited` (1 = le client a quitté la banque, 0 = client retenu).

## Stack & méthodologie

- **Outils** :
  - SQLite + DB Browser for SQLite pour le stockage et les requêtes SQL.

- **Étapes** :
  1. Import du CSV dans une base SQLite et vérifications de base (types, nombre de lignes).
  2. Analyses descriptives : taux de churn global, par pays, par genre. 
  3. Segmentation avancée : tranches d'âge, nombre de produits, statut d'activité.
  4. Identification des clients à forte valeur et à risque (solde élevé + churn).


## Principales requêtes SQL

Le fichier churn_bank_txt contient l'ensemble des requêtes d'analyse.

Exemples de requêtes :

- **Taux de churn global**  
  Calcule la proportion de clients ayant `Exited = 1`.

- **Churn par pays (`Geography`)**  
  Compare les taux de churn entre France, Espagne et Allemagne pour identifier les marchés les plus à risque.

- **Churn par tranche d'âge**  
  Regroupe les clients par tranches (18-29, 30-39, 40-49, 50-59, 60+) et mesure le churn dans chaque segment. 

- **Churn selon l'activité (`IsActiveMember`)**  
  Montre l'impact du statut actif / inactif sur le churn.

- **Top clients à forte valeur qui quittent la banque**  
  Liste les 20 clients churnés avec les plus gros soldes pour illustrer la perte de valeur potentielle.


## Insights clés

- Le **taux de churn global** est d'environ 20 %, soit plus d'un client sur cinq qui quitte la banque.  
- Le churn est **nettement plus élevé en Allemagne (32,4 %) qu'en France et en Espagne (≈16 %)**, ce qui en fait un marché prioritaire pour des actions de rétention. 
- Les **clientes** présentent un taux de churn plus élevé (25,1 %) que les clients masculins (16,5 %), ce qui suggère des attentes ou des comportements différents selon le genre.  
- Le churn augmente fortement avec l'âge : il dépasse **56 % chez les 50-59 ans** et reste supérieur à 27 % chez les clients de 60 ans et plus, contre moins de 11 % pour les moins de 40 ans.
- Les clients ayant **un seul produit** ou au contraire **3-4 produits** sont bien plus à risque que ceux avec 2 produits, ce qui peut refléter des profils sous-équipés (basse valeur) ou sur-sollicités (insatisfaction).
- Les **clients inactifs** (`IsActiveMember = 0`) churnent presque **deux fois plus** (26,9 %) que les clients actifs (14,3 %), ce qui en fait un levier majeur pour des campagnes de réactiva

<img width="752" height="452" alt="image" src="https://github.com/user-attachments/assets/1e84cc26-97a1-4ab2-b66b-9a8ef8932b70" />


## Recommandations business

- **Cibler en priorité l'Allemagne**, avec des actions spécifiques (offres dédiées, appels sortants, revue des conditions tarifaires) pour réduire un churn supérieur à 32 %.
- Mettre en place des **campagnes de réactivation pour les clients inactifs**, par exemple via des emails personnalisés, rendez-vous conseillers ou avantages temporaires, afin de faire baisser un churn de 26,9 %.
- Concevoir des offres adaptées aux **segments d'âge à risque (50 ans et plus)**, comme un accompagnement patrimonial ou des produits plus sécurisés, pour limiter un churn qui dépasse 50 % dans certaines tranches.
- Analyser plus finement les clients avec **3-4 produits** pour comprendre pourquoi ils quittent massivement la banque, et ajuster la politique de cross-sell (éviter la sur‑sollicitation, améliorer la qualité de service).
- Mettre en place un **suivi dédié des clients à forte valeur** (gros soldes) qui montrent des signaux de churn, via des conseillers premium ou des offres de fidélisation sur mesure.

