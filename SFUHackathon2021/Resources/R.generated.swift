//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap { Locale(identifier: $0) } ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)

  /// Find first language and bundle for which the table exists
  fileprivate static func localeBundle(tableName: String, preferredLanguages: [String]) -> (Foundation.Locale, Foundation.Bundle)? {
    // Filter preferredLanguages to localizations, use first locale
    var languages = preferredLanguages
      .map { Locale(identifier: $0) }
      .prefix(1)
      .flatMap { locale -> [String] in
        if hostingBundle.localizations.contains(locale.identifier) {
          if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
            return [locale.identifier, language]
          } else {
            return [locale.identifier]
          }
        } else if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
          return [language]
        } else {
          return []
        }
      }

    // If there's no languages, use development language as backstop
    if languages.isEmpty {
      if let developmentLocalization = hostingBundle.developmentLocalization {
        languages = [developmentLocalization]
      }
    } else {
      // Insert Base as second item (between locale identifier and languageCode)
      languages.insert("Base", at: 1)

      // Add development language as backstop
      if let developmentLocalization = hostingBundle.developmentLocalization {
        languages.append(developmentLocalization)
      }
    }

    // Find first language for which table exists
    // Note: key might not exist in chosen language (in that case, key will be shown)
    for language in languages {
      if let lproj = hostingBundle.url(forResource: language, withExtension: "lproj"),
         let lbundle = Bundle(url: lproj)
      {
        let strings = lbundle.url(forResource: tableName, withExtension: "strings")
        let stringsdict = lbundle.url(forResource: tableName, withExtension: "stringsdict")

        if strings != nil || stringsdict != nil {
          return (Locale(identifier: language), lbundle)
        }
      }
    }

    // If table is available in main bundle, don't look for localized resources
    let strings = hostingBundle.url(forResource: tableName, withExtension: "strings", subdirectory: nil, localization: nil)
    let stringsdict = hostingBundle.url(forResource: tableName, withExtension: "stringsdict", subdirectory: nil, localization: nil)

    if strings != nil || stringsdict != nil {
      return (applicationLocale, hostingBundle)
    }

    // If table is not found for requested languages, key will be shown
    return nil
  }

  /// Load string from Info.plist file
  fileprivate static func infoPlistString(path: [String], key: String) -> String? {
    var dict = hostingBundle.infoDictionary
    for step in path {
      guard let obj = dict?[step] as? [String: Any] else { return nil }
      dict = obj
    }
    return dict?[key] as? String
  }

  static func validate() throws {
    try font.validate()
    try intern.validate()
  }

  #if os(iOS) || os(tvOS)
  /// This `R.storyboard` struct is generated, and contains static references to 1 storyboards.
  struct storyboard {
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()

    #if os(iOS) || os(tvOS)
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    #endif

    fileprivate init() {}
  }
  #endif

  /// This `R.color` struct is generated, and contains static references to 9 colors.
  struct color {
    /// Color `AccentColor`.
    static let accentColor = Rswift.ColorResource(bundle: R.hostingBundle, name: "AccentColor")
    /// Color `backgoundContrast`.
    static let backgoundContrast = Rswift.ColorResource(bundle: R.hostingBundle, name: "backgoundContrast")
    /// Color `backgound`.
    static let backgound = Rswift.ColorResource(bundle: R.hostingBundle, name: "backgound")
    /// Color `blue`.
    static let blue = Rswift.ColorResource(bundle: R.hostingBundle, name: "blue")
    /// Color `darkGrey`.
    static let darkGrey = Rswift.ColorResource(bundle: R.hostingBundle, name: "darkGrey")
    /// Color `foregroundContrast`.
    static let foregroundContrast = Rswift.ColorResource(bundle: R.hostingBundle, name: "foregroundContrast")
    /// Color `foreground`.
    static let foreground = Rswift.ColorResource(bundle: R.hostingBundle, name: "foreground")
    /// Color `lightBlue`.
    static let lightBlue = Rswift.ColorResource(bundle: R.hostingBundle, name: "lightBlue")
    /// Color `lightGrey`.
    static let lightGrey = Rswift.ColorResource(bundle: R.hostingBundle, name: "lightGrey")

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "AccentColor", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func accentColor(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.accentColor, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "backgound", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func backgound(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.backgound, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "backgoundContrast", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func backgoundContrast(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.backgoundContrast, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "blue", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func blue(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.blue, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "darkGrey", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func darkGrey(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.darkGrey, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "foreground", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func foreground(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.foreground, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "foregroundContrast", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func foregroundContrast(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.foregroundContrast, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "lightBlue", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func lightBlue(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.lightBlue, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "lightGrey", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func lightGrey(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.lightGrey, compatibleWith: traitCollection)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "AccentColor", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func accentColor(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.accentColor.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "backgound", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func backgound(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.backgound.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "backgoundContrast", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func backgoundContrast(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.backgoundContrast.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "blue", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func blue(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.blue.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "darkGrey", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func darkGrey(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.darkGrey.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "foreground", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func foreground(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.foreground.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "foregroundContrast", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func foregroundContrast(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.foregroundContrast.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "lightBlue", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func lightBlue(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.lightBlue.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "lightGrey", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func lightGrey(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.lightGrey.name)
    }
    #endif

    fileprivate init() {}
  }

  /// This `R.file` struct is generated, and contains static references to 5 files.
  struct file {
    /// Resource file `MontserratBold.ttf`.
    static let montserratBoldTtf = Rswift.FileResource(bundle: R.hostingBundle, name: "MontserratBold", pathExtension: "ttf")
    /// Resource file `MontserratLight.ttf`.
    static let montserratLightTtf = Rswift.FileResource(bundle: R.hostingBundle, name: "MontserratLight", pathExtension: "ttf")
    /// Resource file `MontserratMedium.ttf`.
    static let montserratMediumTtf = Rswift.FileResource(bundle: R.hostingBundle, name: "MontserratMedium", pathExtension: "ttf")
    /// Resource file `MontserratRegular.ttf`.
    static let montserratRegularTtf = Rswift.FileResource(bundle: R.hostingBundle, name: "MontserratRegular", pathExtension: "ttf")
    /// Resource file `MontserratSemiBold.ttf`.
    static let montserratSemiBoldTtf = Rswift.FileResource(bundle: R.hostingBundle, name: "MontserratSemiBold", pathExtension: "ttf")

    /// `bundle.url(forResource: "MontserratBold", withExtension: "ttf")`
    static func montserratBoldTtf(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.montserratBoldTtf
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "MontserratLight", withExtension: "ttf")`
    static func montserratLightTtf(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.montserratLightTtf
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "MontserratMedium", withExtension: "ttf")`
    static func montserratMediumTtf(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.montserratMediumTtf
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "MontserratRegular", withExtension: "ttf")`
    static func montserratRegularTtf(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.montserratRegularTtf
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "MontserratSemiBold", withExtension: "ttf")`
    static func montserratSemiBoldTtf(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.montserratSemiBoldTtf
      return fileResource.bundle.url(forResource: fileResource)
    }

    fileprivate init() {}
  }

  /// This `R.font` struct is generated, and contains static references to 5 fonts.
  struct font: Rswift.Validatable {
    /// Font `Montserrat-Bold`.
    static let montserratBold = Rswift.FontResource(fontName: "Montserrat-Bold")
    /// Font `Montserrat-Light`.
    static let montserratLight = Rswift.FontResource(fontName: "Montserrat-Light")
    /// Font `Montserrat-Medium`.
    static let montserratMedium = Rswift.FontResource(fontName: "Montserrat-Medium")
    /// Font `Montserrat-Regular`.
    static let montserratRegular = Rswift.FontResource(fontName: "Montserrat-Regular")
    /// Font `Montserrat-SemiBold`.
    static let montserratSemiBold = Rswift.FontResource(fontName: "Montserrat-SemiBold")

    /// `UIFont(name: "Montserrat-Bold", size: ...)`
    static func montserratBold(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: montserratBold, size: size)
    }

    /// `UIFont(name: "Montserrat-Light", size: ...)`
    static func montserratLight(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: montserratLight, size: size)
    }

    /// `UIFont(name: "Montserrat-Medium", size: ...)`
    static func montserratMedium(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: montserratMedium, size: size)
    }

    /// `UIFont(name: "Montserrat-Regular", size: ...)`
    static func montserratRegular(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: montserratRegular, size: size)
    }

    /// `UIFont(name: "Montserrat-SemiBold", size: ...)`
    static func montserratSemiBold(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: montserratSemiBold, size: size)
    }

    static func validate() throws {
      if R.font.montserratBold(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'Montserrat-Bold' could not be loaded, is 'MontserratBold.ttf' added to the UIAppFonts array in this targets Info.plist?") }
      if R.font.montserratLight(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'Montserrat-Light' could not be loaded, is 'MontserratLight.ttf' added to the UIAppFonts array in this targets Info.plist?") }
      if R.font.montserratMedium(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'Montserrat-Medium' could not be loaded, is 'MontserratMedium.ttf' added to the UIAppFonts array in this targets Info.plist?") }
      if R.font.montserratRegular(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'Montserrat-Regular' could not be loaded, is 'MontserratRegular.ttf' added to the UIAppFonts array in this targets Info.plist?") }
      if R.font.montserratSemiBold(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'Montserrat-SemiBold' could not be loaded, is 'MontserratSemiBold.ttf' added to the UIAppFonts array in this targets Info.plist?") }
    }

    fileprivate init() {}
  }

  /// This `R.image` struct is generated, and contains static references to 6 images.
  struct image {
    /// Image `crossroads`.
    static let crossroads = Rswift.ImageResource(bundle: R.hostingBundle, name: "crossroads")
    /// Image `launchScreenLine`.
    static let launchScreenLine = Rswift.ImageResource(bundle: R.hostingBundle, name: "launchScreenLine")
    /// Image `signIn`.
    static let signIn = Rswift.ImageResource(bundle: R.hostingBundle, name: "signIn")
    /// Image `tabBarMap`.
    static let tabBarMap = Rswift.ImageResource(bundle: R.hostingBundle, name: "tabBarMap")
    /// Image `tabBarNews`.
    static let tabBarNews = Rswift.ImageResource(bundle: R.hostingBundle, name: "tabBarNews")
    /// Image `tabBarSettings`.
    static let tabBarSettings = Rswift.ImageResource(bundle: R.hostingBundle, name: "tabBarSettings")

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "crossroads", bundle: ..., traitCollection: ...)`
    static func crossroads(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.crossroads, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "launchScreenLine", bundle: ..., traitCollection: ...)`
    static func launchScreenLine(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.launchScreenLine, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "signIn", bundle: ..., traitCollection: ...)`
    static func signIn(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.signIn, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "tabBarMap", bundle: ..., traitCollection: ...)`
    static func tabBarMap(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.tabBarMap, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "tabBarNews", bundle: ..., traitCollection: ...)`
    static func tabBarNews(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.tabBarNews, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "tabBarSettings", bundle: ..., traitCollection: ...)`
    static func tabBarSettings(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.tabBarSettings, compatibleWith: traitCollection)
    }
    #endif

    fileprivate init() {}
  }

  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }

    fileprivate init() {}
  }

  fileprivate class Class {}

  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    #if os(iOS) || os(tvOS)
    try storyboard.validate()
    #endif
  }

  #if os(iOS) || os(tvOS)
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      #if os(iOS) || os(tvOS)
      try launchScreen.validate()
      #endif
    }

    #if os(iOS) || os(tvOS)
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UIViewController

      let bundle = R.hostingBundle
      let name = "LaunchScreen"

      static func validate() throws {
        if UIKit.UIImage(named: "launchScreenLine", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'launchScreenLine' is used in storyboard 'LaunchScreen', but couldn't be loaded.") }
        if #available(iOS 11.0, tvOS 11.0, *) {
          if UIKit.UIColor(named: "blue", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Color named 'blue' is used in storyboard 'LaunchScreen', but couldn't be loaded.") }
          if UIKit.UIColor(named: "lightBlue", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Color named 'lightBlue' is used in storyboard 'LaunchScreen', but couldn't be loaded.") }
        }
      }

      fileprivate init() {}
    }
    #endif

    fileprivate init() {}
  }
  #endif

  fileprivate init() {}
}
