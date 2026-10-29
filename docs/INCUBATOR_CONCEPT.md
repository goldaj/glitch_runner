> **Archive historique inchangée du concept transféré** depuis `projects-incubator/jeux/speedrun-glitch-platformer.md` le 27 octobre 2026. Les mentions « non démarré » ci-dessous sont **désormais obsolètes** ; voir README/handoff pour l'état courant.

# Glitch Runner — plateforme 2D, vitesse et maîtrise des anomalies

> **Statut : idée retenue, non démarrée.** Cadrage et recherche documentaire seulement, au 2026-10-26. **Aucun code, prototype, playtest, mesure ou dépôt autonome lancé.** Lors d'un vrai démarrage, transférer cette étude dans son dépôt dédié puis retirer la fiche et son lien de l'incubateur.

## 1. Pitch et intention

Un **plateformer 2D volontairement simple en apparence**, où la maîtrise du déplacement et des « glitchs » intentionnels permet d'atteindre des vitesses et des trajectoires **impossibles par le parcours ordinaire**.

**Fantaisie fondamentale :** *« J'ai compris une faille du monde ; je l'ai exécutée proprement ; mon personnage vient de traverser l'obstacle qui me stoppait et je conserve assez d'élan pour m'envoler sur la suite du niveau. »*

La récompense première n'est **ni la médaille ni le raccourci**, mais le moment où un geste technique transforme une trajectoire empêchée en un mouvement spectaculaire, rapide et continu. Le record, les fantômes et les médailles prolongent cette émotion, ils ne la remplacent pas.

**Inspiration, pas copie :**
- **Super Mario Bros. 3** : sophistication obtenue avec peu de boutons, des objets lisibles et des niveaux compacts ; **ne pas** reprendre son contenu, ses personnages, ses niveaux ou sa physique.
- **Sonic 2D classique** : vitesse construite, inertie, pentes, arbitrage freinage/contrôle, sensation d'une vitesse *méritée* ; **ne pas** recopier ses constantes, décors ni gimmicks.
- **Celeste et les jeux de speedrun à techniques avancées** : découverte de gestes émergents, réessais courts, satisfaction de réussir un mouvement auparavant impensable.
- **Pizza Tower** : enchaînement fluide des états de déplacement et routes conçues pour le mouvement rapide, avec un avertissement : la liberté accrue fait exploser le coût du level design.

Le concept **ne vise pas** un puzzle game de téléportation, un simulateur de bugs visuels ni un clone de Sonic.

## 2. Piliers de design (non négociables)

1. **Un jeu agréable sans glitch** : courir, freiner, sauter, atterrir et parcourir la route normale doivent déjà procurer du plaisir. L'absence de glitch ne doit pas équivaloir à une punition.
2. **La vitesse se construit et se conserve** : accélération graduelle, faible perte lors des gestes réussis, inertie sensible, pentes qui aident ou freinent. La vitesse exceptionnelle s'obtient par l'habileté ; pas par un turbo automatique sans préparation.
3. **Le glitch est une prouesse physique, pas un menu de pouvoirs** : on utilise des commandes ordinaires, à un endroit précis et dans un état de mouvement précis. Le monde semble « céder » au bon moment.
4. **Lisible, répétable, apprenable** : des conditions reproductibles, des indices environnementaux, un feedback net et des fenêtres de timing d'abord humaines. Le joueur doit attribuer sa réussite à sa compréhension et à son geste, non à la chance.
5. **Le niveau est conçu pour l'après-glitch** : franchir la faille doit ouvrir une **portion de parcours où l'élan est exploité**, avec virages, tremplins, trajectoire aérienne et arrivée spectaculaire. Sans cette suite, le glitch n'est qu'un coupe-file.
6. **Petite complexité, grande profondeur** : peu de commandes, très peu de types de surfaces/interactions, 2 techniques maîtrisées avant d'en ajouter, profondeur provenant des combinaisons et du level design.
7. **Échec peu coûteux** : relance instantanée, chrono clair, répétition encouragée ; compétition facultative.

**Test de vérité :** si une vidéo muette de 10 à 15 secondes de jeu expert ne montre pas clairement une vitesse « interdite » conquise par une technique, le cœur du produit ne fonctionne pas encore.

## 3. Expérience type : trois couches de lecture d'un même niveau

| Joueur | Ce qu'il voit et fait | Récompense |
| --- | --- | --- |
| Découverte | Suit le chemin lisible, saute normalement, atteint la sortie | Finir le niveau sans nécessité de glitch |
| Curieux / entraîné | Observe une couture suspecte ou une rampe, réussit **une** anomalie et conserve l'élan | Nouvelle route, temps fortement amélioré, sensation d'avoir « cassé » le parcours |
| Expert | Enchaîne deux techniques, adapte son décollage et maintient l'inertie sans freinage inutile | Trajectoire extrême, record personnel, maîtrise visible en replay |

**Exemple de séquence signature (hypothèse de level design) :**
- Le joueur accélère sur une longue descente et arrive devant un mur qui le **stoppe normalement** ; le chemin commun impose une montée et des détours.
- Il repère une irrégularité discrète à l'angle inférieur du mur. À une vitesse suffisante, une séquence de touches connue fait « glisser » la collision sur une très courte épaisseur.
- **L'élan n'est pas remis à zéro** : le personnage jaillit derrière le mur, arrive déjà rapide dans une cuvette, accélère dans une deuxième pente et s'éjecte à un angle anormal.
- La caméra anticipe, les animations et le paysage suivent la vitesse ; le personnage survole une portion pourtant inaccessible par le trajet normal ; le chrono confirme le gain.
- Un expert conserve cet excès de vitesse jusqu'à la sortie, un joueur simplement compétent savoure quand même son premier franchissement.

**Anti-patterns à éviter** : traverser un mur pour atterrir à l'arrêt ; coupure automatique vers l'arrivée ; glitch caché sans indice ni cause déductible ; « juste appuyer sur Glitch » ; long tunnel qui force à attendre après le succès ; choc contre un obstacle invisible immédiatement après la percée.

## 4. Commandes et physique : simple comme un jeu de plateforme classique

**Proposition de commandes à tester** :
- Gauche / droite : accélérer, s'opposer à la vitesse acquise (freiner et inverser), ajuster le saut.
- Saut (hauteur modulée à la durée d'appui).
- Bas : se ramasser / glisser selon vitesse et surface, éventuellement aider à former des techniques.
- Reset rapide pour le mode chrono.

Aucun bouton « pouvoir de glitch » au départ. **Une mécanique doit se découvrir dans une combinaison significative de mouvement, de contexte et de timing**, sans demander une chorégraphie arbitraire de 8 touches.

**Modèle physique envisagé, à éprouver :**
- Une vitesse tangentielle au sol (**ground speed**) distincte de la vitesse vectorielle en l'air. Conversion contrôlée à l'impulsion de saut et à l'atterrissage.
- Accélération lisible et progressive, freinage volontaire plus fort que le frottement passif pour préserver le contrôle ; meilleure réactivité à faible vitesse qu'à vitesse extrême.
- Gravité, saut variable, inertie aérienne modérée ; réception sur pente capable de réorienter et parfois augmenter/diminuer le mouvement selon l'angle.
- Les descentes font gagner de la vitesse et les montées en coûtent ; la glissade peut réduire la friction, sans automatiser toute la conduite.
- **Vitesse normale visée** vs **vitesse exceptionnelle issue d'un glitch** : la limite de course n'est pas une limite absolue qui écrase la vitesse à chaque tick. Le surplus se dissipe graduellement selon le terrain et les actions.
- Préserver une **hauteur de saut utilisable à faible vitesse**, sans transformer tout le jeu en épreuve d'accélération préalable.
- Coyote time et jump buffer modestes pour la jouabilité normale ; ne pas confondre ces aides avec les glitches signature.
- Collisions robustes à grande vitesse (sweep/substeps, contrôle anti-tunneling), sauf fenêtres de traversée **explicitement autorisées** par une technique.
- Géométrie initiale simple : plancher, murs, quelques pentes et plateformes ; 360°, loopings complets, plateformes mobiles sophistiquées et ennemis nombreux **hors MVP**.

**Hypothèse de sensation à tester, non spécification figée :** une vitesse de pointe après enchaînement de glitchs de l'ordre de **1,5 à 2 fois** la pointe normale, pendant quelques secondes et sur une portion conçue pour elle ; sinon la différence risque de ne pas se sentir. Ajuster exclusivement au playtest.

**Caméra et lisibilité à grande vitesse** :
- Cadrage anticipé dans le sens du déplacement, passage progressif de caméra proche à plus large selon vitesse, visibilité **avant** le prochain obstacle.
- Petit amortissement de caméra, sans retard qui cache les dangers ; éviter le « personnage au bord droit de l'écran » à pleine vitesse.
- Animation, poussière et son gradués avec la vitesse ; indicateur de vitesse discret *optionnel* ; pas de secousses ou effets de glitch permanents qui nuisent à la lecture.
- Large fenêtre de réception derrière les premières techniques, afin que le succès ne soit pas immédiatement annulé par une mort imprévisible.

## 5. Catalogue candidat : les anomalies doivent s'enchaîner

### G1 — Corner Slip / « Couture fantôme » (**premier candidat MVP**)
**Fiction physique :** en longeant un angle ou une couture de collision à grande vitesse, un bref changement de posture permet de « s'insérer » dans la jonction et de ressortir de l'autre côté de **certains obstacles minces explicitement désignés**.

- **Entrée :** bonne orientation, vitesse minimum, proximité d'un bord marqué, bas + saut (exemple de combinaison, à tester) dans une fenêtre prévisible.
- **Effet :** franchir une très faible épaisseur de collision et conserver **une grande fraction** de la vitesse d'entrée, sous réserve d'un point de sortie sûr.
- **Sensations :** micro-arrêt visuel de collision / distorsion localisée, puis accélération ressentie derrière le mur ; **pas** de téléportation lointaine.
- **Contrainte :** impossible de traverser tous les murs ; matériaux/angles concernés identifiables, cooldown implicite par géométrie, refus sans mort ni softlock.
- **Échec :** rebond / glissade qui n'efface pas injustement 10 secondes d'élan ; ajustement de la fenêtre temporelle au besoin.
- **Secret expert :** entrer avec suffisamment d'énergie pour atteindre la rampe suivant le mur sans ralentir.

### G2 — Slope Overflow / « Débordement de pente » (**deuxième candidat MVP**)
**Fiction physique :** au bord d'une rupture de pente, le saut prend en compte la tangente précédente et un élan « non consommé », produisant une projection plus rapide / plus longue qu'un saut normal.

- **Entrée :** vitesse au sol significative, crête ou jonction de pente dédiée, saut à l'approche du raccord ; fenêtre d'entrée observable.
- **Effet :** transfert particulier de vitesse tangentielle en vitesse aérienne, **bonus temporaire limité et mesurable** en sortie d'angle ; conservation du surplus à l'atterrissage si la trajectoire le permet.
- **Sensations :** décollage anormal mais cohérent, longue parabole, possibilité de franchir un gouffre théoriquement impossible.
- **Contrainte :** pas de cumul infini ni de traversée accidentelle de plafonds ; collisions et caméra doivent suivre.
- **Combinaison signature :** G1 donne accès à une pente à pleine vitesse ; G2 transforme cet élan en saut géant. Chaque geste doit aussi être utile individuellement.

### Réserve de techniques (à **ne pas** implémenter tant que G1 + G2 ne fonctionnent pas)
- **Momentum escrow / stockage d'élan** : bref verrouillage puis restitution d'une vitesse lors d'une interaction précise ; intéressant mais risque de rendre la physique arbitraire.
- **Platform carry** : conserver, dans certaines conditions, la vélocité d'une plateforme mobile après l'avoir quittée ; demande une complexité de collision supérieure.
- **Hitbox fold** : réduction momentanée de collision lors d'une transition saut/glissade ; pourrait devenir redondant avec G1.
- **Gravity reset** : réinitialisation conditionnelle de la composante verticale ; très puissant mais potentiellement destructeur pour les niveaux.
- **Autres techniques découvertes pendant le développement** : encourager l'émergence, **mais documenter les conditions et stabiliser ce qui devient légitime**. Aucun exploit accidentel n'est garanti admissible en compétition.

**Décision produit ouverte :** G2 doit-il être un « vrai glitch », avec discontinuité physique perceptible, ou une interaction extrême mais systémique entre la pente et le saut ? Le comparatif de ressenti devra décider. La quantité totale de techniques est **volontairement non fixée**.

## 6. Concevoir des niveaux pour l'élan

**Grammaire de salle indicative :** mise en vitesse → premier obstacle qui bloque normalement → anomalie accessible mais non imposée → *runway de récompense* (10 à 20 secondes de mouvement permis par l'exploit, ordre de grandeur à tester) → nouveau défi éventuel → sortie.

**Trois types de séquences** :
1. **Lecture** : découverte des commandes, pentes et de l'existence d'une route non évidente.
2. **Apprentissage** : couture « presque » évidente, approche répétable, espace sûr après franchissement et fantôme de démonstration activable **après** plusieurs essais.
3. **Expression** : plusieurs approches et angles possibles, combinatoire G1/G2, compromis risque / route / conservation de vitesse.

**Niveaux courts** : ordre de grandeur initial **30 à 90 s** au premier passage, plus rapides une fois maîtrisés ; introduction des mécaniques sur des salles/séquences encore plus brèves. Pas de monde ouvert, boss complexe ni narration obligatoire au départ.

**MVP révisé** : 1 espace d'essai des commandes/pentes, 1 salle G1, 1 salle G2 et 1 petit niveau combinant les deux, avec **une route normale complète** et au moins **une route accélérée** chacun là où c'est pertinent. Ne pas promettre trois routes significatives *par salle* dès le prototype. Conserver les anciens objectifs de chrono / replay / fantôme local, sous conditions techniques ci-dessous.

**Après le MVP si validé** : mini-campagne compacte, par exemple 3 ensembles de 6 à 8 niveaux, et une poignée de défis experts optionnels. Ce nombre n'est pas une estimation de contenu déjà produit et ne doit pas entraîner prématurément un moteur de niveau « usine à gaz ».

**Progression / fair-play** :
- Finir l'histoire ne demande pas de maîtriser tous les glitches.
- Découverte graduelle, « aha moment » protégé : indices visuels et démonstration contextuelle facultative plutôt que tutoriel qui révèle tout.
- Ghost du meilleur temps personnel, médaille et comparaison avec son propre précédent passage ; classements mondiaux **non prioritaires**.
- Essais et entraînement avec respawn immédiatement disponible ; pour les records officiels, définir clairement départ/arrivée/checkpoints, pas de saut d'étapes ou de manipulation du chrono.
- La rejouabilité provient des **routes, de la fluidité et de l'amélioration mesurable** plus que des objets à collectionner.

## 7. Faisabilité technique : possible, mais la sensation doit être prouvée

| Sous-système | Faisabilité préliminaire | Difficulté / risque |
| --- | --- | --- |
| Déplacement 2D basique, saut, chrono, reset | Élevée | Faible à moyenne |
| Sensation Sonic-like **sans reproduction** de ses règles | Élevée en principe, à calibrer | **Élevée pour le game feel** |
| Collision G1 contrôlée et sûre | Élevée si géométries prévues | Moyenne |
| Conversion de vitesse G2 / pentes / fortes vitesses | Élevée en principe | Moyenne à élevée |
| Caméra et lisibilité aux vitesses extrêmes | Élevée | Moyenne à élevée |
| Replays identiques sur toute machine / toute version | **Non garantie nativement** | Élevée |
| Contenu varié équilibrant route normale et expert | Faisable | **Élevée en temps de level design** |
| Classement en ligne fiable et anti-triche | Possible, non essentiel | Élevée |

### Moteur et simulation candidats (décision différée)
- **Godot 4.x 2D** : piste prioritaire pour un prototype gratuit et léger ; collisions et scène 2D adaptées. Le mouvement de `CharacterBody2D.move_and_slide()` **modifie la vélocité à la collision** : vérifier que son comportement convient à la conservation contrôlée de l'élan ; sinon, **contrôleur cinématique personnalisé** avec collision explicite.
- **GameMaker** : solution crédible pour du platformer 2D artisanal, mais choix à confronter à l'exigence de replay déterministe et aux outils de test.
- **Pas de moteur physique rigide généraliste** pour définir la physique principale du joueur si cela compromet la maîtrise tick par tick.

**Invariants architecturaux proposés** :
1. Simulation à pas **fixe** (60 ou 120 ticks/s à comparer) ; le rendu et la fréquence écran 30/60/144 Hz ne modifient pas les règles.
2. Chrono fondé sur les ticks simulés, séquencement des inputs par tick ; pas sur le temps variable du rendu.
3. Modèle de déplacement **explicite** : position, ground speed, vitesse aérienne, état de contact, surface, fenêtre G1/G2 et événements de collision.
4. Collisions solides sauf **transitions spécialement autorisées** ; toutes les sorties doivent être valides (pas d'insertion permanente dans les murs ni de franchissement arbitraire).
5. Vérifier le tunneling à pleine vitesse, aux extrêmes et lors de la reprise de collision après G1.
6. **Ne jamais déduire « replay déterministe multi-OS » du seul pas fixe.** Flottants, ordre de collision, solveur, versions et plateformes peuvent différer. Un replay d'inputs exige de rejouer les mêmes règles et la même simulation.
7. Replays « golden » enregistrés (inputs + version physique + version du niveau + état initial + checksums ponctuels), reproduits dans un environnement contrôlé ; comparaison à plusieurs FPS de rendu sans changer le tick de physique.
8. **Ghost visuel local** éventuellement enregistré comme trajectoire de positions horodatées, indépendant de la reproductibilité parfaite des inputs ; son affichage n'est **pas une preuve anti-triche**.
9. Changements de physique/version : segmenter records et preuves par version, archiver une compatibilité de lecture si possible ; ne pas prétendre préserver automatiquement les records compétitifs après une refonte.
10. Si le prototype révèle des divergences graves, évaluer **arithmétique à point fixe ou règles de mouvement entièrement contrôlées** pour la simulation compétitive. Ce choix aurait un coût réel.

**Infra initiale** : ordinateur de développement ordinaire, stockage local des temps et fantômes, distribution PC clavier/manette d'abord ; **aucun serveur, authentification ou réseau requis**. Portage console/mobile et mode multijoueur hors périmètre.

## 8. Études comparatives et enseignements vérifiables (recherche documentaire)

| Référence | Enseignement utile | À ne pas déduire |
| --- | --- | --- |
| [Sonic Physics Guide (reprise documentaire)](https://github.com/trentbrew/sonic-physics-guide) et [décorticage de la physique](https://threadreaderapp.com/thread/1747731331851678170) | Séparer vitesse au sol, pente, frottement, freinage, impulsion et réception ; l'inertie se conçoit comme un **système** | Copier les chiffres ou l'architecture des jeux originaux garantira le même plaisir |
| [Entretien de développement de Pizza Tower](https://www.gamedeveloper.com/design/how-speedy-implementation-high-paced-platformer-pizza-tower) | Relier les états de mouvement enchaînables, aménager des routes rapides, tester différents profils ; le level design a dû être refait à plusieurs reprises | La seule grande vitesse rend un niveau amusant |
| [Analyse des techniques Celeste](https://teemo.dev/game-design/celeste/systems/movement-tech-and-momentum-physics/) ; [changelog officiel](https://www.celestegame.com/changelog.html) | Les interactions très précises peuvent nourrir une communauté de speedrun ; le chrono et ses règles exigent une stabilité explicite | Toutes les techniques célèbres sont des bugs intentionnels dès leur conception, ou doivent être reproduites |
| [Godot : interpolation et pas fixes (stable)](https://docs.godotengine.org/en/stable/tutorials/physics/interpolation/physics_interpolation_introduction.html) | Séparer tick physique et fréquence d'affichage pour éviter les variations dépendantes des FPS | L'interpolation garantit un replay binaire déterministe |
| [Godot : CharacterBody2D](https://docs.godotengine.org/en/stable/classes/class_characterbody2d.html) | Les mouvements/angles/pentes sont pris en charge, mais `move_and_slide` modifie les vitesses ; l'interface doit être testée avec G1/G2 | La solution intégrée suffit nécessairement à des règles de collision anormales |

**État de recherche :** revue qualitative de références documentaires accessibles ; pas d'analyse exhaustive du marché, pas de benchmark, pas de preuve de nouveauté commerciale. L'espace concurrentiel mérite une recherche séparée **avant** toute décision de commercialisation.

## 9. Protocoles de validation scientifique (à exécuter seulement après lancement du projet autonome)

### H1 — L'inertie est satisfaisante AVANT les glitchs
- Comparer une physique réactive classique et une physique à inertie/pentes, avec un même parcours sans glitch.
- Observer erreurs de saut, contrôle ressenti, envie de refaire le segment, perception d'accélération. **Échec** si l'inertie rend simplement les actions frustrantes.

### H2 — G1 provoque une compétence acquise, pas du hasard
- Un joueur novice observe une couture, expérimente, apprend, puis refait la technique avec une fréquence de succès croissante.
- Indicateurs : réussite au premier essai / après indice / après démonstration, temps d'apprentissage, réussite 3 fois de suite, attribution subjective à l'habileté.
- Fenêtre de départ à comparer, par exemple **4–8 ticks à 60 Hz** pour débutants (hypothèse), timings plus serrés seulement pour défis experts optionnels.

### H3 — L'après-glitch est la vraie récompense
- Comparer A : le glitch raccourcit simplement le niveau et arrive presque à l'arrêt ; B : le glitch **conserve l'élan** et débouche sur un long passage rapide.
- Observer préférence, joie déclarée, nombre de replays volontaires, envie d'optimiser. **Si B n'est pas préféré par les joueurs visés, la thèse centrale est fragilisée.**

### H4 — G1 + G2 donnent de la profondeur sans quadrupler le nombre de boutons
- Mesurer routes possibles, réussite de l'enchaînement, temps de lecture, fréquence des atterrissages involontaires.
- Si la combinaison exige uniquement une fenêtre opaque d'une frame et aucun contrôle ensuite, l'adoucir ou revoir la mécanique.

### H5 — Les chronos ne dépendent pas du matériel
- Même séquence d'inputs initialisée identiquement, exécutée à 30/60/144 FPS **de rendu** avec cadence de simulation fixe ; comparer états/checksums au tick et chronos.
- Répéter OS/architecture/versions si classements partagés envisagés. **Les divergences de solveur exigent un correctif ou un format de preuve limité à la version**, pas une déclaration de conformité.
- Comparer 60 vs 120 ticks/s comme **deux versions de règles différentes**, pas exiger des trajectoires identiques.

**Panel indicatif** : 8 à 12 personnes de niveaux différents en exploration qualitative, puis davantage si une décision commerciale est envisagée. Critères candidats (à calibrer, pas résultats observés) : route normale compréhensible sans aide ; majorité des débutants capables de reproduire G1 après un enseignement court ; les joueurs avancés réclament spontanément un « encore une fois » ; préférence nette pour G1 + conservation d'élan face au simple raccourci.

## 10. Plan de travail si l'idée est sélectionnée plus tard

| Phase future | Livrable | Décision de passage |
| --- | --- | --- |
| **P0. Préproduction** | Brief de sensations, benchmark papier et vidéos, références/licences, matrice risques, tests de perception | Le concept est identifiable sans emprunter les signes distinctifs des références |
| **P1. Physique seule** | Contrôleur et rampes placeholders, 30 secondes de jeu, caméra réactive | Courir et sauter plaisent **sans** faille |
| **P2. Un seul glitch** | G1 franchissement local, conditions de réussite claires, boucle reset | Réussite répétable et sensation d'habileté |
| **P3. Glitch + récompense** | G1 menant à une traversée très rapide, comparatif A/B H3 | L'élan après franchissement fait la différence |
| **P4. Combinaison** | G2, petit niveau à deux routes et séquence G1→G2 | Ni hasard ni multiplication des commandes |
| **P5. Instrumentation** | Chronos stables, restart, ghost local, replays/test de régression | Temps et règles crédibles sur la cible PC |
| **P6. Vertical slice** | 4 espaces de jeu, art et feedback limités, playtests, mini-présentation | Décider d'une production plus longue ou arrêter |

**Ordres de grandeur NON contractualisés**, pour un développeur déjà à l'aise avec un moteur 2D : *quelques semaines* pour éprouver le déplacement et un glitch ; *plusieurs semaines supplémentaires* pour une vertical slice testable ; plusieurs mois pour une mini-campagne polie (particulièrement si développement à temps partiel, apprentissage, graphismes et son maison). Le coût dominant n'est pas l'hébergement mais **l'itération physique / caméra / level design / playtest**. Aucune estimation de rentabilité n'est justifiée à ce stade.

## 11. Risques et garde-fous

- **Sonic sans son rythme** : inertie trop lourde ou vitesse donnée gratuitement. *Parade* : calibrer accélération/freinage, pente et vitesse de sortie ; valider H1.
- **Glitch = tromperie ou bouton magique** : un effet pseudo-aléatoire ou un simple téléport ne procure aucune fierté. *Parade* : préconditions observables, réussite répétée, aucun « glitch button ».
- **Glitch = trappe à frustration** : fenêtre trop courte, aucune indication, échecs très coûteux. *Parade* : fenêtres apprenables, enseignement progressif, reset quasi immédiat.
- **Succès gâché** : obstacle mortel non visible juste après une traversée parfaite. *Parade* : runway, caméra anticipée, marges de réception.
- **Physique incontrôlable** : accumulation infinie, sortie dans un mur, tunnel à grande vitesse. *Parade* : limites de conception sur les transitions, sorties sûres et tests extrêmes.
- **Fragilité des records** : disparités de machines, versions ou logique de chrono. *Parade* : tick fixe, versions, replays golden ; pas de leaderboard initial.
- **Coût infini de création des niveaux** : chaque nouvelle anomalie multiplie les possibilités de cassure. *Parade* : seulement deux techniques au MVP et routes construites pour elles.
- **Perte de personnalité** : trop de ressemblances avec Mario/Sonic/Celeste. *Parade* : identité graphique, thèmes et univers propres, anomalies lisibles comme langage du monde, aucun asset ou level design repris.

## 12. Décisions ouvertes (à garder ouvertes jusqu'aux tests)

1. **Signature visuelle** : pixel art sobre à l'ancienne, ou 2D vectorielle minimale ? Le style doit servir la lecture de la vitesse et des coutures.
2. **Fiction des anomalies** : monde « défectueux » assumé ou failles quasi secrètes dans un univers lumineux ? Éviter le filtre VHS/glitch constant.
3. **Profil des joueurs** : jeu de plateforme accessible avec plafond expert très haut (recommandation initiale), plutôt que hardcore dès le niveau 1.
4. **Granularité des niveaux** : segments ultra courts rejouables ou petits niveaux de 30–90 s ? À départager en playtest.
5. **G2** : interaction spectaculaire de pente ou anomalie visiblement contre-intuitive ?
6. **Assistance** : indices / entraînement / ralentissement de pratique. Chronos compétitifs séparés si aide altérant la simulation ; aides visuelles et remappage sans sanction.
7. **Départ du chrono** : premier input / lancement de la salle / franchissement du seuil ? Un protocole commun est nécessaire.
8. **Politiques d'exploits** : accepter les nouvelles trajectoires sûres et reproductibles découvertes par les joueurs si elles enrichissent le jeu ; bannir/corriger prioritairement softlocks, manipulation du chrono, corruption et sorties non valides. Versionner les classements en cas de correction significative.
9. **Commercialisation** : pas de modèle économique, prix ni promesse de marché pour l'instant.
10. **Critère de démarrage** : priorité uniquement si l'envie de travailler sur du **game feel et du level design itératif** l'emporte sur la tentation d'accumuler des features.

## Verdict de préfaisabilité

**Faisable techniquement, pertinent à prototyper, valeur ludique encore à démontrer.** La proposition différenciante est le triptyque **« maîtrise d'une faille → préservation du momentum → vitesse normalement inaccessible »**, dans une présentation de plateformer 2D à faible complexité visible.

**Prochaine étape autorisée dans l'incubateur :** conserver cette fiche comme hypothèses et protocole ; **aucun code**. Au moment où une expérimentation démarre, créer/choisir un dépôt autonome, y transférer l'étude et **retirer** la fiche de l'incubateur conformément à sa politique.
