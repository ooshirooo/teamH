//
//  ViewController.swift
//  bird4
//
//  Created by yuka kiyuna on 2017/10/20.
//  Copyright © 2017年 RyukyuUniversity. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //sceneオブジェクトを作成
        let scene = SCNScene()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let url = Bundle.main.url(forResource: "bird4", withExtension: "dae")!
        
        //daeを別のシーンとして読み込む，読み込んだ時点では表示されない
        let scene_source = SCNSceneSource(url:url, options:nil)
        guard let bird_scene = scene_source?.scene(options: nil) else {
            //読み込み失敗
            fatalError("daeファイル読み込み失敗")
        }
 
        let bird = bird_scene.rootNode.childNode(withName: "bluj_body", recursively: true)!
        
        let w1 = SCNNode(), w2 = SCNNode()
        w1.addChildNode(bird.clone())
        w2.addChildNode(bird.clone())
        
        //重ならないように動かしてみる
        w2.position = SCNVector3(1,0,0)

        //現在のシーンに追加．アニメーションが設定されていれば，自動で再生開始
        scene.rootNode.addChildNode(w1)
        scene.rootNode.addChildNode(w2)
        
        guard let sceneView = self.sceneView else {
            fatalError()
        }
        
        // Set the scene to the view
        sceneView.scene = scene
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target:self, action: #selector(ViewController.handleTap(sender:)))
        sceneView.addGestureRecognizer(tapGesture)
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

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
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
    
func handleTap(sender: UITapGestureRecognizer) {
        guard let view = self.sceneView else { //scnViewが存在することを保証(同時にアンラップ)
            return
        }
        if sender.state == .ended { //タップし終えたか？
            
            //タップ位置を取得
            let loc = sender.location(in: self.sceneView)
            //３Dオブジェクトに対するヒットテスト（どのgeometryをタップしたか？）
            let results = view.hitTest(loc)
            
            //結果は配列で返る．一つ以上ヒットしていればアニメーションを再生する
            if let res = results.first  {
                res.node.ctrlAnimationOfAllChildren(do_play: true)
            }
        }
}

