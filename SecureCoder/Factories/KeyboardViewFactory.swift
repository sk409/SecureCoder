
struct KeyboardViewFactory {
    
    static func make(name: String) -> KeyboardView? {
        switch name {
        case "iframe_injection_unsafe_welcome.php_0":
            return KeyboardIFrameInjectionUnsafeWelcome0View()
        case "iframe_injection_unsafe_trap.php_0":
            return KeyboardIFrameInjectionUnsafeTrap0View()
        case "iframe_injection_safe_welcome.php_0":
            return KeyboardIFrameInjectionSafeWelcome0View()
        default:
            return nil
        }
    }
    
}
