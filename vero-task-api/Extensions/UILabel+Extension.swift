//
//  UILabel+Extension.swift
//  vero-task-api
//
//  Created by Bertay Yönel on 1.01.2024.
//

import UIKit

extension UILabel {

    func heightForLabel(withConstrainedWidth width: CGFloat) -> CGFloat {
            let labelSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
            let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]

            let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: self.font ?? UIFont.systemFont(ofSize: 17.0)]

            let rect = self.text?.boundingRect(with: labelSize, options: options, attributes: attributes, context: nil) ?? CGRect.zero

            return ceil(rect.height)
        }
}
