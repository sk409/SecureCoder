

struct WebSimulatorViewControllerFactory {
    
    static func make(lessonTitle: String) -> WebSimulatorViewController? {
        switch lessonTitle {
        case "iframe_injection_unsafe":
            return IFrameInjectionUnsafeWebSimulatorViewController()
        case "iframe_injection_safe":
            return IFrameInjectionSafeWebSimulatorViewController()
        case "falsify_form_unsafe":
            return FalsifyFormUnsafeWebSimulatorViewController()
        case "falsify_form_safe":
            return FalsifyFormSafeWebSimulatorViewController()
        case "no_quotes_unsafe":
            return NoQuotesUnsafeWebSimulatorViewController()
        case "no_quotes_safe":
            return NoQuotesSafeWebSimulatorViewController()
        case "ent_quotes_unsafe":
            return EntQuotesUnsafeWebSimulatorViewController()
        case "ent_quotes_safe":
            return EntQuotesSafeWebSimulatorViewController()
        case "javascript_scheme_unsafe":
            return JavaScriptSchemeUnsafeWebSimulatorViewController()
        case "javascript_scheme_safe":
            return JavaScriptSchemeSafeWebSimulatorViewController()
        case "take_measures_unsafe":
            return SQLInjectionTakeMeasuresUnsafeWebSimulatorViewController()
        case "take_measures_safe":
            return SQLInjectionTakeMeasuresSafeWebSimulatorViewController()
        case "information_schema_unsafe":
            return InformationSchemaUnsafeWebSimulatorViewController()
        case "information_schema_safe":
            return InformationSchemaSafeWebSimulatorViewController()
        case "falsify_database_unsafe":
            return FalsifyDatabaseUnsafeWebSimulatorViewController()
        default:
            return nil
        }
    }
    
}
