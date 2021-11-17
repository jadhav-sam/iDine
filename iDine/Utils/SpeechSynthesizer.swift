//
//  SpeechSynthesizer.swift
//  iDine
//
//  Created by Samruddhi Jadhav on 17/11/21.
//

import Foundation
import AVFoundation
import Speech

enum SupportedLanguage: String {
  case enUS = "en-US"
  case enDE = "en-DE"
}

class SpeechSynthesizer {
  private let supportedLanguage: SupportedLanguage
  
  init(supportedLanguage: SupportedLanguage = .enUS) {
    self.supportedLanguage = supportedLanguage
  }
  
  func say(utteranceString: String) {
    let utterance = AVSpeechUtterance(string: utteranceString)
    utterance.voice = AVSpeechSynthesisVoice(language: supportedLanguage.rawValue)
    
    let synthesizer = AVSpeechSynthesizer()
    synthesizer.speak(utterance)
  }
  
  func handleError(withMessage: String) {
    print(withMessage)
  }
}
