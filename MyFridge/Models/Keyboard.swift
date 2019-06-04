import UIKit

struct Keyboard {
    let duration: Double
    let options: UIView.AnimationOptions
    let height: CGFloat
    let state: State
    
    init?(notification: Notification) {
        guard
            let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt,
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
            else { return nil }
        
        self.duration = duration
        self.options = [UIView.AnimationOptions(rawValue: curve), UIView.AnimationOptions.beginFromCurrentState]
        self.height = frame.cgRectValue.height
        self.state = State(height: height)
    }
}

extension Keyboard {
    enum State {
        case up
        case down

        init(height: CGFloat) {
            self = height < 100 ? .down : .up
        }
    }
}
