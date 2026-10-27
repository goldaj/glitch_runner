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

## 2026-10-27 — Branche Web, futur playtest H1 (ajout)
- Branche isolée `feat/web-playtest-preview` créée depuis `feat/foundation-movement-p1` (ne pas fusionner en `main` sans coordination).
- Préréglage `export_presets.cfg` « Web », Godot 4.7.2 stable et `variant/thread_support=false`, afin de fonctionner sous GitHub Pages sans SharedArrayBuffer.
- `.github/workflows/web-preview.yml` : export réel, artifact ZIP, publication générée sur branche `gh-pages` (ne jamais modifier manuellement ses fichiers sans raison).
- Guide d'utilisation : `docs/WEB_PLAYTEST.md`. **Un réglage propriétaire indispensable** : dans GitHub Settings → Pages, sélectionner Deploy from a branch → gh-pages /root. Aucun token normal de GitHub Actions ne l'active automatiquement.
- URL prévue **une fois activée** : https://goldaj.github.io/glitch_runner/ .
- **Aucun G1/G2 implémenté** : la page est le labo A/B P1 pour tester H1. Ne pas la présenter comme jeu complet.
- Rester factuel : l'existence d'un workflow n'établit pas sa réussite. Reporter le résultat d'export, la présence de gh-pages, et la disponibilité HTTPS après vérification.

## État Web après première CI (27/10/2026)
- Workflow export **réellement successful** : https://github.com/goldaj/glitch_runner/actions/runs/40461342279
- 17 invariants Godot PASS, `index.html`, `index.js`, `index.wasm` (~38 Mio), `index.pck` et fichiers annexes exportés et commités sur la branche [gh-pages](https://github.com/goldaj/glitch_runner/tree/gh-pages) (commit `bd5a666`).
- Artifact Web ZIP : [exécution GitHub](https://github.com/goldaj/glitch_runner/actions/runs/40461342279/artifacts/12714611805). **Page HTTPS non confirmée active à cette date.**
- Ajout ultérieur d'un contrôle navigateur dans `tests/web_smoke.mjs` (Playwright/Chromium, touches, JS errors, capture). **Ne pas prétendre que ce nouveau contrôle a passé sans run validé**.

## Résultat du Web smoke et publication (27/10/2026)
- [Run 40461694868](https://github.com/goldaj/glitch_runner/actions/runs/40461694868) **SUCCESS** : installation Godot 4.7.2, export Web 1-thread, tests **17 invariants PASS**, serveur local puis **Chromium PASS** (canvas visible + inputs + pas de pageerror/console error). Capture [artifact 12714877353](https://github.com/goldaj/glitch_runner/actions/runs/40461694868/artifacts/12714877353).
- ZIP [artifact 12714967049](https://github.com/goldaj/glitch_runner/actions/runs/40461694868/artifacts/12714967049), binaires **présents dans branche gh-pages** commit `a037452`.
- **Seule étape de mise en ligne manquante connue** : activer GitHub Pages dans Settings → Pages → Deploy from a branch → gh-pages/(root). Impossible d'affirmer URL active sans cela. Une fois activée, vérifier https://goldaj.github.io/glitch_runner/ .
- `docs/WEB_PLAYTEST.md` donne touches et protocole. Aucun feedback humain H1. Codex ne doit pas généraliser « CI verte » au ressenti.
- Amélioration technique non fonctionnelle : cache Actions du template single-thread pour éviter de retélécharger l'archive officielle de 1,3 Go à chaque mise à jour ; CI du changement de cache à observer séparément.

## P1.6 — Régression pente signalée et correction (27/10/2026)
- **Utilisateur, retour de jeu réel :** en test Web, les pentes ne semblent ni accélérer à la descente, ni freiner à la montée.
- **Cause confirmée par lecture du code :** le modèle bornait `ground_speed` à ±420 px/s **à chaque tick**, immédiatement après avoir calculé `SLOPE_FORCE`, ce qui jetait l'excédent ; l'accélération constante sous input dominait l'opposition d'une montée. Le HUD montrait aussi la norme totale de `air_velocity`, susceptible de brouiller l'interprétation.
- **Correctif P1.6 sur la branche Web** : l'accélération de la touche décroît près de la vitesse normale cible (sans écraser la vélocité obtenue du terrain), force de gravité de pente renforcée, frottement distinct A/B, léger amortissement de surplus (0,45/s) et garde-fou absolu de P1. HUD `vx` + descente/montée dans le sens de déplacement + témoin surplus. Tests comparatifs tenus à vitesse d'entrée identique, dans les deux sens.
- **Ne pas confondre** cette correction exploratoire avec la résolution finale de #5 : une fois G1 ajouté, il faudra tester vitesse exceptionnelle, transitions air/sol, plafonds absolus et contrôles de collision réels. Aucun G1 implémenté ici.
- Le code, les tests et la documentation ont été écrits. **Validation CI et expérience humaine à consigner après observation**, ne pas inventer de résultats. Export Web automatique depuis `feat/web-playtest-preview` via workflow GitHub Actions.

### Suivi P1.6b
En révisant P1.6, un second écrêtage a été identifié : en vol, `air_velocity.x` était bornée à ±550 px/s à **chaque tick**. Même si une pente produisait plus, sauter aurait supprimé le gain. Le correctif de contrôle aérien applique désormais une limite à l'**accélération fournie par la commande**, mais conserve la vitesse horizontale exceptionnelle tant qu'elle reste sous la borne de sécurité P1. Tests additionnels saut et réception. H1 demeure humainement non validée. Reporter les résultats CI du commit séparément.

## Confirmation des correctifs de pente sur la branche Web (27/10/2026)
- [Godot CI 40463364151](https://github.com/goldaj/glitch_runner/actions/runs/40463364151) et [40463367736](https://github.com/goldaj/glitch_runner/actions/runs/40463367736) : **PASS movement_lab: 29 invariants**, y compris pente à commandes/vitesses égales, conservation overspeed au sol, saut et atterrissage.
- [Export Web + Chromium + publication 40463364187](https://github.com/goldaj/glitch_runner/actions/runs/40463364187) : **SUCCESS** sur commit `7448652`; dernière évolution HUD incluse.
- Le propriétaire a confirmé que GitHub Pages s'ouvre normalement, **avant** ces correctifs. Le prochain retour humain sur la physique corrigée reste requis, voir [issue #2](https://github.com/goldaj/glitch_runner/issues/2).
- PR #6 demeure branche Web isolée, ne pas fusionner automatiquement. Le site `gh-pages` est un **build généré**, ne pas y corriger la physique à la main.

## 27/10/2026 — P1.L : carte x10 et transmission
- Branche distincte `feat/long-form-playtest-level` issue de `feat/web-playtest-preview`. Le workflow Web publie cette branche sur gh-pages après validation. Pas de fusion automatique ni d'écrasement de PR #6.
- `docs/LEVEL_DESIGN_P1_LONG.md` est le document de game design : 31 000 px, 10 environnements, 75 sommets, 30 plateformes traversables par-dessous, 7 vrais fossés, 4 ressorts, 190 éclats, reprise toutes les 3 100 unités (9 checkpoints). Source sans asset sous droits.
- `course_profile.gd` décrit tout le niveau ; `movement_model.gd` gère le sol 1D, les fossés, surfaces à sens unique et impulsions de ressort ; `prototype.gd` gère checkpoint, visuels, orbes et HUD. Limite : **pas de vrais murs/coins**, donc ne pas prétendre que le solveur suffit à G1.
- Premier test étendu a signalé l'impulsion de ressort coupée par `jump_held=false` : correction dans le modèle via `bounce_flight`. Runs suivants verts : [Godot 40546294374](https://github.com/goldaj/glitch_runner/actions/runs/40546294374) (29 + 462 invariants), [Web 40546293820](https://github.com/goldaj/glitch_runner/actions/runs/40546293820) (export, navigateur et branche gh-pages succès).
- **Ne pas déclarer le niveau validé humainement** : il reste des risques de placement trop dur, de caméra, de plateformes trop hautes ou de fossés hors rythme. Rejouer H1 issue #2 avant G1.
