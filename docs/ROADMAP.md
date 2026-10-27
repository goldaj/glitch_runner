# Roadmap détaillée et statut

**P0 — Préproduction documentaire**
- [x] P0.1 Audit du dépôt initial : README minimal + licence MIT.
- [x] P0.2 Transfert intégral de la fiche incubateur.
- [x] P0.3 Comparaison moteurs et risques de collision/replays.
- [x] P0.4 H1–H5 et protocoles de rejet ; AGENTS, historique et handoff.

**P1 — Laboratoire de mouvement normal (sans glitch)**
- [x] P1.1 Fichiers de projet Godot, scène placeholder et Gitignore **écrits**.
- [x] P1.2 Contrôleur vitesse au sol, friction, freinage, pentes, saut variable **écrit**.
- [x] P1.3 Terrain dessiné, joueur, caméra anticipée, HUD, chrono local et reset **écrits**.
- [x] P1.4 Tests unitaires headless, workflow GitHub Actions **écrits**.
- [x] P1.5a Import + tests Godot 4.7.2 observés **verts** dans GitHub Actions (run 40457925457).
- [x] P1.5b Deux profils A/B sélectionnables + protocole de recueil **écrits** ; CI du changement vert (runs 40458297529 et 40458303074).
- [x] P1.5d Test de sortie atteignable sans glitch et smoke test de scène **ajoutés**, CI **vérifiée verte** sur 6f27e1b (runs 40458594556 et 40458599650, 17 invariants passés, scène lancée 180 frames).
- [ ] P1.5c Comparatif A/B **humain** clavier/manette, synthèse observations et décision H1. Ne pas déclarer H1 validée sur un simple test CI.

**P2 — G1, Corner Slip (bloqué par H1)**
- [ ] P2.0 Séparer vitesse normale et **surplus post-glitch conservé** : plafonds/decay/air-sol et tests, cf. issue #5 (bloqué par H1).
- [ ] P2.1 Choisir véritable système de collisions murs/coins et éviter tunneling.
- [ ] P2.2 Écrire tests limites, sécurité des sorties, préconditions observables.
- [ ] P2.3 Premier glitch déterminé par le geste, sans bouton magique.
- [ ] P2.4 Test H2 : apprentissage et réussite trois fois de suite.

**P3 — La vitesse après le glitch**
- [ ] P3.1 Même obstacle, route normale vs raccourci.
- [ ] P3.2 Tronçon de vitesse/rampe/vol après faille.
- [ ] P3.3 Test comparatif H3 ; supprimer/refondre si expérience peu gratifiante.

**P4 — G2 + combinaison**
- [ ] P4.1 Comparer pente systémique vs discontinuité volontaire.
- [ ] P4.2 Enchaîner G1→G2 sans autre commande.
- [ ] P4.3 Test H4, lisibilité et niveau expert.

**P5 — Chrono / replay**
- [ ] P5.1 Chrono par tick, records locaux versionnés.
- [ ] P5.2 Ghost visuel, inputs enregistrés, régressions.
- [ ] P5.3 H5 cross-FPS et inter-machines, gestion de versions.

**P6 — Vertical slice / décision**
- [ ] P6.1 Quatre espaces distincts : mouvement, G1, G2, combinaison.
- [ ] P6.2 Feedback léger, tutoriel non spoilant, accessibilité et essais courts.
- [ ] P6.3 Playtests novices/experts ; go/no-go avant campagne.

**Clôture d'une sous-étape** : fichier/commit + test réellement exécuté ou limitation explicite + observation documentée + tâche suivante confiable.
 
**P1.W — Diffusion Web pour recueillir le playtest H1 (branche isolée `feat/web-playtest-preview`)**
- [x] P1.W1 Ajouter le préréglage Web Godot 4.7.2, **sans threads** pour GitHub Pages ; aucun changement de physique.
- [x] P1.W2 Ajouter workflow export HTML/WASM/PCK + ZIP + publication dans `gh-pages` (source écrite, **à valider en run**).
- [x] P1.W3 Documenter lancement un-clic, limites et activation Settings → Pages.
- [x] P1.W4a Export/ZIP/gh-pages validés en CI sur eecfd61 (run 40461342279 : 17 invariants, fichiers Web et branche gh-pages observés).
- [x] P1.W4b Browser smoke réel **observé vert** (run 40461694868, Chromium affiche canvas, clavier répond, pas d'erreur JS).
- [x] P1.W4c Présence des fichiers sur gh-pages et ZIP/capture en artifacts vérifiée.
- [ ] P1.W4d Accès HTTPS public : activation GitHub Pages dans Settings par le propriétaire du dépôt, puis test du lien.
- [ ] P1.W5 Réaliser H1 humain avec la page de test ; même blocage avant G1.

## P1.6 — Correction du ressenti des pentes (retour utilisateur 2026-10-27)
- [x] Diagnostic du code actuel : vitesse plafonnée à chaque tick à 420 px/s, malgré la force de pente ; accélération du joueur écrase la montée.
- [x] Séparer plafond d'accélération par input et vitesse de terrain, conserver le surplus et l'amortir progressivement ; effets de pente dans les deux sens.
- [x] HUD modifié pour afficher **vx horizontal**, pente relative au sens de parcours et surplus, plutôt que la norme de vitesse aérienne qui masquait l'effet.
- [x] Ajouter tests de la descente, montée, plat, surplus, sens inverse ; **code écrit, CI à vérifier**.
- [ ] Contrôler run Godot headless, Playwright export Web et version publiée gh-pages.
- [ ] Faire valider le nouveau ressenti par jeu humain, comparer profils A/B ; H1 non validée.
- [x] P1.6b Préservation du surplus aussi **au saut et à la réception** (sinon ancien plafonnement air à 550 px/s détruit l'élan d'une descente), tests ajoutés ; CI à confirmer.
