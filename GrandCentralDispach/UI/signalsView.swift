//
//  signalsView.swift
//  GrandCentralDispach
//
//  Created by Александр Коробицын on 10.11.2022.
//

import UIKit

class SygnalsView: UIView {

    let first = UIImageView()
    let second = UIImageView()
    let third = UIImageView()
    let fourth = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createSygnalsView()
    }
    
    private func createSygnalsView() {
        self.addSubview(first)
        self.addSubview(second)
        self.addSubview(third)
        self.addSubview(fourth)
        
        first.image = UIImage(named: "notActive" )
        second.image = UIImage(named: "notActive" )
        third.image = UIImage(named: "notActive" )
        fourth.image = UIImage(named: "notActive" )
        
        first.translatesAutoresizingMaskIntoConstraints = false
        second.translatesAutoresizingMaskIntoConstraints = false
        third.translatesAutoresizingMaskIntoConstraints = false
        fourth.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            first.widthAnchor.constraint(equalToConstant: 70),
            first.heightAnchor.constraint(equalToConstant: 70),
            first.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            first.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            second.widthAnchor.constraint(equalToConstant: 70),
            second.heightAnchor.constraint(equalToConstant: 70),
            second.leadingAnchor.constraint(equalTo: first.trailingAnchor),
            second.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
       
        NSLayoutConstraint.activate([
            third.widthAnchor.constraint(equalToConstant: 70),
            third.heightAnchor.constraint(equalToConstant: 70),
            third.leadingAnchor.constraint(equalTo: second.trailingAnchor),
            third.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            fourth.widthAnchor.constraint(equalToConstant: 70),
            fourth.heightAnchor.constraint(equalToConstant: 70),
            fourth.leadingAnchor.constraint(equalTo: third.trailingAnchor),
            fourth.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
