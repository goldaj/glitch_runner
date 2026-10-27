# Passation à Codex — branche de fondation

**Au 27/10/2026**. Nouveau dépôt `goldaj/glitch_runner`. Branche ChatGPT : `feat/foundation-movement-p1`, `main` conservée intacte. Une PR de migration Incubator existe séparément ou doit être créée.

## Comprendre
- Commencer par `AGENTS.md`, `docs/RESEARCH.md`, `docs/ROADMAP.md`, puis l'archive `docs/INCUBATOR_CONCEPT.md`.
- Objectif : satisfaction de vitesse / inertie à la Sonic rétro, mais simplicité d'apprentissage d'un SMB3 (sans copier ces jeux).
- G1 Corner Slip et G2 Slope Overflow sont **hypothèses**. **Aucun glitch P1**.
- Un glitch doit conserver une vitesse que le chemin normal *couperait*, donnant une séquence normalement impossible.
- Recherche H1 sur qualité du mouvement **avant** tout ajout de collision fantaisiste.

## Implémentation P1
- `scripts/course_profile.gd` : hauteur/derivée de terrain composée de segments. **Ni murs ni plafonds.**
- `scripts/movement_model.gd` : état physique testable sans scène ; 60 Hz fixe dans `project.godot`.
- `scripts/prototype.gd` : input, rendu placeholders, caméra et HUD.
- `tests/test_movement.gd` : tests purs sous Godot headless. Workflow sur PR/push.
- Les constantes physiques sont **valeurs de départ expérimentales**, pas calibration achevée.

## Prochaines actions dans l'ordre
1. Inspecter CI et logs ; réparer toute erreur de parse/exécution, **ne pas déclarer vert sans preuve**.
2. Exécuter jeu manuellement (clavier ET manette si possible), noter friction, caméras, freinage, pente, saut. Faire deux variantes sur une **branche distincte**, comparer H1.
3. Mesurer la qualité de jeu H1. Si H1 non convaincante, continuer P1, ne pas lancer G1.
4. Après H1, concevoir collision 2D robuste et tests aux vitesses extrêmes, *ensuite* G1.

## Règles
Jamais fusion automatique, jamais écraser Codex ou `main`. Mise à jour de ce fichier, résultats/échecs et du journal de contexte à chaque sous-étape. Aucune capture de toutes les conversations historiques n'est disponible : **pas de faux verbatim**.

**État déclaré au moment de la création :** code écrit, CI à observer ; aucun playtest humain et aucune validation de game feel ; cross-platform et anti-cheat non testés.

## Avancement technique additionnel — 27/10/2026
- Première CI observée **verte**, run https://github.com/goldaj/glitch_runner/actions/runs/40457925457 : installation Godot 4.7.2, import, tests d'invariants, toutes étapes successful.
- Ajout ensuite d'un protocole H1 A/B, touches 1 et 2, compteur de sauts, vitesse max et tests distinctifs du freinage ; **nouveau commit à vérifier en CI**.
- Le protocole complet se trouve dans `docs/PLAYTEST_H1.md`. H1 **toujours non validée par des personnes**. N'ajouter ni G1 ni G2 avant cette validation.

## Références après validation du profil A/B (27/10/2026)
- Runs verts sur le commit `69296de4` : https://github.com/goldaj/glitch_runner/actions/runs/40458297529 et https://github.com/goldaj/glitch_runner/actions/runs/40458303074 (CI sur push/PR).
- Renforcement suivant : smoke test de la **vraie scène** dans la CI, plus test de route normale jusqu'à l'arrivée ; son résultat doit être vérifié sur le commit correspondant.
- Tickets de coordination : [#2 playtest H1](https://github.com/goldaj/glitch_runner/issues/2) **bloquant**, [#3 architecture des collisions P2](https://github.com/goldaj/glitch_runner/issues/3) à étudier seulement après H1, [#4 expérience H3](https://github.com/goldaj/glitch_runner/issues/4) après H2.
- État conceptuel : aucun glitch codé, H1 non évaluée humainement, P2 et P3 non commencés.

## Bilan vérifié sur le commit 6f27e1b (27/10/2026)
- CI du **code P1 A/B + route normale + smoke de scène** : deux runs verts https://github.com/goldaj/glitch_runner/actions/runs/40458594556 et https://github.com/goldaj/glitch_runner/actions/runs/40458599650.
- Job `test` confirmé : Godot 4.7.2 installé, import success, **17 invariants PASS** (sortie explicite des logs), **scene 180 frames success**.
- Les invariants couvrent accélération, freinage, friction, hauteur du saut, pente, répétition identique dans un même environnement, reset, différence A/B et franchissement du parcours sans glitch.
- **GATE restant : #2 H1 playtest avec de vraies personnes.** Ne pas transformer une CI verte en validation game design.
- La PR #1 reste brouillon/non fusionnée ; la PR incubateur #5 est séparée. Aucune fusion par ChatGPT.

## Risque P2 identifié et ordre de reprise
- **Issue [#5](https://github.com/goldaj/glitch_runner/issues/5) : plafond de vitesse**. L'actuel `movement_model.gd` borne `ground_speed` à `GROUND_SPEED_CAP` à chaque tick et l'air à `AIR_SPEED_CAP`. Cela suffit au laboratoire P1, mais **annulerait instantanément tout surplus d'élan issu d'un futur glitch**. Ne pas étendre G1/G2 sans résoudre et tester vitesse normale vs surplus et amortissement.
- `main` et les PR ne sont pas fusionnées ; seules des branches dédiées ont été écrites. Les deux runs verts du dernier commit documentaire `b88a1a6` sont [40458826898](https://github.com/goldaj/glitch_runner/actions/runs/40458826898) et [40458831597](https://github.com/goldaj/glitch_runner/actions/runs/40458831597).
- **Ordre** : #2 playtest H1 puis, en cas de résultat favorable, #3 et #5 recherches/architecture, puis premier G1 testé, puis #4 H3. Ce chantier s'arrête proprement ici sur une dépendance humaine explicite, non sur une limite artificielle de backlog.
