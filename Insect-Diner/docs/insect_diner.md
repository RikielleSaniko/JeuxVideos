# INSECT DINER

*Avec Ama, l'abeille serveuse*

---

## Histoire

Au cœur d'un grand marché d'une ville d'Afrique se trouve l'**Insect Diner**, un petit restaurant populaire où tous les insectes du quartier viennent manger : fourmis, coccinelles, papillons et scarabées.

Le restaurant appartient à **Fatou**, une cuisinière connue pour ses beignets au miel et son nectar d'hibiscus. Mais depuis l'ouverture d'un grand fast-food de l'autre côté du marché, les clients se font rares et les dettes s'accumulent. 

C'est à ce moment qu'arrive **Ama**, une jeune abeille rapide et débrouillarde, engagée comme serveuse. Sa mission : servir les clients plus vite que jamais, gagner leur confiance et rendre au restaurant sa réputation.

Ama réussira-t-elle à sauver le restaurant de Fatou ?

---

## Présentation du jeu

**INSECT DINER** est un jeu de gestion de restaurant en 2D vu de haut, dans lequel le joueur incarne Ama, une abeille serveuse.

Les clients insectes entrent, s'installent à une table libre et passent leur commande. Le joueur doit prendre les commandes, récupérer les plats au comptoir de la cuisine et les servir avant que les clients perdent patience.

Chaque journée de travail est plus intense que la précédente : plus de clients, plus de tables et de nouveaux plats. La rapidité, l'organisation et les priorités sont les atouts à avoir.

---

## Thématiques principales

- La débrouillardise.
- La gestion du temps et des priorités.
- Le petit commerce face à la grande concurrence.

## Objectif du joueur

Le joueur doit servir le plus de clients possible pendant chaque journée, sans les faire attendre trop longtemps.

Chaque journée possède un **objectif d'argent** à atteindre. Si l'objectif est atteint, le restaurant ouvre le lendemain avec de nouveaux défis. Si trop de clients partent mécontents, la réputation du restaurant baisse et la journée est perdue.

## Algorithmes à développer

1. **File d'attente des clients** : les clients qui arrivent alors que toutes les tables sont occupées attendent à l'entrée dans une file.
   
2. **Machine à états des clients** : chaque client passe par des états successifs (arrive, s'assoit, commande, attend, mange, paie, part).
  
3. **Génération des clients et des commandes** : les clients et leurs plats sont choisis aléatoirement.

---

## Personnages

**Ama**
- Statut : Abeille
- Rôle : Personnage principal, serveuse

## Différents clients

Dans INSECT DINER, les clients remplacent les ennemis. Ils peuvent faire perdre la partie s'ils sont mal servis.

**Fourmis**
- Particularité : Patience très courte. Il faut les servir en priorité.

**Coccinelles**
- Particularité: Patientes et polies.

**Papillons**
- Particularité: Laissent de gros pourboires.

**Scarabées**
- Particularité: Patience longue.

## Le menu

| Plat | Description |
|---|---|
| Beignets au miel | Beignets dorés nappés de miel |
| Nectar d'hibiscus | Boisson sucrée à la fleur d'hibiscus |
| Jus de mangue bien mûre | Jus de fruit très mûr, presque fermenté |
| Bol de graines et pollen | Graines et pollen |

---

## Différentes journées

Le jeu est découpé en journées de travail, qui jouent le rôle de niveaux.

### 1. Journée 1 - L'ouverture

- **Description** : Premier jour d'Ama à l'Insect Diner.
- **Clients** : Coccinelles et fourmis.
- **Menu disponible** : Beignets au miel et nectar d'hibiscus.
- **Objectif** : Atteindre le premier objectif d'argent et apprendre les bases du service.

### 2. Journée 2 - Le restaurant s'anime

- **Description** : Le bouche-à-oreille fonctionne et le restaurant attire plus de monde.
- **Clients** : Coccinelles, fourmis et papillons.
- **Menu disponible** : Ajout du jus de mangue bien mûre.
- **Objectif** : Gérer plus de tables en même temps sans perdre de clients.

### 3. Journée 3 - La grande réussite

- **Description** : Le restaurant attire encore plus de clients et devient le plus populaire du coin.
- **Clients** : Tous les types de clients.
- **Menu disponible** : Ajout du bol de graines et pollen.
- **Objectif** : Atteindre l'objectif d'argent.
- **Fin du jeu** : Selon la somme d'argent final, l'Insect Diner devient le restaurant le plus populaire du marché, ou doit fermer ses portes.

---

## Calendrier du projet

| Date | Détails | Projet |
|---|---|---|
| 10-18 | Création, déplacement et animations du joueur | Livrable #1 – Personnage jouable |
| 10-21 | Salle du restaurant, tables, comptoir et collisions | Livrable #2 – Environnement de test |
| 10-28 | Arrivée des clients, file d'attente, attribution des tables et déplacement des clients | Livrable #3 – Clients et IA |
| 11-04 | Prise de commande, service, patience et humeur des clients | Livrable #4 – Boucle de jeu complète |
| 11-11 | Argent, pourboires, HUD, objectifs de journée et sons | Livrable #5 – Pointage et progression |
| 11-18 | Menu principal, pause, journées 2, 3 et scène de fin | Livrable #6 – Contenu et narration |
| 11-25 | Équilibrage et version finale | Livrable #7 – Version finale jouable |
