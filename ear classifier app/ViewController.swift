import UIKit
import AVFoundation
import Vision

class ViewController: CaptureViewController {

    @IBOutlet weak private var previewView: UIView!
    private var requests = [VNRequest]()

    // Define the classificationResult label with Auto Layout
    let classificationResult = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.setupAVCapture(previewView)
        
        setupViews()
        setupClassifier()
        startCaptureSession()
    }
    
    func getClassifierRequestResults(_ results: [Any]) {
        var maxObs: VNClassificationObservation?
        if let Obses = results as? [VNClassificationObservation] {
            maxObs = Obses.max { $0.confidence < $1.confidence }
        }
        
        guard let objectObservation = maxObs else {
            return
        }
        
        self.classificationResult.text = objectObservation.confidence > 0.97 ? "I am \(String(format: "%.2f", (objectObservation.confidence*100)))% sure this is a \(objectObservation.identifier)." : "--"
    }
    
    func setupViews() {
        // Add the classificationResult label to the view
        self.view.addSubview(self.classificationResult)

        // Increase font size and adjust alignment
        classificationResult.font = UIFont.systemFont(ofSize: 20)  // Change size as needed
        classificationResult.textAlignment = .center
        classificationResult.numberOfLines = 0  // Allow multiple lines if needed
        
        classificationResult.textColor = .black
        
        // Set up Auto Layout constraints
        classificationResult.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            classificationResult.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            classificationResult.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 150), // Push it down by 150 points
            classificationResult.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40),
            classificationResult.heightAnchor.constraint(equalToConstant: 50) // Increase height to accommodate larger font
        ])
    }

    func setupClassifier() {
        guard let modelURL = Bundle.main.url(forResource: "earClassifier", withExtension: "mlmodelc") else {
            return
        }
        do {
            let model = try! earClassifier(contentsOf: modelURL)
            let visionModel = try VNCoreMLModel(for: model.model)
            classificationResult.text = ""
            let objectRecognition = VNCoreMLRequest(model: visionModel, completionHandler: { (request, error) in
                DispatchQueue.main.async(execute: {
                    if let results = request.results {
                        self.getClassifierRequestResults(results)
                    }
                })
            })
            objectRecognition.imageCropAndScaleOption = .scaleFit
            self.requests = [objectRecognition]
        } catch let error as NSError {
            print("Model loading went wrong: \(error)")
        }
    }
    
    override func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let reqOrientation = reqOrientationFromDeviceOrientation()
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: reqOrientation, options: [:])
        do {
            try imageRequestHandler.perform(self.requests)
        } catch {
            print(error)
        }
    }
}


