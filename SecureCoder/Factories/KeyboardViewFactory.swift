
struct KeyboardViewFactory {
    
    static func make(name: String) -> KeyboardView? {
        switch name {
        case "iframe_injection_unsafe_welcome.php_0":
            return KeyboardIFrameInjectionUnsafeWelcome0View()
        case "iframe_injection_unsafe_trap.php_0":
            return KeyboardIFrameInjectionUnsafeTrap0View()
        case "iframe_injection_safe_welcome.php_0":
            return KeyboardIFrameInjectionSafeWelcome0View()
        case "falsify_form_unsafe_apply.php_0":
            return KeyboardFalsifyFormUnsafeApply0View()
        case "falsify_form_safe_apply.php_0":
            return KeyboardFalsifyFormSafeApply0View()
        case "no_quotes_unsafe_welcome.php_0":
            return KeyboardNoQuotesUnsafeWelcome0View()
        case "no_quotes_safe_welcome.php_0":
            return KeyboardNoQuotesSafeWelcome0View()
        case "no_quotes_safe_welcome.php_1":
            return KeyboardNoQuotesSafeWelcome1View()
        default:
            return nil
        }
    }
    
}
