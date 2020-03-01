//
//  MyViewController.swift
//  MyProduct
//
//  Created by 王雪慧 on 2020/1/15.
//  Copyright © 2020 王雪慧. All rights reserved.
//

import UIKit
import AVKit
import PiPhone
import SnapKit

class MyViewController: BaseViewController {

    let urls = ["http://vfx.mtime.cn/Video/2019/02/04/mp4/190204084208765161.mp4",
    "http://vfx.mtime.cn/Video/2019/03/21/mp4/190321153853126488.mp4"]
    
    var playBtn: UIButton!
    var containerView: UIView!
    
    var topPresentedViewController: UIViewController {
        var viewController: UIViewController = self
        
        while let vc = viewController.presentedViewController {
            viewController = vc
        }
        
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "我的"
        
        createPlayBtn()
        createContainerView()
        
        if !PiPManager.isSettedUp {
            containerView.isUserInteractionEnabled = false
            containerView.alpha = 0.6
        }
        
        PiPManager.contentInsetAdjustmentBehavior = .navigationAndTabBars
    }
    
    func constructPlayer() -> AVPlayer {
        let playerItems = urls.compactMap(URL.init(string:)).map(AVPlayerItem.init)
        
        return AVQueuePlayer(items: playerItems)
    }
    
    func createPlayBtn() {
        playBtn = UIButton(type: .custom)
        playBtn.frame = .zero
        playBtn.setTitle("播放视频", for: .normal)
        playBtn.setTitleColor(.systemBlue, for: .normal)
        playBtn.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
        playBtn.backgroundColor = .clear
        self.view.addSubview(playBtn)
        
        playBtn.snp.makeConstraints { (make) in
            make.top.equalTo(200)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
    }
    
    func createContainerView() {
        containerView = UIView(frame: .zero)
        containerView.backgroundColor = .clear
        self.view.addSubview(containerView)
        
        containerView.snp.makeConstraints { (make) in
            make.top.equalTo(playBtn.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(170)
            make.height.equalTo(40)
        }
        
        let pipLbl = UILabel(frame: .zero)
        pipLbl.text = "是否开启画中画:"
        pipLbl.font = UIFont.systemFont(ofSize: 14)
        pipLbl.backgroundColor = .clear
        containerView.addSubview(pipLbl)
        
        pipLbl.snp.makeConstraints { (make) in
            make.left.centerY.height.equalToSuperview()
            make.width.equalTo(110)
        }
        
        let pipSwitch = UISwitch(frame: .zero)
        pipSwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        pipSwitch.isOn = true
        pipSwitch.backgroundColor = .clear
        containerView.addSubview(pipSwitch)
        
        pipSwitch.snp.makeConstraints { (make) in
            make.right.centerY.equalToSuperview()
            make.left.equalTo(pipLbl.snp.right).offset(5)
        }
    }
    
    @objc
    func playVideo() {
        let playCtr = CustomPlayerViewController()
        playCtr.delegate = self
        playCtr.player = constructPlayer()
        navigationController?.pushViewController(playCtr, animated: true)
    }

    @objc
    func switchValueChanged(_ switchView: UISwitch) {
        PiPManager.isPictureInPicturePossible = switchView.isOn
    }
    
}

// MARK: - CustomPlayerViewControllerDelegate
extension MyViewController: CustomPlayerViewControllerDelegate {
    
    func customPlayerViewController(_ customPlayerViewController: CustomPlayerViewController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        
        if navigationController!.viewControllers.firstIndex(of: customPlayerViewController) != nil {
            completionHandler(true)
        } else {
            navigationController!.pushViewController(customPlayerViewController, animated: true)
            completionHandler(true)
            
            if let tabCtr = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
                tabCtr.selectedIndex = 1
            }
        }
    }

}
