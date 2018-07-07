import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var canvasView: CanvasView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        canvasView.clearCanvas()
    }
    
    @IBAction func startOverPressed(_ sender: UIButton) {
        canvasView.clearCanvas()
    }

    @IBAction func styleChanged(_ sender: UISegmentedControl) {
        canvasView.changeStyle(sender.selectedSegmentIndex)
        canvasView.clearCanvas()
    }
    
    override var prefersStatusBarHidden: Bool { return true }
}



