import SwiftUI
import Combine

// MARK: - Helper function of View to operate on.
extension View {
    /// Conditional modifier
    @ViewBuilder func `if`<Content: View>(_ conditional: Bool, @ViewBuilder _ content: (Self) -> Content) -> some View {
        if conditional {
            content(self)
        } else {
            self
        }
    }

    /// Closure given view and unwrapped optional value if optional is set.
    /// - Parameters:
    ///   - conditional: Optional value.
    ///   - content: Closure to run on view with unwrapped optional.
    @ViewBuilder func iflet<Content: View, T>(_ conditional: Optional<T>, @ViewBuilder _ content: (Self, _ value: T) -> Content) -> some View {
        if let value = conditional {
            content(self, value)
        } else {
            self
        }
    }

    /// Closure given view if conditional.
    /// - Parameters:
    ///   - conditional: Boolean condition.
    ///   - truthy: Closure to run on view if true.
    ///   - falsy: Closure to run on view if false.
    @ViewBuilder func `if`<Truthy: View, Falsy: View>(
        _ conditional: Bool = true,
        @ViewBuilder _ truthy: (Self) -> Truthy,
        @ViewBuilder else falsy: (Self) -> Falsy
    ) -> some View {
        if conditional {
            truthy(self)
        } else {
            falsy(self)
        }
    }
}
