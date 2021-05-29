//
//  ContentView.swift
//  TestRichText
//
//  Created by 김동준 on 2021/05/29.
//

import SwiftUI
import UIKit
import RichEditorView

struct ContentView: View {
    
    @State var text: String = ""
    
    var body: some View {
        
        VStack {
            
            htmlTextView(text: $text)
            
            RichTextEditor(text: $text)
            
        }
    }
}


struct RichTextEditor: UIViewControllerRepresentable {
    
    @Binding var text: String
    
    func makeUIViewController(context: Context) -> some UIViewController {
        RichTextEditorVC(text: $text)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}


class RichTextEditorVC: UIViewController {
    
    @Binding var text: String
    
    var colorType: String = ""
    var textColor: UIColor = .black
    var textBgColor: UIColor = .red
    
    
    var editorView =  RichEditorView()
    
    lazy var toolbar: RichEditorToolbar = {
        let toolbar = RichEditorToolbar()
        toolbar.options = [
            RichEditorDefaultOption.bold,
            RichEditorDefaultOption.italic,
            RichEditorDefaultOption.indent,
            RichEditorDefaultOption.outdent,
            RichEditorDefaultOption.alignLeft,
            RichEditorDefaultOption.alignCenter,
            RichEditorDefaultOption.alignRight,
            RichEditorDefaultOption.textColor,
            RichEditorDefaultOption.textBackgroundColor,
            RichEditorDefaultOption.orderedList,
            RichEditorDefaultOption.unorderedList,
            RichEditorDefaultOption.undo,
            RichEditorDefaultOption.redo,
            RichEditorDefaultOption.strike,
            RichEditorDefaultOption.underline,
            RichEditorDefaultOption.image,
            RichEditorDefaultOption.link,
            RichEditorDefaultOption.subscript,
            RichEditorDefaultOption.superscript,
            RichEditorDefaultOption.header(20),
            RichEditorDefaultOption.clear,
            
        ]
        return toolbar
    }()
    
    
    
    init(text: Binding<String>) {
        self._text = text
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(editorView)
        self.view.addSubview(toolbar)
        
        
        let safeAreaInsets = view.safeAreaInsets
        
        //editorView
        editorView.translatesAutoresizingMaskIntoConstraints = false
        editorView.topAnchor.constraint(equalTo: view.topAnchor, constant: safeAreaInsets.top).isActive = true
        editorView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: safeAreaInsets.bottom).isActive = true
        editorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        editorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
        self.toolbar.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44)
        
        
        editorView.delegate = self
        editorView.inputAccessoryView = toolbar
        editorView.placeholder = "텍스트를 입력해주세요"
        
        toolbar.delegate = self
        toolbar.editor = editorView
        
        //삭제하는 아이템 추가하는 곳
//        let item = RichEditorOptionItem(image: nil, title: "Clear") { toolbar in
//            toolbar.editor?.html = ""
//        }
        
        
//        var options = toolbar.options
//        options.append(item)
//        toolbar.options = options
        
    }
    
    @objc private func didTapSelectColor() {
        let colorPickerVC = UIColorPickerViewController()
        colorPickerVC.delegate = self
        self.modalPresentationStyle = .fullScreen
        present(colorPickerVC, animated: true)
        
    }
}

extension RichTextEditorVC: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        
        if colorType == "textColor" {
            textColor = color
            toolbar.editor?.setTextColor(self.textColor)
        } else {
            textBgColor = color
            toolbar.editor?.setTextBackgroundColor(self.textBgColor)
        }
        
        
        print("textColor: \(self.textColor)")
        print("textBgColor: \(self.textBgColor)")
        
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        
        if colorType == "textColor" {
            textColor = color
            
        } else {
            textBgColor = color
            
        }
        
        print("textColor: \(self.textColor)")
        print("textBgColor: \(self.textBgColor)")
        
        
        
    }
    
    
}


extension RichTextEditorVC: RichEditorDelegate {
    
    func richEditor(_ editor: RichEditorView, contentDidChange content: String) {
        if content.isEmpty {
            self.text = "텍스트를 입력해주세요"
        } else {
            self.text = content
        }
    }
    
}

extension RichTextEditorVC: RichEditorToolbarDelegate {
    
    func richEditorToolbarChangeTextColor(_ toolbar: RichEditorToolbar) {
        
        colorType = "textColor"
        self.didTapSelectColor()
        
        print("textColor: \(self.textColor)")
        
        
        
    }
    
    func richEditorToolbarChangeBackgroundColor(_ toolbar: RichEditorToolbar) {
        
        colorType = "textBgColor"
        self.didTapSelectColor()
        print("textBgColor: \(self.textBgColor)")
        
        
        
        
    }
    
    func richEditorToolbarInsertImage(_ toolbar: RichEditorToolbar) {
        toolbar.editor?.insertImage("https://gravatar.com/avatar/696cf5da599733261059de06c4d1fe22", alt: "Gravatar")
    }
    
    func richEditorToolbarInsertLink(_ toolbar: RichEditorToolbar) {
        // Can only add links to selected text, so make sure there is a range selection first
        if toolbar.editor?.hasRangeSelection == true {
            toolbar.editor?.insertLink("https://github.com/cjwirth/RichEditorView", title: "Github Link")
        }
    }
    
}





struct htmlTextView: UIViewRepresentable {
    
    @Binding var text: String
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.isUserInteractionEnabled = true
        
        return textView
        
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
    
}
