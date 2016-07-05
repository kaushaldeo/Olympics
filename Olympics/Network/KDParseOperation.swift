//
//  KDParseOperation.swift
//  Olympics
//
//  Created by Kaushal Deo on 6/15/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import Foundation
import CoreData

class KDParseOperation: NSOperation, NSXMLParserDelegate {
    
    let parser: NSXMLParser
    
    let context: NSManagedObjectContext
    
    init(parser: NSXMLParser, persistentStoreCoordinator: NSPersistentStoreCoordinator = KDAPIManager.sharedInstance.persistentStoreCoordinator) {
        self.parser = parser
        self.context = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        self.context.persistentStoreCoordinator = persistentStoreCoordinator
        super.init()
    }
    
    override func main() {
        self.parser.delegate = self
        self.parser.parse()
    }

    
    //MARK: - NSXMLParser Delegate
    
    // Document handling methods
    // sent when the parser begins parsing of the document.
    func parserDidStartDocument(parser: NSXMLParser) {
        
        
    }
    
    
    // sent when the parser has completed parsing. If this is encountered, the parse was successful.
    func parserDidEndDocument(parser: NSXMLParser) {
        
    }
    /*
     // DTD handling methods for various declarations.
     optional public func parser(parser: NSXMLParser, foundNotationDeclarationWithName name: String, publicID: String?, systemID: String?)
     
     optional public func parser(parser: NSXMLParser, foundUnparsedEntityDeclarationWithName name: String, publicID: String?, systemID: String?, notationName: String?)
     
     optional public func parser(parser: NSXMLParser, foundAttributeDeclarationWithName attributeName: String, forElement elementName: String, type: String?, defaultValue: String?)
     
     optional public func parser(parser: NSXMLParser, foundElementDeclarationWithName elementName: String, model: String)
     
     optional public func parser(parser: NSXMLParser, foundInternalEntityDeclarationWithName name: String, value: String?)
     
     optional public func parser(parser: NSXMLParser, foundExternalEntityDeclarationWithName name: String, publicID: String?, systemID: String?)
     */
    
    // sent when the parser finds an element start tag.
    // In the case of the cvslog tag, the following is what the delegate receives:
    //   elementName == cvslog, namespaceURI == http://xml.apple.com/cvslog, qualifiedName == cvslog
    // In the case of the radar tag, the following is what's passed in:
    //    elementName == radar, namespaceURI == http://xml.apple.com/radar, qualifiedName == radar:radar
    // If namespace processing >isn't< on, the xmlns:radar="http://xml.apple.com/radar" is returned as an attribute pair, the elementName is 'radar:radar' and there is no qualifiedName.
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
    }
    
    // sent when an end tag is encountered. The various parameters are supplied as above.
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
    }
    
    /*
     optional public func parser(parser: NSXMLParser, didStartMappingPrefix prefix: String, toURI namespaceURI: String)
     // sent when the parser first sees a namespace attribute.
     // In the case of the cvslog tag, before the didStartElement:, you'd get one of these with prefix == @"" and namespaceURI == @"http://xml.apple.com/cvslog" (i.e. the default namespace)
     // In the case of the radar:radar tag, before the didStartElement: you'd get one of these with prefix == @"radar" and namespaceURI == @"http://xml.apple.com/radar"
     
     optional public func parser(parser: NSXMLParser, didEndMappingPrefix prefix: String)
     // sent when the namespace prefix in question goes out of scope.
     */
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        // This returns the string of the characters encountered thus far. You may not necessarily get the longest character run. The parser reserves the right to hand these to the delegate as potentially many calls in a row to -parser:foundCharacters:
    }
    
    /*
     optional public func parser(parser: NSXMLParser, foundIgnorableWhitespace whitespaceString: String)
     // The parser reports ignorable whitespace in the same way as characters it's found.
     
     optional public func parser(parser: NSXMLParser, foundProcessingInstructionWithTarget target: String, data: String?)
     // The parser reports a processing instruction to you using this method. In the case above, target == @"xml-stylesheet" and data == @"type='text/css' href='cvslog.css'"
     
     optional public func parser(parser: NSXMLParser, foundComment comment: String)
     // A comment (Text in a <!-- --> block) is reported to the delegate as a single string
     
     optional public func parser(parser: NSXMLParser, foundCDATA CDATABlock: NSData)
     // this reports a CDATA block to the delegate as an NSData.
     
     optional public func parser(parser: NSXMLParser, resolveExternalEntityName name: String, systemID: String?) -> NSData?
     // this gives the delegate an opportunity to resolve an external entity itself and reply with the resulting data.
     */
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        // ...and this reports a fatal error to the delegate. The parser will stop parsing.
        
        
    }
    
    func parser(parser: NSXMLParser, validationErrorOccurred validationError: NSError) {
       
    }
    
}
