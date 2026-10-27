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
