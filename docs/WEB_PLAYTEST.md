# Jouer à Glitch Runner sans installer Godot (version Web)

## Lien de jeu

Une fois la publication GitHub Pages activée sur ce dépôt :
**https://goldaj.github.io/glitch_runner/**

Si le lien affiche 404, cela ne signifie pas que l'export Godot a échoué. Il faut activer une fois GitHub Pages :
1. Ouvrir le dépôt GitHub → **Settings** → **Pages**.
2. Dans **Build and deployment**, sélectionner **Deploy from a branch**, puis **gh-pages** et **/(root)** ; enregistrer.
3. Après publication de GitHub Pages, ouvrir le lien ci-dessus. Aucune installation de Godot, aucun compte et aucun téléchargement requis pour jouer.

Le workflow [Export and publish web playtest](../.github/workflows/web-preview.yml) compile le **vrai jeu Godot** depuis la branche `feat/web-playtest-preview`, publie les fichiers `index.html`, `index.js`, `index.wasm`, `index.pck` sur la branche **gh-pages** du même dépôt, et produit également un ZIP téléchargeable dans les artifacts de la CI.

## Contrôles dans le navigateur
| Touche | Action |
| --- | --- |
| ← / → | Courir, accélérer et freiner |
| Espace ou Entrée | Saut, maintien = plus haut |
| 1 | Profil A réactif |
| 2 | Profil B inertiel |
| R | Recommencer, chrono remis à zéro |

Cliquer sur le jeu si les touches n'agissent pas. Le jeu fonctionne essentiellement sur **PC au clavier**, la version tactile est hors périmètre à ce stade.

### Ce qui est réellement testable
- **P1, mouvements normaux uniquement**. C'est un laboratoire de déplacement avec terrain à pentes, chrono et caméra ; aucun glitch G1/G2 pour le moment.
- Objectif de test H1 : essayer A et B, relever sensation d'accélération, contrôle, freinage, saut, caméra. Guide : [PLAYTEST_H1.md](PLAYTEST_H1.md).
- Les constantes ne sont pas finalisées. Ne pas conclure que la physique est « bonne » sur la seule base d'une CI verte.

## Télécharger plutôt que jouer en ligne
Aller dans **Actions → Export and publish web playtest → dernier run vert → Artifacts → glitch-runner-web-playtest**.

**Important :** comme tout export Godot Web, les fichiers HTML/WASM/PCK doivent être servis par un serveur HTTP ; un double clic sur `index.html` extrait du ZIP (`file://`) ne fonctionne généralement pas. Depuis le dossier décompressé :
```bash
python -m http.server 8000
```
Puis ouvrir `http://localhost:8000/`. Ce mode ne demande ni Godot ni compilation, mais Python doit être présent. **Pour le vrai un-clic, utiliser GitHub Pages.**

## Fabrication automatique et reproduction
- Source : `export_presets.cfg`, Godot **4.7.2 stable**, export « Web » **sans threads**, requis pour un hébergement simple sur GitHub Pages sans en-têtes COOP/COEP.
- Export CI depuis le source exact testé, jamais une version HTML écrite à la main.
- Runtime Web : navigateur avec WebAssembly et WebGL 2.0.
- Une modification sur la branche de préparation déclenche le build + nouvelle publication sur `gh-pages`. Les autres branches ne publient pas implicitement ; Codex ne doit pas écraser le build.
- L'upload d'artifact est limité dans le temps ; la branche `gh-pages` conserve les fichiers publiés.

## Limites et pièges techniques
- GitHub Pages ne s'active pas automatiquement avec `GITHUB_TOKEN`; l'étape **Settings → Pages** est une action du propriétaire du dépôt. Le workflow peut réussir et peupler la branche `gh-pages` avant que l'URL du jeu soit accessible.
- Version Web single-thread : pas d'exigence `SharedArrayBuffer` ni en-têtes cross-origin isolation.
- Aucune validation visuelle dans un navigateur ou sur mobile n'est implicite dans l'export Godot réussi. Signaler séparément export, publication, chargement HTTP et plaisir de jeu.
- Pas de possibilité de jouer hors ligne par simple double clic sur un unique `.html` Godot exporté : le runtime dépend de ses ressources liées.

## Contrôle navigateur en CI

La chaîne d'export inclut désormais un contrôle **Chromium + Playwright** : serveur HTTP local, téléchargement de `index.wasm` et `index.pck`, démarrage réel du moteur, présence d'un canvas visible, émulation des touches de déplacement et capture d'écran dans les artifacts GitHub Actions. Cette vérification est plus forte qu'un simple export réussi, mais **ne remplace pas un test humain visuel et tactile H1**.

## Résultats techniques observés le 27 octobre 2026

- **Export réel : VALIDÉ** via [run 40461694868](https://github.com/goldaj/glitch_runner/actions/runs/40461694868).
- **17 invariants Godot : PASS** (ligne de log), **navigateur Chromium : PASS** (`PASS web_smoke` dans les logs).
- **Files `index.html`, `index.js`, `index.wasm`, `index.pck` : présents et non vides** sur [`gh-pages`](https://github.com/goldaj/glitch_runner/tree/gh-pages).
- **Capture d'écran d'exécution** : [artifact du run](https://github.com/goldaj/glitch_runner/actions/runs/40461694868/artifacts/12714877353).
- **Build ZIP** : [artifact du run](https://github.com/goldaj/glitch_runner/actions/runs/40461694868/artifacts/12714967049).
- **Accès public par URL** : non confirmé ; dépend de Settings → Pages. **Test humain d'agrément H1** : non fait.

## Retour du premier playtest et version corrigée P1.6
Le test humain du 27 octobre a révélé un défaut de ressenti : les pentes ne semblent pas changer la vitesse. Le moteur limitait la vitesse après application de la gravité, effaçant les accélérations en descente. La correction P1.6 laisse désormais la pente dépasser le plafond de course normal et fait ralentir la montée même lorsque la direction est maintenue. Le HUD affiche la **vitesse horizontale `vx`** et le type de terrain. Réessayer la descente en profil **B inertiel**, puis le même trajet sur du plat et en montée. Les tests automatiques ne remplacent pas la confirmation humaine.

## Vérification P1.6 (correction pentes) — 27 octobre 2026
Le premier jeu Web a été ouvert avec succès par le propriétaire ; GitHub Pages est activé. Suite au retour de ressenti :
- L'accélération au sol n'efface plus l'apport des pentes à 420 px/s ; l'élan supplémentaire se dissipe progressivement.
- Les sauts et réceptions conservent aussi l'élan gagné, au lieu de plafonner la composante horizontale en vol.
- HUD : `vx`, `vmax` horizontale, témoin « (+ élan) » et indication plat/descente/montée dans le sens du déplacement.
- [29 tests du mouvement validés](https://github.com/goldaj/glitch_runner/actions/runs/40463364151) et [export + Chrome + branche gh-pages validés](https://github.com/goldaj/glitch_runner/actions/runs/40463364187).
- **H1 toujours non validée** : revenir sur l'URL publique après déploiement, comparer A/B et noter sensations et erreurs dans [issue #2](https://github.com/goldaj/glitch_runner/issues/2).

## Prototype dix zones (31 000 px)
La version longue comporte 30 plateformes à sens unique, 7 fossés, 4 ressorts, 190 éclats et des marqueurs de zones. Elle est exportée depuis la branche `feat/long-form-playtest-level`. Les nouveaux contrôles sont **R** pour reprendre à la zone actuelle et **Maj+R** pour repartir au début. **1/2** sélectionne A/B en repartant de zéro. Le chapitre courant et les éclats sont affichés dans le HUD. Détails : [niveau long](LEVEL_DESIGN_P1_LONG.md). Aucun ennemi et aucun glitch. Vérifier le build courant et éventuellement actualiser par Ctrl+F5 après un déploiement Pages.

## Correction des chutes à travers le sol solide, issue #8
Le 27 octobre, un essai humain a signalé des passages sous le terrain en sautant tout en avançant, à des endroits sans fossés dessinés. Il s'agissait d'une collision de type **tunneling diagonal** entre deux ticks. Nouveau balayage continu de la trajectoire contre les segments solides, en respectant les **7 vrais fossés**, avec tests de régression à haute vitesse dans les deux directions. Les collisions des plateformes aériennes restent unidirectionnelles.
- Branche correctrice : `fix/swept-ground-contact`.
- [Historique CI initial](https://github.com/goldaj/glitch_runner/actions/runs/40548857720) (avant l'ajout du contrôle obligatoire au Web).
- Le Web ne publie cette branche qu'après succès du nouveau contrôle dédié. Une CI verte vérifie le modèle et le chargement Chromium, mais **les sensations et l'absence de toute autre régression restent à éprouver réellement en jeu**.
