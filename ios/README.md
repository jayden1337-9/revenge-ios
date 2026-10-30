# Revenge iOS foundation

This directory starts a native iOS integration layer for the existing Revenge
JavaScript bundle. It is deliberately separate from the Android loader and
does not change the existing Android build.

## Current contents

- A Swift Package containing a small host lifecycle coordinator.
- A runtime-adapter protocol for a future iOS JavaScript engine integration.
- A macOS CI workflow that compiles and tests this Swift package.

## Important: this is not an installable Discord client yet

The upstream bundle is built for a loader that provides React Native, Discord
internals, Metro/native modules, and Revenge-specific globals. The Swift package
does not provide those pieces. A compatible iOS host and runtime adapter must
be implemented before the Revenge bundle can run.

A normal WKWebView is not a drop-in replacement for the Android loader.
Discord account integration, UI integration, plugin APIs, themes, notifications,
and voice all need separate iOS-compatible implementations and device testing.

## Development

From the repository root on macOS with Swift installed:

```sh
swift test --package-path ios
```

The next engineering steps are to select and integrate a JavaScript runtime,
implement the required native module/global compatibility layer, and then build
a real iOS application target. Do not mark a feature as supported until it has
been tested on a physical iPhone.
