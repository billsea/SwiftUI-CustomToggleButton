//
//  ContentView.swift
//  SwiftUI-CustomToggleButton
//
//  Created by Bill Seaman on 5/6/22.
//

import SwiftUI

struct ContentView: View {
  @State private var active = false

  var body: some View {
    Toggle(isOn: $active, label: {
      Text("")
    })
      .toggleStyle(CheckmarkToggleStyle(handler: {
        print("toggled")
      }))
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CheckmarkToggleStyle: ToggleStyle {
  var handler: () -> Void

  private var minPosition = -DefaultConstants.callActionSliderFramePositionOffset
  private var maxPosition = DefaultConstants.callActionSliderFramePositionOffset
  private var activeThreshold = DefaultConstants.callActionSliderActiveThreshold

  @State private var position = -DefaultConstants.callActionSliderFramePositionOffset
  @State private var backgroundOpacity = 0.0

  @GestureState private var dragOffset = CGSize.zero

  public init(handler: @escaping () -> Void) {
    self.handler = handler
  }

  func makeBody(configuration: Configuration) -> some View {
    HStack {
      LinearGradient(gradient: Gradient(colors: [Color(UIColor.sosecPanelButton), Color(UIColor.sosecBackgroundPanelActive)]), startPoint: .leading, endPoint: .trailing)
        .opacity(backgroundOpacity)
        .frame(width: DefaultConstants.callActionActionSliderFrameSize.width, height: DefaultConstants.callActionActionSliderFrameSize.height, alignment: .center)
        .overlay(
          Text(self.position == maxPosition ? "" : "slide to toggle")
            .foregroundColor(Color(UIColor.sosecBackgroundPanelText))
            .font(Font.textStyle22)
            .padding(.trailing, DefaultConstants.buttonLabelInsertPadding)
        )
        .animation(.easeInOut)
        .overlay(
          Circle()
            .foregroundColor(Color(UIColor.sosecPanelButton))
            .padding(.all, DefaultConstants.callActionSliderButtonPadding)
            .shadow(color: Color(UIColor.sosecPanelButton), radius: DefaultConstants.callActionSliderButtonShadowRadius, x: 1.0, y: 4.0)
            .overlay(
              Circle()
                .foregroundColor(Color(UIColor.sosecPanelButtonActive))
                .padding(.all, DefaultConstants.callActionSliderButtonPadding)
                .shadow(color: Color(UIColor.sosecPanelButtonActive), radius: DefaultConstants.callActionSliderButtonShadowRadius, x: 1.0, y: 4.0)
                .opacity(backgroundOpacity)
            )
            .overlay(
                Text("!")
                  .foregroundColor(.white)
                  .font(Font.textStyle21)
            )
            .offset(x: position + dragOffset.width, y: 0)
            .animation(.easeInOut)
            .gesture(
              DragGesture()
                .updating($dragOffset, body: { (value, state, transaction) in
                  if value.translation.width <= DefaultConstants.callActionSliderMaxLimit {
                    state = value.translation
                  }
                })
                .onEnded({ (value) in
                  self.position += value.translation.width

                  if self.position > minPosition {
                    if self.position >= activeThreshold {
                      self.position = maxPosition
                      self.handler()
                      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.position = minPosition
                        self.backgroundOpacity = 0.0
                      }
                    } else {
                      self.position = minPosition
                      self.backgroundOpacity = 0.0
                    }
                  } else {
                    self.position = minPosition
                  }
                })
                .onChanged({value in
                  self.backgroundOpacity = value.translation.width/DefaultConstants.callActionSliderMaxLimit
                })
            )
        )
    }
    .background(Color(UIColor.sosecBackgroundPanel))
    .cornerRadius(DefaultConstants.callActionSliderFrameCornerRadius)
  }
}

public struct DefaultConstants {
  public static let callActionTopCircleSize = CGSize(width: 180, height: 180)
  public static let callActionTopInnerCircleSize = CGSize(width: 160, height: 160)
  public static let callActionActionSliderFrameSize = CGSize(width: 360, height: 74)
  public static let callActionSliderFramePositionOffset = 144.0
  public static let callActionSliderActiveThreshold = 75.0
  public static let callActionSliderFrameCornerRadius = 40.0
  public static let callActionSliderButtonPadding = 10.0
  public static let callActionSliderButtonShadowRadius = 6.0
  public static let callActionSliderMaxLimit = 287.0
  public static let buttonLabelInsertPadding: CGFloat = 45.0
}

extension UIColor {
  class var sosecBackgroundPanel: UIColor {
    return UIColor(red: 255.0 / 255.0, green: 128.0 / 255.0, blue: 12.0 / 255.0, alpha: 0.1)
  }

  class var sosecPanelButton: UIColor {
    return UIColor(red: 255.0 / 255.0, green: 128.0 / 255.0, blue: 12.0 / 255.0, alpha: 1.0)
  }

  class var warmBlackFiftyPercent: UIColor {
    return UIColor(red: 0.0, green: 21.0 / 255.0, blue: 35.0 / 255.0, alpha: 0.5)
  }

  class var sosecBackgroundPanelActive: UIColor {
    return UIColor(red: 255.0 / 255.0, green: 81.0 / 255.0, blue: 81.0 / 255.0, alpha: 1.0)
  }

  class var sosecPanelButtonActive: UIColor {
    return UIColor(red: 110.0 / 255.0, green: 6.0 / 255.0, blue: 6.0 / 255.0, alpha: 1.0)
  }

  class var sosecBackgroundPanelText: UIColor {
    return UIColor(red: 176.0 / 255.0, green: 96.0 / 255.0, blue: 4.0 / 255.0, alpha: 1.0)
  }

  class var sosecBackgroundPanelActiveLight: UIColor {
    return UIColor(red: 255.0 / 255.0, green: 81.0 / 255.0, blue: 81.0 / 255.0, alpha: 0.1)
  }

  class var sosecPulseCircleStarting: UIColor {
    return UIColor(red: 255.0 / 255.0, green: 128.0 / 255.0, blue: 12.0 / 255.0, alpha: 1.0)
  }

  class var sosecPulseCircleEnding: UIColor {
    return UIColor(red: 255.0 / 255.0, green: 81.0 / 255.0, blue: 92.0 / 255.0, alpha: 1.0)
  }

  class var sosecErrorPanelBackground: UIColor {
    return UIColor(red: 255.0 / 255.0, green: 81.0 / 255.0, blue: 81.0 / 255.0, alpha: 0.06)
  }
}

extension Font {
  public static var textStyle21: Font {
    return Font.system(size: 15.0, weight: Font.Weight.heavy, design: .rounded)
  }

  public static var textStyle22: Font {
    return Font.system(size: 15.0, weight: Font.Weight.semibold, design: .default)
  }
}
