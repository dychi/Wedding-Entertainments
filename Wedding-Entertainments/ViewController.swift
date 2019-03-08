//
//  ViewController.swift
//  Wedding-Entertainments
//
//  Created by Daichi Yamaoka on 2019/03/08.
//  Copyright © 2019 Daichi Yamaoka. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    // Settings for ARWorldTrackingConfiguration
    let defaultConfiguration: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.environmentTexturing = .automatic
        return configuration
    }()
    
    // ??
    lazy var pictureTableNode: SCNNode = {
        let scene = SCNScene(named: "art.scnassets/pictureTable.scn")!
        let node = scene.rootNode.childNode(withName: "tableNode", recursively: false)!
        node.name = "tablePictureNode"
        
        // 写真のnode
        let picture = SCNBox(width: 0.5, height: 0.5, length: 0.01, chamferRadius: 0)
        picture.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "my-photo")
        let pictureNode = SCNNode(geometry: picture)
        
        // frameに貼る
        let frameNode = node.childNode(withName: "frame", recursively: true)
        frameNode?.addChildNode(pictureNode)
        
        node.scale = SCNVector3(x: 0.3, y: 0.3, z: 0.3)
        return node
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        // Show feature points
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Run the view's session
        sceneView.session.run(defaultConfiguration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: sceneView),
            let horizontalHit = sceneView.hitTest(location,
                                                  types: .existingPlaneUsingExtent).first else {
                return
        }
        // let float3 = horizontalHit.worldTransform.transpose()
        // let position = SCNVector3(float3)
        let position = SCNVector3.init(horizontalHit.worldTransform.columns.3.x,
                                       horizontalHit.worldTransform.columns.3.y,
                                       horizontalHit.worldTransform.columns.3.z)
        pictureTableNode.position = position
        
        // カメラの方向を向かせる
        if let camera = sceneView.pointOfView {
            pictureTableNode.eulerAngles.y = camera.eulerAngles.y
        }
        sceneView.scene.rootNode.addChildNode(pictureTableNode)
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
}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
    }
}
