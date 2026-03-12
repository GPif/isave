# Niveaux

English version [here](LEVELS.md).

---

Vous trouverez ci-dessous tous les niveaux mentionnés précédemment, chacun contenant une ou plusieurs « fonctionnalités utilisateur » qui devraient être implémentées. Complétez autant de niveaux que possible, en mettant en valeur vos compétences.


N'hésitez pas à lire le [Glossaire](GLOSSARY.fr.md) pour des explications sur les termes financières.

## Niveau 1 - Établir la base

**En tant que client (`Customer`), je veux pouvoir lister tous mes portefeuilles (`Portfolio`).**
- Pour un portefeuille donné, je veux voir son libellé, son montant total et son type.
- Mon portefeuille peut être de type « CTO », « PEA », « Assurance Vie » ou « Livret A ».
- Mes portefeuilles de type « CTO », « PEA » et « Assurance Vie » peuvent avoir des placements en des instruments financiers (`Instrument`).

**En tant que client, je veux voir les placements de mes portefeuilles.**
- Un portefeuille eligible ne peut investir qu'une seule fois dans un instrument donné.
- Plusieurs portefeuilles eligibles peuvent investir dans un même instrument.
- Un instrument est caractérisé par son ISIN (identifiant global unique), son type, son libellé, son prix et son SRI (niveau de risque).
- Un instrument peut être de type « Action » (`stock`), « Obligation » (`bond`) et « Fonds en Euros » (`euro_fund`).
- Si mon portefeuille a des placements, je veux voir le montant investi dans chaque instrument, ainsi que le poids que ce montant représente dans le portefeuille.

Écrivez le code nécessaire pour un endpoint qui renvoie le contenu de `data/level_1/portfolios.json` en JSON.

## Niveau 2 - Apporter des modifications

**En tant que client, je veux arbitrer mes placement au sein d'un portfolio eligible.**
- Un portfolio est eligibles a des opérations si son type est « CTO » ou « PEA ».
- Je peux déposer de l'argent dans un placement existant.
- Je peux retirer de l'argent d'un placement existant.
- Je peux transférer de l'argent d'un de mes placements vers un autre placement.


Écrivez le code nécessaire pour exposer une API permettant au client de faire des changements sur leurs placements.

## Niveau 3 - Comprendre mes investissements

iSave permet au client d'avoir une meilleure vision sur ces placements, notamment en calculant son niveau de risque global et la répartiotion de ces placements dans les secteurs financiers.

**En tant que client, je veux voir des indicateurs sur mes placements.**
- Je veux voir le niveau de risque de chaque portefeuille, afin de savoir combien de risque je prends pour chaque ensemble d'investissements. Ce risque est calculé en prenant en compte le poids de chaque investissement dans le portefeuille et son indice de risque (SRI).
- Je veux voir la répartition de mon Portfolio par type d'investissement (stock, bond, etc.) afin de comprendre comment est investi mon argent.
- Je veux connaître le risque global que je prends en considérant l’ensemble de mes portefeuilles, afin d’avoir une vue d’ensemble de mes risques financiers.
- je veux voir la répartition globale de tous mes investissements par type, afin de comprendre comment mon argent est réparti dans l’ensemble de mes portefeuilles.


Écrivez le code nécessaire pour exposer une API permettant au client d'obtenir les indicateurs mentionnés ci-dessus.

## Niveau 4 - Frais

iSave applique des frais mensuels pour l'hébergement des portefeuilles du client avec des placements sur ses serveurs. Les frais sont les suivants :

- 5% pour les montants compris entre 0 et 5000
- 3% pour les montants compris entre 5000 et 7500
- 2% pour les montants compris entre 7500 et 10000
- 0,8% pour les montants supérieurs à 10000

En ce qui concerne ces frais, **en tant que client, j'aimerais voir les frais liés à mon utilisation d'iSave.**
- Le montant actuel des frais appliqués à chacun de mes portefeuilles.
- Le pourcentage actuel des frais appliqués à chacun de mes portefeuilles.
- Les valeurs ci-dessus, mais globalement sur tous mes placements.

Écrivez le code nécessaire pour exposer une API permettant au client de voir ses frais.

## Niveau 5 - L'histoire prédit l'avenir

Le client investit sur iSave depuis un certain temps et aimerait savoir comment son état a évolué dans le temps. Pour cela, iSave sauvegarde les valeurs historiques des portefeuilles hebergés sur la plateforme

**En tant que client, je veux voir l'historique des performances de mes portefeuilles**
- Je veux voir la valorisation historique de chacun de mes portefeuilles.
- Je veux voir les rendements (pourcentage de croissance) de mes portfeuilles globalement et à une date donnée dans le passé.

Le _rendement_ est calculé comme suit :

$$Y = (\dfrac{Vc}{Vi} - 1) \times 100$$

**En tant que client, je veux voir les frais que j'ai payés dans le passé.**
- Je veux voir tous les frais du niveau 4, mais à une date donnée dans le passé.
- JE veux voir le montant des frais que j'ai payés globalement par portefeuille depuis leur ajout à la plateforme.


La valorisation hebdomadaire des portefeuilles du client se trouve dans `data/level_4/historical_values.json`.

Écrivez le code nécessaire pour exposer une API permettant d'accéder à ces informations.
