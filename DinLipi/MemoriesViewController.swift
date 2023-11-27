import UIKit
import SwiftUI

class MemoriesViewController: UIViewController {
    private var viewModel = MemoriesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        let memoriesListView = MemoriesListView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: memoriesListView)

        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.frame = view.bounds
        hostingController.didMove(toParent: self)
    }
}
