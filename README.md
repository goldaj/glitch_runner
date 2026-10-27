# Glitch Runner

**Jeu de plateforme 2D expérimental : maîtriser des failles pour préserver et libérer une vitesse autrement impossible.**

Projet autonome lancé le **27 octobre 2026**. La branche de recherche et d'implémentation initiale est `feat/foundation-movement-p1`, soumise à revue avant intégration. Aucun gameplay n'a été validé par des joueurs.

## Intentions
- Simplicité de commandes et niveaux accessibles sans glitch, sans copier Super Mario Bros. 3.
- Inertie, vitesse acquise, pentes, freinage et plaisir du déplacement inspirés des Sonic 2D classiques sans copier leur physique.
- Glitchs intentionnels, déductibles, reproductibles via les commandes ordinaires.
- La récompense est **l'élan conservé derrière l'obstacle**, transformé en séquence de vitesse / envol ; le temps gagné est secondaire.
- G1 Corner Slip et G2 Slope Overflow restent hypothétiques, et **ne figurent pas encore au P1**.

## Laboratoire P1.L : niveau long, sans glitch ni ennemi

**31 000 px, dix environnements**, soit exactement dix fois le terrain d'origine. **30 plateformes unidirectionnelles, 7 fossés, 4 ressorts, 190 éclats optionnels** et reprise au début de la zone en cours. Les graphismes géométriques sont originaux, volontairement provisoires. Inspiration du premier niveau de Mario 3 **dans le rythme pédagogique uniquement**, sans reproduire son agencement, ses blocs ni ses sprites.

Dans Godot 4.7.2 : flèches pour courir, Espace/Entrée pour sauter, **R pour reprendre au point de contrôle**, **Maj+R pour repartir de zéro**, 1/2 pour comparer physique réactive/inertielle.

Lire [le découpage des dix zones et les limites techniques](docs/LEVEL_DESIGN_P1_LONG.md). L'architecture P1 ne simule **pas encore les murs/coins solides ni les glitches** ; seules les plateformes posables par-dessus sont ajoutées. Ne pas utiliser ce contrôleur comme solveur G1.

Vérification : `godot --headless --editor --path . --import --quit` puis `godot --headless --path . --script res://tests/test_movement.gd` (nécessite Godot 4.7.2 installé). La CI automatise ces commandes. **Compilation et tests ne prouvent pas le ressenti**.

## Tester le jeu dans un navigateur

[**Version Web de test**](https://goldaj.github.io/glitch_runner/) (nécessite l'activation initiale GitHub Pages si le lien n'est pas encore actif). [Mode d'emploi et contrôle du déploiement](docs/WEB_PLAYTEST.md).

Le workflow publie maintenant le niveau long depuis `feat/long-form-playtest-level` après validation. Il exporte réellement le projet Godot en HTML5 et conserve le build compilé sur la branche `gh-pages` du même dépôt, ainsi qu'en ZIP depuis GitHub Actions. Pas d'installation locale pour jouer sur Pages.

## Docs et collaboration
[Archive complète du concept](docs/INCUBATOR_CONCEPT.md) · [Étude](docs/RESEARCH.md) · [Roadmap](docs/ROADMAP.md) · [Handoff Codex](docs/CODEX_HANDOFF.md) · [Historique des échanges](docs/CHATGPT_PROJECT_HISTORY.md) · [AGENTS](AGENTS.md)

Licence [MIT](LICENSE). Indépendant des franchises citées comme inspirations.

[Protocole de playtest H1 A/B](docs/PLAYTEST_H1.md) : touches **1** (A réactif) et **2** (B inertiel), départ et chrono remis à zéro à chaque changement. Consigner les observations avant de décider du premier glitch. Une CI verte confirme l'exécution, pas le plaisir de jeu.
