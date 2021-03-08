//
//  NewsCellFactory.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 08.03.2021.
//

import Foundation
import UIKit

final class NewsCellFactory {
    
    enum CellIdentifier: String {
        case header = "NewsHeaderTableViewCell"
        case text = "NewsTextTableViewCell"
        case media = "NewsMediaTableViewCell"
        case footer = "NewsFooterTableViewCell"
        case stock = "NewsTableViewCell"
    }

    init() {
    }
    
    func buildCell(for identifier: CellIdentifier, _ news: News?, _ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        switch identifier {
        case .header:
            return makeHeaderCell(for: news, tableView, indexPath)
        case .text:
            return makeTextCell(for: news, tableView, indexPath)
        case .media:
            return makeMediaCell(for: news, tableView, indexPath)
        case .footer:
            return makeFooterCell(for: news, tableView, indexPath)
        case .stock:
            return makeStockCell(tableView, indexPath)
        }
    }
    
}

extension NewsCellFactory {
    
    private func makeHeaderCell(for news: News?, _ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.header.rawValue, for: indexPath) as! NewsHeaderTableViewCell
        cell.configureCell(avatar: news?.avatar, author: news?.author, time: news?.time)
        return cell
    }
    
    private func makeTextCell(for news: News?, _ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.text.rawValue, for: indexPath) as! NewsTextTableViewCell
        cell.configureCell(text: news?.text)
        return cell
    }
    
    private func makeMediaCell(for news: News?, _ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.media.rawValue, for: indexPath) as! NewsMediaTableViewCell
        cell.imagesArray = news?.photos
        cell.mediaCollectionView.reloadData()
        return cell
    }
    
    private func makeFooterCell(for news: News?, _ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.footer.rawValue, for: indexPath) as! NewsFooterTableViewCell
        cell.configureCell(likes: news?.likeCount, comments: news?.commentCount, reviews: news?.reviewCount, userLiked: news?.liked)
        cell.likeButton.tag = indexPath.section
        return cell
    }
    
    private func makeStockCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.stock.rawValue, for: indexPath) as! NewsTableViewCell
        return cell
    }
    
}
