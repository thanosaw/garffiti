//
//  ViewController.swift
//  ARBrush
//

import UIKit
import SceneKit
import ARKit
import simd
import Photos

//class ParamButton: UIButton{
//    var params: Dictionary<String, Any>
//    override init(frame: CGRect) {
//        self.params = [:]
//        super.init(frame: frame)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        self.params = [:]
//        super.init(coder: aDecoder)
//    }
//}

func getRoundyButton(size: CGFloat = 100,
                     imageName : String,
                     _ color : UIColor) -> UIButton {
    let button = UIButton(frame: CGRect.init(x: 0, y: 0, width: size, height: size))
    button.clipsToBounds = true
    button.layer.cornerRadius = 10
    button.tintColor = color
    
    
    let mediumConfig = UIImage.SymbolConfiguration(pointSize: size, weight: .regular, scale: .medium)
    let mediumIcon = UIImage(systemName: imageName, withConfiguration: mediumConfig)
    button.setImage(mediumIcon, for: .normal)

    return button

}


extension URL {
    
    static func documentsDirectory() -> URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
        
    }
}

extension String {

    // Python-y formatting:  "blah %i".format(4)
    func format(_ args: CVarArg...) -> String {
        return NSString(format: self, arguments: getVaList(args)) as String
    }
    
}

extension UIColor {
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let coreImageColor = self.coreImageColor
        return (coreImageColor.red, coreImageColor.green, coreImageColor.blue, coreImageColor.alpha)
    }
}

@available(iOS 13.0, *)
class ViewController: UIViewController, ARSCNViewDelegate, UIGestureRecognizerDelegate, UIColorPickerViewControllerDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    let vertBrush = VertBrush()
    var buttonDown = false
    
    var clearDrawingButton : UIButton!
    var colorButton : UIButton!
    
    var frameIdx = 0
    var splitLine = false
    var lineRadius : Float = 0.001
    
    var metalLayer: CAMetalLayer! = nil
    var hasSetupPipeline = false
    
    var videoRecorder : MetalVideoRecorder? = nil
    
    var tempVideoUrl : URL? = nil
    
    var currentColor : SCNVector3 = SCNVector3(1,0.5,0)
    
    // smooth the pointer position a bit
    var avgPos : SCNVector3! = nil
    
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        // This tends to conflict with the rendering
        //sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/world.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        
        metalLayer = self.sceneView.layer as? CAMetalLayer
        
        metalLayer.framebufferOnly = false
        
        addButtons()
        
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(tapHandler))
        tap.minimumPressDuration = 0
        tap.cancelsTouchesInView = false
        tap.delegate = self
        self.sceneView.addGestureRecognizer(tap)
        
        
        PHPhotoLibrary.requestAuthorization { status in
            print(status)
        }
        
    }
    
    var recordingOrientation : UIInterfaceOrientationMask? = nil
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let orientation = recordingOrientation {
            return orientation
        } else {
            return .all
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
    
    var touchLocation : CGPoint = .zero
    
    // called by gesture recognizer
    @objc func tapHandler(gesture: UITapGestureRecognizer) {
        
        // handle touch down and touch up events separately
        if gesture.state == .began {
            
            self.touchLocation = self.sceneView.center
            buttonTouchDown()
            
        } else if gesture.state == .ended { // optional for touch up event catching
            
            buttonTouchUp()
            
        } else if gesture.state == .changed {
            
            if buttonDown {
                // You can use this to draw with touch location rather than
                // center screen
                //self.touchLocation = gesture.location(in: self.sceneView)
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func addButtons() {
        clearDrawingButton = getRoundyButton(size: 30, imageName: "trash", UIColor.white)
        clearDrawingButton.addTarget(self, action:#selector(self.clearDrawing), for: .touchUpInside)
        self.view.addSubview(clearDrawingButton)
        
        colorButton = getRoundyButton(size: 35, imageName: "pencil", UIColor.white)
        colorButton.addTarget(self, action:#selector(self.pickColor), for: .touchUpInside)
        self.view.addSubview(colorButton)
    }
    
    override func viewDidLayoutSubviews() {
        let sw = self.view.bounds.size.width
       // let sh = self.view.bounds.size.height
        let ySafe = self.view.safeAreaInsets.top
        
        let off : CGFloat = 50
        clearDrawingButton.center = CGPoint(x: off, y: ySafe)
        
        colorButton.center = CGPoint(x: sw - off, y: ySafe)
    }
    
    // MARK: - Buttons
    
    @objc func pickColor() {
        Haptics.strongBoom()
        let colorPickerVC = UIColorPickerViewController()
        colorPickerVC.delegate = self
        present(colorPickerVC, animated: true)
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
//        let color = viewController.selectedColor
//        let rgb = color.components
//        self.currentColor = SCNVector3(rgb.red, rgb.green, rgb.blue)
//        colorButton.tintColor = color
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        let rgb = color.components
        self.currentColor = SCNVector3(rgb.red, rgb.green, rgb.blue)
        colorButton.tintColor = color
    }

    @objc func saveDrawing() {
        Haptics.strongBoom()
        // Save drawing into FireBase here:
    }

    
    @objc func setBrushMode() {
        
        Haptics.strongBoom()
        
    }
    
    @objc func clearDrawing() {
        
        Haptics.threeWeakBooms()
        vertBrush.clear()
    }
    
    // MARK: - Touch
    @objc func buttonTouchDown() {
        splitLine = true
        buttonDown = true
        avgPos = nil
        
//        let pointer = getPointerPosition()
//        if pointer.valid {
//            self.addBall(pointer.pos)
//        }
        
    }
    @objc func buttonTouchUp() {
        buttonDown = false
    }
    
    // MARK: - ARSCNViewDelegate
    
    // Test mixing with scenekit content
    func addBall( _ pos : SCNVector3 ) {
        let b = SCNSphere(radius: 0.01)
        b.firstMaterial?.diffuse.contents = UIColor.red
        let n = SCNNode(geometry: b)
        n.worldPosition = pos
        self.sceneView.scene.rootNode.addChildNode(n)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        let pointer = getPointerPosition()
        
        if avgPos == nil {
            avgPos = pointer.pos
        }
        
        avgPos = avgPos - (avgPos - pointer.pos) * 0.4;
        
        if ( buttonDown ) {
            
            if ( pointer.valid ) {
                
                if ( vertBrush.points.count == 0 || (vertBrush.points.last! - pointer.pos).length() > 0.001 ) {
                    
                    var radius : Float = 0.001
                    
                    if ( splitLine || vertBrush.points.count < 2 ) {
                        lineRadius = 0.001
                    } else {
                        
                        let i = vertBrush.points.count-1
                        let p1 = vertBrush.points[i]
                        let p2 = vertBrush.points[i-1]
                        
                        radius = 0.001 + min(0.015, 0.005 * pow( ( p2-p1 ).length() / 0.005, 2))
                        
                    }
                    
                    lineRadius = lineRadius - (lineRadius - radius)*0.075
                    
                    let color : SCNVector3 = self.currentColor
                    
                    vertBrush.addPoint(avgPos,
                                       radius: lineRadius,
                                       color: color,
                                       splitLine:splitLine)
                    
                    if ( splitLine ) { splitLine = false }
                    
                }
                
            }
            
        }
        
        
        frameIdx = frameIdx + 1
        
    }
    
    
    
    func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
        

        if ( !hasSetupPipeline ) {
            // pixelFormat is different if called at viewWillAppear
            hasSetupPipeline = true
            
            vertBrush.setupPipeline(device: sceneView.device!, renderDestination: self.sceneView! )
        }
        
        guard let frame = self.sceneView.session.currentFrame else {
            return
        }
        
        if let commandQueue = self.sceneView?.commandQueue {
            if let encoder = self.sceneView.currentRenderCommandEncoder {
                
                let projMat = float4x4.init((self.sceneView.pointOfView?.camera?.projectionTransform)!)
                let modelViewMat = float4x4.init((self.sceneView.pointOfView?.worldTransform)!).inverse
                
                vertBrush.updateSharedUniforms(frame: frame)
                vertBrush.render(commandQueue, encoder, parentModelViewMatrix: modelViewMat, projectionMatrix: projMat)
                
                
            }
        }
        
        
        
        // This is not the right way to do this ..
        // seems to work though
        DispatchQueue.global(qos: .userInteractive).async {

            if let recorder = self.videoRecorder,
                recorder.isRecording {

                if let tex = self.metalLayer.nextDrawable()?.texture {
                    recorder.writeFrame(forTexture: tex)
                }
            }
        }
        
    }
    

    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    // MARK: -
    
    func getPointerPosition() -> (pos : SCNVector3, valid: Bool, camPos : SCNVector3 ) {
        
        // Un-project a 2d screen location into ARKit world space using the 'unproject'
        // function. 
        
        guard let pointOfView = sceneView.pointOfView else { return (SCNVector3Zero, false, SCNVector3Zero) }
        guard let currentFrame = sceneView.session.currentFrame else { return (SCNVector3Zero, false, SCNVector3Zero) }
        
        let cameraPos = SCNVector3(currentFrame.camera.transform.translation)
        
        let touchLocationVec = SCNVector3(x: Float(touchLocation.x), y: Float(touchLocation.y), z: 0.01)
        
        let screenPosOnFarClippingPlane = self.sceneView.unprojectPoint(touchLocationVec)
        
        let dir = (screenPosOnFarClippingPlane - cameraPos).normalized()
        
        let worldTouchPos = cameraPos + dir * 0.12

        return (worldTouchPos, true, pointOfView.position)
        
    }
    
}
