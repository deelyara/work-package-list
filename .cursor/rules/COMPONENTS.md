# Work Package Page Components

## Overview
The work package page has been refactored from a single 2380-line file into 6 focused components for better maintainability and separation of concerns.

## File Structure

```
lib/features/
├── work_package_page.dart              # Main page (500 lines)
├── models/
│   └── work_package_models.dart        # Data classes
├── components/
│   ├── work_package_toolbar.dart       # Filter/generate toolbar
│   └── progress_components.dart        # Progress UI widgets
├── dialogs/
│   ├── export_dialog.dart             # Export functionality
│   └── generation_parameters_dialog.dart # Parameters display
├── data/
│   └── mock_work_packages.dart         # Mock data separated from logic
└── utils/
    └── work_package_utils.dart         # Helper functions
```

## Components Detail

### `work_package_page.dart`
**Purpose:** Main stateful widget containing the work package table and orchestrating all sub-components.

**Key Features:**
- Expandable rows with language package details
- Progress report generation state management
- Column-aligned translation stage layout
- Always-visible progress badges (with placeholder styling)
- Modern Material 3 action buttons
- Integration with toolbar, dialogs, and utilities

**State Management:**
- `expandedRows`: Controls table row expansion
- `expandedLanguagePackages`: Controls language package expansion  
- `progressReportGenerated`: Tracks which packages have reports
- `progressReportDates`: Stores report generation timestamps

**UX Improvements:**
- Non-sticky table header for better scrolling
- Proper column alignment between main table and expanded content
- Placeholder badges show "Generate report to see progress" when no report exists
- TextButton with "Edit" text replaces confusing icon-only action

### `models/work_package_models.dart`
**Purpose:** Data classes for type safety and structure.

**Classes:**
- `WorkPackage`: Top-level work package data
- `LanguagePackage`: Language-specific package data
- `TranslationStage`: Individual translation stage data
- `FilterOption`: Filter configuration data

### `components/work_package_toolbar.dart`
**Purpose:** Stateful widget handling filter popup and generate button.

**Features:**
- Multi-select filter popup with checkboxes
- Limit input field
- Clear/apply filter actions
- Generate work package button

**Callback:** `onFiltersChanged(List<FilterOption>)` to parent

### `components/progress_components.dart`
**Purpose:** Reusable progress visualization widgets and functions.

**Functions:**
- `buildProgressBadge()`: Creates status badges (New/Translated/Proofread)
- `buildMultiSegmentProgressBar()`: Multi-colored progress bars

**Widget:**
- `OverallProgressWidget`: Calculates and displays combined progress across all language packages

### `dialogs/export_dialog.dart`
**Purpose:** Modal dialog for work package export configuration.

**Function:** `showExportDialog(BuildContext, String packageName)`

**Features:**
- File format selection (XLIFF, CSV, etc.)
- Language selection dropdown
- Export type filtering
- Multiple configuration checkboxes

### `dialogs/generation_parameters_dialog.dart`
**Purpose:** Read-only modal displaying work package generation settings.

**Function:** `showGenerationParametersDialog(BuildContext)`

**Displays:**
- Source language info
- Generation parameters (split size, export settings)
- Timeline data with creation/generation dates

### `utils/work_package_utils.dart`
**Purpose:** Static utility functions for common operations.

**Functions:**
- `parseDate()`: Converts string dates to DateTime objects
- `extractDate()`: Extracts date portion from datetime strings
- `formatDateTime()`: Formats DateTime to readable strings
- `getFlagIcon()`: Returns country flag widgets for language codes
- `calculateLanguageProgress()`: Computes completion percentage

## Dependencies

**External Packages:**
- `country_flags`: For language flag icons
- `flutter/material.dart`: Material Design components

**Internal Dependencies:**
- `../theme/app_theme.dart`: Consistent theming
- `../theme/button_styles.dart`: Button styling (dialogs only)

## Usage Patterns

**Progress Report Flow:**
1. User clicks generate button in expanded row
2. `progressReportGenerated[index] = true` 
3. UI shows `OverallProgressWidget` and updates header
4. Individual stages show progress badges

**Filter Flow:**
1. User opens filter popup in toolbar
2. Selects/deselects options using `StatefulBuilder`
3. Clicks "Show results" → `onFiltersChanged` callback
4. Parent updates `filterOptions` state

**Export Flow:**
1. User selects "Export..." from row actions menu
2. `showExportDialog()` called with package name
3. User configures export settings
4. Modal handles form state internally

## State Flow

```
WorkPackagePage (main state)
├── FilterOptions → WorkPackageToolbar
├── ExpandedRows → Table row expansion
├── ProgressReports → OverallProgressWidget
└── Mock data → All child components
``` 