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
