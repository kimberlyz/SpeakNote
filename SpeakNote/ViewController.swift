//
//  ViewController.swift
//  SpeakNote
//
//  Created by Kimberly Zai on 10/3/15.
//  Copyright (c) 2015 Kimberly Zai. All rights reserved.
//

import UIKit



class ViewController: UIViewController, OEEventsObserverDelegate {
    
    @IBOutlet weak var recordButton: UIButton!
    
    var openEarsEventsObserver = OEEventsObserver()
    var buttonFlashing = false

// START HERE
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        self.openEarsEventsObserver = OEEventsObserver()
        self.openEarsEventsObserver.delegate = self
        
        
        var words: Array<String> = ["HI", "HELLO", "DOES THIS WORK", "SUNDAY", "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY","FRIDAY", "SATURDAY"]
        
        
        let lmGenerator: OELanguageModelGenerator = OELanguageModelGenerator()
        //let name = "LanguageModelFileStarSaver"
        
        let name = "LanguageModelFileStarSaver"
        let err = lmGenerator.generateLanguageModelFromArray(words, withFilesNamed: name, forAcousticModelAtPath: OEAcousticModel.pathToModel("AcousticModelEnglish"))  // Change "AcousticModelEnglish" to "AcousticModelSpanish" to create a Spanish language model instead of an English one.
        
        var lmPath: String!
        var dicPath: String!
        
        if err == nil {
            lmPath = lmGenerator.pathToSuccessfullyGeneratedLanguageModelWithRequestedName(name)
            dicPath = lmGenerator.pathToSuccessfullyGeneratedDictionaryWithRequestedName(name)
        } else {
            print("Error: %@", err)
        }
        
        OEPocketsphinxController.sharedInstance().setActive(true, error: nil)
        OEPocketsphinxController.sharedInstance().startListeningWithLanguageModelAtPath(lmPath, dictionaryAtPath: dicPath, acousticModelAtPath: OEAcousticModel.pathToModel("AcousticModelEnglish"), languageModelIsJSGF: false) // Change "AcousticModelEnglish" to "AcousticModelSpanish" to perform Spanish recognition instead of English.
        
    }
    
    @IBAction func record(sender: AnyObject) {
        
        if !buttonFlashing {
            startFlashingbutton()
            //startListening()
        } else {
            stopFlashingbutton()
            //stopListening()
        }
    }
    
    func startFlashingbutton() {
        
        buttonFlashing = true
        recordButton.alpha = 1
        
        UIView.animateWithDuration(0.5 , delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut | UIViewAnimationOptions.Repeat | UIViewAnimationOptions.Autoreverse | UIViewAnimationOptions.AllowUserInteraction, animations: {
            
            self.recordButton.alpha = 0.1
            
            }, completion: {Bool in
        })
    }
    
    func stopFlashingbutton() {
        
        buttonFlashing = false
        
        UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut | UIViewAnimationOptions.BeginFromCurrentState, animations: {
            
            self.recordButton.alpha = 1
            
            }, completion: {Bool in
        })
    }
    
    
    
    func pocketsphinxDidReceiveHypothesis(hypothesis: String!, recognitionScore: String!, utteranceID: String!) {
        println("The received hypothesis is %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID)
    }
    
    func pocketsphinxDidStartListening() {
        println("Pocketsphinx is now listening.")
    }
    
    func pocketsphinxDidDetectSpeech() {
        println("Pocketsphinx has detected speech.")
    }
    
    func pocketsphinxDidDetectFinishedSpeech() {
        println("Pocketsphinx has detected a period of silence, concluding an utterance.")
    }
    
    func pocketsphinxDidStopListening() {
        println("Pocketsphinx has stopped listening.")
    }
    
    func pocketsphinxDidSuspendRecognition() {
        println("Pocketsphinx has suspended recognition.")
    }
    
    func pocketsphinxDidResumeRecognition() {
        println("Pocketsphinx has resumed recognition.")
    }
    
    func pocketsphinxDidChangeLanguageModelToFile(newLanguageModelPathAsString: String, newDictionaryPathAsString: String) {
        println("Pocketsphinx is now using the following language model: \(newLanguageModelPathAsString) and the following dictionary: \(newDictionaryPathAsString)")
    }
    
    func pocketSphinxContinuousSetupDidFailWithReason(reasonForFailure: String) {
        println("Listening setup wasn't successful and returned the failure reason: \(reasonForFailure)")
    }
    
    func pocketSphinxContinuousTeardownDidFailWithReason(reasonForFailure: String) {
        println("Listening teardown wasn't successful and returned the failure reason: \(reasonForFailure)")
    }
    
    
    func testRecognitionCompleted() {
        println("A test file that was submitted for recognition is now complete.")
    }

    
    
        /*
    func addWords() {
        //add any thing here that you want to be recognized. Must be in capital letters
        words.append("SUNDAY")
        words.append("MONDAY")
        words.append("TUESDAY")
        words.append("WEDNESDAY")
        words.append("THURSDAY")
        words.append("FRIDAY")
        words.append("SATURDAY")
        
        words.append("JANUARY")
        words.append("FEBRUARY")
        words.append("MARCH")
        words.append("APRIL")
        words.append("MAY")
        words.append("JUNE")
        words.append("JULY")
        words.append("AUGUST")
        words.append("SEPTEMBER")
        words.append("OCTOBER")
        words.append("NOVEMBER")
        words.append("DECEMBER")
        words.append("HI")
    } */

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

