# Glitch Runner : audit GitHub et passation — 30/10/2026

## Mission
Platformer Godot : le mouvement normal agréable précède les glitches. H1 doit être confirmée en playtest humain avant G1/G2. Pas de bouton de téléport ; pentes et contacts au pas fixe. Le sol interpolé P1 n'est pas un solveur de collision universel.

## Branches (cible `main`)
- `main` : `43ac0b53f4c666bab6bd8b73aaf20df9d1a0a341` (conserver).
- `feat/foundation-movement-p1` (`adaf49b6c892fe670d29414eaa1e5d6fd87e3288`) : behind, ahead 0, behind 23. Histoire intégrée, candidate au nettoyage après vérification des liens.
- `feat/long-form-playtest-level` (`bae5aabd91ce83e0d17ef0556b21ee9d43332c11`) : behind, ahead 0, behind 10. Histoire intégrée, candidate au nettoyage après vérification des liens.
- `feat/web-playtest-preview` (`aa92ce67c1052e0dae8513c24b8adfc677f325fb`) : behind, ahead 0, behind 16. Histoire intégrée, candidate au nettoyage après vérification des liens.
- `fix/swept-ground-contact` (`e5de2a94201eb40ad8312d464713a84092a4e26c`) : behind, ahead 0, behind 4. Histoire intégrée, candidate au nettoyage après vérification des liens.
- `gh-pages` (`950589f6673fc8ed4cc657f6c5c331f21aa7d144`) : sans ancêtre commun. **Conserver obligatoirement** : branche de publication web à historique séparé, ne surtout pas tenter de la fusionner avec main.

## PR
- [#9](https://github.com/goldaj/glitch_runner/pull/9) : fusionnée ; `fix/swept-ground-contact` → `main`.
- [#7](https://github.com/goldaj/glitch_runner/pull/7) : fermée sans merge ; `feat/long-form-playtest-level` → `feat/web-playtest-preview`.
- [#6](https://github.com/goldaj/glitch_runner/pull/6) : fermée sans merge ; `feat/web-playtest-preview` → `feat/foundation-movement-p1`.
- [#1](https://github.com/goldaj/glitch_runner/pull/1) : fermée sans merge ; `feat/foundation-movement-p1` → `main`.

## Challenger les correctifs
- Reproduire le bug de **chute à travers les textures** en saut avec mouvement, surtout jonctions de pentes/tuiles et hautes vitesses. Vérifier collisions continues, contact sol et comportement de saut, pas uniquement rendu graphique.
- Contrôler accélération en descente / ralentissement en montée, conservation de vitesse, caméra, gravité et chronos au pas fixe.
- Le parcours a été allongé pour de longs tests : vérifier variété, difficulté pour novice, zones qui ne sont pas jouables et continuité des collisions, puis mesurer par playtests humains.
- Vérifier Godot HTML5, contrôles manette/clavier, assets et `gh-pages` ; le build web n'établit pas la qualité de l'expérience Windows.

## Reprise
Lire README (« # Glitch Runner »), AGENTS.md, docs/INCUBATOR_CONCEPT.md, docs/CODEX_HANDOFF.md, docs/RESEARCH.md et historique. Tester GDScript/headless puis jouer une version Windows et web ; vérifier CI et artefacts. PR #9 a absorbé les anciennes PR empilées #1/#6/#7. Aucun test ni déploiement effectué dans cette passe, aucun code ni branche supprimé, document uniquement.
