/* Exercice 2 Eval SQL "Northwind" */

/* 1 : Liste des contacts Français */

SELECT 
	`CompanyName` AS `Société`, -- AS = alias (rename)
	`ContactName` AS `Contact`,
	`ContactTitle` AS `Fonction`,
	`Phone` AS `Téléphone`
FROM `customers`
WHERE `Country` = "France"
;

/* 2 : Produits vendus par le fournisseur "Exotic liquids" */

SELECT `ProductName` AS `Produit` ,
		 `UnitPrice` AS `Prix`
FROM `products`
LIMIT 3  --  Limite la selection a 3 ligne 
;

/* 3 : Nombre de produits vendus par les fournisseurs Français dans l'ordre décroissant */

SELECT 
	`suppliers`.`CompanyName` AS `Fournisseur`,
COUNT(`products`.`ProductID`) AS `NbreProduits`/*Compte le nombre d'enregistrement dans une table*/
FROM `suppliers`
-- JOIN combine deux tableaux & localise une valeur ciblé avec ON 
INNER JOIN `products` 
ON `suppliers`.`SupplierID` = `products`.`SupplierID`
WHERE `suppliers`.`Country` = "France" -- notre condition 
GROUP BY `suppliers`.`SupplierID` 
ORDER BY `NbreProduits` DESC -- permet d'afficher en décroissant
;

/* 4 : Liste des clients Français ayant plus de 10 commandes */

SELECT
	`customers`.`CompanyName` AS `Client`,
COUNT(`orders`.`CustomerID`) AS `NbreCommandes`
FROM `customers`
INNER JOIN `orders` ON `customers`.`CustomerID` = `orders`.`CustomerID` 
WHERE `customers`.`Country` = "France"
GROUP BY `customers`.`CustomerID`
HAVING `NbreCommandes` > 10 -- Permet de selectionner que les commandes suppérieur a 10 
;

/* 5 : Liste des clients ayant un chiffre d’affaires > 30.000 */ 

SELECT
	`customers`.`CompanyName` AS `Client`,
	`customers`.`Country` AS `Pays`,
	SUM(`order details`.`UnitPrice` * `order details`.`Quantity`) as `CA`-- SUM nous permet de calculé la somme totale (pas d'espace)
FROM ((`customers`	-- parenthèse pour joindre plusieurs table 
	INNER JOIN `orders` ON `orders`.`CustomerID` = `customers`.`CustomerID`)
	INNER JOIN `order details` ON `order details`.`OrderID` = `orders`.`OrderID`)
GROUP BY `customers`.`CustomerID`
HAVING `CA` > 30000 -- permet de selectionner que les CA supérieur a 30000 
ORDER BY `CA` DESC  -- Les affiches dans l'ordre decroissant 
;

/* 6 : Liste des pays dont les clients ont passé commande de produits fournis par « Exotic Liquids » */

SELECT DISTINCT -- pour evité d'afficher des doublons  
`orders`.`ShipCountry` AS `Pays`
FROM (((`orders`
	INNER JOIN `order details` ON `order details`.`OrderID` = `orders`.`OrderID`)
	INNER JOIN `products` ON `products`.`ProductID` = `order details`.`ProductID`)
	INNER JOIN `suppliers` ON `suppliers`.`SupplierID` = `products`.`SupplierID`)
WHERE `suppliers`.`CompanyName` = "Exotic Liquids"
ORDER BY `Pays` ASC
;

/* 7 : Montant des ventes de 1997 */
-- On peux faire select sum directement 
SELECT SUM(`order details`.`Quantity` * `order details`.`UnitPrice`) AS "Montant Ventes 97"
FROM `order details`
INNER JOIN `orders` ON `orders`.`OrderID` = `order details`.`OrderID`
WHERE `orders`.`OrderDate`
;

/* 8 : Montant des ventes de 1997 mois par mois */

SELECT 
MONTH(`orders`.`OrderDate`) AS `Mois 97`, -- Retourne le numéro du mois 
SUM(`order details`.`UnitPrice` * `order details`.`Quantity`) AS `Montant Ventes`
FROM `order details`
INNER JOIN `orders` 
ON `orders`.`OrderID` = `order details`.`OrderID`
WHERE `orders`.`OrderDate` LIKE '1997%' -- "like" permet de chercher toute les lignes qui contienne '1997'
GROUP BY `Mois 97`
;

/* 9 : Depuis quelle date le client « Du monde entier » n’a plus commandé ? */

SELECT `orders`.`OrderDate` AS 'Date de dernière commande'
FROM `orders` 
INNER JOIN `customers` 
ON `customers`.`CustomerID` = `orders`.`CustomerID`
WHERE `customers`.`CustomerID` = 'DUMON'
ORDER BY `orders`.`OrderDate` DESC 
LIMIT 1 -- donne que une valeur du tableau
;

/* 10 : Quel est le délai moyen de livraison en jours ? */

SELECT
TRUNCATE (AVG(DATEDIFF(`orders`.`ShippedDate`, `orders`.`OrderDate`)), 0) AS 'Délai moyen de livraison en jours'
FROM `orders`;
-- AVG = permet de calculé une valeur moyenne
-- TRUNCATE = purge la table sans la supprimer 
-- DATEDIFF détermine l'intervalle entre 2 dates spécifiées 