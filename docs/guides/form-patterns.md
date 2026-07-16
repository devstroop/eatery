# Form Patterns

> How to build consistent, tokenized forms using `AppFormField` and `AppMultiStepForm`.

## Quick Reference

```dart
// Single field — the standard pattern for all CRUD forms
AppFormField(
  label: 'Customer Name',
  hint: 'Enter full name',
  controller: _controllerName,
  focusNode: _focusNodes[0],
  focusNext: _focusNodes[1],
  validator: (v) => v!.isEmpty ? 'Required' : null,
)

// Multi-step flow — for onboarding, setup, or any wizard pattern
AppMultiStepForm(
  steps: const ['Company', 'Auth', 'Taxation', 'Plan'],
  currentStep: index,
  hiddenSteps: {2},  // skip Taxation step when not applicable
  onStepChanged: (i) => setState(() => index = i),
  onNext: () => _validateAndAdvance(),
  onSubmit: () => _submit(),
  onBack: index > 0 ? () => setState(() => index--) : null,
  child: bodies[index],
)
```

## AppFormField

### Core Pattern: Focus Chaining

The key difference from legacy `LabeledCustomTextFormField` is the `focusNext` prop. Instead of manually requesting focus in `onFieldSubmitted`, declare the next node:

```dart
// ❌ Legacy — manual focus chaining, boilerplate themeColor/foregroundColor
LabeledCustomTextFormField(
  label: 'Name',
  controller: _controllerName,
  themeColor: _pageColor,         // irrelevant to the field's purpose
  foregroundColor: AppColors.black600,  // always the same
  focusNode: _focusNodes[0],
  onFieldSubmitted: (v) {
    _focusNodes[1].requestFocus();  // boilerplate
  },
)

// ✅ Current — focusNext + automatic tokens
AppFormField(
  label: 'Name',
  controller: _controllerName,
  focusNode: _focusNodes[0],
  focusNext: _focusNodes[1],
)
```

### Terminal Fields (Last Field in Form)

When a field is the last in the chain, either:
- Omit `focusNext` (defaults to `null` — keyboard stays open)
- Add `onFieldSubmitted` to unfocus: `onFieldSubmitted: (v) => FocusScope.of(context).unfocus()`

```dart
AppFormField(
  label: 'Description',
  controller: _controllerDesc,
  focusNode: _focusNodes[2],
  multiline: true,
  onFieldSubmitted: (v) => FocusScope.of(context).unfocus(),
)
```

### With Prefix/Suffix Icons

```dart
AppFormField(
  label: 'Sale Price',
  prefix: const Icon(Icons.currency_rupee, size: 14),
  hint: '0.00',
  keyboardType: TextInputType.number,
  controller: _controllerPrice,
)

AppFormField(
  label: 'Tax Rate',
  suffix: Icon(Icons.percent, color: AppColors.white),
  keyboardType: const TextInputType.numberWithOptions(decimal: true),
  controller: _controllerTax,
)
```

### With Validators

```dart
AppFormField(
  label: 'Staff Name',
  controller: _controllerName,
  focusNode: _focusNodes[0],
  focusNext: _focusNodes[1],
  validator: (value) {
    if (value == null || value.isEmpty) return 'Enter Staff Name';
    if (value.length < 3) return 'Minimum 3 characters';
    if (ref.read(staffRepositoryProvider).isStaffNameTaken(value)) {
      return 'Staff Name already exists';
    }
    return null;
  },
)
```

### Multi-line Fields

```dart
AppFormField(
  label: 'Address',
  controller: _controllerAddress,
  multiline: true,
  hint: 'Enter full address',
)
```

### Obscured Fields (PIN / Password)

```dart
AppFormField(
  label: 'PIN (4 digits)',
  controller: _controllerPin,
  obscureText: true,
  keyboardType: TextInputType.number,
  validator: (v) => v!.length < 4 ? 'Minimum 4 digits' : null,
)
```

### Internal Spacing

`AppFormField` adds spacing automatically:

```dart
// Inside AppFormField.build():
Column(
  children: [
    Text(label),                                    // label in fieldLabel style
    SizedBox(height: AppSpacing.fieldLabelGap),     // 4px gap
    _AppTextField(...),                             // the actual input
    SizedBox(height: AppSpacing.md),                // 12px bottom margin
  ],
)
```

This means you should **not** add external `SizedBox` or `AppSpacing` widgets between consecutive `AppFormField`s — the spacing is already provided.

### Full Page Pattern

```dart
class AddCustomerPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<AddCustomerPage> createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends ConsumerState<AddCustomerPage> {
  final _formKey = GlobalKey<FormState>();
  final _focusNodes = [FocusNode(), FocusNode(), FocusNode(), FocusNode()];
  final _controllerName = TextEditingController();
  final _controllerPhone = TextEditingController();
  final _controllerAddress = TextEditingController();
  final _controllerLandmark = TextEditingController();

  @override
  void dispose() {
    for (final f in _focusNodes) f.dispose();
    _controllerName.dispose();
    _controllerPhone.dispose();
    _controllerAddress.dispose();
    _controllerLandmark.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Add Customer',
      color: AppColors.menuCustomers,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) _save();
        },
        child: const Icon(Icons.save),
      ),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            AppFormField(
              controller: _controllerPhone,
              label: 'Phone Number (*required)',
              keyboardType: TextInputType.phone,
              focusNode: _focusNodes[0],
              focusNext: _focusNodes[1],
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            AppFormField(
              controller: _controllerName,
              label: 'Customer Name',
              focusNode: _focusNodes[1],
              focusNext: _focusNodes[2],
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            AppFormField(
              controller: _controllerAddress,
              label: 'Address',
              keyboardType: TextInputType.streetAddress,
              multiline: true,
              focusNode: _focusNodes[2],
              focusNext: _focusNodes[3],
            ),
            AppFormField(
              controller: _controllerLandmark,
              label: 'Landmark (Optional)',
              focusNode: _focusNodes[3],
              onFieldSubmitted: (v) => _focusNodes[3].unfocus(),
            ),
          ],
        ),
      ),
    );
  }
}
```

## AppMultiStepForm

### Step Indicator Pattern

```dart
AppMultiStepForm(
  steps: const [
    'Company',   // index 0
    'Auth',      // index 1
    'Taxation',  // index 2 — conditionally hidden
    'Tax Reg',   // index 3 — conditionally hidden
    'Currency',  // index 4
    'Plan',      // index 5
  ],
  currentStep: viewIndex,      // visible step index (accounting for hidden steps)
  hiddenSteps: taxed ? {} : {2, 3}, // skip tax steps when not applicable
  onStepChanged: (i) => setState(() => viewIndex = i),
  onNext: () {
    // Validate current step's form before advancing
    if (_formKeys[viewIndex].currentState?.validate() != true) return;
    setState(() => viewIndex++);
  },
  onSubmit: () => _submitAll(),
  onBack: viewIndex > 0 ? () => setState(() => viewIndex--) : null,
  child: bodies[viewIndex],    // the current step's widget tree
)
```

### Step Dots

Each step renders as a dot + label in the header:
- **Active**: filled primary color, larger dot (14px), bold label
- **Completed**: filled success color with checkmark icon
- **Inactive**: outlined grey300, smaller dot (10px), normal label
- **Tappable**: clicking a dot calls `onStepChanged(i)`

### Conditional Step Skipping

The `hiddenSteps: Set<int>` parameter omits steps from the visible list. The `currentStep` value is already relative to visible steps — you don't need to adjust indexing manually.

### Creating a Multi-Step Form Body

Each body is a regular widget — use `AppFormField` inside:

```dart
// Step 0: Company Info
Form(
  key: formKeys[0],
  child: ListView(
    children: [
      AppFormField(label: 'Company Name', controller: ..., focusNext: ...),
      AppFormField(label: 'Email', controller: ..., keyboardType: ...),
      AppFormField(label: 'Phone', controller: ..., keyboardType: ...),
    ],
  ),
)
```

## Related

- [ADR-006: Domain Molecule Cohesion](../decisions/006-domain-molecule-cohesion.md)
- [Component Library](../architecture/component-library.md)
- [Migration Patterns](../development/migration-patterns.md)
