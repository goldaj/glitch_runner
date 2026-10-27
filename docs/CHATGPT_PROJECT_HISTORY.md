# Archive ChatGPT / Codex — Glitch Runner

Couverture **partielle**, créée le **27/10/2026**. Les heures exactes des messages ne sont pas attestées. Les citations Utilisateur sont verbatim d'un échange accessible ; les notes Assistant sont des **résumés reconstruits**, pas des citations intégrales. L'historique complet des conversations précédentes nécessiterait un export authentique. Ne pas le fabriquer.

## 2026-10-26 — Première étude
**Utilisateur (verbatim) :**
> On va étoffer un peu [https://github.com/goldaj/projects-incubator/blob/main/jeux/speedrun-glitch-platformer.md](https://github.com/goldaj/projects-incubator/blob/main/jeux/speedrun-glitch-platformer.md)
> Pour l'instant on laisse ça dans l'incubator et on ne code pas. Mais ça sera peut être un des projets sujets auquel on s'attaque.
>
> Réfléchis, recherche, détermine la faisabilité. On part de quelque chose de simple mais subtile, comme la complexité d'un SMB3 par exemple, mais sans le copier, juste dans la simplicité je veux dire. Et surtout on veut une satisfaction de vitesse et d'inertie à la sonic, dans anciens jeux 2D.
> En gros il faut vraiment la fierté de passer les glitchs et la satisfaction du résultat de vitesse qui était coupé dans son élan/impossible à avoir si on avait joué normalement.

**Assistant (résumé reconstruit, non verbatim) :** fiche d'incubation approfondie en game design, physique, G1/G2, hypotheses H1–H5, programme P0–P6, sans code ni tests à cette date. Copie exacte conservée dans `docs/INCUBATOR_CONCEPT.md`.

## 2026-10-27 — Démarrage
**Utilisateur (verbatim) :**
> j'ai créé ce repo : [https://github.com/goldaj/glitch_runner](https://github.com/goldaj/glitch_runner)
> On va commencer à bosser sérieusement dessus.
> On prends les mêmes consignes que toutes les conversations qu'on a eu ensemble du type "Avancement_projets_codex_8"
>
> Et en avance !

**Assistant (résumé reconstruit, non verbatim) :** audit GitHub : nouveau dépôt public avec licence MIT et simple README, aucun code. Reprise des consignes connues de travail chercheur senior + ingénieur, progression autonome sous-étape par sous-étape, branche dédiée, pas de fusion, `AGENTS.md` et archive du contexte accessibles à Codex, tests réels et limites transparentes. Choix provisoire Godot 4.7.2 stable vérifié dans la publication officielle ; développement du laboratoire **sans glitch** avant jeu complet. Suppression de la fiche incubator prévue sur PR séparée.

## 2026-10-27 — Suite de P1 (assistant, résumé reconstruit)
La CI GitHub du laboratoire initial a été vérifiée **successful** (run 40457925457 : import et tests). L'assistant a ajouté deux réglages A réactif/B inertiel sélectionnables et un protocole de playtest H1. Les changements techniques A/B restent soumis à leur propre exécution de CI. Aucun test humain n'a été exécuté ni simulé.

## 2026-10-27 — Renforcement de validation et coordination (assistant, résumé reconstruit)
Les deux runs CI du changement A/B ont été observés verts (40458297529 et 40458303074). Trois tickets ont été ouverts : #2 playtest H1, #3 recherche collisions P2 conditionnée par H1, #4 récompense d'élan H3 après H2. Ajout d'un test de franchissement de la route normale sans glitch et d'un lancement de la scène pendant 180 frames en headless. **Ce troisième changement exige encore sa propre validation CI**. Rien n'a été fusionné.

## 2026-10-27 — Vérification finale de la base P1 (assistant, résumé reconstruit)
CI du commit `6f27e1b` observée successful dans deux runs (40458594556, 40458599650). Inspection du job : import du projet, tests automatisés, lancement headless de la scène (180 frames), tous les steps successful. Ligne de sortie des tests `PASS movement_lab: 17 invariants`. Aucun playtest visuel ou manette n'a été exécuté ; passage H1 non validé, aucune implémentation G1/G2. Documentation actualisée en conséquence.

## 2026-10-27 — Alerte architecturale (assistant, résumé reconstruit)
Le modèle P1 applique un plafond strict à la vitesse au sol (et en l'air). Risque de casser le futur plaisir central : un glitch qui conserve une vitesse supérieure à la course normale. L'assistant a créé l'issue #5 pour distinguer plafond normal, surplus autorisé, amortissement et passage sol/air, en dépendance du playtest H1. Deux nouvelles CI du commit documentaire `b88a1a6` ont été observées vertes (40458826898, 40458831597). Pas de code de glitch ni de validation humaine.

## 2026-10-27 — Demande d'une version Web jouable

**Utilisateur (verbatim, heure exacte non attestée) :**
> Pour tester le jeu, tu me feras une version web toute prête que j'ai juste à lancer et tu la mettras dans le repo

**Assistant (résumé reconstruit, non verbatim) :** conception d'un export Web Godot réel, sans threads pour l'hébergement sur GitHub Pages, dans une branche de travail distincte issue de P1, sans modifier les mécaniques. Ajout d'une configuration d'export, d'une CI exportant vers `gh-pages` et offrant un artifact ZIP, d'un guide pour jouer depuis l'URL et de la passation Codex. L'activation initiale GitHub Pages dépend des réglages du dépôt accessibles au propriétaire et ne peut être présumée. L'exécution et la publication sont à confirmer à partir des résultats CI.

## 2026-10-27 — Premier export Web vérifié (assistant, résumé reconstruit)
L'export officiel Godot 4.7.2 single-thread a passé sa première CI (run 40461342279), comprenant 17 tests de déplacement réussis, création d'une archive ZIP `glitch-runner-web-playtest`, et commit des fichiers HTML/WASM/JS/PCK sur la branche `gh-pages`. GitHub Pages n'a pas encore été confirmé actif (réglage propriétaire). Un smoke test navigateur Playwright/Chromium a ensuite été ajouté, en attente d'observation CI ; aucune validation de ressenti par un humain n'a eu lieu.

## 2026-10-27 — Web exécuté en navigateur (assistant, résumé reconstruit)
La CI [40461694868](https://github.com/goldaj/glitch_runner/actions/runs/40461694868) a fini avec succès : 17 invariants du modèle, export Web officiel et smoke test **Playwright/Chromium réellement exécuté**, canvas visible et touches clavier utilisées sans erreurs JS détectées. Une capture et un ZIP ont été versés comme artifacts, et la branche `gh-pages` a été peuplée. L'URL HTTPS publique reste non confirmée avant l'activation Pages par le propriétaire. Ajout d'un cache CI pour limiter les téléchargements de l'archive d'export de 1,3 Go ; ce changement demandera sa propre validation.

## 2026-10-27 — Retour de test sur les pentes
**Utilisateur (verbatim ; heure exacte non attestée) :**
> le test se lance, mais j'ai pas l'impression que les pentes accelère la vitesse en descendant ou la ralenti en montant

**Assistant (résumé reconstruit, non verbatim) :** inspection des constantes et calculs. La force des pentes existait, mais était masquée par un plafonnement strict de la vitesse appliqué après la gravité et par l'accélération continue sous input, spécialement en montée. Révision de la logique de mouvement : cap de l'**effort utilisateur** plutôt que de la vitesse acquise du terrain, drag progressif du surplus, pente relative au mouvement, HUD de vitesse horizontale ; tests contrôlés pour quantifier descente/plat/montée sous mêmes commandes. Pas d'ajout de glitch G1, pas de passage H1, CI et publication à constater après exécution.

## 2026-10-27 — Correction complémentaire sur les sauts (assistant, résumé reconstruit)
Le premier correctif pente passait les tests du modèle et l'export navigateur, mais une relecture a repéré un autre écrêtage strict en vol (±550 px/s) : un saut après une descente pouvait annuler l'élan. Modification du contrôle aérien pour distinguer la vitesse fournie par les commandes et le surplus gagné ; tests pour la conservation au décollage et après réception. Ceci reste une vérification de physique pré-playtest H1, sans G1.
