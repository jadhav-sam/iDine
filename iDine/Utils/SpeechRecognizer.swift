//
//  SpeechRecognizer.swift
//  iDine
//
//  Created by Samruddhi Jadhav on 17/11/21.
//

import Foundation
import AVFoundation
import Speech

class SpeechRecognizer {
  private var audioEngine: AVAudioEngine
  private var inputNode: AVAudioInputNode
  private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
  private var audioSession: AVAudioSession?

  init() {
    audioEngine = AVAudioEngine()
    inputNode = audioEngine.inputNode
    audioSession = AVAudioSession.sharedInstance()
    recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
  }

  func listen() {
    startRecording()
    guard let recognizer = SFSpeechRecognizer(), recognizer.isAvailable,
          let recognitionRequest = recognitionRequest else {
      handleError(withMessage: "Speech Recognizer not available.")
      return
    }
    recognitionRequest.shouldReportPartialResults = false
    recognizer.recognitionTask(with: recognitionRequest) { [weak self] (result, error) in
      guard error == nil,
            let result = result else {
        self?.handleError(withMessage: error!.localizedDescription)
        return
      }
      
      print("You said: \(result.bestTranscription.formattedString), final : \(result.isFinal)")
      
      if result.isFinal {
        self?.stopRecording()
        self?.update(withResult: result)
      }
    }
  }
  
  private func checkPermissions() {
    SFSpeechRecognizer.requestAuthorization { authStatus in
      DispatchQueue.main.async {
        switch authStatus {
        case .authorized:
          // TODO: Implement.
          break
        case .denied:
          // TODO: Implement.
          break
        case .restricted:
          // TODO: Implement.
          break
        case .notDetermined:
          // TODO: Implement.
          break
        @unknown default:
          fatalError()
        }
      }
    }
  }

  func handleError(withMessage: String) {
    print(withMessage)
  }

  private func update(withResult result: SFSpeechRecognitionResult) {
    
  }
  
  private func startRecording() {
    let recordingFormat = inputNode.outputFormat(forBus: 0)
    inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] (buffer, _) in
      self?.recognitionRequest?.append(buffer)
    }

    audioEngine.prepare()

    do {
      // Activate the session.
      try audioSession?.setCategory(.record, mode: .spokenAudio, options: .duckOthers)
      try audioSession?.setActive(true, options: .notifyOthersOnDeactivation)
      try audioEngine.start()
    } catch {
      handleError(withMessage: error.localizedDescription)
    }
  }

  private func stopRecording() {
    // End the recognition request.
    recognitionRequest?.endAudio()
    recognitionRequest = nil
    
    // Stop recording.
    audioEngine.stop()
    inputNode.removeTap(onBus: 0) // Call after audio engine is stopped as it modifies the graph.
    
    // Stop our session.
    try? audioSession?.setActive(false)
    audioSession = nil
  }
}
