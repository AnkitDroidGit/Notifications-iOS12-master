//
//  ViewController.swift
//  NotificationTester
//
//  Created by Ankit Kumar on 09/06/18.
//  Copyright © 2018 Ankit Kumar. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    private var stackView: UIStackView!
    var podcastNotificationButton: UIButton!
    private var podcastName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stackView = UIStackView(frame: view.frame)
        stackView?.distribution = .fillProportionally
        stackView?.alignment = .center
        stackView?.axis = .vertical
        stackView.spacing = 20
        stackView?.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)
        stackView?.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        podcastName = "Cogitator"

        podcastNotificationButton = UIButton(type: .roundedRect)
        podcastNotificationButton.backgroundColor = UIColor.black
        podcastNotificationButton.setTitleColor(.white, for: .normal)
        podcastNotificationButton.setTitle("Send dance notification", for: .normal)
        podcastNotificationButton.addTarget(self, action: #selector(sendPodcastNotification(sender:)), for: .touchUpInside)

        stackView.addArrangedSubview(podcastNotificationButton)
    }

    @objc func sendPodcastNotification(sender: UIButton) {
        guard let podcastName = podcastName else { return }

        let content = UNMutableNotificationContent()
        content.body = "Introducing Season 7"
        content.title = "New episode of \(podcastName):"
        content.threadIdentifier = podcastName.lowercased()
        content.summaryArgument = podcastName
        content.categoryIdentifier = NotificationCategoryType.podcast.rawValue


        guard let pathUrlForPodcastImg = Bundle.main.url(forResource: "startup", withExtension: "png") else { return }
        let imgAttachment = try! UNNotificationAttachment(identifier: "image", url: pathUrlForPodcastImg, options: nil)

        guard let pathUrlForButtonNormal = Bundle.main.url(forResource: "heart-outline", withExtension: "png") else { return }
        let buttonNormalStateImgAtt = try! UNNotificationAttachment(identifier: "button-normal-image", url: pathUrlForButtonNormal, options: nil)

        guard let pathUrlForButtonHighlighted = Bundle.main.url(forResource: "heart-filled", withExtension: "png") else { return }
        let buttonHighlightStateImgAtt = try! UNNotificationAttachment(identifier: "button-highlight-image", url: pathUrlForButtonHighlighted, options: nil)

        content.attachments = [imgAttachment, buttonNormalStateImgAtt, buttonHighlightStateImgAtt]
        sendNotification(with: content)
    }

    func sendNotification(with content: UNNotificationContent) {
        let uuid = UUID().uuidString
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
