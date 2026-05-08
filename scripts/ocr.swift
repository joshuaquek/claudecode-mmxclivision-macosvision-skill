#!/usr/bin/env swift
// ocr.swift - Built-in macOS Vision framework OCR (NO external dependencies)
// Uses: Vision framework, CoreGraphics, AppKit

import Foundation
import Vision
import AppKit

// -------- Perform OCR via Vision Framework --------

func performOCR(on imagePath: String) -> String {
    let imageURL: URL
    if imagePath.hasPrefix("http://") || imagePath.hasPrefix("https://") {
        guard let url = URL(string: imagePath) else {
            return "ERROR: Invalid URL"
        }
        imageURL = url
    } else {
        guard FileManager.default.fileExists(atPath: imagePath) else {
            return "ERROR: File not found: \(imagePath)"
        }
        imageURL = URL(fileURLWithPath: imagePath)
    }

    guard let img = NSImage(contentsOf: imageURL) else {
        return "ERROR: Could not load image from \(imagePath)"
    }

    guard let cgImage = img.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
        return "ERROR: Could not convert to CGImage"
    }

    var recognizedText = ""
    let semaphore = DispatchSemaphore(value: 0)
    var performError: Error?

    let request = VNRecognizeTextRequest { request, error in
        defer { semaphore.signal() }

        if let error = error {
            performError = error
            return
        }

        guard let observations = request.results as? [VNRecognizedTextObservation] else {
            return
        }

        let strings = observations.compactMap { observation in
            observation.topCandidates(1).first?.string
        }
        recognizedText = strings.joined(separator: "\n")
    }

    request.recognitionLevel = .accurate
    request.usesLanguageCorrection = true

    let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])

    DispatchQueue.global(qos: .userInitiated).async {
        do {
            try handler.perform([request])
        } catch {
            performError = error
            semaphore.signal()
        }
    }

    semaphore.wait()

    if let error = performError {
        return "ERROR: Vision framework error: \(error.localizedDescription)"
    }

    return recognizedText
}

// -------- Main --------

let args = ProcessInfo.processInfo.arguments

if args.count < 2 {
    print("Usage: ocr.swift <image-url-or-path>")
    print("Example: ocr.swift /tmp/screenshot.png")
    exit(1)
}

let input = args[1]

let text = performOCR(on: input)

print("EXTRACTED TEXT (OCR):")
print("---------------------")
if text.isEmpty {
    print("(No text detected in image)")
} else {
    print(text)
}
print("")
