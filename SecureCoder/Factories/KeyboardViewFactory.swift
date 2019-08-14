
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
        case "ent_quotes_unsafe_welcome.php_0":
            return KeyboardEntQuotesUnsafeWelcome0View()
        case "ent_quotes_unsafe_welcome.php_1":
            return KeyboardEntQuotesUnsafeWelcome1View()
        case "ent_quotes_unsafe_welcome.php_2":
            return KeyboardEntQuotesUnsafeWelcome2View()
        case "ent_quotes_safe_welcome.php_0":
            return KeyboardEntQuotesSafeWelcome0View()
        case "javascript_scheme_unsafe_welcome.php_0":
            return KeyboardJavaScriptSchemeUnsafeWelcome0View()
        case "javascript_scheme_unsafe_welcome.php_1":
            return KeyboardJavaScriptSchemeUnsafeWelcome1View()
        case "javascript_scheme_unsafe_welcome.php_2":
            return KeyboardJavaScriptSchemeUnsafeWelcome2View()
        case "javascript_scheme_unsafe_welcome.php_3":
            return KeyboardJavaScriptSchemeUnsafeWelcome3View()
        case "javascript_scheme_safe_welcome.php_0":
            return KeyboardJavaScriptSchemeSafeWelcome0View()
        case "take_measures_unsafe_books.php_0":
            return KeyboardSQLInjectionTakeMeasuresUnsafeBooks0View()
        case "take_measures_safe_books.php_0":
            return KeyboardSQLInjectionTakeMeasuresSafeBook0View()
        case "take_measures_safe_books.php_1":
            return KeyboardSQLInjectionTakeMeasuresSafeBook1View()
        case "information_schema_unsafe_books.php_0":
            return KeyboardSQLInjectionTakeMeasuresUnsafeBooks0View()
        case "information_schema_safe_books.php_0":
            return KeyboardSQLInjectionTakeMeasuresSafeBook0View()
        case "information_schema_safe_books.php_1":
            return KeyboardSQLInjectionTakeMeasuresSafeBook1View()
        case "falsify_database_unsafe_books.php_0":
            return KeyboardSQLInjectionTakeMeasuresUnsafeBooks0View()
        case "falsify_database_safe_books.php_0":
            return KeyboardSQLInjectionTakeMeasuresSafeBook0View()
        case "falsify_database_safe_books.php_1":
            return KeyboardSQLInjectionTakeMeasuresSafeBook1View()
        default:
            return nil
        }
    }
    
}
