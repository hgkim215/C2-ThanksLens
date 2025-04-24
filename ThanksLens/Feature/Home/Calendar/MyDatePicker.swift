//
//  MyDatePicker.swift
//  ThanksLens
//
//  Created by 김현기 on 4/23/25.
//

import SwiftUI
import UIKit

struct MyDatePicker: View {
  @Environment(\.modelContext) private var modelContext
  @ObservedObject var calendarViewModel = CalendarViewModel()
  @Binding var isDateChangePresented: Bool

  var body: some View {
    ZStack {
      Color(.customWhite)
        .ignoresSafeArea(edges: .all)

      VStack {
        CustomDatePicker(selectedYear: $calendarViewModel.selectedYear, selectedMonth: $calendarViewModel.selectedMonth)

        Button {
          let selectedDate = createNewDate(year: calendarViewModel.selectedYear, month: calendarViewModel.selectedMonth)
          let difference = Calendar.current.dateComponents([.month], from: Calendar.current.startOfDay(for: Date()), to: selectedDate).month ?? 0

          calendarViewModel.loadMonthlyImage(context: modelContext)
          
          calendarViewModel.currentMonth = difference
          calendarViewModel.currentDate = selectedDate
          isDateChangePresented.toggle()
        } label: {
          Text("완료")
        }
        .padding()
      }
      .foregroundStyle(.customP1)
    }
  }

  private func createNewDate(year: Int, month: Int) -> Date {
    var components = DateComponents()
    components.year = year
    components.month = month
    components.day = 1

    guard let selectedDate = Calendar.current.date(from: components) else {
      return Date()
    }
    return selectedDate
  }
}

// UIViewRepresentable: UIKit의 UIView를 SwiftUI에서 사용하기 위한 프로토콜
struct CustomDatePicker: UIViewRepresentable {
  @Binding var selectedYear: Int
  @Binding var selectedMonth: Int

  func makeUIView(context: UIViewRepresentableContext<CustomDatePicker>) -> UIPickerView {
    let picker = UIPickerView()
    picker.dataSource = context.coordinator
    picker.delegate = context.coordinator

    picker.selectRow(selectedYear - 1, inComponent: 0, animated: false)
    picker.selectRow(selectedMonth - 1, inComponent: 1, animated: false)

    return picker
  }

  func updateUIView(_: UIPickerView, context _: UIViewRepresentableContext<CustomDatePicker>) {}

  func makeCoordinator() -> CustomDatePicker.Coordinator {
    return CustomDatePicker.Coordinator(self)
  }

  class Coordinator: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    var parent: CustomDatePicker

    // INIT
    init(_ pickerView: CustomDatePicker) {
      parent = pickerView
    }

    let allMonths: [Int] = Array(1 ... 12)
    var selectedYear: Int = Calendar.current.component(.year, from: .now)
    var selectedMonth: Int = Calendar.current.component(.month, from: .now)

    let formatterYear = DateFormatter()
    let formatterMonth = DateFormatter()

    var todayYear: String {
      formatterYear.dateFormat = "yyyy"
      return formatterYear.string(from: Date())
    }

    var todayMonth: String {
      formatterMonth.dateFormat = "MM"
      return formatterMonth.string(from: Date())
    }

    var availableYear: [Int] {
      var years: [Int] = []
      for i in 2025 ... Int(todayYear)! {
        years.append(i)
      }
      return years
    }

    func numberOfComponents(in _: UIPickerView) -> Int {
      return 2
    }

    // 각 컴포넌트의 행 수를 반환합니다.
    func pickerView(_: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      switch component {
      case 0:
        return availableYear.count
      case 1:
        return allMonths.count
      default:
        return 0
      }
    }

    // 각 컴포넌트의 행에 대한 제목을 반환합니다.
    func pickerView(_: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      switch component {
      case 0:
        return "\(availableYear[row])년"
      case 1:
        return "\(allMonths[row])월"
      default:
        return ""
      }
    }

    // 사용자가 선택한 행을 처리합니다.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      switch component {
      case 0:
        parent.selectedYear = availableYear[row]
      case 1:
        parent.selectedMonth = allMonths[row]
      default:
        break
      }

      if Int(todayYear)! <= parent.selectedYear && Int(todayMonth)! < parent.selectedMonth {
        pickerView.selectRow(Int(todayMonth)! - 1, inComponent: 1, animated: true)
        parent.selectedMonth = Int(todayMonth)!
      }
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing _: UIView?) -> UIView {
      let label = UILabel()
      label.text = self.pickerView(pickerView, titleForRow: row, forComponent: component) // 기존 텍스트 설정
      label.textColor = .customP1 // 원하는 색상 설정
      label.textAlignment = .center // 텍스트 정렬
      return label
    }

    func pickerView(_: UIPickerView, widthForComponent _: Int) -> CGFloat {
      return UIScreen.main.bounds.width / 3.5
    }

    func pickerView(_: UIPickerView, rowHeightForComponent _: Int) -> CGFloat {
      return 40
    }
  }
}

#Preview {
  MyDatePicker(isDateChangePresented: .constant(false))
}
