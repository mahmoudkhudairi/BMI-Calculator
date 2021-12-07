//
//  BundleExtension.swift
//  localeBMI
//
//  Created by mahmoudkhudairi on 05/12/2021.
//

import Foundation

var bundleKey: UInt8 = 0

class AnyLanguageBundle: Bundle {
    
    override func localizedString(forKey key: String,
                                  value: String?,
                                  table tableName: String?) -> String {
        guard let path = objc_getAssociatedObject(self, &bundleKey) as? String,
              let bundle = Bundle(path: path) else {
                // main bundle
                  return super.localizedString(forKey: key, value: value, table: tableName)
              }
        return bundle.localizedString(forKey: key, value: value, table: tableName)
    }
}

extension Bundle {
    
    class func setLanguage(_ language: String) {
        // set the class for Bundle.main to AnyLanguageBundle.self class
        object_setClass(Bundle.main, AnyLanguageBundle.self)
        /*
         You use the Objective-C runtime function objc_setAssociatedObject to make
         an association between one object and another. The function takes four parameters:
         the source object, a key, the value, and an association policy constant.
         The key is a void pointer.The key for each association must be unique. A typical pattern is to use a static variable.
         nonatomic means multiple thread access the variable (dynamic type).
         nonatomic is thread-unsafe.
         But it is fast in performance
         nonatomic is NOT default behavior. We need to add the nonatomic keyword in the property attribute.
         It may result in unexpected behavior, when two different process (threads) access the same variable at the same time.
         */
        objc_setAssociatedObject(Bundle.main, &bundleKey,    Bundle.main.path(forResource: language, ofType: "lproj"), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
