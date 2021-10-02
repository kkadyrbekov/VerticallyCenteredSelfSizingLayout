import UIKit

class InterestsVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var selectedIndexPaths: [IndexPath] = []
    
    var tags = ["Eddard (Ned) Stark", "Jon Snow", "Jaime Lannistersdcdsc csd", "Catelyn Stark", "Cersei Lannister", "Daenerys Targaryen", "Jorah Mormont", "Viserys Targaryen", "Robert Baratheon", "Sansa Stark", "Arya Stark", "Robb Stark", "Theon Greyjoy", "Bran Stark", "Joffrey Baratheon", "Eddard (Ned) Stark", "Jon Snow", "Jaime Lannister", "Catelyn Stark", "Cersei Lannister", "Daenerys Targaryen", "Jorah Mormont", "Viserys Targaryen", "Robert Baratheon", "Sansa Stark", "Arya Stark", "Robb Stark", "Theon Greyjoy", "Bran Stark", "Joffrey Baratheon", "Eddard (Ned) Stark", "Jon Snow", "Jaime Lannister", "Catelyn Stark", "Cersei Lannister", "Daenerys Targaryen", "Jorah Mormont", "Viserys Targaryen", "Robert Baratheon", "Sansa Stark", "Arya Stark", "Robb Stark", "Theon Greyjoy", "Bran Stark", "Joffrey Baratheon", "Eddard (Ned) Stark", "Jon Snow", "Jaime Lannister", "Catelyn Stark", "Cersei Lannister", "Daenerys Targaryen", "Jorah Mormont", "Viserys Targaryen", "Robert Baratheon", "Sansa Stark", "Arya Stark", "Robb Stark", "Theon Greyjoy", "Bran Stark", "Joffrey Baratheon", "Eddard (Ned) Stark", "Jon Snow", "Jaime Lannister", "Catelyn Stark", "Cersei Lannister", "Daenerys Targaryen", "Jorah Mormont", "Viserys Targaryen", "Robert Baratheon", "Sansa Stark", "Arya Stark", "Robb Stark", "Theon Greyjoy", "Bran Stark", "Joffrey Baratheon", "Eddard (Ned) Stark", "Jon Snow", "Jaime Lannister", "Catelyn Stark", "Cersei Lannister", "Daenerys Targaryen", "Jorah Mormont", "Viserys Targaryen", "Robert Baratheon", "Sansa Stark", "Arya Stark", "Robb Stark", "Theon Greyjoy", "Bran Stark", "Joffrey Baratheon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "InterestsCVCell", bundle: nil), forCellWithReuseIdentifier: "InterestsCVCell")
        let layout = VerticallyCenteredSelfSizingLayout()
        layout.numberOfColumns = 2
        layout.cellPadding = 6.0
        layout.delegate = self
        collectionView.collectionViewLayout = layout
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.reloadData()
    }
}

extension InterestsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InterestsCVCell", for: indexPath) as! InterestsCVCell
        cell.delegate = self
        cell.setupWith(tag: tags[indexPath.row], index: indexPath.row, isSelected: selectedIndexPaths.contains(indexPath))
        return cell
    }
}

extension InterestsVC: VerticallyCenteredSelfSizingLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, widthForCellAtIndexPath indexPath:IndexPath) -> CGFloat {
        let text = "\(tags[indexPath.row].uppercased()) (\(indexPath.row))"
        let size: CGSize = text.size(withAttributes: [.font: UIFont.systemFont(ofSize: 16, weight: .medium)])
        return size.width + 50
    }
}

extension InterestsVC: TagsCollectionViewCellDelegate {
    func didSelectCell(_ cell: InterestsCVCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        if selectedIndexPaths.contains(indexPath) {
            selectedIndexPaths.removeAll { (it) -> Bool in
                return it == indexPath
            }
        } else {
            selectedIndexPaths.append(indexPath)
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! InterestsCVCell
        cell.setupWith(tag: tags[indexPath.row], index: indexPath.row, isSelected: selectedIndexPaths.contains(indexPath))
    }
}
