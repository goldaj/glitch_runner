# Recherche P0 : design et faisabilité

**27 octobre 2026. Travail documentaire et architecture proposée ; aucun essai utilisateur.**

## Thèse à démontrer
La victoire n'est pas seulement franchir un mur plus vite. C'est *sentir* une vitesse acquise qui aurait dû être stoppée, réussir un geste répété et réinvestir toute cette inertie dans une séquence spectaculaire. Si l'après-glitch est décevant, le jeu échoue même si les astuces font baisser le chrono.

## Comparaison et décision d'outil
| Approche | Bénéfice | Limite | Sort |
| --- | --- | --- | --- |
| Godot 4.7.2 stable + GDScript | Open source, 2D, CI headless, petites itérations | Game feel à construire | **P1** |
| CharacterBody2D / move_and_slide | Collisions pentes/sol intégrées | La fonction peut modifier velocity sur collision | Benchmark ultérieur |
| Sol 1D composé de segments linéaires + modèle indépendant | Très simple, vitesse/pente/saut testables | **Pas de murs, coins, plafonds ni vraies collisions 2D** | **Seulement P1/H1** |
| GameMaker | Mature en 2D | Coûts/outils/portage à étudier | Alternative |

La version 4.7.2 est la dernière stable visible dans l'archive officielle consultée le 27/10/2026 ; 4.8 est beta. Godot recommande pas de physique fixe distinct du rendu ; cela **n'établit pas** un déterminisme inter-platforme.

Sources documentaires à revérifier :
- https://godotengine.org/download/archive/
- https://docs.godotengine.org/en/stable/classes/class_characterbody2d.html
- https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html
- https://www.gamedeveloper.com/design/how-speedy-implementation-high-paced-platformer-pizza-tower

## Hypothèses falsifiables
**H1, indispensable avant G1 :** avec deux profils A « réactif » et B « inertiel », comparer sur **le même terrain** : envie spontanée de réessayer, contrôle perçu, erreurs de saut, temps d'apprentissage, lisibilité du prochain obstacle. Rejeter B si la plupart le trouvent seulement plus pénible ; n'inférer aucun plaisir du compilateur.

**H2, apprentissage :** G1 devient fiable après exploration et indices. Mesurer succès consécutifs, essais avant compréhension, explication causale. Rejeter si succès aléatoires ou réussite par spam.

**H3, après-glitch :** A = raccourci à l'arrêt ; B = même franchissement maintenant l'élan puis rampe et envol. Mesurer préférence et nombre de relances volontaires. Rejeter la thèse centrale si B n'est pas perçu comme plus gratifiant.

**H4, combinaison :** G1→G2 augmente les routes sans complexifier les boutons. Rejeter si timing opaque ou collisions incontrôlables.

**H5, stabilité technique :** mêmes entrées par tick, état initial et version du moteur reproduisent une trajectoire dans un environnement contrôlé. Vérifier rendu à 30/60/144Hz, puis architectures/versions **dans un test distinct**. Pas de promesse de replay universel sans preuve.

## Architecture prudente
- P1 : classe de modèle de déplacement sans rendu ; profil du terrain par segments ; scène visuelle ; tests headless.
- Physique à 60 ticks/s, composantes distinctes `ground_speed` et `air_velocity`. Accélération, freinage, friction, pente, jump buffer/coyote time **plus tard** s'ils sont utiles et mesurables.
- Sol sous pieds échantillonné par interpolation : **banc d'étude**, pas collision générale. La transition future G1 exigera de vrais obstacles et un test anti-tunneling.
- Pentes / vitesse : constantes documentées comme premières hypothèses et non copies de Sonic.
- Replays futurs : inputs + configuration + version + checksums ; ghost d'affichage n'est pas preuve anti-triche.

## Risques majeurs
Ressenti sans valeur malgré code correct ; caméra cachant les obstacles à forte vitesse ; glitch dépourvu de vitesse récompense ; collision de sortie invalide ; multiplication coûteuse des niveaux ; records non comparables entre révisions.

## Verdict
**Faisable comme projet 2D léger** ; la vraie incertitude est la qualité du game feel et la reproductibilité. Priorité à H1, puis H3, avant toute mécanique supplémentaire.
