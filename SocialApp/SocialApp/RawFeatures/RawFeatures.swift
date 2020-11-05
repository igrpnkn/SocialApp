//
//  RawFeatures.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 23.10.2020.
//

import Foundation
import UIKit

class CustomView: UIView {
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setStrokeColor(UIColor.red.cgColor)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 40, y: 20))
        path.addLine(to: CGPoint(x: 45, y: 40))
        path.addLine(to: CGPoint(x: 65, y: 40))
        path.addLine(to: CGPoint(x: 50, y: 50))
        path.addLine(to: CGPoint(x: 60, y: 70))
        path.addLine(to: CGPoint(x: 40, y: 55))
        path.addLine(to: CGPoint(x: 20, y: 70))
        path.addLine(to: CGPoint(x: 30, y: 50))
        path.addLine(to: CGPoint(x: 15, y: 40))
        path.addLine(to: CGPoint(x: 35, y: 40))
        path.close()
        path.stroke()
    }
}

class RawFeaturesController: UIViewController {
    
    //let myView = UIView()
    @IBOutlet weak var myView: UIView!
    var interactiveAnimation: UIViewPropertyAnimator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myView.frame.size = CGSize(width: 148, height: 148)
        self.myView.center = self.view.center
        let cv = CustomView(frame: CGRect(x: 24, y: 24, width: 100, height: 100))
        self.myView.addSubview(cv)
        
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(panAction(_:)))
        self.myView.addGestureRecognizer(recognizer)
    }
    
    @objc func panAction(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            interactiveAnimation = UIViewPropertyAnimator(duration: 5, curve: .linear, animations: {
                self.myView.frame = self.myView.frame.offsetBy(dx: 0, dy: self.view.bounds.height)
            })
            interactiveAnimation.pauseAnimation()
        case .changed:
            let transition = recognizer.translation(in: self.myView)
            interactiveAnimation.fractionComplete = transition.y / self.view.bounds.height
        case .ended:
            interactiveAnimation.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        default:
            return
        }
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        animationOfRotation()
    }
    
    func animateIt() {
        UIView.animateKeyframes(withDuration: 5 , delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25, animations: {
                self.myView.center.y += 100
            })
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25, animations: {
                self.myView.center.x -= 100
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.25, animations: {
                self.myView.center.y -= 100
            })
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25, animations: {
                self.myView.center.x += 100
            })
        }, completion: nil)
    }
    
    func animateGroup() {
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 5
        animationGroup.fillMode = .forwards
        animationGroup.autoreverses = false
        animationGroup.isRemovedOnCompletion = true
        animationGroup.repeatCount = 0
        animationGroup.timingFunction = CAMediaTimingFunction(controlPoints: 0.1, 0.8, 0.9, 1)
        //animationGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        
        let transition = CABasicAnimation(keyPath: "position.y")
        transition.toValue = 100
        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.toValue = 0
        let cornerRadius = CABasicAnimation(keyPath: "cornerRadius")
        cornerRadius.toValue = myView.frame.width/2
        
        animationGroup.animations = [transition, opacity, cornerRadius]
        self.myView.layer.add(animationGroup, forKey: nil)
    }
    
    func animatePath() {
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.fromValue = 0
        pathAnimation.toValue = 1
        
        
    }
    
    func animationOfRotation() {
        
        let rotation = CATransform3DMakeRotation(CGFloat(Double.pi), 1, 0, 0)
        let scale = CATransform3DMakeScale(0.5, 0.5, 1)
        let concat = CATransform3DConcat(rotation, scale)
        
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseInOut], animations: {
            self.myView.transform = CATransform3DGetAffineTransform(concat)
        }, completion: nil)
        
        
    }
    
}


class ViewControllerWithZoom: UIViewController {
    
    var fullScreenScrollView: FullScreenScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullScreenScrollView = FullScreenScrollView(frame: view.bounds)
        view.addSubview(fullScreenScrollView)
        setupFullScreenScrollView()
        
        //let imagePath = Bundle.main.path(forResource: "guy", ofType: "png")!
        let image = UIImage(named: "guy5")!
        self.fullScreenScrollView.set(image: image)
    }
    
    func setupFullScreenScrollView() {
        fullScreenScrollView.translatesAutoresizingMaskIntoConstraints = false
        fullScreenScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        fullScreenScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        fullScreenScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        fullScreenScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    
}
