import Foundation
import UIKit

extension String {
    public func attributed() -> AttributedStringBuilder {
        return AttributedStringBuilder(self)
    }
}

public final class AttributedStringBuilder {
    private let string: String

    public init(_ string: String) {
        self.string = string
    }

    // MARK: -

    private var attributes = [NSAttributedString.Key: Any]()

    private var paragraphStyle: NSMutableParagraphStyle {
        if let style = attributes[.paragraphStyle] as? NSMutableParagraphStyle {
            return style
        }

        let style = NSMutableParagraphStyle()

        attributes[.paragraphStyle] = style

        return style
    }

    // MARK: -

    public func alignment(_ value: NSTextAlignment) -> Self {
        paragraphStyle.alignment = value

        return self
    }

    public func allowsDefaultTighteningForTruncation(_ value: Bool) -> Self {
        paragraphStyle.allowsDefaultTighteningForTruncation = value

        return self
    }

    public func backgroundColor(_ value: UIColor) -> Self {
        attributes[.backgroundColor] = value

        return self
    }

    public func baseWritingDirection(_ value: NSWritingDirection) -> Self {
        paragraphStyle.baseWritingDirection = value

        return self
    }

    public func baselineOffset(_ value: Float) -> Self {
        attributes[.baselineOffset] = NSNumber(value: value)

        return self
    }

    public func defaultTabInterval(_ value: CGFloat) -> Self {
        paragraphStyle.defaultTabInterval = value

        return self
    }

    public func expansion(_ value: Float) -> Self {
        attributes[.expansion] = NSNumber(value: value)

        return self
    }

    public func firstLineHeadIndent(_ value: CGFloat) -> Self {
        paragraphStyle.firstLineHeadIndent = value

        return self
    }

    public func font(_ value: UIFont) -> Self {
        attributes[.font] = value

        return self
    }

    public func foregroundColor(_ value: UIColor) -> Self {
        attributes[.foregroundColor] = value

        return self
    }

    public func headIndent(_ value: CGFloat) -> Self {
        paragraphStyle.headIndent = value

        return self
    }

    public func hyphenationFactor(_ value: Float) -> Self {
        paragraphStyle.hyphenationFactor = value

        return self
    }

    public func kern(_ value: Float) -> Self {
        attributes[.kern] = NSNumber(value: value)

        return self
    }

    public func ligature(_ value: Int) -> Self {
        attributes[.ligature] = NSNumber(value: value)

        return self
    }

    public func lineBreakMode(_ value: NSLineBreakMode) -> Self {
        paragraphStyle.lineBreakMode = value

        return self
    }

    public func lineHeightMultiple(_ value: CGFloat) -> Self {
        paragraphStyle.lineHeightMultiple = value

        return self
    }

    public func lineSpacing(_ value: CGFloat) -> Self {
        paragraphStyle.lineSpacing = value

        return self
    }

    public func maximumLineHeight(_ value: CGFloat) -> Self {
        paragraphStyle.maximumLineHeight = value

        return self
    }

    public func minimumLineHeight(_ value: CGFloat) -> Self {
        paragraphStyle.minimumLineHeight = value

        return self
    }

    public func obliqueness(_ value: Float) -> Self {
        attributes[.obliqueness] = NSNumber(value: value)

        return self
    }

    public func paragraphSpacing(_ value: CGFloat) -> Self {
        paragraphStyle.paragraphSpacing = value

        return self
    }

    public func paragraphSpacingBefore(_ value: CGFloat) -> Self {
        paragraphStyle.paragraphSpacingBefore = value

        return self
    }

    public func shadow(offsetX: CGFloat,
                       offsetY: CGFloat,
                       blurRadius: CGFloat,
                       color: UIColor?) -> Self {
        let value = NSShadow()
        value.shadowOffset = CGSize(width: offsetX, height: offsetY)
        value.shadowBlurRadius = blurRadius
        value.shadowColor = color

        attributes[.shadow] = value

        return self
    }

    public func strikethroughColor(_ value: UIColor) -> Self {
        attributes[.strikethroughColor] = value

        return self
    }

    public func strikethroughStyle(_ value: Int) -> Self {
        attributes[.strikethroughStyle] = NSNumber(value: value)

        return self
    }

    public func strokeColor(_ value: UIColor) -> Self {
        attributes[.strokeColor] = value

        return self
    }

    public func strokeWidth(_ value: Float) -> Self {
        attributes[.strokeWidth] = NSNumber(value: value)

        return self
    }

    public func tailIndent(_ value: CGFloat) -> Self {
        paragraphStyle.tailIndent = value

        return self
    }

    public func underlineColor(_ value: UIColor) -> Self {
        attributes[.underlineColor] = value

        return self
    }

    public func underlineStyle(_ value: NSUnderlineStyle) -> Self {
        attributes[.underlineStyle] = NSNumber(value: value.rawValue)

        return self
    }

    // MARK: -

    public func make() -> NSAttributedString {
        return NSAttributedString(
            string: string,
            attributes: attributes
        )
    }

    public func makeMutable() -> NSMutableAttributedString {
        return NSMutableAttributedString(
            string: string,
            attributes: attributes
        )
    }
}
