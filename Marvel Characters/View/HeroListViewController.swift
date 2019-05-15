import UIKit
import Foundation
import CommonCrypto
class HeroListViewController: UIViewController {
    
    @IBOutlet var heroListTableView:UITableView!
    
    private var viewModel: ViewModel! {
        didSet {
            heroListTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heroListTableView.rowHeight = 120
        heroListTableView.estimatedRowHeight = UITableView.automaticDimension
        callService()
    }    
}

//MARK: TableView Data source
extension HeroListViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel == nil {
            return 0
        }
        return self.viewModel.modelData.data?.results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeroTableViewCell") as! HeroTableViewCell
        let model = viewModel.modelData.data!.results![indexPath.row]
        cell.heroNameLabel?.text = model.name
        cell.heroImageView.loadImageUsingCache(withUrl: model.thumbnail!.path! + "." + model.thumbnail!.extensionString! )
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "HeroDetailsViewController") as! HeroDetailsViewController
        vc.index = indexPath.row
        vc.viewModel = viewModel
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: Call WebService
extension HeroListViewController {
    func callService() {
        let miliSecondDate = Date.shared.toMillisString()
        let toHash: String = miliSecondDate + APIKeys.privateKey + APIKeys.publicKey
        let md5Hash = toHash.MD5!
        let urlEncrypted = WebService.baseURL + "characters?ts=\(miliSecondDate)&hash=\(md5Hash)&apikey=\(APIKeys.publicKey)"
        showIndicator()
        WebService.fetchData(url: URL(string: urlEncrypted)!,
                             httpMethod: .get,
                             parameters: [:]) { (data) in
                                self.hideIndicator()
                                do {
                                    let modelData = try JSONDecoder().decode(CharacterListModel.self, from: data)
                                    self.viewModel = ViewModel(model: modelData)
                                } catch {
                                    self.showAlert()
                                }
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Uh Oh", message: "Try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.callService()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
