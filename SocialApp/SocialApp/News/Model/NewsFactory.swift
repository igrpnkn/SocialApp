//
//  NewsFactory.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 08.03.2021.
//

import Foundation

class NewsFactory {
    
    private var newsFeed: [News]
    //private var news: News?
    
    init() {
        self.newsFeed = []
    }
    
    func buildNewsFeed(parsedJSON: PostResponse) -> [News] {
        for item in parsedJSON.items! {
            var news = News()
            news = matchPostAuthor(parsedJSON: parsedJSON, id: item.source_id!, news: news)
            news.time = item.date
            news.liked = item.likes?.user_likes
            news.likeCount = item.likes?.count
            news.reviewCount = item.views?.count
            news.commentCount = item.comments?.count
            news.text = item.text
            news = fillAttachedPhotosURL(attachments: item.attachments, news: news)
            print("\nINFO: \(#function) News posted by \(news.author) has \(news.photosURL?.count ?? 0)")
            newsFeed.append(news)
        }
        return self.newsFeed
    }
    
    private func matchPostAuthor(parsedJSON: PostResponse, id: Int, news: News) -> News {
        if id < 0 {
            let author = parsedJSON.groups?.filter({ $0.id == (-1 * id) })
            news.author = author?.first?.name ?? ""
            news.avatarURL = author?.first?.photo_50
            return news
        } else {
            let author = parsedJSON.profiles?.filter({ $0.id == id })
            news.author = ((author?.first?.first_name ?? "") + " " + (author?.first?.last_name ?? ""))
            news.avatarURL = author?.first?.photo_50
            return news
        }
    }
    
    private func fillAttachedPhotosURL(attachments: [PostAttachment]?, news: News) -> News {
        guard let attachments = attachments else {
            print("\nINFO: ERROR - Guard detected that \(#function) has NIL value\n")
            return news
        }
        for attachment in attachments {
            if let attachedURL = attachment.photo?.sizes.filter { $0.type == "p" }.first {
                news.photosURL?.append(attachedURL.url!)
            } else {
                news.photosURL?.append(attachment.photo?.sizes.first?.url ?? "")
            }
        }
        return news
    }
    
}
