# Protocole H1 — comparaison A/B du mouvement normal

**Prêt à réaliser ; aucune session humaine exécutée au 27/10/2026.** But : découvrir si l'inertie B apporte un plaisir supérieur à une configuration plus réactive A.

## Préparation
- Godot 4.7.2 stable : ouvrir et lancer le projet depuis le dossier téléchargé/cloné.
- Le prototype propose **1 = A réactif** (accélération et freinage plus forts, frottement plus élevé, pente moins influente), **2 = B inertiel** (construit et conserve davantage sa vitesse), **R = reset**.
- **Même terrain, mêmes touches, mêmes conditions de caméra.** Le temps, vitesse maximale et sauts sont affichés ; aucune donnée de jeu n'est envoyée en ligne.
- Faire au moins deux passages par profil et inverser l'ordre entre joueurs pour limiter les biais (A→B pour certains, B→A pour d'autres).

## Questions et mesures
1. Chaque personne réussit-elle à atteindre la fin des deux profils ? Nombre d'essais, temps et erreurs de saut.
2. Le joueur anticipe-t-il le freinage et l'angle des pentes, ou trouve-t-il les déplacements imprévisibles ?
3. Note subjective (1 à 5) pour plaisir de vitesse, contrôle et désir de recommencer.
4. Le joueur choisit-il spontanément de refaire une course dans A ou B ?
5. La caméra révèle-t-elle suffisamment tôt la rampe suivante et l'arrivée ?
6. Quel geste/surface est perçu comme injuste ? Note des moments où l'élan paraît gratifiant.

## Fiche de relevé
| Participant (pseudonyme) | Ordre AB/BA | Profil | Essais | Temps s | Note vitesse /5 | Note contrôle /5 | Encore une fois ? | Observations |
| --- | --- | --- | ---: | ---: | ---: | ---: | --- | --- |
| À remplir | | | | | | | | |

## Critère de décision
- **GO vers sophistication P1** : B est compris et régulièrement préféré sans taux d'échec rédhibitoire. Ajuster si problèmes contrôlables.
- **REWORK P1** : B est perçu comme lourd ou illisible ; tester friction/accélération et caméra plutôt que déclencher G1.
- **STOP du principe physique actuel** : A/B n'apporte aucun plaisir répété et les corrections raisonnables échouent.

Panel exploratoire cible de 8–12 personnes ; les chiffres ne sont *pas* des résultats. Aucune valeur de p-value ou promesse de significativité avec un tel échantillon.

## Limites
Il s'agit de deux réglages provisoires, **pas d'une preuve d'identité Sonic**. Cette étude évalue H1 (mouvement normal), *pas encore* le plaisir du glitch ni la stabilité cross-OS. Conserver traces brutes et rendre compte des échecs.

## Protocole long : P1.L
La carte mesure désormais dix fois la longueur initiale. Parcourir au moins plusieurs sections B avant de juger, puis comparer leurs mouvements en A. Consigner le rythme, la satisfaction de vitesse dans les descentes, les erreurs de saut de fossés, la lisibilité de la caméra, le plaisir des chemins hauts et la facilité de reprise. `R` reprend au début du secteur ; `Maj+R` réinitialise tout. Aucune évaluation H1 positive n'est déduite des tests automatiques.
