import UIKit
import Speech
import Foundation
//import NVActivityIndicatorView
import UniformTypeIdentifiers

class AiVoiceChanger: UIViewController, UIDocumentPickerDelegate {
    
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnFileRemove: UIButton!
    @IBOutlet weak var btnSelecteFile: UIButton!
    @IBOutlet weak var viewFileUpload: UIView!
    @IBOutlet weak var uploadFileIconImg: UIImageView!
    @IBOutlet weak var supportFormateLblText: UILabel!
    @IBOutlet weak var lblSelectedFileName: UILabel!
    @IBOutlet weak var imgSuccessIcon: UIImageView!
    //@IBOutlet weak var view_loader: NVActivityIndicatorView!
    
    var isExceededLimit: Bool = false
    var audioURL = URL(string: "")
    var accumulatedSpeech = "" // To hold the final sentence
    var selectedFileName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewFileUpload.layer.masksToBounds = true
        self.viewFileUpload.clipsToBounds = true
        self.viewFileUpload.layer.borderWidth = 1
        self.viewFileUpload.layer.cornerRadius = 8
        self.viewFileUpload.layer.borderColor = UIColor.gray.cgColor
        self.uploadFileIconImg.isHidden = false
        self.supportFormateLblText.isHidden = false
        self.lblSelectedFileName.isHidden = true
        self.imgSuccessIcon.isHidden = true
        self.btnFileRemove.isHidden = true
        self.btnContinue.isHidden = true
        self.btnSelecteFile.isHidden = false
    }
    
    // MARK: - UIDocumentPickerDelegate
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else {
            print("No file was selected.")
            self.lblSelectedFileName.isHidden = true
            self.supportFormateLblText.isHidden = false
            self.uploadFileIconImg.isHidden = false
            self.imgSuccessIcon.isHidden = true
            return
        }
        self.supportFormateLblText.isHidden = true
        self.uploadFileIconImg.isHidden = true
        // Check file size limit (e.g., 10 MB)
        let fileSizeLimit: Int64 = 10 * 1024 * 1024 // 10 MB in bytes
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: selectedFileURL.path)
            if let fileSize = fileAttributes[.size] as? Int64 {
                if fileSize > fileSizeLimit {
                    print("The file size exceeds the limit of 10 MB.")
                    isExceededLimit = true
                    self.btnFileRemove.isHidden = false
                    self.btnSelecteFile.isHidden = true
                    self.btnContinue.isHidden = true
                    self.lblSelectedFileName.isHidden = false
                    self.imgSuccessIcon.isHidden = false
                    self.lblSelectedFileName.text = "The file size exceeds the limit of 10 MB."
                    self.imgSuccessIcon.image = UIImage(systemName: "xmark.circle")
                    self.imgSuccessIcon.tintColor = .systemRed
                    self.viewFileUpload.borderColor = .systemRed
                    return
                }
                print("File is within the size limit.")
            }
        } catch {
            print("Failed to retrieve file attributes: \(error.localizedDescription)")
            self.lblSelectedFileName.isHidden = true
            self.supportFormateLblText.isHidden = false
            self.uploadFileIconImg.isHidden = false
            self.imgSuccessIcon.isHidden = true
            self.btnSelecteFile.isEnabled = false
            self.btnFileRemove.isHidden = false
            return
        }
        
        let fileName = selectedFileURL.lastPathComponent
        let filePath = selectedFileURL.path
        selectedFileName = fileName
        
        // Print file name and path
        print("File Name: \(fileName)")
        print("File Path: \(filePath)")
        self.audioURL = selectedFileURL
        isExceededLimit = false
        self.btnSelecteFile.isHidden = true
        self.btnContinue.isHidden = false
        self.imgSuccessIcon.tintColor = UIColor(named: "app_main_color")
        self.imgSuccessIcon.image = UIImage(systemName: "checkmark.circle")
        self.btnFileRemove.isHidden = false
        self.imgSuccessIcon.isHidden = true
        self.lblSelectedFileName.isHidden = false
        self.lblSelectedFileName.text = fileName
        // Hide upload icon and message
        self.supportFormateLblText.isHidden = true
        self.uploadFileIconImg.isHidden = true
        self.lblSelectedFileName.isHidden = true
        
        if isExceededLimit {
            self.btnContinue.isEnabled = false
        } else {
            self.btnContinue.isEnabled = true
            verifyAudioFileContainsSpeech(audioURL: audioURL!) { containsSpeech, detectedText in
                if containsSpeech {
                    print("The audio file contains speech: \(detectedText ?? "No text detected")")
                } else {
                    print("The audio file does not contain any speech.")
                }
            }
            
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("User canceled the document picker.")
    }
    
    
    @IBAction func onTappedBack(_ sender: Any) {
        Navigation.shared.gotoBack(from: self)
    }
    
    @IBAction func onTappedFileRemove(_ sender: Any) {
        self.viewFileUpload.layer.borderColor = UIColor.gray.cgColor
        self.btnFileRemove.isHidden = true
        self.btnSelecteFile.isEnabled = true
        self.btnSelecteFile.isHidden = false
        self.uploadFileIconImg.isHidden = true
        self.supportFormateLblText.isHidden = false
        self.uploadFileIconImg.isHidden = false
        self.lblSelectedFileName.isHidden = true
        self.imgSuccessIcon.isHidden = true
        self.isExceededLimit = false
    }
    
    @IBAction func onTappedUploadFileButton(_ sender: Any) {
        let audioTypes: [UTType] = [.mp3, .mpeg4Audio, .wav, .aiff]
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: audioTypes, asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
    
    @IBAction func onTappedContinue(_ sender: Any) {
        
    }
}

extension AiVoiceChanger {
    
    func verifyAudioFileContainsSpeech(audioURL: URL, completion: @escaping (Bool, String?) -> Void) {
        // Request speech recognition authorization
        SFSpeechRecognizer.requestAuthorization { authStatus in
            guard authStatus == .authorized else {
                print("Speech recognition authorization denied: \(authStatus)")
                completion(false, nil)
                return
            }
            
            // Initialize Speech Recognizer with English locale
            guard let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US")) else {
                print("Speech recognizer not available for English locale.")
                completion(false, nil)
                return
            }
            
            // Ensure the speech recognizer is available
            guard speechRecognizer.isAvailable else {
                print("Speech recognizer is currently unavailable.")
                completion(false, nil)
                return
            }
            
            // Create recognition request
            let recognitionRequest = SFSpeechURLRecognitionRequest(url: audioURL)
            
            // Start recognition task
            speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
                if let error = error {
                    print("Recognition error: \(error.localizedDescription)")
                    completion(false, nil)
                    return
                }
                self.imgSuccessIcon.isHidden = true
                
                //self.view_loader.isHidden = false
                //self.view_loader.type = .lineSpinFadeLoader
                //self.view_loader.color = UIColor(named: "app_main_color")!
                //self.view_loader.startAnimating()
                // Define a variable to accumulate the final detected text
                var accumulatedSpeech = ""
                
                // Process recognition result
                if let result = result {
                    let detectedText = result.bestTranscription.formattedString
                    
                    // Calculate progress percentage
                    let progress = Int((result.bestTranscription.segments.count * 100) / (result.bestTranscription.segments.count + 1))
                    print("Progress: \(progress)%")
                    self.imgSuccessIcon.isHidden = true
                    self.lblSelectedFileName.isHidden = false
                    self.lblSelectedFileName.text = "Progress: \(progress)%"
                    
                    if result.isFinal {
                        // Final result: Update the accumulated speech and return it
                        accumulatedSpeech += " " + detectedText
                        print("Final Speech Detected: \(accumulatedSpeech.trimmingCharacters(in: .whitespaces))")
                        completion(true, accumulatedSpeech.trimmingCharacters(in: .whitespaces))
                       // self.view_loader.stopAnimating()
                       // self.view_loader.isHidden = true
                        self.imgSuccessIcon.isHidden = false
                        self.lblSelectedFileName.isHidden = false
                        self.lblSelectedFileName.text = self.selectedFileName
                        
                        
                    } else {
                        // Intermediate result: Accumulate the detected text
                        accumulatedSpeech += " " + detectedText
                    }
                } else {
                    print("No result returned from recognition task.")
                    completion(false, nil)
                }
            }
            
            
        }
    }
    func processSpeech(_ newWord: String, isFinal: Bool) {
        if isFinal {
            // When speech recognition is complete, print the final accumulated sentence
            accumulatedSpeech += " " + newWord
            print("Final Speech Detected: \(accumulatedSpeech.trimmingCharacters(in: .whitespaces))")
            accumulatedSpeech = "" // Reset for the next recognition session
        } else {
            // Accumulate the intermediate words but don't print them
            accumulatedSpeech += " " + newWord
        }
    }
}
