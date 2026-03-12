# Défi Backend WeSave - iSave

English version [here](README.md).

## Prérequis

- `ruby` version 3.3.1
- `sqlite3`

## Introduction

Bienvenue au Défi Tech WeSave !

Votre tâche consiste à créer **l'API backend** d'une application web, *iSave*, qui aide les clients à gérer leurs investissements en fonction de leurs objectifs financiers. Le cœur de cette application repose sur la gestion de portefeuille boursier et le calcul d'indicateurs financiers.

## Instructions pour le rendu

- Clonez ce dépôt (ne pas le forker).
- Implémentez les fonctionnalités décrites dans [LEVELS.fr.md](LEVELS.fr.md).
- Résolvez les niveaux dans l'ordre croissant.
- Écrivez des tests pour couvrir les fonctionnalités implémentées.
- Assurez-vous que votre code est bien documenté. Il est attendu que vous fournissiez des instructions sur la façon de lancer l'application et d'utiliser l'API.
- Vous pouvez effectuer autant de commits que vous le souhaitez pour chaque niveau. Chaque commit doit respecter la [norme Conventional Commit](https://www.conventionalcommits.org/fr/v1.0.0/), comme suit :

```txt
<type>[scope]: <description>

[corps optionnel]

[pied(s) de page optionnel(s)]
```

Exemple :

```txt
chore(init) : ceci est le premier commit

Ajouter les exigences de base à l'application

Niveau 1
```

## Critères d'évaluation

Votre soumission sera évaluée sur la base des critères suivants :

- **Fonctionnalité** : Dans quelle mesure le backend répond-il aux exigences ?
- **Qualité du code** : Le code est-il bien organisé, commenté et maintenable ?
- **Tests** : Y a-t-il suffisamment de tests pour garantir que les fonctionnalités sont correctes et fiables ?

## Instructions de configuration

1. Clonez le dépôt (ne le forkez pas) : `git clone https://gitlab.com/anatec/wesave/isave-backend-test-2024.git`
2. Installez la version de Ruby requise (~> 3.3.1)
3. Installez les dépendances : `bundle install`
4. Configurez la base de données (si nécessaire) : `rake db:create db:migrate`

## Soumission de votre travail

Lorsque vous avez terminé, soumettez vos résultats à votre correspondant chez WeSave.

Vous pouvez soit :
- Partager un lien vers votre projet sur Github, Gitlab ou Bitbucket.
Vous pouvez partager votre dépôt avec les identifiants suivants :
  - *Github* : `@nezih-anatec`
  - *Gitlab* : `@nezih1`
- OU zipper votre répertoire de projet et l'envoyer par e-mail.

Si vous n'utilisez pas Github, Gitlab ou Bitbucket, assurez-vous d'inclure votre dossier `.git` dans l'archive.

## Le défi

Dans le fichier [LEVELS.fr.md](LEVELS.fr.md), vous trouverez 5 niveaux, chacun devenant progressivement plus difficile.

Votre tâche est de compléter autant de niveaux que possible dans le temps imparti, en démontrant vos compétences.

## Conseils

- Vous êtes libre de jeter un œil aux niveaux supérieurs, mais essayez de vous concentrer sur la résolution du niveau actuel avec la solution la plus simple possible.
- Au fur et à mesure que les niveaux deviennent plus complexes, vous devrez probablement réutiliser et adapter du code précédent. Une bonne approche consiste à utiliser la programmation orientée objet (OOP), à ajouter de nouvelles couches d'abstraction lorsque nécessaire, et à écrire des tests pour garantir que vous ne cassez aucune fonctionnalité existante.
- N'hésitez pas à écrire du "shameless code" au début et à le refactoriser dans les niveaux suivants.
- Pour les niveaux supérieurs, nous sommes intéressés par un code propre, extensible et robuste, donc ne négligez pas les cas limites, utilisez des exceptions lorsque c'est nécessaire, ...

**Remarques supplémentaires :**

- L'authentification **n'est pas** requise, ni attendue, pour cette application.
- Vous êtes autorisé à utiliser n'importe quelle gem publiquement disponible.
- Tous les montants doivent être stockés sous forme décimale.
- Tous les prix des actifs seront définis dans la même devise.

**Bonne chance !**
