# P1.L — Dix horizons : niveau de test long et original

**Statut : prototype fonctionnel en GitHub Actions ; ressenti de jeu non validé.** Le nouveau terrain mesure exactement **31 000 px** (ancien : 3 100 px). Dix secteurs de 3 100 px, originaux dans leur géométrie et leurs éléments. Aucun ennemi ni glitch. Ce n'est pas un décalque de *Super Mario Bros. 3*, seulement une utilisation de ses principes d'introduction progressive, rythme, chemins hauts et récompenses. Analyse de design consultée : https://www.gamedeveloper.com/design/super-mario-bros-3-level-design-lessons-part-1 .

| Zone | Nom | Objectif de sensation |
| --- | --- | --- |
| 1 | Clairière | Prendre en main l'accélération et le saut sans danger |
| 2 | Collines vivantes | Préserver l'élan dans les pentes, découvrir un ressort |
| 3 | Terrasses suspendues | Découvrir des plateformes et un premier fossé |
| 4 | Grande dévalée | Contraster grande descente et montée, saut sans glitch |
| 5 | Ponts du vent | Choisir entre route rapide au sol et récompense en hauteur |
| 6 | Hauts plateaux | Tester montée, sommet, freinage et caméra dans la descente |
| 7 | Vallée des sauts | Anticiper les fossés après relief prononcé |
| 8 | Jardins mécaniques | Expérimenter les enchaînements sur plateformes |
| 9 | Longues crêtes | Construire un élan exceptionnel par le terrain |
| 10 | Dernier élan | Varier les trajectoires puis rallier l'arrivée |

## Éléments réellement jouables
- **75 sommets de terrain** et affichage des pentes ; la physique des pentes est celle du P1.6 corrigé.
- **7 trous sans sol** à sauter, suivis d'une chute puis d'une réapparition au checkpoint si échec.
- **30 plateformes unidirectionnelles** ; on peut y atterrir, sauter depuis elles ou passer au-dessous. Elles ne bloquent pas les côtés.
- **4 ressorts automatiques** qui préservent le mouvement horizontal, sans exiger de maintenir le bouton saut.
- **190 éclats facultatifs** placés en arcs, récupérables sans effet sur la physique et sans condition de victoire.
- **9 points de reprise**, drapeaux de zone : R pour la zone atteinte ; Maj+R pour recommencer complètement.
- Un HUD de progression en 10 zones, vitesse horizontale, secteur, collectibles, chronomètre de tentative et nombre de reprises.
- Identités colorées par zone, montagnes, nuages et formes originales ; aucune ressource externe ou copiée.

## Limites d'architecture
P1 demeure un échantillonneur de sol 1D à segments, avec fossés, plus surfaces aériennes à collision de dessus uniquement. Ce n'est pas un système de vraies collisions 2D (pas de murs, plafonds, destructions ni blocs solides) ; G1 Corner Slip exige encore les recherches P2. Les décors ne changent pas la physique. Les écarts entre petits secteurs restent à calibrer.

## Playtest utile
Tester au moins plusieurs secteurs avant de juger le profil B ; comparer ensuite quelques sections en profil A grâce aux reprises. Noter séparément : variation réelle de vitesse par pente, visibilité des fossés à pleine allure, retombée sur les plateformes, désir spontané de refaire une section, utilité des ressorts, ressenti de la longueur. Le contrôle de tous les fossés et plateformes en situation humaine n'a pas été effectué. L'issue [#2](https://github.com/goldaj/glitch_runner/issues/2) reste la porte de décision H1.

## Validations
- [Run CI Godot](https://github.com/goldaj/glitch_runner/actions/runs/40546294374) : **29 invariants de mouvement et 462 invariants de structure et interactions**.
- [Export Web](https://github.com/goldaj/glitch_runner/actions/runs/40546293820) : **succès**, navigateur Chromium + branche gh-pages.
- Validation finale via navigateur du joueur et appréciation du gameplay : **non réalisée**.

**Règle de design :** si le parcours étendu n'est ni agréable ni lisible, réviser sa grammaire physique/visuelle avant tout développement de glitch, même si les tests passent.
