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
