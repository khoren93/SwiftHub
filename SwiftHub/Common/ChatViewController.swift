//
//  ChatViewController.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 5/7/19.
//  Copyright © 2019 Khoren Markosyan. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import RxSwift

class ChatViewController: MessagesViewController {

    var messages: [MessageType] = [] {
        didSet {
            self.messagesCollectionView.reloadData()
        }
    }

    let sendPressed = PublishSubject<String>()

    let senderSelected = PublishSubject<SenderType>()
    let mentionSelected = PublishSubject<String>()
    let hashtagSelected = PublishSubject<String>()
    let urlSelected = PublishSubject<URL>()

    let currentUser = User.currentUser()

    /// The object that manages autocomplete, from InputBarAccessoryView
    lazy var autocompleteManager: AutocompleteManager = { [unowned self] in
        let manager = AutocompleteManager(for: self.messageInputBar.inputTextView)
        manager.delegate = self
        manager.dataSource = self
        return manager
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        makeUI()
        bindViewModel()
    }

    func makeUI() {
        configureMessageCollectionView()
        configureMessageInputBar()
        configureAutocomplete()
    }

    func bindViewModel() {

    }

    func configureAutocomplete() {
        // Configure AutocompleteManager
        autocompleteManager.register(prefix: "@", with: [
            .font: UIFont.preferredFont(forTextStyle: .body),
            .foregroundColor: UIColor.secondary(),
            .backgroundColor: UIColor.secondary().withAlphaComponent(0.1)
        ])

        autocompleteManager.register(prefix: "#")
        autocompleteManager.maxSpaceCountDuringCompletion = 1 // Allow for autocompletes with a space

        // Set plugins
        messageInputBar.inputPlugins = [autocompleteManager]

        autocompleteManager.defaultTextAttributes = [.font: UIFont.preferredFont(forTextStyle: .callout), .foregroundColor: UIColor.text()]

        autocompleteManager.tableView.theme.backgroundColor = themeService.attribute { $0.primaryDark }
    }

    func configureMessageCollectionView() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self

        scrollsToLastItemOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true

        view.theme.backgroundColor = themeService.attribute { $0.primaryDark }
        messagesCollectionView.theme.backgroundColor = themeService.attribute { $0.primaryDark }
    }

    func configureMessageInputBar() {
        messageInputBar.delegate = self
        messageInputBar.inputTextView.keyboardType = .twitter
        messageInputBar.inputTextView.cornerRadius = Configs.BaseDimensions.cornerRadius

        messageInputBar.backgroundView.theme.backgroundColor = themeService.attribute { $0.primary }
        messageInputBar.inputTextView.theme.backgroundColor = themeService.attribute { $0.primaryDark }
        messageInputBar.theme.tintColor = themeService.attribute { $0.secondary }
        messageInputBar.sendButton.theme.titleColor(from: themeService.attribute { $0.secondary }, for: .normal)
        messageInputBar.sendButton.theme.titleColor(from: themeService.attribute { $0.secondaryDark }, for: .highlighted)
        messageInputBar.separatorLine.theme.backgroundColor = themeService.attribute { $0.separator }
        messageInputBar.inputTextView.theme.keyboardAppearance = themeService.attribute { $0.keyboardAppearance }
    }

    // MARK: - Helpers

    func isPreviousMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section - 1 >= 0 else { return false }
        return (messages[indexPath.section].sender as? User) == (messages[indexPath.section - 1].sender as? User)
    }

    func isNextMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section + 1 < messages.count else { return false }
        return (messages[indexPath.section].sender as? User) == (messages[indexPath.section + 1].sender as? User)
    }
}

extension ChatViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return currentUser ?? User()
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }

    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1).bold,
            NSAttributedString.Key.foregroundColor: UIColor.secondary()
        ])
    }

    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let dateString = message.sentDate.toRelative(since: nil)
        return NSAttributedString(string: dateString, attributes: [
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2),
            NSAttributedString.Key.foregroundColor: UIColor.text()
        ])
    }
}

extension ChatViewController: MessageCellDelegate {

    func didTapAvatar(in cell: MessageCollectionViewCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell),
            let message = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView) else {
                return
        }
        senderSelected.onNext(message.sender)
    }

    func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell),
            let message = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView) else {
                return
        }
        senderSelected.onNext(message.sender)
    }
}

extension ChatViewController: MessageLabelDelegate {
    func didSelectURL(_ url: URL) {
        urlSelected.onNext(url)
    }

    func didSelectMention(_ mention: String) {
        mentionSelected.onNext(mention)
    }

    func didSelectHashtag(_ hashtag: String) {
        hashtagSelected.onNext(hashtag)
    }
}

extension ChatViewController: InputBarAccessoryViewDelegate {

    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        sendPressed.onNext(text)
    }
}

extension ChatViewController: MessagesDisplayDelegate {

    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? UIColor.text() : UIColor.text()
    }

    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedString.Key: Any] {
        return [.foregroundColor: UIColor.secondary()]
    }

    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return [.url, .address, .phoneNumber, .date, .transitInformation, .mention, .hashtag]
    }

    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? UIColor.primary().darken(by: 0.15) : UIColor.primary()
    }

    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let tail: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(tail, .curved)
    }

    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        if let user = message.sender as? User {
            avatarView.isHidden = isNextMessageSameSender(at: indexPath)
            avatarView.kf.setImage(with: user.avatarUrl?.url)
            avatarView.borderColor = .secondary()
            avatarView.borderWidth = Configs.BaseDimensions.borderWidth
        }
    }
}

extension ChatViewController: MessagesLayoutDelegate {

    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 10
    }

    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }

    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }

    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 22
    }
}

extension ChatViewController: AutocompleteManagerDataSource {
    func autocompleteManager(_ manager: AutocompleteManager, autocompleteSourceFor prefix: String) -> [AutocompleteCompletion] {
        switch prefix {
        case "@": return messages.map { $0.sender as? User }
            .withoutDuplicates()
            .map { AutocompleteCompletion(text: $0?.displayName ?? "", context: ["avatar": $0?.avatarUrl ?? ""]) }
        default: return []
        }
    }

    func autocompleteManager(_ manager: AutocompleteManager, tableView: UITableView, cellForRowAt indexPath: IndexPath, for session: AutocompleteSession) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AutocompleteCell.reuseIdentifier, for: indexPath) as? AutocompleteCell else {
            fatalError("Oops, some unknown error occurred")
        }
        let image = session.completion?.context?["avatar"] as? String
        cell.imageView?.kf.setImage(with: image?.url)
        cell.imageViewEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        cell.imageView?.cornerRadius = 20
        cell.imageView?.borderColor = .secondary()
        cell.imageView?.borderWidth = Configs.BaseDimensions.borderWidth
        cell.imageView?.clipsToBounds = true
        let attributedText = manager.attributedText(matching: session, fontSize: 15)
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.text(), range: NSRange(location: 0, length: attributedText.length))
        cell.textLabel?.attributedText = attributedText
        cell.backgroundColor = UIColor.primary()
        cell.separatorLine.backgroundColor = UIColor.separator()
        return cell
    }
}

extension ChatViewController: AutocompleteManagerDelegate {
    func autocompleteManager(_ manager: AutocompleteManager, shouldBecomeVisible: Bool) {
        setAutocompleteManager(active: shouldBecomeVisible)
    }

    // MARK: - AutocompleteManagerDelegate Helper
    func setAutocompleteManager(active: Bool) {
        let topStackView = messageInputBar.topStackView
        if active && !topStackView.arrangedSubviews.contains(autocompleteManager.tableView) {
            topStackView.insertArrangedSubview(autocompleteManager.tableView, at: topStackView.arrangedSubviews.count)
            topStackView.layoutIfNeeded()
        } else if !active && topStackView.arrangedSubviews.contains(autocompleteManager.tableView) {
            topStackView.removeArrangedSubview(autocompleteManager.tableView)
            topStackView.layoutIfNeeded()
        }
        messageInputBar.invalidateIntrinsicContentSize()
    }
}
