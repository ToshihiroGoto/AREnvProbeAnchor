//
//  ViewController.swift
//  AREnvProbeAnchor
//
//  Created by Toshihiro Goto on 2018/08/09.
//  Copyright © 2018年 Toshihiro Goto. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    let sphereGeo = SCNSphere(radius: 0.06)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        
        
        //
        sphereGeo.firstMaterial?.lightingModel = .physicallyBased
        sphereGeo.firstMaterial?.metalness.contents = NSNumber(value: 1.0)
        sphereGeo.firstMaterial?.roughness.contents = NSNumber(value: 0.0)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.environmentTexturing = .manual
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        
        setProbeAnchor()
        
    }
    
    
    func setProbeAnchor() {
        
        let basePosition = simd_float3(0, 0.25, -1.0)
        
        
        if let camera = sceneView.pointOfView {
            
            let putPosition = camera.simdConvertPosition(basePosition, to: nil)
            let position = simd_float4x4(
                float4( 1,  0,  0, 0),
                float4( 0,  1,  0, 0),
                float4( 0,  0,  1, 0),
                float4(putPosition.x, putPosition.y, putPosition.z, 1)
            )
            
            let probeAnchor = AREnvironmentProbeAnchor(name: "probe", transform: position, extent: float3(1, 1, 1))
            sceneView.session.add(anchor: probeAnchor)
            
            let probeNode = SCNNode(geometry: sphereGeo)
            probeNode.simdTransform = position
            sceneView.scene.rootNode.addChildNode(probeNode)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
//    var probeAnchorFlag = false
//
//    func session(_ session: ARSession, didUpdate frame: ARFrame) {
//        if !probeAnchorFlag {
//            session.add(anchor: probeAnchor_L_minusZ)
//            session.add(anchor: probeAnchor_L_plusZ)
//            session.add(anchor: probeAnchor_R_minusZ)
//            session.add(anchor: probeAnchor_R_plusZ)
//            probeAnchorFlag = true
//        }
//    }
    
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
