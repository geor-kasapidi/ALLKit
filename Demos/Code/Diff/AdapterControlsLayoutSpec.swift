import Foundation
import UIKit
import ALLKit

struct AdapterControlsModel {
    let delayChanged: (TimeInterval) -> Void
    let movesEnabledChanged: (Bool) -> Void
}

final class AdapterControlsLayoutSpec: ModelLayoutSpec<AdapterControlsModel> {
    override func makeNodeWith(boundingDimensions: LayoutDimensions<CGFloat>) -> LayoutNodeConvertible {
        let sliderTitle = "Reload delay".attributed()
            .font(.systemFont(ofSize: 8))
            .foregroundColor(UIColor.black)
            .make()

        let switcherTitle = "Moves enabled".attributed()
            .font(.systemFont(ofSize: 8))
            .foregroundColor(UIColor.black)
            .make()

        let sliderTitleNode = LayoutNode(sizeProvider: sliderTitle, {
            $0.width(40)
        }) { (label: UILabel, _) in
            label.numberOfLines = 0
            label.attributedText = sliderTitle
        }

        let sliderNode = LayoutNode({
            $0.margin(.left(8)).height(24).width(80)
        }) { (slider: UISlider, _) in
            slider.minimumValue = 0.05
            slider.maximumValue = 2.0
            slider.value = 0.5

            slider.all_setEventHandler(for: .valueChanged, { [weak slider] in
                slider.flatMap { self.model.delayChanged(TimeInterval($0.value)) }
            })
        }

        guard #available(iOS 11.0, *) else {
            return LayoutNode(children: [sliderTitleNode, sliderNode], {
                $0.flexDirection(.row).alignItems(.center)
            })
        }

        let swicherTitleNode =  LayoutNode(sizeProvider: switcherTitle, {
            $0.margin(.left(40)).width(40)
        }) { (label: UILabel, _) in
            label.numberOfLines = 0
            label.attributedText = switcherTitle
        }

        let switcherNode = LayoutNode({
            $0.margin(.left(8)).width(51).height(32)
        }) { (switcher: UISwitch, _) in
            switcher.setOn(true, animated: false)

            switcher.all_setEventHandler(for: .valueChanged, { [weak switcher] in
                switcher.flatMap { self.model.movesEnabledChanged($0.isOn) }
            })
        }

        return LayoutNode(children: [sliderTitleNode, sliderNode, swicherTitleNode, switcherNode], {
            $0.flexDirection(.row).alignItems(.center)
        })
    }
}
