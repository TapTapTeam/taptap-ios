//
//  TargetName.swift
//  Manifests
//
//  Created by Hong on 10/6/25.
//

import ProjectDescription

public enum TargetName: String {
  case safariExtension
  case shareExtension
  
  public var sourcesPath: String {
    switch self {
    case .safariExtension: return "SafariExtension/Sources/**"
    case .shareExtension: return "ShareExtension/Sources/**"
    }
  }
  
  public var resourcesPath: String {
    switch self {
    case .safariExtension: return "SafariExtension/Resources/**"
    case .shareExtension: return "ShareExtension/Resources/**"
    }
  }
}
