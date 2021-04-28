//
//  ViewController.swift
//  EyeGazingImplementation
//
//  Created by Edwin Niwarlangga on 27/04/21.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet weak var orangeView: UIView!
    @IBOutlet weak var greenView: UIView!
    @IBOutlet var sceneView: ARSCNView!
//    var faceNode = SCNNode()
    var greenFrame = CGRect()
    var orangeFrame = CGRect()
//    var leftEyeNode = SCNNode()
//    var rightEyeNode = SCNNode()
    var timer = 5
    
    func resetTimer(){
        self.timer = 5
    }
    var leftEyeNode: SCNNode = {
        let geometry = SCNCone(topRadius: 0.005, bottomRadius: 0, height: 0.1)
        geometry.radialSegmentCount = 3
        geometry.firstMaterial?.diffuse.contents = UIColor.red
        let node = SCNNode()
        node.geometry = geometry
        node.eulerAngles.x = -.pi / 2
        node.position.z = 0.1
        let parentNode = SCNNode()
        parentNode.addChildNode(node)
        return parentNode
    }()

    var rightEyeNode: SCNNode = {
        let geometry = SCNCone(topRadius: 0.005, bottomRadius: 0, height: 0.1)
        geometry.radialSegmentCount = 3
        geometry.firstMaterial?.diffuse.contents = UIColor.blue
        let node = SCNNode()
        node.geometry = geometry
        node.eulerAngles.x = -.pi / 2
        node.position.z = 0.1
        let parentNode = SCNNode()
        parentNode.addChildNode(node)
        return parentNode
    }()
    var points: [CGPoint] = []
    var endPointLeftEye: SCNNode = {
        let node = SCNNode()
        node.position.z = 2
        return node
    }()

    var endPointRightEye: SCNNode = {
        let node = SCNNode()
        node.position.z = 2
        return node
    }()
    
    var nodeInFrontOfScreen: SCNNode = {

        let screenGeometry = SCNPlane(width: 1, height: 1)
        screenGeometry.firstMaterial?.isDoubleSided = true
        screenGeometry.firstMaterial?.fillMode = .fill
        screenGeometry.firstMaterial?.diffuse.contents = UIColor.green.withAlphaComponent(0.5)

        let node = SCNNode()
        node.geometry = screenGeometry
        return node
    }()

    let crosshair = Crosshair(size: .init(width: 50, height: 50))
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("Face tracking is not supported on this device")
        }
        sceneView.delegate = self
        setupView()
        
//        setupEyeNode()
        sceneView.pointOfView?.addChildNode(nodeInFrontOfScreen)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getFrame()
        print("GREEN : \(self.greenFrame.origin.x) :: \(self.greenFrame.origin.y)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARFaceTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func getFrame(){
        self.greenFrame = CGRect(origin: greenView.center, size: CGSize(width: greenView.frame.width, height: greenView.frame.height))
        self.orangeFrame = CGRect(origin: orangeView.center, size: CGSize(width: orangeView.frame.width, height: orangeView.frame.height))
//        self.greenFrame = CGRect(x: greenView.frame.midX, y: greenView.frame.midY, width: greenView.frame.width, height: greenView.frame.height)
        
//        self.orangeFrame = CGRect(x: self.orangeView.frame.midX, y: self.orangeView.frame.midY, width: self.orangeView.frame.width, height: self.orangeView.frame.height)
    }
    
    
//    func setupEyeNode(){
//
//
//        //1. Create A Node To Represent The Eye
//        let eyeGeometry = SCNCone(topRadius: 0.005, bottomRadius: 0, height: 0.1)
//        eyeGeometry.materials.first?.diffuse.contents = UIColor.cyan
//        eyeGeometry.radialSegmentCount = 3
//        eyeGeometry.materials.first?.transparency = 0.5
//
//        //2. Create A Holder Node & Rotate It So The Gemoetry Points Towards The Device
//        let node = SCNNode()
//        node.geometry = eyeGeometry
//        node.eulerAngles.x = -.pi / 2
//        node.position.z = 0.1
//
//        //3. Create The Left & Right Eyes
//        leftEyeNode = node.clone()
//        rightEyeNode = node.clone()
//
//    }
    
    fileprivate func setupView() {
        view.addSubview(crosshair)
        crosshair.center = view.center
    }
    
    fileprivate func setNewPoint(_ point: CGPoint) {
        points.append(point)
        points = points.suffix(50).map {$0}

        print("POINT : \(point)")
        print("GRREN FRAME : \(greenFrame)")
        print("GRREN FRAME : \(orangeFrame)")
//        print("GRREN FRAME : \(greenFrame.midX)")
//        print("GRREN FRAME : \(greenFrame.midY)")
        
        DispatchQueue.main.async {
            self.crosshair.center = self.points.average()
            
            UIView.animate(withDuration: 0.5, animations: {
                if(self.greenFrame.contains(point)){
                    self.orangeView.backgroundColor = UIColor.orange
                    self.greenView.backgroundColor = UIColor.blue
                    print("You touch this GREEN, Game over!")
                    
                }
                
                if(self.orangeFrame.contains(point)){
                    self.greenView.backgroundColor = UIColor.green
                    self.orangeView.backgroundColor = UIColor.red
                    print("You touch this ORANGE, Game over!")
                    self.timer = self.timer + 1
                }
            })
            
        }
        
       
    }


}


extension ViewController: ARSCNViewDelegate {

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {

        guard let device = sceneView.device else {
            return nil
        }

        let faceGeometry = ARSCNFaceGeometry(device: device)
        let node = SCNNode(geometry: faceGeometry)
        node.geometry?.firstMaterial?.fillMode = .lines

        node.addChildNode(leftEyeNode)
        leftEyeNode.addChildNode(endPointLeftEye)
        node.addChildNode(rightEyeNode)
        rightEyeNode.addChildNode(endPointRightEye)

        return node
    }
    
//    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//
//        //1. Setup The FaceNode & Add The Eyes
//        faceNode = node
//        faceNode.addChildNode(leftEyeNode)
//        faceNode.addChildNode(rightEyeNode)
//        faceNode.transform = node.transform
//
//    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {

        guard let faceAnchor = anchor as? ARFaceAnchor,
            let faceGeometry = node.geometry as? ARSCNFaceGeometry else {
                return
        }

        leftEyeNode.simdTransform = faceAnchor.leftEyeTransform
        rightEyeNode.simdTransform = faceAnchor.rightEyeTransform

        faceGeometry.update(from: faceAnchor.geometry)
        hitTest()
    }
}

extension ViewController{
    func hitTest() {

        var leftEyeLocation = CGPoint()
        var rightEyeLocation = CGPoint()

        let leftEyeResult = nodeInFrontOfScreen.hitTestWithSegment(from: endPointLeftEye.worldPosition,
                                                          to: leftEyeNode.worldPosition,
                                                          options: nil)

        let rightEyeResult = nodeInFrontOfScreen.hitTestWithSegment(from: endPointRightEye.worldPosition,
                                                          to: rightEyeNode.worldPosition,
                                                          options: nil)
        
//        print("LEFT : \(leftEyeResult.count) :: RIGHT : \(rightEyeResult.count)")
        if leftEyeResult.count > 0 || rightEyeResult.count > 0 {

            guard let leftResult = leftEyeResult.first, let rightResult = rightEyeResult.first else {
                return
            }

            leftEyeLocation.x = CGFloat(leftResult.localCoordinates.x) / (Constants.Device.screenSize.width / 2) *
                Constants.Device.frameSize.width
            leftEyeLocation.y = CGFloat(leftResult.localCoordinates.y) / (Constants.Device.screenSize.height / 2) *
                Constants.Device.frameSize.height

            rightEyeLocation.x = CGFloat(rightResult.localCoordinates.x) / (Constants.Device.screenSize.width / 2) *
                Constants.Device.frameSize.width
            rightEyeLocation.y = CGFloat(rightResult.localCoordinates.y) / (Constants.Device.screenSize.height / 2) *
                Constants.Device.frameSize.height

            let point: CGPoint = {
                var point = CGPoint()
                let pointX = ((leftEyeLocation.x + rightEyeLocation.x) / 2)
                let pointY = -(leftEyeLocation.y + rightEyeLocation.y) / 2

                point.x = pointX.clamped(to: Constants.Ranges.widthRange)
                point.y = pointY.clamped(to: Constants.Ranges.heightRange)
                return point
            }()

            setNewPoint(point)
        }
    }
}

extension Collection where Element == CGPoint {
    func average() -> CGPoint {
        let point = self.reduce(CGPoint(x: 0, y: 0)) { (result, point) -> CGPoint in
            result.add(point: point)
        }
        return point.divide(by: self.count)
    }
}
extension CGPoint {
    func add(point: CGPoint) -> CGPoint {
        return CGPoint(x: self.x + point.x, y: self.y + point.y)
    }

    func divide(by: Int) -> CGPoint {
        let denominator = CGFloat(by)
        return CGPoint(x: self.x / denominator, y: self.y / denominator)
    }
}

struct Constants {

    struct Device {
        static let screenSize = CGSize(width: 0.0623908297, height: 0.135096943231532)
        static let frameSize = CGSize(width: 375, height: 812)
    }

    struct Ranges {
        static let widthRange: ClosedRange<CGFloat> = (0...Device.frameSize.width)
        static let heightRange: ClosedRange<CGFloat> = (0...Device.frameSize.height)
    }

    struct Colors {
        static let crosshairColor: UIColor = .white
    }
}

extension CGFloat {

    func clamped(to: ClosedRange<CGFloat>) -> CGFloat {
        return to.lowerBound > self ? to.lowerBound
            : to.upperBound < self ? to.upperBound
            : self
    }
}
