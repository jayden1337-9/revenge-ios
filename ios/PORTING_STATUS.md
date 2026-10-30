# iOS porting status

This is a tracking document, not a claim of feature parity.

| Area | Status | Next requirement |
| --- | --- | --- |
| Native Swift package | Foundation added | Expand as host architecture is selected |
| JavaScript runtime | Not implemented | Select and integrate an iOS-compatible runtime |
| Revenge bundle bootstrap | Not implemented | Supply the globals and modules expected by `src/entry.ts` |
| Discord client integration | Not implemented | Design a supported iOS host/integration approach |
| Plugin manager | Not implemented | Port runtime and storage APIs, then validate plugins |
| Themes and fonts | Not implemented | Port styling, asset, and font APIs |
| Custom CSS | Not implemented | Implement a safe iOS-compatible styling bridge |
| Notifications | Not implemented | Implement and test iOS notification integration |
| Voice | Not implemented | Investigate supported iOS audio/session integration |
| App signing and installation | Not implemented | Configure Apple signing and a distribution route |
| Physical-device testing | Not started | Test on a registered iPhone |

## Compatibility rule

Keep Android loader code and release behavior unchanged. iOS-specific code
belongs under `ios/` until the shared bundle can support both platforms without
platform-specific regressions.
