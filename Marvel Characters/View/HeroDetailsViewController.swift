import UIKit

class HeroDetailsViewController: UIViewController {
    
    var viewModel: ViewModel!
    var index = 0
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var heroNameLabel: UILabel!
    @IBOutlet weak var heroDescription: UILabel!
    @IBOutlet weak var comicsNames: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let model = viewModel.modelData.data!.results![index]
        heroNameLabel?.text = "Character Name: " + (model.name ?? "")
        title = (model.name ?? "")
        heroDescription?.text = "Character description: " + (model.description ?? "description Not available")
        heroImageView.loadImageUsingCache(withUrl: model.thumbnail!.path! + "." + model.thumbnail!.extensionString! )
        let comicsName = model.comics!.items!.map {$0.name!}
        comicsNames?.text = "Character Names: \n • "  + comicsName.joined(separator: "\n • ")
    }
}
