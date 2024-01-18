//
//  RichTextCoordinator+Subscriptions.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-22.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

#if iOS || macOS || os(tvOS) || os(visionOS)
import SwiftUI

extension RichTextCoordinator {

    /// Make the coordinator subscribe to context changes.
    func subscribeToContextChanges() {
        subscribeToAlignment()
        subscribeToBackgroundColor()
        subscribeToFontName()
        subscribeToFontSize()
        subscribeToForegroundColor()
        subscribeToHighlightedRange()
        subscribeToHighlightingStyle()
        subscribeToIsBold()
        subscribeToIsEditingText()
        subscribeToIsItalic()
        subscribeToIsStrikethrough()
        subscribeToIsUnderlined()
        subscribeToShouldPasteImage()
        subscribeToShouldPasteImages()
        subscribeToShouldPasteText()
        subscribeToShouldSelectRange()
        subscribeToShouldSetAttributedString()
        subscribeToStrikethroughColor()
        subscribeToStrokeColor()
        subscribeToTriggerAction()
        subscribeToUnderlineColor()
    }
}

private extension RichTextCoordinator {

    func handle(_ action: RichTextAction?) {
        guard let action else { return }
        switch action {
        case .copy:
            textView.copySelection()
        case .dismissKeyboard:
            textView.resignFirstResponder()
        case .print: break
        case .redoLatestChange:
            textView.redoLatestChange()
            syncContextWithTextView()
        case .setAlignment: break
        case .stepFontSize: break
        case .stepIndent(let points):
            textView.stepRichTextIndent(points: points)
        case .stepSuperscript: break
        case .toggleStyle: break
        case .undoLatestChange:
            textView.undoLatestChange()
            syncContextWithTextView()
        case .backgroundColor(_):
            break
        case .foregroundColor(_):
            break
        case .underlineColor(_):
            break
        case .strikethroughColor(_):
            break
        case .strokeColor(_):
            break
        case .highlightedRange(_):
            break
        case .highlightingStyle(_):
            break
        case .pasteImage(_):
            break
        case .pasteImages(_):
            break
        case .pasteText(_):
            break
        case .selectRange(_):
            break
        case .setAttributedString(_):
            break
        case .triggerAction(_):
            break
        case .changeStyle(_, _):
            break
        }
    }

    func subscribeToTriggerAction() {
        richTextContext.$triggerAction
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in
                    self?.handle($0)
                })
            .store(in: &cancellables)
    }


    func subscribeToAlignment() {
        richTextContext.$textAlignment
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in
                    self?.textView.setRichTextAlignment($0)
                })
            .store(in: &cancellables)
    }

    func subscribeToBackgroundColor() {
        richTextContext.$backgroundColor
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in
                    guard let color = $0 else { return }
                    self?.textView.setRichTextColor(.background, to: color)
                })
            .store(in: &cancellables)
    }

    func subscribeToFontName() {
        richTextContext.$fontName
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in
                    self?.textView.setRichTextFontName($0)
                })
            .store(in: &cancellables)
    }

    func subscribeToFontSize() {
        richTextContext.$fontSize
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in
                    self?.textView.setRichTextFontSize($0)
                })
            .store(in: &cancellables)
    }

    func subscribeToForegroundColor() {
        richTextContext.$foregroundColor
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in
                    guard let color = $0 else { return }
                    self?.textView.setRichTextColor(.foreground, to: color)
                })
            .store(in: &cancellables)
    }

    func subscribeToHighlightedRange() {
        richTextContext.$highlightedRange
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in
                    self?.setHighlightedRange(to: $0)
                })
            .store(in: &cancellables)
    }

    func subscribeToHighlightingStyle() {
        richTextContext.$highlightingStyle
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in
                    self?.textView.highlightingStyle = $0
                })
            .store(in: &cancellables)
    }

    func subscribeToIsBold() {
        richTextContext.$isBold
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in
                    self?.setStyle(.bold, to: $0)
                })
            .store(in: &cancellables)
    }

    func subscribeToIsEditingText() {
        richTextContext.$isEditingText
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in
                    self?.setIsEditing(to: $0)
                })
            .store(in: &cancellables)
    }

    func subscribeToIsItalic() {
        richTextContext.$isItalic
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in
                    self?.setStyle(.italic, to: $0)
                })
            .store(in: &cancellables)
    }

    func subscribeToIsStrikethrough() {
        richTextContext.$isStrikethrough
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in
                    self?.setStyle(.strikethrough, to: $0)
                })
            .store(in: &cancellables)
    }

    func subscribeToIsUnderlined() {
        richTextContext.$isUnderlined
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in
                    self?.setStyle(.underlined, to: $0)
                })
            .store(in: &cancellables)
    }

    func subscribeToShouldPasteImage() {
        richTextContext.$shouldPasteImage
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in
                    self?.pasteImage($0)
                })
            .store(in: &cancellables)
    }

    func subscribeToShouldPasteImages() {
        richTextContext.$shouldPasteImages
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in
                    self?.pasteImages($0)
                })
            .store(in: &cancellables)
    }

    func subscribeToShouldPasteText() {
        richTextContext.$shouldPasteText
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in
                    self?.pasteText($0)
                })
            .store(in: &cancellables)
    }

    func subscribeToShouldSetAttributedString() {
        richTextContext.$shouldSetAttributedString
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in
                    self?.setAttributedString(to: $0)
                })
            .store(in: &cancellables)
    }

    func subscribeToShouldSelectRange() {
        richTextContext.$shouldSelectRange
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in
                    self?.setSelectedRange(to: $0)
                })
            .store(in: &cancellables)
    }

    func subscribeToStrokeColor() {
        richTextContext.$strokeColor
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in
                    guard let color = $0 else { return }
                    self?.textView.setRichTextColor(.stroke, to: color)
                })
            .store(in: &cancellables)
    }

    func subscribeToStrikethroughColor() {
        richTextContext.$strikethroughColor
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in
                    guard let color = $0 else { return }
                    self?.textView.setRichTextColor(.strikethrough, to: color)
                })
            .store(in: &cancellables)
    }

    func subscribeToUnderlineColor() {
        richTextContext.$underlineColor
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in
                    guard let color = $0 else { return }
                    self?.textView.setRichTextColor(.underline, to: color)
                })
            .store(in: &cancellables)
    }
}

internal extension RichTextCoordinator {

    func pasteImage(_ data: (image: ImageRepresentable, atIndex: Int, moveCursor: Bool)?) {
        guard let data = data else { return }
        textView.pasteImage(
            data.image,
            at: data.atIndex,
            moveCursorToPastedContent: data.moveCursor
        )
    }

    func pasteImages(_ data: (images: [ImageRepresentable], atIndex: Int, moveCursor: Bool)?) {
        guard let data = data else { return }
        textView.pasteImages(
            data.images,
            at: data.atIndex,
            moveCursorToPastedContent: data.moveCursor
        )
    }

    func pasteText(_ data: (text: String, atIndex: Int, moveCursor: Bool)?) {
        guard let data = data else { return }
        textView.pasteText(
            data.text,
            at: data.atIndex,
            moveCursorToPastedContent: data.moveCursor
        )
    }

    func setAttributedString(to newValue: NSAttributedString?) {
        guard let newValue else { return }
        textView.setRichText(newValue)
    }

    func setHighlightedRange(to range: NSRange?) {
        resetHighlightedRangeAppearance()
        guard let range = range else { return }
        setHighlightedRangeAppearance(for: range)
    }

    func setHighlightedRangeAppearance(for range: NSRange) {
        let back = textView.richTextColor(.background, at: range) ?? .clear
        let fore = textView.richTextColor(.foreground, at: range) ?? .textColor
        highlightedRangeOriginalBackgroundColor = back
        highlightedRangeOriginalForegroundColor = fore
        let style = textView.highlightingStyle
        let background = ColorRepresentable(style.backgroundColor)
        let foreground = ColorRepresentable(style.foregroundColor)
        textView.setRichTextColor(.background, to: background, at: range)
        textView.setRichTextColor(.foreground, to: foreground, at: range)
    }

    func setIsEditing(to newValue: Bool) {
        if newValue == textView.isFirstResponder { return }
        if newValue {
#if iOS || os(visionOS)
            textView.becomeFirstResponder()
#else
            print("macOS currently doesn't resign first responder.")
#endif
        } else {
#if iOS || os(visionOS)
            textView.resignFirstResponder()
#else
            print("macOS currently doesn't resign first responder.")
#endif
        }
    }

    func setSelectedRange(to range: NSRange) {
        if range == textView.selectedRange { return }
        textView.selectedRange = range
    }

    func setStyle(_ style: RichTextStyle, to newValue: Bool) {
        let hasStyle = textView.richTextStyles.hasStyle(style)
        if newValue == hasStyle { return }
        textView.setRichTextStyle(style, to: newValue)
    }
}

extension ColorRepresentable {

    #if iOS || os(tvOS) || os(visionOS)
    static var textColor: ColorRepresentable { .label }
    #endif
}
#endif
