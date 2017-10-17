//
//  ViewController.swift
//  monkey
//
//  Created by Risa KAKAZU on 2017/10/04.
//  Copyright © 2017年 Risa KAKAZU. All rights reserved.
//

//
//// Create a new scene
//let scene = SCNScene(named: "art.scnassets/ship.scn")!
//
//// Set the scene to the view
//self.sceneView.scene = scene

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // デバッグ時用オプション
        // ARKitが感知しているところに「+」がいっぱい出てくるようになる
        sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
        
        let scene = SCNScene()
        sceneView.scene = scene
        
        addTapGesture()

    }
    
    func addTapGesture() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func tapped(recognizer: UIGestureRecognizer) {
        let sceneView = recognizer.view as! ARSCNView
        let touchLocation = recognizer.location(in: sceneView)
        
        let hitTestResult = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
        if !hitTestResult.isEmpty {
            if let hitResult = hitTestResult.first {
                addBox(hitResult :hitResult)
            }
        }
    }
    
    func addBox(hitResult: ARHitTestResult) {
//        let boxGeometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
//        let material = SCNMaterial()
//        material.diffuse.contents = UIImage(named: "block")
//        boxGeometry.materials = [material]
//        
//        let boxNode = SCNNode(geometry: boxGeometry)
//        
//        boxNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: boxGeometry, options: [:]))
//        boxNode.physicsBody?.categoryBitMask = 1
//        // タップした位置より20cm上から落下させる
//        boxNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y + 0.05 , hitResult.worldTransform.columns.3.z)
        
     let treeScene = SCNScene(named: "art.scnassets/ship.scn")!
        let treeNode = treeScene.rootNode.childNode(withName: "tree", recursively: true)
       // treeNode?.position = SCNVector3(0, -1, -2)
        treeNode?.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        treeNode?.physicsBody?.restitution = 0
        treeNode?.physicsBody?.damping = 1
        treeNode?.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y + Float(0.01), hitResult.worldTransform.columns.3.z)
        //treeNode?.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y + 0.10 , hitResult.worldTransform.columns.3.z)
  

       // sceneView.scene = scene
        sceneView.scene.rootNode.addChildNode(treeNode!)
        //sceneView.scene.rootNode.addChildNode(boxNode)
    }
    
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal // <= 平面の検出を有効化する
        sceneView.session.run(configuration)

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

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                // 平面を表現するノードを追加する
                node.addChildNode(PlaneNode(anchor: planeAnchor) )
                
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor, let planeNode = node.childNodes[0] as? PlaneNode {
                // ノードの位置及び形状を修正する
                planeNode.update(anchor: planeAnchor)
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
}
