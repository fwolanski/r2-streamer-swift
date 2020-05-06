//
// Created by Filip Wolanski on 2020-05-04.
// Copyright (c) 2020 Readium. All rights reserved.
//

import Foundation


public class FontResource {
    private let fontFamily: String
    private let normalResourceURL: URL
    private let italicResourceURL: URL?
    private let boldResourceURL: URL?
    private let boldItalicResourceURL: URL?

    public init(fontFamily: String, normalResourceURL: URL, italicResourceURL: URL? = nil, boldResourceURL: URL? = nil, boldItalicResourceURL: URL? = nil) {
        self.fontFamily = fontFamily
        self.normalResourceURL = normalResourceURL
        self.italicResourceURL = italicResourceURL
        self.boldResourceURL = boldResourceURL
        self.boldItalicResourceURL = boldItalicResourceURL
    }

    var styleTag: String {
        var css = "<style type=\"text/css\">" + getCSS(url: normalResourceURL, weight: "normal", style: "normal")

        if let italic = italicResourceURL {
            css += getCSS(url: italic, weight: "normal", style: "italic")
        }

        if let bold = boldResourceURL {
            css += getCSS(url: bold, weight: "bold", style: "normal")
        }

        if let boldItalic = boldItalicResourceURL {
            css += getCSS(url: boldItalic, weight: "bold", style: "italic")
        }

        return css + "</style>\n"
    }

    var servedPaths: [URL: String] {
        var paths: [URL: String] = [normalResourceURL: servedPath(url: normalResourceURL)]

        if let italic = italicResourceURL {
            paths[italic] = servedPath(url: italic)
        }

        if let bold = boldResourceURL {
            paths[bold] = servedPath(url: bold)
        }

        if let boldItalic = boldItalicResourceURL {
            paths[boldItalic] = servedPath(url: boldItalic)
        }

        return paths
    }

    private func servedPath(url: URL) -> String {
        return "/font-resource/\(url.absoluteString.lastPathComponent)"
    }

    private func getCSS(url: URL, weight: String, style: String) -> String {
        var format: String = "";
        if let typeFormat = self.getFormat(url: url) {
            format = "format(\"\(typeFormat)\")"
        }

        return """
               @font-face {
                   font-family: "\(fontFamily)";
                   src: url(\(servedPath(url: url))) \(format);
                   font-weight: \(weight);
                   font-style: \(style);
               }
               """
    }


    private func getFormat(url: URL) -> String? {
        switch url.absoluteString.pathExtension {
        case "ttf":
            return "truetype"

        case "oft":
            return "opentype"

        default:
            return nil
        }
    }
}


