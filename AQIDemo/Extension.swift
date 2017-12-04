//
//  Extension.swift
//  AQIDemo
//
//  Created by dreamer on 2017/9/21.
//  Copyright © 2017年 lxc. All rights reserved.
//

import UIKit
import AVFoundation

extension UIImage {
    
//    func averageColor() -> UIColor {
//        
//        //同比压缩图片，0.25
//        let ratio: CGFloat = 0.125
//        let w = Int(UIScreen.main.bounds.size.width * ratio)
//        let h = Int(UIScreen.main.bounds.size.height * ratio)
//        
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        let bmpInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)
//
//        let context = CGContext(data: nil, width: w, height: h, bitsPerComponent: 8, bytesPerRow: w * 4, space: colorSpace, bitmapInfo: bmpInfo.rawValue)
//        
//        let rect = CGRect(x: 0, y: 0, width: w, height: h)
//        return nil
//    }
    
    
    func crop(_ rect: CGRect) -> UIImage {
        let newCGImage = cgImage?.cropping(to: rect)
        let newImage = UIImage(cgImage: newCGImage!)
        return newImage
    }
    
    
    func areaAverage() -> UIColor {
        var bitmap = [UInt8](repeating: 0, count: 4)
        
        if #available(iOS 9.0, *) {
            // Get average color.
            
            //截取上半部分
            let newCGImage = cgImage?.cropping(to: CGRect(x: 0, y: 0, width: self.size.width, height: 50))
            let context = CIContext()
            
            let inputImage: CIImage = ciImage ?? CoreImage.CIImage(cgImage: newCGImage!)
            let extent = inputImage.extent
            let inputExtent = CIVector(x: extent.origin.x, y: extent.origin.y, z: extent.size.width, w: extent.size.height)
            let filter = CIFilter(name: "CIAreaAverage", withInputParameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: inputExtent])!
            let outputImage = filter.outputImage!
            let outputExtent = outputImage.extent
            assert(outputExtent.size.width == 1 && outputExtent.size.height == 1)
            
            // Render to bitmap.
            context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: kCIFormatRGBA8, colorSpace: CGColorSpaceCreateDeviceRGB())
        } else {
            // Create 1x1 context that interpolates pixels when drawing to it.
            let context = CGContext(data: &bitmap, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
            let inputImage = cgImage ?? CIContext().createCGImage(ciImage!, from: ciImage!.extent)
            
            // Render to bitmap.
            context.draw(inputImage!, in: CGRect(x: 0, y: 0, width: 1, height: 1))
        }
        
        // Compute result.
        let result = UIColor(red: CGFloat(bitmap[0]) / 255.0, green: CGFloat(bitmap[1]) / 255.0, blue: CGFloat(bitmap[2]) / 255.0, alpha: CGFloat(bitmap[3]) / 255.0)
        return result
    }
    
}


//extension AVAudioSession {
//    var isHeadphones: Bool {
//        return portType == AVAudioSessionPortHeadphones
//    }
//}









