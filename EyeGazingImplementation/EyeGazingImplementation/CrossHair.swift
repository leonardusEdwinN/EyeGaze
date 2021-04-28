//
//  CrossHair.swift
//  EyeGazingImplementation
//
//  Created by Edwin Niwarlangga on 27/04/21.
//

import Foundation
import UIKit
import ARKit

class Crosshair: UIView {

    let crossRectOne: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors.crosshairColor
        return view
    }()

    let crossRectTwo: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors.crosshairColor
        return view
    }()

    init(size: CGSize) {
        super.init(frame: .zero)
        frame.size = size
        layer.cornerRadius = frame.width / 2
        backgroundColor = UIColor.init(white: 0, alpha: 0.2)

        setupViews()
    }

    func setupViews() {

        addSubview(crossRectOne)
        addSubview(crossRectTwo)

        crossRectOne.contraintToCenter()
        crossRectOne.constraintToConstants(top: 5, bottom: 5)
        crossRectOne.contraintSize(width: frame.width/12)

        crossRectTwo.contraintToCenter()
        crossRectTwo.constraintToConstants(leading: 5, trailing: 5)
        crossRectTwo.contraintSize(height: frame.width/12)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension UIView {

    func contraintToSuperView() {
        self.translatesAutoresizingMaskIntoConstraints = false

        if let superView = self.superview {
            self.topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
            self.leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
            self.trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
            self.bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        }
    }

    func contraintToCenter() {
        self.translatesAutoresizingMaskIntoConstraints = false

        if let superView = self.superview {
            self.centerXAnchor.constraint(equalTo: superView.centerXAnchor).isActive = true
            self.centerYAnchor.constraint(equalTo: superView.centerYAnchor).isActive = true
        }
    }

    func constraintHeightToSuperView() {
        self.translatesAutoresizingMaskIntoConstraints = false

        if let superView = self.superview {
            self.topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
            self.bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        }
    }

    func constraintToConstants(top: CGFloat? = nil, leading: CGFloat? = nil,
                               trailing: CGFloat? = nil, bottom: CGFloat? = nil) {
        self.translatesAutoresizingMaskIntoConstraints = false

        if let superView = self.superview {
            if let topConstant = top {
                self.topAnchor.constraint(equalTo: superView.topAnchor, constant: topConstant).isActive = true
            }

            if let leadingConstant = leading {
                self.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: leadingConstant).isActive = true
            }

            if let trailingConstant = trailing {
                self.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -trailingConstant).isActive = true
            }

            if let bottomConstant = bottom {
                self.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -bottomConstant).isActive = true
            }
        }
    }

    func contraintSize(width: CGFloat? = nil, height: CGFloat? = nil) {
        self.translatesAutoresizingMaskIntoConstraints = false

        if let widthConstant = width {
            self.widthAnchor.constraint(equalToConstant: widthConstant).isActive = true
        }

        if let heightConstant = height {
            self.heightAnchor.constraint(equalToConstant: heightConstant).isActive = true
        }
    }
}

extension ARSCNView {

    func contraintARSCNToSuperView() {
        self.translatesAutoresizingMaskIntoConstraints = false

        if let superView = self.superview {
            self.topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
            self.leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
            self.trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
            self.bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        }
    }
}
