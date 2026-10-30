#if os(iOS)
import AVFAudio
import Foundation

/// Owns the iOS audio-session configuration required by a future voice transport.
/// This manages microphone permission and audio routing only; it does not
/// implement Discord's voice gateway, encryption, RTP, or call signalling.
@MainActor
public final class VoiceAudioSession {
    public enum VoiceAudioError: Error {
        case microphonePermissionDenied
    }

    private let session = AVAudioSession.sharedInstance()
    private var observers: [NSObjectProtocol] = []

    public init() {}

    /// Ask iOS for microphone access. The app must also include
    /// NSMicrophoneUsageDescription in its Info.plist.
    public func requestMicrophonePermission() async throws {
        let granted = await withCheckedContinuation { continuation in
            session.requestRecordPermission { allowed in
                continuation.resume(returning: allowed)
            }
        }

        guard granted else {
            throw VoiceAudioError.microphonePermissionDenied
        }
    }

    /// Configure the system for two-way voice communication.
    public func activate() throws {
        try session.setCategory(
            .playAndRecord,
            mode: .voiceChat,
            options: [.allowBluetooth, .defaultToSpeaker]
        )
        try session.setActive(true)
        observeSystemChanges()
    }

    public func deactivate() throws {
        removeObservers()
        try session.setActive(false, options: .notifyOthersOnDeactivation)
    }

    /// Available output routes, suitable for a future in-call audio picker.
    public var availableOutputs: [String] {
        session.currentRoute.outputs.map { $0.portName }
    }

    private func observeSystemChanges() {
        guard observers.isEmpty else { return }
        let center = NotificationCenter.default

        observers.append(center.addObserver(
            forName: AVAudioSession.routeChangeNotification,
            object: session,
            queue: .main
        ) { _ in
            // The host should query availableOutputs again after route changes.
        })

        observers.append(center.addObserver(
            forName: AVAudioSession.interruptionNotification,
            object: session,
            queue: .main
        ) { _ in
            // The voice transport must pause/resume when the audio session is interrupted.
        })
    }

    private func removeObservers() {
        observers.forEach(NotificationCenter.default.removeObserver)
        observers.removeAll()
    }

    deinit {
        observers.forEach(NotificationCenter.default.removeObserver)
    }
}
#else
import Foundation

/// Placeholder for non-iOS package builds. Voice audio is iOS-only.
@MainActor
public final class VoiceAudioSession {
    public init() {}
}
#endif
