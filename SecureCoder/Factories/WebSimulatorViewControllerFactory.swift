

struct WebSimulatorViewControllerFactory {
    
    static func make(lessonTitle: String) -> WebSimulatorViewController? {
        switch lessonTitle {
        case "iframe_injection_unsafe":
            return IFrameInjectionUnsafeWebSimulatorViewController()
        case "iframe_injection_safe":
            return IFrameInjectionSafeWebSimulatorViewController()
        case "falsify_form_unsafe":
            return FalsifyFormUnsafeWebSimulatorViewController()
        default:
            return nil
        }
    }
    
}
