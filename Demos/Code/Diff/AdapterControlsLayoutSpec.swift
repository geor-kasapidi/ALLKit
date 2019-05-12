import Foundation
import UIKit
import ALLKit

struct AdapterControlsModel {
    let delayChanged: (TimeInterval) -> Void
    let movesEnabledChanged: (Bool) -> Void
}

final class AdapterControlsLayoutSpec: ModelLayoutSpec<AdapterControlsModel> {
    override func makeNodeFrom(model: AdapterControlsModel, sizeConstraints: SizeConstraints) -> LayoutNode {
        let sliderTitle = "Reload delay".attributed()
            .font(.systemFont(ofSize: 8))
            .foregroundColor(UIColor.black)
            .make()

        let switcherTitle = "Moves enabled".attributed()
            .font(.systemFont(ofSize: 8))
            .foregroundColor(UIColor.black)
            .make()

        let sliderTitleNode = LayoutNode(sizeProvider: sliderTitle, config: { node in
            node.width = 40
        }) { (label: UILabel, _) in
            label.numberOfLines = 0
            label.attributedText = sliderTitle
        }

        let sliderNode = LayoutNode(config: { node in
            node.marginLeft = 8
            node.height = 24
            node.width = 80
        }) { (slider: UISlider, _) in
            slider.minimumValue = 0.05
            slider.maximumValue = 2.0
            slider.value = 0.5

            slider.all_setEventHandler(for: .valueChanged, { [weak slider] in
                slider.flatMap { model.delayChanged(TimeInterval($0.value)) }
            })
        }

        guard #available(iOS 11.0, *) else {
            return LayoutNode(children: [sliderTitleNode, sliderNode], config: { node in
                node.flexDirection = .row
                node.alignItems = .center
            })
        }

        let swicherTitleNode =  LayoutNode(sizeProvider: switcherTitle, config: { node in
            node.marginLeft = 40
            node.width = 40
        }) { (label: UILabel, _) in
            label.numberOfLines = 0
            label.attributedText = switcherTitle
        }

        let switcherNode = LayoutNode(config: { node in
            node.marginLeft = 8
            node.width = 51
            node.height = 32
        }) { (switcher: UISwitch, _) in
            switcher.setOn(true, animated: false)

            switcher.all_setEventHandler(for: .valueChanged, { [weak switcher] in
                switcher.flatMap { model.movesEnabledChanged($0.isOn) }
            })
        }

        return LayoutNode(children: [sliderTitleNode, sliderNode, swicherTitleNode, switcherNode], config: { node in
            node.flexDirection = .row
            node.alignItems = .center
        })
    }
}
