import Foundation
import UIKit

public struct AttributedStringDrawing: SizeProvider {
    public let string: NSAttributedString
    public let options: NSStringDrawingOptions
    public let context: NSStringDrawingContext?

    public func calculateSize(boundedBy dimensions: LayoutDimensions<CGFloat>) -> CGSize {
        string.boundingRect(with: dimensions.size, options: options, context: context).size
    }

    public func draw(with size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)

        guard UIGraphicsGetCurrentContext() != nil else {
            return nil
        }

        defer { UIGraphicsEndImageContext() }

        string.draw(with: CGRect(origin: .zero, size: size),
                    options: options,
                    context: context)

        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension NSAttributedString {
    public func drawing(options: NSStringDrawingOptions = .usesLineFragmentOrigin,
                        context: NSStringDrawingContext? = nil) -> AttributedStringDrawing {
        return AttributedStringDrawing(
            string: self,
            options: options,
            context: context
        )
    }
}

extension NSAttributedString: SizeProvider {
    public func calculateSize(boundedBy dimensions: LayoutDimensions<CGFloat>) -> CGSize {
        return drawing().calculateSize(boundedBy: dimensions)
    }
}
