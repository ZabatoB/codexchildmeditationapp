import AVFoundation
import Observation
import SwiftUI

@Observable
final class TTSAudioEngine: NSObject {

    private(set) var isSpeaking: Bool = false
    private(set) var isPaused: Bool = false

    private let synthesizer = AVSpeechSynthesizer()
    private var silenceTimer: Timer?
    private var completionHandler: (() -> Void)?

    private let voiceIdentifier = "com.apple.voice.compact.en-US.Samantha"
    private let speechRate: Float = 0.42
    private let speechPitch: Float = 1.08
    private let speechVolume: Float = 1.0

    override init() {
        super.init()
        synthesizer.delegate = self
        configureAudioSession()
    }

    private func configureAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .spokenAudio, options: [.duckOthers])
            try session.setActive(true)
        } catch {
            print("Failed to configure audio session: \(error)")
        }
    }

    func speak(_ text: String, completion: @escaping () -> Void) {
        guard !text.isEmpty else {
            completion()
            return
        }

        completionHandler = completion

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(identifier: voiceIdentifier)
            ?? AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = speechRate
        utterance.pitchMultiplier = speechPitch
        utterance.volume = speechVolume
        utterance.preUtteranceDelay = 0.1
        utterance.postUtteranceDelay = 0.3

        isSpeaking = true
        synthesizer.speak(utterance)
    }

    func startSilence(duration: TimeInterval, completion: @escaping () -> Void) {
        completionHandler = completion

        silenceTimer?.invalidate()
        silenceTimer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { [weak self] _ in
            self?.silenceTimer = nil
            self?.completionHandler?()
            self?.completionHandler = nil
        }
    }

    func pause() {
        if isSpeaking {
            synthesizer.pauseSpeaking(at: .immediate)
        }
        silenceTimer?.fireDate = Date.distantFuture
        isPaused = true
    }

    func resume() {
        if isSpeaking {
            synthesizer.continueSpeaking()
        }
        silenceTimer?.fireDate = Date().addingTimeInterval(1)
        isPaused = false
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
        silenceTimer?.invalidate()
        silenceTimer = nil
        completionHandler = nil
        isSpeaking = false
        isPaused = false
    }
}

extension TTSAudioEngine: AVSpeechSynthesizerDelegate {

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async { [weak self] in
            self?.isSpeaking = false
            self?.completionHandler?()
            self?.completionHandler = nil
        }
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        DispatchQueue.main.async { [weak self] in
            self?.isSpeaking = false
        }
    }
}
