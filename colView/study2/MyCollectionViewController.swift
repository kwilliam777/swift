//
//  MyViewController.swift
//  study2
//
//  Created by 김응진 on 2021/05/09.
//

import UIKit
import Photos

private let reuseIdentifier = "Cell"

class MyCollectionViewController: UICollectionViewController, PHPhotoLibraryChangeObserver {
    
    var toolbar: UIToolbar!
    
    var fetchResult: PHFetchResult<PHAsset>!
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.clearSelectionInViewWillAppear = false
        self.checkAuthAndLoadData()
        self.collectionView!.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.setFlowLayout()
        PHPhotoLibrary.shared().register(self)
        setToolbar()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fetchResult?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: MyCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? MyCollectionViewCell else { return MyCollectionViewCell()}
        let asset: PHAsset = fetchResult.object(at: indexPath.item)
        let myWidth: CGFloat = self.collectionView.frame.width/3-1
        imageManager.requestImage(for: asset, targetSize: CGSize(width: myWidth, height: myWidth), contentMode: .aspectFill, options: nil) {(image, _) in
            cell.imageView.image = image
        }
        
        if cell.isSelected == false {
            cell.layer.borderWidth = 0
        }
//        cell.imageView.image = UIImage(named: "다운로드.jpeg")
        
        return cell
    }
    
    func setFlowLayout() {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 1
        flowLayout.minimumInteritemSpacing = 1
        let myWidth: CGFloat = self.collectionView.frame.width/3-1
        flowLayout.itemSize = CGSize(width: myWidth, height: myWidth)
        self.collectionView.backgroundColor = .white
        self.collectionView.collectionViewLayout = flowLayout
    }
    
    func getPhotosFromIPhone() {
        let collectionList: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        guard let assetCollection = collectionList.firstObject else { print("No Photos")
            return
        }
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        self.fetchResult = PHAsset.fetchAssets(in: assetCollection, options: fetchOptions)
    }
    
    func checkAuthAndLoadData() {
        let photoLibraryAuthrizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoLibraryAuthrizationStatus{
        case .authorized:
            self.getPhotosFromIPhone()
            OperationQueue.main.addOperation {
                self.collectionView.reloadData()
            }
        case .denied:
            print("access denied")
        case .notDetermined:
            print("Not determined")
            PHPhotoLibrary.requestAuthorization({(status) in
                switch status {
                case .authorized:
                    self.getPhotosFromIPhone()
//                    self.collectionView.reloadData()
                case .denied:
                    print("Access denied")
                    OperationQueue.main.addOperation {
                        self.collectionView.reloadData()
                    }
                default:
                    break
                }
            })
        default:
        print("Unexpected case")
        }
    }
    
    func setToolbar() {
        let toolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(toolbar)
        
        let flexibleButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        
        let button = UIBarButtonItem(title: "select", style: .plain, target: self, action: #selector(self.pressSelectOrCancelButton(_:)))
        
        toolbar.setItems([flexibleButton, button, flexibleButton], animated: true)
        
        toolbar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        toolbar.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        toolbar.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        toolbar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.toolbar = toolbar
    }
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let changes = changeInstance.changeDetails(for: self.fetchResult) else { return }
        self.fetchResult = changes.fetchResultAfterChanges
        
        OperationQueue.main.addOperation {
            self.toolbar.items?[3].isEnabled = false
            self.collectionView.reloadSections(IndexSet(0...0))
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if self.toolbar.items?.count == 4 {
            if self.collectionView.indexPathsForSelectedItems?.isEmpty == true {
                self.toolbar.items?[3].isEnabled = true
            }
        }
        
        if self.collectionView.allowsMultipleSelection == true {
            let cell = self.collectionView.cellForItem(at: indexPath)
            if cell?.isSelected == false {
                cell?.isSelected = true
                cell?.layer.borderWidth = 4.0
                cell?.layer.borderColor = UIColor.gray.cgColor
                return true
            }
        }
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        if self.toolbar.items?.count == 4 {
            if self.collectionView.indexPathsForSelectedItems?.count == 1 {
                self.toolbar.items?[3].isEnabled = false
            }
        }
        
        if self.collectionView.allowsMultipleSelection == true {
            let cell = self.collectionView.cellForItem(at: indexPath)
            if cell?.isSelected == true {
                cell?.isSelected = false
                cell?.layer.borderWidth = 0
                return true
            }
        }
        return true
    }
    
    @IBAction func pressSelectOrCancelButton(_ sender: UIBarButtonItem) {
        let flexibleButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        if self.collectionView.allowsMultipleSelection == false {
            self.collectionView.allowsMultipleSelection = true
            let cancelButton = UIBarButtonItem(title: "cancel", style: .plain, target: self, action:
                                                #selector(self.pressSelectOrCancelButton(_:)))
            let trashButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.trash, target: self, action: #selector(pressTrashButton(_:)))
            
            trashButton.isEnabled = false
            
            self.toolbar.setItems([flexibleButton,cancelButton,flexibleButton,trashButton], animated: true)
        } else {
            self.collectionView.allowsMultipleSelection = false
            let selectButton = UIBarButtonItem(title: "select", style: .plain, target: self, action: #selector(self.pressSelectOrCancelButton(_:)))
            self.toolbar.setItems([flexibleButton,selectButton,flexibleButton], animated: true)
            
            guard let selectedCell = self.collectionView.indexPathsForSelectedItems else { return }
            for indexPath in selectedCell {
                if let tempCell = self.collectionView.cellForItem(at: indexPath) {
                    tempCell.isSelected = false
                    tempCell.layer.borderWidth = 0
                }
            }
            OperationQueue.main.addOperation {
                self.collectionView.reloadData()
            }
        }
    }
    
    @IBAction func pressTrashButton(_ sender: UIBarButtonItem) {
        guard let selectedCells = self.collectionView.indexPathsForSelectedItems else { return }
        var deleteAssets = [PHAsset]()
        for indexPath in selectedCells {
            deleteAssets.append(self.fetchResult[indexPath.item])
        }
        PHPhotoLibrary.shared().performChanges({PHAssetChangeRequest.deleteAssets(deleteAssets as NSArray)}, completionHandler: nil)
    }
}
