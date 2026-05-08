#!/usr/bin/env swift
// ocr.swift - Built-in macOS Vision framework OCR (NO external dependencies)
// Uses: Vision framework, CoreGraphics, AppKit

import Foundation
import Vision
import AppKit

// -------- Download Image --------

func downloadImage(from urlString: String) -> NSImage? {
    guard let url = URL(string: urlString) else { return nil }
    guard let data = try? Data(contentsOf: url) else { return nil }
    return NSImage(data: data)
}

// -------- Perform OCR via Vision Framework --------

func performOCR(on image: NSImage) -> String {
    guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
        return "ERROR: Could not convert to CGImage"
    }

    var recognizedText = ""
    let semaphore = DispatchSemaphore(value: 0)

    let request = VNRecognizeTextRequest { request, error in
        defer { semaphore.signal() }

        guard error == nil,
              let observations = request.results as? [VNRecognizedTextObservation] else {
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
        try? handler.perform([request])
    }

    semaphore.wait()
    return recognizedText
}

// -------- Get Image Info --------

func getImageInfo(from image: NSImage) -> (width: Int, height: Int) {
    var width = 0
    var height = 0
    if let rep = image.representations.first as? NSBitmapImageRep {
        width = rep.pixelsWide
        height = rep.pixelsHigh
    }
    if width == 0 || height == 0 {
        width = Int(image.size.width)
        height = Int(image.size.height)
    }
    return (width, height)
}

// -------- Main --------

let args = ProcessInfo.processInfo.arguments

if args.count < 2 {
    print("Usage: ocr.swift <image-url-or-path>")
    print("Example: ocr.swift https://example.com/screenshot.png")
    exit(1)
}

let input = args[1]
var image: NSImage?

if input.hasPrefix("http://") || input.hasPrefix("https://") {
    print("[ocr] Downloading from: \(input)")
    image = downloadImage(from: input)
} else {
    image = NSImage(contentsOfFile: input)
}

guard let img = image else {
    print("ERROR: Could not load image")
    exit(1)
}

let (width, height) = getImageInfo(from: img)
print("")
print("IMAGE ANALYSIS")
print("==============")
print("")
print("Source: \(input)")
print("Dimensions: \(width) x \(height)")
print("")

print("EXTRACTED TEXT (OCR):")
print("---------------------")
let text = performOCR(on: img)

if text.isEmpty {
    print("(No text detected in image)")
} else {
    print(text)
}
print("")
