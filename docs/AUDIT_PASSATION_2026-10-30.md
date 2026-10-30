# Audit indépendant et passation Glitch Runner — 30 octobre 2026

Inventaire direct GitHub et comparaison de l'ensemble des branches : 6 refs, 4 PR. Aucune exécution Godot ni test d'export web pendant la revue.

## Branches et graphe
- `main` : `8d6023fd2351526804fb714b45be9f652720294d`.
- `feat/foundation-movement-p1` (`adaf49b6c892fe670d29414eaa1e5d6fd87e3288`) — **behind**, 0 commit(s) exclusif(s), 20 derrière. Travaux historiques absorbés, candidate nettoyage après vérification des workflows.
- `feat/long-form-playtest-level` (`bae5aabd91ce83e0d17ef0556b21ee9d43332c11`) — **behind**, 0 commit(s) exclusif(s), 7 derrière. Travaux historiques absorbés, candidate nettoyage après vérification des workflows.
- `feat/web-playtest-preview` (`aa92ce67c1052e0dae8513c24b8adfc677f325fb`) — **behind**, 0 commit(s) exclusif(s), 13 derrière. Travaux historiques absorbés, candidate nettoyage après vérification des workflows.
- `fix/swept-ground-contact` (`e5de2a94201eb40ad8312d464713a84092a4e26c`) — **behind**, 0 commit(s) exclusif(s), 1 derrière. Travaux historiques absorbés, candidate nettoyage après vérification des workflows.
- `gh-pages` (`950589f6673fc8ed4cc657f6c5c331f21aa7d144`) — **indépendante / pas d'ancêtre commun**, sans objet commit(s) exclusif(s), sans objet derrière. **Branche de publication avec historique sans ancêtre commun : conserver**, ne jamais traiter comme simple branche périmée.

## Pull requests
- [#9](https://github.com/goldaj/glitch_runner/pull/9) — closed, fusionnée : [CONSOLIDÉ][Codex] Glitch Runner P0/P1 + web + 10 zones + correction collision.
- [#7](https://github.com/goldaj/glitch_runner/pull/7) — closed, non fusionnée : P1.L — parcours de test 10× plus long, dix zones et interactions.
- [#6](https://github.com/goldaj/glitch_runner/pull/6) — closed, non fusionnée : Web playtest: real Godot HTML5 export, downloadable build and GitHub Pages.
- [#1](https://github.com/goldaj/glitch_runner/pull/1) — closed, non fusionnée : P0/P1: foundations and playable movement research lab.

## Périmètre Git
`.github`, `.gitignore`, `AGENTS.md`, `LICENSE`, `README.md`, `docs`, `export_presets.cfg`, `project.godot`, `scenes`, `scripts`, `tests`.

## Remise en cause de l'existant
1. Reproduire le bug de chute à travers des textures pendant un saut horizontal ; tester les collisions swept et les raccords de pente.
2. Mesurer accélération sur pente descendante et ralentissement en montée avec positions/vitesses vérifiables, pas seulement impression visuelle.
3. Playtester les dix zones, collisions, trous, checkpoints, caméra et difficulté.
4. Vérifier export Godot Web, GitHub Pages et lanceur local Windows : `gh-pages` est une branche **à historique indépendant**, ne pas la supprimer.
5. Les anciennes PR fermées sans merge explicite peuvent être ancêtres du code consolidé, ne pas réintroduire leurs vieilles implémentations.
6. Tests et prod non vérifiés par cet audit ; aucun changement de physique effectué.


## Vérification CI distante (30 octobre 2026)
- [Godot movement lab checks](https://github.com/goldaj/glitch_runner/actions/runs/41046591846) : **success** sur commit documentaire `e6059055b510` ; [déploiement GitHub Pages](https://github.com/goldaj/glitch_runner/actions/runs/40551612754) : **success** sur `gh-pages` (ancienne exécution).

Ce résultat décrit uniquement le workflow cité, pas un test utilisateur, un playtest complet ni une validation de la production. Le prochain agent doit lire les jobs, confirmer la couverture des scénarios demandés et relancer après ses modifications.
