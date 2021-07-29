//
//  IntroductionVC.swift
//  Repoush
//
//  Created by Apple on 23/12/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit
import ImageSlideshow
import ImageScrollView
class IntroductionVC: UIViewController {
   
    @IBOutlet var lblNext: UILabel!
    @IBOutlet var lblPrivious: UILabel!
    @IBOutlet var viewNext: UIView!
    @IBOutlet var viewPrivious: UIView!

    @IBOutlet weak var imageScrollView: ImageScrollView!
    @IBOutlet weak var pageController: UIPageControl!
    var images = [UIImage]()
    var index = 0
  
    var dict = Dictionary<String, String>()
    let localSource = [BundleImageSource(imageString: "screen1"), BundleImageSource(imageString: "screen2"), BundleImageSource(imageString: "screen3"), BundleImageSource(imageString: "screen4")]


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        for i in 0..<6 {
            if let image = UIImage(named: "screen\(i)") {
                images.append(image)
            }
        }
        print(images)

//        slideshow.slideshowInterval = 20.0
//        slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
//        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
//
//        let pageControl = UIPageControl()
//        pageControl.currentPageIndicatorTintColor = UIColor.lightGray
//        pageControl.pageIndicatorTintColor = UIColor.black
//        slideshow.pageIndicator = pageControl
//
//        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
//        slideshow.activityIndicator = DefaultActivityIndicator()
//        slideshow.delegate = self
//
//        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
//        slideshow.setImageInputs(localSource)
//
//        let recognizer = UITapGestureRecognizer(target: self, action: #selector(IntroductionVC.didTap))
//        slideshow.addGestureRecognizer(recognizer)

        imageScrollView.isPagingEnabled = true
        if (MyDefaults().language ?? "") as String ==  "en"{
             self.changeLanguage(strLanguage: "en")
            } else{
            self.changeLanguage(strLanguage: "da")
        }
        imageScrollView.setup()
        imageScrollView.imageScrollViewDelegate = self
        imageScrollView.imageContentMode = .aspectFit
        imageScrollView.initialOffset = .center
        imageScrollView.display(image: images[index])
        self.viewPrivious.isHidden = true
        self.pageController.numberOfPages = images.count
    }
    func changeLanguage(strLanguage:String) {

        self.lblNext.text = "Next".LocalizableString(localization: strLanguage)
        self.lblPrivious.text = "Previous".LocalizableString(localization: strLanguage)
    }
//    @objc func didTap() {
//        let fullScreenController = slideshow.presentFullScreenController(from: self)
//        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
//        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
//    }
    @IBAction func previousButtonTap(_ sender: AnyObject) {
       
        index = (index - 1 + images.count)%images.count
        imageScrollView.display(image: images[index])
        print(index)

        if index == 0 {
            self.viewPrivious.isHidden = true
        } else {
            if (MyDefaults().language ?? "") as String ==  "en"{
                 self.changeLanguage(strLanguage: "en")
                } else{
                self.changeLanguage(strLanguage: "da")
            }
        }
        pageController.currentPage = index
    }

    @IBAction func nextButtonTap(_ sender: AnyObject) {
       
        if index == 4 {
        self.pushController()

        } else{
            index = (index + 1)%images.count
            imageScrollView.display(image: images[index])
            self.viewPrivious.isHidden = false
            if index == 4 {
                MyDefaults().isClickOnHome = true
                if (MyDefaults().language ?? "") as String ==  "en"{
                self.lblNext.text = "HOMEPage".LocalizableString(localization: "en")
                } else{
                    self.lblNext.text = "HOMEPage".LocalizableString(localization: "da")
            }
            }
        }
        pageController.currentPage = index
    }
    func pushController()  {
        MyDefaults().isClickOnHome = true
        let vc = Util.loadViewController(fromStoryboard: "TabBarVC", storyboardName: "Home") as? TabBarVC
            if let aVc = vc {
                self.navigationController?.pushViewController(aVc, animated: true)
            }
    }
}
extension IntroductionVC: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        print("current page:", page)
    }
}
extension IntroductionVC: ImageScrollViewDelegate {
    func imageScrollViewDidChangeOrientation(imageScrollView: ImageScrollView) {
        print("Did change orientation")
    }
    func imageScrolldid(imageScrollView: ImageScrollView) {
        print("Did change orientation")
    }
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print("scrollViewDidEndZooming at scale \(scale)")
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
            pageController.currentPage = Int(pageNumber)
        }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let page = scrollView.contentOffset.x / scrollView.frame.size.width
            self.pageController.currentPage = Int(page)
        }
}


//class IntroductionVC: UIViewController {
//
//    @IBOutlet weak var sliderCollectionView: UICollectionView!
//    @IBOutlet weak var pageView: UIPageControl!
//        @IBOutlet var lblNext: UILabel!
//        @IBOutlet var lblPrivious: UILabel!
//        @IBOutlet var viewNext: UIView!
//        @IBOutlet var viewPrivious: UIView!
//
//    var imgArr = [UIImage]()
////    var imgArr = [  UIImage(named:"Alexandra Daddario"),
////                    UIImage(named:"Angelina Jolie") ,
////                    UIImage(named:"Anne Hathaway") ,
////                    UIImage(named:"Dakota Johnson") ,
////                    UIImage(named:"Emma Stone") ,
////                    UIImage(named:"Emma Watson") ,
////                    UIImage(named:"Halle Berry") ,
////                    UIImage(named:"Jennifer Lawrence") ,
////                    UIImage(named:"Jessica Alba") ,
////                    UIImage(named:"Scarlett Johansson") ]
//
//    var timer = Timer()
//    var counter = 0
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        pageView.currentPage = 0
//
//            for i in 0..<6 {
//                   if let image = UIImage(named: "screen\(i)") {
//                    imgArr.append(image)
//                   }
//               }
//        pageView.numberOfPages = imgArr.count
//        DispatchQueue.main.async {
//           // self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
//        }
//        self.viewPrivious.isHidden = true
//
//
//        if (MyDefaults().language ?? "") as String ==  "en"{
//                     self.changeLanguage(strLanguage: "en")
//                    } else{
//                    self.changeLanguage(strLanguage: "da")
//                }
//    }
//    func changeLanguage(strLanguage:String) {
//
//        self.lblNext.text = "Next".LocalizableString(localization: strLanguage)
//        self.lblPrivious.text = "Previous".LocalizableString(localization: strLanguage)
//    }
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//   @objc func changeImage() {
//
//    if counter < imgArr.count {
//        let index = IndexPath.init(item: counter, section: 0)
//        self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
//        pageView.currentPage = counter
//        counter += 1
//    } else {
//        counter = 0
//        let index = IndexPath.init(item: counter, section: 0)
//        self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
//        pageView.currentPage = counter
//        counter = 1
//    }
//
//
//   print(counter)
//
//
//   }
//    func moveCollectionToFrame(contentOffset : CGFloat) {
//
//        let frame: CGRect = CGRect(x : contentOffset ,y : self.sliderCollectionView.contentOffset.y ,width : self.sliderCollectionView.frame.width,height : self.sliderCollectionView.frame.height)
//        self.sliderCollectionView.scrollRectToVisible(frame, animated: true)
//        self.sliderCollectionView.reloadData()
//       // self.changeImage()
//    }
//
//        @IBAction func previousButtonTap(_ sender: AnyObject) {
//         //   index = (index - 1 + images.count)%images.count
//           // imageScrollView.display(image: images[index])
//        //    print(index)
//
//            if counter == 0 {
//                self.viewPrivious.isHidden = true
//            }
//
//            let contentOffset = CGFloat(floor(self.sliderCollectionView.contentOffset.x - sliderCollectionView.frame.size.width))
//            self.moveCollectionToFrame(contentOffset: contentOffset)
//        }
//
//        @IBAction func nextButtonTap(_ sender: AnyObject) {
//             counter = (counter + 1)%imgArr.count
//
//            print(counter)
//            if counter == 4 {
//            self.pushController()
//
//            } else{
//              //  index = (index + 1)%images.count
//              //  imageScrollView.display(image: images[index])
//                self.viewPrivious.isHidden = false
//                if counter == 4 {
//                if (MyDefaults().language ?? "") as String ==  "en"{
//                    self.lblNext.text = "HOMEPage".LocalizableString(localization: "en")
//                    } else{
//                        self.lblNext.text = "HOMEPage".LocalizableString(localization: "da")
//                }
//                }
//            }
//
//            let contentOffset = CGFloat(floor(self.sliderCollectionView.contentOffset.x + sliderCollectionView.frame.size.width))
//            self.moveCollectionToFrame(contentOffset: contentOffset)
//
//
//        }
//        func pushController()  {
//            MyDefaults().isClickOnHome = true
//            let vc = Util.loadViewController(fromStoryboard: "TabBarVC", storyboardName: "Home") as? TabBarVC
//                if let aVc = vc {
//                    self.navigationController?.pushViewController(aVc, animated: true)
//                }
//        }
//}
//
//extension IntroductionVC: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return imgArr.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
//        if let vc = cell.viewWithTag(111) as? UIImageView {
//            vc.image = imgArr[indexPath.row]
//        }
//        return cell
//    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.changeImage()
//    }
//}
//
//extension IntroductionVC: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let size = sliderCollectionView.frame.size
//        return CGSize(width: size.width, height: size.height)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0.0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0.0
//    }
//}
