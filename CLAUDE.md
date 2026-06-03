# CLAUDE.md

This file documents architectural decisions and constraints for AI assistants
working on this codebase. Read this before making any changes.

## General

- This is a Qt6 QML project. Do not introduce Qt5 dependencies.
- ThemeImage.qml is a core reusable component. Do not modify it unless the
  change is specifically about image loading, fallback, or sizing.
- Always work on a feature branch. Do not commit directly to main.

## Issue #6 — Scene Graph Refactor: Architectural Constraint

**Read this before writing any code for Issue #6.**

The SVG hand files contain embedded PNGs with offset pivot points. All pivot
compensation currently lives in the Canvas JavaScript:

    ctx.save()
    ctx.translate(cx, cy)
    ctx.rotate(angle)
    ctx.drawImage(handImage, ...)
    ctx.restore()

ThemeImage.qml has no knowledge of clock geometry. It handles image loading,
fallback, and sizing only. Do not modify ThemeImage.qml for this refactor.

**Required before writing any refactor code:**

1. Examine the actual pivot offset values in the current Canvas code.
2. Propose a QML Rotation transform strategy that correctly replicates the
   pivot behavior for each hand (hour, minute, second).
3. Confirm that ThemeImage.qml requires no changes.
4. Get that design approved before touching main.qml.

Do not assume that applying `rotation:` natively to a ThemeImage will behave
correctly. It will rotate around the image center, not the clock's center pin.

## Issue #6 — Resolution Notes (June 2026)

Investigation confirmed that the Scene Graph refactor described above is
already largely implemented. Face layers are already ThemeImage items.
The Canvas is already scoped exclusively to hand rendering and date display.

The SVG overflow clipping problem was investigated and found to affect all
210 hand SVG files across 35 themes. The hand tails (counterweights) extend
beyond the pivot point into negative SVG x-space and would be clipped by
native QML Image viewport bounds. Modifying all 210 SVG files was deemed
out of scope for this refactor.

Decision: Canvas hand rendering is retained intentionally. This is not a
bug or an oversight — it is the correct solution given the SVG file structure.
Do not attempt to replace Canvas hand drawing with native QML Image rotation
without first resolving the overflow clipping issue in the SVG files.

What was fixed: The minute hand angle calculation was corrected to include
a seconds component (root.seconds * 0.1), matching the hour hand's behavior.
The minute hand now sweeps continuously at smoothness=3 with no visible
change at lower smoothness settings.

Issue #6 is closed. Open a new issue if pursuing the SVG overflow fix.
