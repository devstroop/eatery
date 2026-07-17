# Design Tokens

All visual properties derive from tokens in `packages/eatery_core/lib/theme/`. **Never use raw values.**

## Colors

**Semantic tokens** (preferred wherever possible):

| Token | Value | Use |
|-------|-------|-----|
| `AppColors.primary` | `#30A8CF` | Brand, headers, primary actions |
| `AppColors.success` | `#4AC3A1` | Confirmations, available status |
| `AppColors.warning` | `#F5A142` | Alerts, occupied tables |
| `AppColors.error` | `#EF6850` | Deletion, voids, rejections |
| `AppColors.info` | `#2F5EC2` | Information, preparing status |

**Neutrals:**

| Token | Value | Use |
|-------|-------|-----|
| `white` | `#FFFFFF` | Cards, backgrounds |
| `grey50–grey900` | `#F8F9FA–#151515` | Text hierarchy, borders |
| `grey200` | `#EEEEEE` | Page backgrounds |
| `grey500` | `#858585` | Muted text, completed status |

**Status tokens** (specific to order lifecycle):

| Token | Maps to |
|-------|---------|
| `statusPending` | `warning` |
| `statusPreparing` | `info` |
| `statusReady` | `success` |
| `statusCompleted` | `grey500` |
| `statusVoided` | `error` |

## Typography

All styles via `AppTypography`. No raw `TextStyle(fontSize: N)`.

| Token | Size | Weight | Use |
|-------|------|--------|-----|
| `displayLarge` | 48 | w700 | Hero text |
| `headlineLarge` | 32 | w600 | Page titles |
| `headlineMedium` | 28 | w600 | Section headers |
| `headlineSmall` | 24 | w600 | Card titles |
| `titleLarge` | 20 | w600 | Important labels |
| `titleMedium` | 16 | w600 | Sub-section labels |
| `bodyLarge` | 16 | w400 | Primary text |
| `bodyMedium` | 14 | w400 | Secondary text |
| `bodySmall` | 12 | w400 | Captions |
| `labelLarge` | 14 | w500 | Chips, badges |
| `labelSmall` | 10 | w500 | Tiny labels |

## Spacing

4px base unit. Use `AppSpacing.gapSm` (`SizedBox`) or `AppSpacing.md` (raw value).

| Token | px | SizedBox shortcut |
|-------|----|-------------------|
| `xs` | 4 | `gapXs` |
| `sm` | 8 | `gapSm` |
| `md` | 12 | `gapMd` |
| `lg` | 16 | `gapLg` |
| `xl` | 24 | `gapXl` |
| `xxl` | 32 | `gapXxl` |

**Preset paddings:** `pageMobile`, `cardPadding`, `tilePadding`, `buttonPadding`, `fieldPadding`.

## Border Radius

| Token | px | Use |
|-------|----|-----|
| `radiusSm` | 4 | Chips, small containers |
| `radiusMd` | 8 | Cards, fields |
| `radiusLg` | 12 | Modals, dialogs |
| `radiusXl` | 16 | Large cards |
