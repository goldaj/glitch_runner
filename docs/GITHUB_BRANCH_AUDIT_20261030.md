# Audit de branches et passation — 30 octobre 2026

**Source :** branches et PR ouvertes GitHub vérifiées. **Limite :** audit complet des différences de code et tests non exécutés dans cette passe. Ne pas déduire qu'une branche est supprimable de son nom.

- Dépôt : `goldaj/glitch_runner` ; branche par défaut : `main`.
- PR ouvertes : aucune.

## Branches (6)
- `feat/foundation-movement-p1`
- `feat/long-form-playtest-level`
- `feat/web-playtest-preview`
- `fix/swept-ground-contact`
- `gh-pages`
- `main` (défaut)

## Défis et passation
- Rejouer le niveau long, collisions sur pentes, sauts simultanés et build web avant validation du gameplay.
- Pour chaque branche, comparer SHA et ascendance à la bonne cible ; inspecter les diffs divergents et les PR historiques.
- Ne jamais fusionner vers la production sans tests ni autorisation.

**Décision :** inventaire documenté ; suppression et fusion laissées en attente de validation individualisée.
