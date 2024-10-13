//
//  MHBodyLabel.swift
//  MovieHunter
//
//  Created by Shamil Bayramli on 08.08.24.
//

import UIKit

class MHBodyLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init (textAlignment: NSTextAlignment, color: UIColor)
    {
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        self.textColor = color
        configure()
    }
    
    func configure()
    {
        font                                      = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontSizeToFitWidth                 = true
        minimumScaleFactor                        = 0.75
        lineBreakMode                             = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints = false
    }
}
