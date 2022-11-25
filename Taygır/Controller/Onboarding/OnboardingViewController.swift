//
//  OnboardingViewController.swift
//  Taygır
//
//  Created by Fatih Bilgin on 25.11.2022.
//

import UIKit
import FirebaseAuth

class OnboardingViewController: UIViewController {
    
    static var authIsValid = false
    var slides: [OnboardingSlide] = []
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == slides.count - 1 {
                nextButton.setTitle("Başla", for: .normal)
            } else {
                nextButton.setTitle("İleri", for: .normal)
            }
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // BİRİSİNİ GÖRDÜM SANKİ AA ZEYNEP'MİŞ OHA BU TATLILIK NE!!
        slides = [OnboardingSlide(title: "BİRİSİNİ GÖRDÜM SANKİ", description: "", image: #imageLiteral(resourceName: "cirtter")),
                  OnboardingSlide(title: "AA ZEYNEP'MİŞ", description: "", image: #imageLiteral(resourceName: "2")),
                  OnboardingSlide(title: "OHA BU TATLILIK NE!!", description: "", image: #imageLiteral(resourceName: "3"))
        ]
        validateAuth()
    }
    
    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            OnboardingViewController.authIsValid = false
            UserDefaults.standard.hasOnboarded = false
        } else {
            OnboardingViewController.authIsValid = true
            UserDefaults.standard.hasOnboarded = true
        }
    }
    
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        
        if (currentPage == slides.count - 1) && OnboardingViewController.authIsValid == true {
            let controller = storyboard?.instantiateViewController(withIdentifier: "Dashboard") as? UINavigationController
            controller?.modalPresentationStyle = .fullScreen
            controller?.modalTransitionStyle = .flipHorizontal
            present(controller!, animated: true)
        } else if OnboardingViewController.authIsValid == false && (currentPage == slides.count - 1) {
            let controller = storyboard?.instantiateViewController(withIdentifier: "Dashboard") as? UINavigationController
            controller?.modalPresentationStyle = .fullScreen
            controller?.modalTransitionStyle = .flipHorizontal
            present(controller!, animated: true)
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath,
                                        at: .centeredHorizontally,
                                        animated: true)
        }
    }
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionCollectionViewCell
        cell.setup(slides[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
}
