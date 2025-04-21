//
//  NewsCell.swift
//  NewsApp
//
//  Created by Telegey Nurbekova on 17/04/25.
//

import UIKit

class NewsCell: UITableViewCell {
    
    static let identifier = "NewsCell"

    private let previewImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 8
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 12)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 2
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        contentView.addSubview(previewImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            previewImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            previewImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            previewImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            previewImageView.heightAnchor.constraint(equalToConstant: 180),
            
            titleLabel.topAnchor.constraint(equalTo: previewImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: previewImageView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: previewImageView.trailingAnchor),
            
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            authorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            dateLabel.centerYAnchor.constraint(equalTo: authorLabel.centerYAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: previewImageView.trailingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: previewImageView.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    func configure(with item: NewsItem) {
        titleLabel.text = item.title ?? "Без заголовка"
        descriptionLabel.text = item.description
        authorLabel.text = item.creator?.first ?? "Без автора"
        dateLabel.text = formatDate(item.pubDate)

        previewImageView.image = nil

        if let urlString = item.image_url, let url = URL(string: urlString) {
            loadImage(from: url)
        } else {
            previewImageView.image = UIImage(systemName: "photo")
        }
    }

    private func formatDate(_ isoDate: String?) -> String {
        guard let iso = isoDate else { return "" }
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: iso) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            displayFormatter.timeStyle = .none
            return displayFormatter.string(from: date)
        }
        return iso
    }

    private func loadImage(from url: URL) {
        let currentURL = url
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, url == currentURL {
                DispatchQueue.main.async {
                    self.previewImageView.image = UIImage(data: data)
                }
            }
        }.resume()
    }
}
