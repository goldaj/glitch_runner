# AGENTS.md — Glitch Runner

Lire dans cet ordre : `README.md`, `docs/INCUBATOR_CONCEPT.md`, `docs/RESEARCH.md`, `docs/ROADMAP.md`, `docs/CODEX_HANDOFF.md`, puis `docs/CHATGPT_PROJECT_HISTORY.md`.

## Instructions produit
1. Le mouvement normal agréable **précède** les glitches. Pas de G1/G2 tant que l'hypothèse H1 n'a pas été éprouvée par un test de jeu humain.
2. Glitch = geste précis sur collision / pente qui préserve l'élan et ouvre vitesse ou hauteur inaccessible ; **pas** de bouton « glitch », téléport ni raccourci à l'arrêt.
3. Commandes simples, niveaux courts, joueur novice peut finir sans exploits, vitesse qui se construit. Caméra doit anticiper les obstacles.
4. Éviter copies de niveaux, assets et paramètres d'œuvres existantes.
5. Godot 4.7.2 stable + GDScript (choix provisoire P1). Le sol P1 est une **hauteur interpolée, pas** un solveur complet pour murs/coins ; ne pas généraliser avant étude des collisions.
6. Physique à pas fixe, chronos par ticks. Aucune garantie automatique de déterminisme multi-OS, multi-version ou anti-triche.

## Instructions chercheur/ingénieur (conventions permanentes)
- Avancer par **baby steps** avec objectif, hypothèse falsifiable, travail réellement fait, vérifications et blocages documentés ; prévenir à chaque sous-étape et poursuivre sans attendre d'approbation tant qu'il existe du travail pertinent.
- Travailler sur **branche dédiée et PR**, ne pas écraser ni fusionner `main`, `develop`, les branches Codex ou d'autres travaux en cours.
- Maintenir à jour `docs/CODEX_HANDOFF.md` et `docs/CHATGPT_PROJECT_HISTORY.md` lors de chaque intervention ; enregistrer décisions et limites vérifiées, commandes de test et résultats. Inclure les échanges visibles (rôles et dates) ; **ne jamais inventer d'anciens messages**.
- Distinguer « écrit », « compilé », « tests exécutés » et « validé par jeu humain ». CI headless ≠ playtest.
- Reporter toute régression, même si elle compromet la livraison. Aucune fonctionnalité art final, serveur, leaderboard, réseau ou IA en avance de phase.
- Vérifier la licence et les fichiers non générés avant PR.
