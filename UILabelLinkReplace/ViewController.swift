//
//  ViewController.swift
//  UILabelLinkReplace
//
//  Created by Alexander Shive on 2/27/15.
//  Copyright (c) 2015 Alexander Shive. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TTTAttributedLabelDelegate {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//		let label = TTTAttributedLabel(frame: CGRectZero)
		let label = TTTAttributedLabel(frame: CGRectMake(20, view.frame.height/2, view.frame.width - 20, view.frame.height / 2))
		label.numberOfLines = 0
		
		let string = "Search here <a href=\"http://google.com\">Google</a> or here <a href=\"http://yahoo.com\">Yahoo</a>" as NSString
		
		let replacePattern = "<a href=\"[^\"]+\">([^<]+)</a>"
		let findPattern = "<a href=\"(.*?)\">(.*?)</a>"
		
		var error: NSError? = nil
		
		var replaceRegex = NSRegularExpression(pattern: replacePattern, options: NSRegularExpressionOptions.DotMatchesLineSeparators, error: &error)
		var findRegex = NSRegularExpression(pattern: findPattern, options: NSRegularExpressionOptions.DotMatchesLineSeparators, error: &error)
		
		
		var findResult = replaceRegex?.stringByReplacingMatchesInString(string, options: nil, range: NSRange(location:0, length: string.length), withTemplate: "$1")
		
		var replaceString = NSString(string: findResult!)
		
		var arrayOfAllMatches = findRegex?.matchesInString(string, options: nil, range: NSMakeRange(0, string.length)) as Array<NSTextCheckingResult>
		
		label.delegate = self
		label.enabledTextCheckingTypes = NSTextCheckingType.Link.rawValue
		label.setText(replaceString)
		
		for match in arrayOfAllMatches {
			let link = string.substringWithRange(match.rangeAtIndex(1)) // link
			let text = string.substringWithRange(match.rangeAtIndex(2)) // text
			
			let range:NSRange = replaceString.rangeOfString(text)
			let URL = NSURL(string: link)
			label.addLinkToURL(URL, withRange: range)
		}
		
		view.addSubview(label)
		
		label.sizeToFit()
		
	}
	
	func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
		UIApplication.sharedApplication().openURL(url)
	}
	
}

