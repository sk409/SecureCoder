
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
        case "authentication_bypass_unsafe_auth.php_0":
            return KeyboardAuthenticationBypassUnsafeAuth0View()
        case "authentication_bypass_unsafe_auth.php_1":
            return KeyboardAuthenticationBypassUnsafeAuth1View()
        case "authentication_bypass_safe_auth.php_0":
            return KeyboardAuthenticationBypassSafeAuth0View()
        case "authentication_bypass_safe_auth.php_1":
            return KeyboardAuthenticationBypassSafeAuth1View()
        case "authentication_bypass_safe_auth.php_2":
            return KeyboardAuthenticationBypassSafeAuth2View()
        case "authentication_bypass_safe_auth.php_3":
            return KeyboardAuthenticationBypassSafeAuth3View()
        case "dynamic_column_unsafe_books.php_0":
            return KeyboardDynamicColumnUnsafeBooks0View()
        case "dynamic_column_safe_books.php_0":
            return KeyboardDynamicColumnSafeBooks0View()
        case "token_safe_change_password.php_0":
            return KeyboardTokenSafeChangePassword0View()
        case "token_safe_change_password.php_1":
            return KeyboardTokenSafeChangePassword1View()
        case "re-enter_password_safe_change_password.php_0":
            return KeyboardReEnterPasswordSafeChangePassword0View()
        case "re-enter_password_safe_change_password.php_1":
            return KeyboardReEnterPasswordSafeChangePassword1View()
        case "referer_safe_change_password.php_0":
            return KeyboardRefererSafeChangePassword0View()
        default:
            return nil
        }
    }
    
}
