//
//  LottieViewController.swift
//  MyProduct
//
//  Created by 王雪慧 on 2020/2/29.
//  Copyright © 2020 王雪慧. All rights reserved.
//

import UIKit
import SnapKit
import Lottie

class LottieViewController: BaseViewController {

    let animationView = AnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Lottie动画"
        
        view.backgroundColor = .white
        
        createBtns()
        
        let animation = Animation.named("servishero_loading")

        animationView.bounds = CGRect(x: 0, y: 0, width: 400, height: 400)
        animationView.center = view.center
        animationView.animation = animation
        animationView.loopMode = .playOnce
        animationView.contentMode = .scaleAspectFit
        animationView.backgroundBehavior = .pauseAndRestore
        view.addSubview(animationView)
    }
    
    func createBtns() {
        let stopBtn = UIButton(type: .custom)
        stopBtn.frame = .zero
        stopBtn.backgroundColor = .clear
        stopBtn.setTitle("停止", for: .normal)
        stopBtn.setTitleColor(.systemBlue, for: .normal)
        stopBtn.addTarget(self, action: #selector(stop(_:)), for: .touchUpInside)
        self.view.addSubview(stopBtn)
        
        stopBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(30)
            make.bottom.equalToSuperview().offset(-20 - TabbarSafeBottomHeight())
        }
        
        let playBtn = UIButton(type: .custom)
        playBtn.frame = .zero
        playBtn.backgroundColor = .clear
        playBtn.setTitle("播放", for: .normal)
        playBtn.setTitleColor(.systemBlue, for: .normal)
        playBtn.addTarget(self, action: #selector(play(_:)), for: .touchUpInside)
        self.view.addSubview(playBtn)
        
        playBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(30)
            make.bottom.equalTo(stopBtn.snp.top).offset(-20)
        }
    }
    
    @objc
    func play(_ sender: Any) {
        animationView.play()
    }

    @objc
    func stop(_ sender: Any) {
        animationView.stop()
    }
    
}
