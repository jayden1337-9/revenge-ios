# Voice integration plan

Voice is a native integration, not just a UI toggle.

## Added foundation

`VoiceAudioSession` configures iOS for two-way voice communication, requests
microphone permission, activates/deactivates the audio session, and exposes the
current output route names. It also observes route changes and interruptions.

The app target must include `NSMicrophoneUsageDescription` in its Info.plist.
The user must grant microphone access before joining a voice channel.

## Still required for working Discord voice

This module intentionally does **not** implement the Discord voice protocol.
A complete implementation still needs:

1. A supported Discord client integration that can obtain legitimate voice
   session information from the signed-in client.
2. Voice gateway signalling and session lifecycle.
3. The required voice transport, codec, encryption, packet timing, and network
   handling compatible with Discord's current protocol.
4. A bridge between the voice transport and the iOS audio input/output pipeline.
5. Mute/deafen state, output route selection, Bluetooth handling, interruptions,
   reconnects, and cleanup.
6. Physical-device testing with a real iPhone, headset, speaker, and network
   transitions.

Do not claim voice chat works until a real end-to-end call has been tested.
The audio-session helper alone is not a voice client.
