//
//  PostCell.swift
//  TaskSample
//
//  Created by 이시원 on 11/9/23.
//

import UIKit

import SnapKit

final class PostCell: UITableViewCell {
    
    private let VStack = UIStackView()
    private let topHStack = UIStackView()
    private let bottomHStack = UIStackView()
    private let dot1 = UILabel()
    private let dot2 = UILabel()
    
    fileprivate let noticeBadge = Badge.notice
    fileprivate let replyBadge = Badge.reply
    fileprivate let newBadge = Badge.new
    fileprivate let titleLabel = UILabel()
    fileprivate let clipIcon = UIImageView(image: MIcon.clip)
    fileprivate let eyeIcon = UIImageView(image: MIcon.eye)
    fileprivate let writerLabel = UILabel()
    fileprivate let dateLabel = UILabel()
    fileprivate let readCountLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        backgroundColor = .white
        
        VStack.then {
            $0.alignment = .leading
            $0.axis = .vertical
            $0.addArrangedSubview(topHStack)
            $0.addArrangedSubview(bottomHStack)
        }
        
        topHStack.then {
            $0.spacing = 4
            $0.alignment = .center
            $0.addArrangedSubview(noticeBadge)
            $0.addArrangedSubview(replyBadge)
            $0.addArrangedSubview(titleLabel)
            $0.addArrangedSubview(clipIcon)
            $0.addArrangedSubview(newBadge)
        }
        
        bottomHStack.then {
            $0.spacing = 2
            $0.alignment = .center
            $0.addArrangedSubview(writerLabel)
            $0.addArrangedSubview(dot1)
            $0.addArrangedSubview(dateLabel)
            $0.addArrangedSubview(dot2)
            $0.addArrangedSubview(eyeIcon)
            $0.addArrangedSubview(readCountLabel)
        }
        
        titleLabel.then {
            $0.font = MFont.bold_16
            $0.textColor = MColor.chocolate700
        }
        
        
        writerLabel.then {
            $0.font = MFont.thin_12
            $0.textColor = MColor.gray500
        }
        
        dot1.then {
            $0.text = "•"
            $0.font = MFont.medium_14
            $0.textColor = MColor.gray500
        }
        
        dot2.then {
            $0.text = "•"
            $0.font = MFont.medium_14
            $0.textColor = MColor.gray500
        }
        
        dateLabel.then {
            $0.font = MFont.thin_12
            $0.textColor = MColor.gray500
        }
        
        readCountLabel.then {
            $0.font = MFont.thin_12
            $0.textColor = MColor.gray500
        }
        
    }
    
    private func layout() {
        addSubview(VStack)
        VStack.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview().inset(16)
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        newBadge.isHidden = false
        clipIcon.isHidden = false
        replyBadge.isHidden = false
        noticeBadge.isHidden = false
    }
    
    func setContent(post: Post, dateFormatter: DateFormatter, searchItem: SearchItem?) {
       
        
        if let date = dateFormatter.date(from: String(post.createdDateTime.prefix(10))) {
            dateLabel.text = dateFormatter.string(from: date)
        }
        
        titleLabel.text = post.title
        if let item = searchItem {
            let attributedStr = NSMutableAttributedString(string: titleLabel.text!)
            attributedStr.addAttribute(.foregroundColor, value: MColor.orange500, range: (titleLabel.text! as NSString).range(of: item.keyword))
            titleLabel.attributedText = attributedStr
        }
        
        writerLabel.text = post.isAnonymous ? "익명" : post.writer.name
        readCountLabel.text = "\(post.viewCount)"
        newBadge.isHidden = !post.isNewPost
        clipIcon.isHidden = post.attachmentsCount == 0
        switch post.postType {
        case .notice:
            replyBadge.isHidden = true
        case .reply:
            noticeBadge.isHidden = true
        case .normal:
            replyBadge.isHidden = true
            noticeBadge.isHidden = true
        }
    }
    
}
