//
//  ProductCollectionViewCell.swift
//  iOS-Design-Project
//
//  Created by 김태훈 on 2020/05/28.
//  Copyright © 2020 이주혁. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var InnerCollectionView: UICollectionView!
    static let identifier:String = "ProductCell"
    override func awakeFromNib() {
       super.awakeFromNib()
        setupViews()
       //custom logic goes here
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    private var badgeboolean : [Bool] = [false,false,false]
    private var badgeImgName : [String] = ["badgeRoketwow","badgeRoketfresh","badgeRoketdelivery"]
    private var ProductInformation:[[Product]] = []
    var sectionNumber:Int?
    func setupViews(){
        var recommend:[Product] = []
        var roketfresh:[Product] = []
        var todayprice:[Product] = []
        HomeService.shared.setUI() { networkResult in
            switch networkResult {
            case .success(let resultData):
                
                guard let data=resultData as? [ProductData] else {
                    return}
                for index in 0..<data.count {
                    let item = Product(imagname: data[index].img, name: data[index].name, price: data[index].price, bool: [data[index].wow,data[index].fresh, data[index].delivery])
                    recommend.append(item)
                    roketfresh.append(item)
                    todayprice.append(item)
                }
                self.ProductInformation=[recommend,roketfresh,todayprice]
                self.InnerCollectionView.delegate = self
                self.InnerCollectionView.dataSource = self
                
                
            case .pathErr : print("Patherr")
            case .serverErr : print("ServerErr")
            case .requestErr(let message) : print(message)
            case .networkFail:
                print("networkFail")
            }
        }
    }

}

extension ProductCollectionViewCell:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        ProductInformation[sectionNumber!].count
    }
}
extension ProductCollectionViewCell:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         collectionView.deselectItem(at: indexPath, animated: true)
        print("상품 이름 : " + ProductInformation[sectionNumber!][indexPath.row].ProductName)
        print("상품 가격 : " + ProductInformation[sectionNumber!][indexPath.row].ProductPrice + "원")
     }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell:InnerProductCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: InnerProductCollectionViewCell.identifier, for: indexPath) as! InnerProductCollectionViewCell
        cell.ProductImage.setImage(path: ProductInformation[sectionNumber!][indexPath.row].ProductImageName)
        cell.ProductName.text = ProductInformation[sectionNumber!][indexPath.row].ProductPrice + " 원"
        cell.ProductPrice.text = ProductInformation[sectionNumber!][indexPath.row].ProductName
        cell.ProductImage.contentMode = UIView.ContentMode.scaleAspectFill
        //cell.ProductImage.backgroundColor = UIColor.blue
        cell.ProductImage.frame.size = CGSize(width: 95, height: 121)
        var badgenum = 0
        for index in 0..<3 {
            if ProductInformation[sectionNumber!][indexPath.row].badgeBool[index] {
                let badgeFrame = CGRect(x: 5 + badgenum*23, y: 5, width: 23, height: 23)
                let badgeImg = UIImageView(frame: badgeFrame)
                badgeImg.image = UIImage(named: badgeImgName[index])
                cell.addSubview(badgeImg)
                badgenum = badgenum + 1
            }
        }
        return cell
    }
}
extension ProductCollectionViewCell:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 6.5, left: 11, bottom: 0, right: 11)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width : 95,height:165)
    }
}

