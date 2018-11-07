//
//  ViewController.swift
//  2dParticleAnim
//
//  Created by Mikhail Zoline on 7/9/17.
//  Copyright © 2017 MZ. All rights reserved.
// 
/**
   A demo with a very simplistic behavior of 2d collisions between 2particles and screen bounds.
   Both particles are spawned with initial velocity and directions.
   The main loop is scheduled at an arbitrary rate of 30 frames per second.
   There is a keyframe animation of color change on collision between particles.
   Basically the demo mimics the behavious of spriteKit or cocos2d.
*/

import UIKit

// Initialisation constants
fileprivate let paRadius : CGFloat = 55.0
fileprivate let pbRadius : CGFloat = 45.0

fileprivate let paInitPosition = CGPoint(x: 275.0, y: 225.0)
fileprivate let pbInitPosition = CGPoint(x: 275.0, y: 75.0)

fileprivate let paInitialVelocity = CGVector(dx: 2.0, dy: 4.0)
fileprivate let pbInitialVelocity = CGVector(dx: 0.00, dy: 0.00)


class ParticleAnimController: UIViewController {
    
    var timer = Timer()
    var pA:CollisionParticle! = nil
    var pB:CollisionParticle! = nil

    var circleMode:Bool = false
    var aPath:UIBezierPath = UIBezierPath()
    var aLayer:CAShapeLayer = CAShapeLayer()
    var cRadius: Float = 60.0
    var pOne:CGPoint = CGPoint()
    var pTwo:CGPoint = CGPoint()
    
    let colorKeyframeAnimation = CAKeyframeAnimation(keyPath: "backgroundColor")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Init color animation of particles
        colorKeyframeAnimation.values = [UIColor.red.cgColor,
                                         UIColor.green.cgColor,
                                         UIColor.blue.cgColor,
                                         UIColor.orange.cgColor,
                                         UIColor.magenta.cgColor,
                                         UIColor.cyan.cgColor]
        colorKeyframeAnimation.keyTimes = [0, 0.5, 1, 1.5, 2, 2.5]
        colorKeyframeAnimation.duration = 3
        
        // Initialize the particles with raduis, position and velocity
        pA = CollisionParticle (with: paRadius, initialVelocity: paInitialVelocity, initialPosition: paInitPosition, color: UIColor.red, view: view)
        pB = CollisionParticle (with: pbRadius, initialVelocity: pbInitialVelocity, initialPosition: pbInitPosition, color: UIColor.blue, view: view)
        
        // Start Animation
        startTimer()
    }
    
        func startTimer(){
            
        // Run Animation Loop
        timer = Timer.scheduledTimer(timeInterval: 1/60, target: self, selector: #selector(ParticleAnimController.animation), userInfo: nil, repeats: true)
    }
    
    func stopTimer(){
        timer.invalidate()
    }
    
    //
    @objc func animation(){
        
        // Move A and B according to their velocities
        pA?.step()
        pB?.step()
        
        // Detect the collision between particle A and B and view frame
        if(pA != nil ){
            _ = intersectWithFrame(view.bounds, pA!)
        }
        if(pB != nil ){
            _ = intersectWithFrame(view.bounds, pB!)
        }
        
        // Detect the collision between particles
        if(pB != nil && pA != nil){
            let collision:Bool = intersectWithCircle(pB!,pA!)
            if collision {
                // start color animation
                if (pA?.pAnimated)! {
                    pA?.pAnimated = false
                    pB?.pAnimated = true
                    pA?.pImage.layer.removeAllAnimations()
                    pB?.pImage.layer.add(colorKeyframeAnimation, forKey: "colors")
                }
                else{
                    pB?.pAnimated = false
                    pA?.pAnimated = true
                    pB?.pImage.layer.removeAllAnimations()
                    pA?.pImage.layer.add(colorKeyframeAnimation, forKey: "colors")
                }
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
