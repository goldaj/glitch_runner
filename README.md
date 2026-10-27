# Glitch Runner

**Jeu de plateforme 2D expérimental : maîtriser des failles pour préserver et libérer une vitesse autrement impossible.**

Projet autonome lancé le **27 octobre 2026**. La branche de recherche et d'implémentation initiale est `feat/foundation-movement-p1`, soumise à revue avant intégration. Aucun gameplay n'a été validé par des joueurs.

## Intentions
- Simplicité de commandes et niveaux accessibles sans glitch, sans copier Super Mario Bros. 3.
- Inertie, vitesse acquise, pentes, freinage et plaisir du déplacement inspirés des Sonic 2D classiques sans copier leur physique.
- Glitchs intentionnels, déductibles, reproductibles via les commandes ordinaires.
- La récompense est **l'élan conservé derrière l'obstacle**, transformé en séquence de vitesse / envol ; le temps gagné est secondaire.
- G1 Corner Slip et G2 Slope Overflow restent hypothétiques, et **ne figurent pas encore au P1**.

## Laboratoire P1 (sans glitch)
Ouvrir le dossier dans **Godot 4.7.2 stable** et exécuter la scène principale. Flèches gauche/droite, Espace/Entrée pour sauter, R pour reset. Terrain de test généré, caméra et affichage du chrono. Le contrôleur P1 n'a volontairement **ni murs ni coins ni plateformes** : il ne doit pas servir tel quel à construire G1.

Vérification : `godot --headless --editor --path . --import --quit` puis `godot --headless --path . --script res://tests/test_movement.gd` (nécessite Godot 4.7.2 installé). La CI automatise ces commandes. **Compilation et tests ne prouvent pas le ressenti**.

## Docs et collaboration
[Archive complète du concept](docs/INCUBATOR_CONCEPT.md) · [Étude](docs/RESEARCH.md) · [Roadmap](docs/ROADMAP.md) · [Handoff Codex](docs/CODEX_HANDOFF.md) · [Historique des échanges](docs/CHATGPT_PROJECT_HISTORY.md) · [AGENTS](AGENTS.md)

Licence [MIT](LICENSE). Indépendant des franchises citées comme inspirations.
