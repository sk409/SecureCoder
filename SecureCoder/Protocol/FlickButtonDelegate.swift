import UIKit

protocol FlickButtonDelegate {
    
    func flickButtonPopUpViewsWillShow(_ flickButton: FlickButton)
    func flickButtonPopUpViewsDidShow(_ flickButton: FlickButton)
    func flickButtonWillFlick(_ flickButton: FlickButton)
    func flickButton(_ flickButton: FlickButton, popUpViewsWillHide activeView: UIView?)
    func flickButton(_ flickButton: FlickButton, popUpViewsDidHide activeView: UIView?)
    func flickButton(_ flickButton: FlickButton, didFlick selectedView: UIView?)
    
}

extension FlickButtonDelegate {
    
    func flickButtonPopUpViewsWillShow(_ flickButton: FlickButton) {
    }
    
    func flickButtonPopUpViewsDidShow(_ flickButton: FlickButton) {
    }
    
    func flickButtonWillFlick(_ flickButton: FlickButton) {
    }
    
    func flickButton(_ flickButton: FlickButton, popUpViewsWillHide activeView: UIView?) {
    }
    
    func flickButton(_ flickButton: FlickButton, popUpViewsDidHide activeView: UIView?) {
    }
    
    func flickButton(_ flickButton: FlickButton, didFlick selectedView: UIView?) {
    }
    
}
