x.y.z Release Notes (yyyy-MM-dd)
=============================================================

1.1.0 Release Notes (2020-05-20)
=============================================================

### Enhancements

* All `add` APIs have had `new` removed from them for more succinct naming.
* Most Swift annotated methods have been renamed to match `UISegmentedControl` more closely.

### Added

* Support for iOS 9.
* A new method called  `setSelectedSegmentIndex(_:animated:)` to allow animated transitions of the thumb.

### Fixed

* Creating instances with `init(items:)` was yielding no visible items.
* Tint color of the reversible arrow icon wasn't updating properly.
* A deadlock was occurring when creating an instance with no items initially, and adding items later.
* A crash was occurring when trying to insert new items with invalid index numbers.
* Removed trailing separators when appending items with using `insert` functions.
* If touch events were canceled while tapping down on the control, UI state wasn't being restored to an untapped state.

1.0.1 Release Notes (2019-09-24)
=============================================================

### Fixed

* Simplified the segment selection logic to fix a layout bug with the reversible arrow icon.
* Slightly tweaked the corner radius to match `UISegmentedControl` more closely.

1.0.0 Release Notes (2019-09-23)
=============================================================

### Enhancements

* Added dark mode support for iOS 13 and up.
* Added optional 'reversible' mode for specific segments.

0.0.1 Release Notes (2019-09-15)
=============================================================

* Initial Release! 🎉
