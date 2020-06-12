//
//  HomeExVC.swift
//  iOS-Design-Project
//
//  Created by 이주혁 on 2020/05/24.
//  Copyright © 2020 이주혁. All rights reserved.
//

import UIKit

class HomeExVC: UIViewController {
    /// 상단 Banner
    var ProductInformation:[ProductData] = []
    
    var urls:[URL] = []
    var rankingName:[String] = []
    func searchGET(){
        
    }

    func dataRequest(){
        HomeService.shared.setUI() { networkResult in
            switch networkResult {
            case .success(let resultData):
                
                guard let data=resultData as? [ProductData] else {
                    return}
                for index in 0..<data.count {
                    self.urls.append(data[index].bannerimg)
                }
                print(self.urls)
                self.ProductInformation = data
                self.setUpUI()
                self.setUpBannerView(item: self.ProductInformation.count)
            case .pathErr : print("Patherr")
            case .serverErr : print("ServerErr")
            case .requestErr(let message) : print(message)
            case .networkFail:
                print("networkFail")
            }
        }
    }
    @IBOutlet weak var Banner: UIView!
    private var bannerView:BannerView!
    private func setUpUI() {
        bannerView = BannerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width*(197.0/375.0)))
        self.Banner.addSubview(bannerView)
        print(bannerView.frame)
        bannerView.backgroundColor = UIColor.green
        Banner.frame = bannerView.frame
    }
    private func setUpBannerView(item:Int) {
      
        bannerView.reloadData(configuration: nil, numberOfItems: item) { (bannerView, index) -> (UIView) in
           
           return self.itemView(at: index)
        }
    }
    private func itemView(at index:Int)->UIImageView {
            let itemImageView:UIImageView = UIImageView(frame: .zero)
            itemImageView.translatesAutoresizingMaskIntoConstraints = false
            itemImageView.setImage(path: self.urls[index])
            itemImageView.clipsToBounds = true
            itemImageView.contentMode = UIView.ContentMode.scaleToFill
            itemImageView.isUserInteractionEnabled=true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(buttonTapped(i:)))
            itemImageView.addGestureRecognizer(tapGestureRecognizer)
            return itemImageView
    }
    @objc func buttonTapped(i:Int){
        
    }
    ///로켓시리즈
    @IBAction func roketDiliveryButton(_ sender: Any) {
        print("로켓배송 클릭")
    }
    @IBAction func roketFreshButton(_ sender: Any) {
        print("로켓프레쉬 클릭")
    }
    @IBAction func roketOverseaButton(_ sender: Any) {
        print("로켓직구 클릭")
    }
    ///카테고리 베너
    
    @IBOutlet weak var Category: UIView!
    @IBOutlet weak var CategoryCollectionView: UICollectionView!
    //@IBOutlet weak var CategoryScroll: UIScrollView!
    @IBOutlet weak var CategoryPageControl: UIPageControl!
    
    private var first_page_categoryImageInformation:[String]=[]

    
    private func setCategoryInformation(){
        first_page_categoryImageInformation=["iconBeauty","iconBook","iconCook","iconDigital","iconFashion","iconHealth","iconOffice","iconSport","iconSupply","iconTicket","iconBook","","iconCook","","iconDigital","","iconFashion","","iconBeauty",""]
        self.CategoryCollectionView.delegate = self
        self.CategoryCollectionView.dataSource = self
        self.CategoryCollectionView.showsHorizontalScrollIndicator = false
        self.Category.layer.shadowColor = UIColor.black.cgColor
        self.CategoryCollectionView.tag = 1
        let layout = self.CategoryCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let width = floor(self.view.frame.width / 5)-8
        let height = width
        layout.itemSize = CGSize(width: width, height:height)
        
    }
/// 인기검색어
    
    @IBOutlet weak var RankingCollectionView: UICollectionView!
    @IBOutlet weak var RankingViewHeight: NSLayoutConstraint!
    @IBOutlet weak var RankLabel: UILabel!
    @IBOutlet weak var RankItemLabel: UILabel!
    var toggle:Bool = true
    @IBOutlet weak var buttonImg: UIButton!
    @IBOutlet weak var Ranking: UIView!
    @IBAction func RankButton(_ sender: Any) {
        if toggle {
            HomeService.shared.getRank(){ networkResult in
                switch networkResult{
                case .success(let rank):
                    guard let data=rank as? [Rank] else {
                        return}
                    for index in 0..<data.count {
                        self.rankingName.append(data[index].name)
                    }
                    self.RankItemLabel.text = self.rankingName[0]
                    self.setRankInfo()
                case .pathErr : print("Patherr")
                case .serverErr : print("ServerErr")
                case .requestErr(let message) : print(message)
                case .networkFail:
                    print("networkFail")
                }
            }
            //self.RankingViewHeight.constant = self.Ranking.frame.size.height * 5
            self.RankingViewHeight.constant = 26 * 5
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
            buttonImg.setImage(UIImage(named: "iconRealtimeMore"), for: .normal)
            RankLabel.alpha = 0
            RankItemLabel.alpha = 0
        }
        else {
            buttonImg.setImage(UIImage(named: "iconRealtimeMore2"), for: .normal)
            self.RankingViewHeight.constant = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
            RankLabel.alpha = 1
            RankItemLabel.alpha = 1
            
        }
        toggle = !toggle
    }
    
    
    
    private func setRankInfo(){
        RankingCollectionView.delegate = self
        RankingCollectionView.dataSource = self
        RankingCollectionView.tag = 3
    }

    
///아래 콜렉션뷰
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var ProductCollectionView: UICollectionView!
    
    private func setProductInformation(){
        ProductCollectionView.delegate = self
        ProductCollectionView.dataSource = self
        ProductCollectionView.tag = 2
    }
    private var headerLabel:[String] = ["@@@님의 추천상품","로켓프레시","오늘의 특가"]
    
/// 뷰디드로드
    override func viewDidLoad() {
        super.viewDidLoad()
        dataRequest()

        setCategoryInformation()
        setProductInformation()
        //setRankInfo()
        collectionViewHeight.constant = ProductCollectionView.frame.height * 3
        // Do any additional setup after loading the view.

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension HomeExVC:UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView.tag == 2{

            return 3
        }
        else {return 1}
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1{return first_page_categoryImageInformation.count}
        else if collectionView.tag == 3 {
            return self.rankingName.count
        }
        else { return 1}
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int(targetContentOffset.pointee.x / 300)
        self.CategoryPageControl.currentPage = page
    }
}

extension HomeExVC:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView.tag == 1 {
        let cell:CategoryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
            cell.categoryImageView.image = UIImage(named: first_page_categoryImageInformation[indexPath.row * (indexPath.section+1)])

        return cell
        }
        else if collectionView.tag == 2{
            switch indexPath.section {
            default:
                let productCell : ProductCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as! ProductCollectionViewCell
                productCell.sectionNumber = indexPath.section
                return productCell
            }
        }
        else {
            let cell:RankingCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: RankingCollectionViewCell.identifier, for: indexPath) as! RankingCollectionViewCell
            cell.RankLabel.text = String(indexPath.row + 1)
            cell.itemLabel.text = rankingName[indexPath.row]
            if indexPath.row > 2{
                cell.RankLabel.textColor = UIColor.black
            }
            else {
                cell.RankLabel.textColor = UIColor(red: 78.0 / 255.0, green: 167.0 / 255.0, blue: 224.0 / 255.0, alpha: 1.0)

            }
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print(indexPath)
        if collectionView.tag == 3 {
            //print("상품 id : " + String(self.ProductInformation[indexPath.row].id))
            //print("상품 이름 : " + String(self.ProductInformation[indexPath.row].name))
            //print("상품 가격 : " + String(self.ProductInformation[indexPath.row].price))
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexpath:IndexPath) ->UICollectionReusableView{

        var header : ProductCollectionViewHeader!
        if kind == UICollectionView.elementKindSectionHeader
        {
            header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headercell", for: indexpath) as? ProductCollectionViewHeader
            switch indexpath.section {
            case 0:
                header?.name.text = "@@@님의 추천상품"
                header?.sectionNumber = 0
            case 1:
                header?.name.text = "로켓프레쉬"
                header?.sectionNumber = 1
            case 2:
                header?.name.text = "오늘의 특가"
                header.sectionNumber = 2
            default:
                header?.layer.borderWidth=0.5
            }
        }
        return header!
    }
}
extension HomeExVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView.tag == 1 {
            return UIEdgeInsets(top: 0, left: 8,bottom: 0, right: 8)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView.tag == 1 {return 8}
        else if collectionView.tag == 3{ return 0 }
        else {return 0}
    }
}

extension UIImageView {
    func setImage(path:URL) {
       let url = path
        DispatchQueue.global(qos: .background).async {
            guard let data:Data = try? Data(contentsOf: url) , let image:UIImage = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
/*extension HomeExVC:UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage:Int = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        if currentPage == 0 {
            self.CategoryScroll.contentOffset = CGPoint(x: scrollView.frame.size.width * CGFloat(2), y: scrollView.contentOffset.y)
        }
        else if currentPage == 2 {
            self.CategoryScroll.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y)
        }
        self.CategoryPageControl.currentPage = currentPage
    }
}
*/
