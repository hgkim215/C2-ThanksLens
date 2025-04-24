//
//  CalendarViewModel.swift
//  ThanksLens
//
//  Created by 김현기 on 4/16/25.
//

import SwiftData
import SwiftUI

class CalendarViewModel: ObservableObject {
  @Query var monthlyImages: [MonthlyImage]

  @Published var selectedImage: UIImage?

  @Published var currentDate: Date = .now
  @Published var currentMonth: Int = 0

  @Published var selectedDate: Date = .now
  @Published var selectedYear: Int = Calendar.current.component(.year, from: .now)
  @Published var selectedMonth: Int = Calendar.current.component(.month, from: .now)

  /// 현재 캘린더에 보이는 month 구하는 함수
  func getCurrentMonth(addingMonth: Int) -> Date {
    // 현재 날짜 캘린더
    let calendar = Calendar.current

    // 현재 날짜의 month에 addingMonth의 month를 더해서 새로운 month를 만들어서
    // Ex. 오늘이 1월 27일이라면, addingMonth에 2를 넣으면 3월 27일이 됨.
    guard let currentMonth = calendar.date(
      byAdding: .month,
      value: addingMonth,
      to: Date()
    ) else { return Date() }

    return currentMonth
  }

  /// 두 날짜가 같은 날인지 확인하는 함수
  func isSameDay(date1: Date, date2: Date) -> Bool {
    let calendar = Calendar.current
    return calendar.isDate(date1, inSameDayAs: date2)
  }

  /// 해당 월의 모든 날짜들을 DateValue 배열로 만들어주는 함수.
  /// 모든 날짜를 배열로 만들어야 Grid에서 보여줄 수가 있다.
  func extractDate(currentMonth: Int) -> [DateValue] {
    let calendar = Calendar.current

    // getCurrentMonth가 리턴한 month 구해서 해당 currentMonth를 통해서
    let presentedMonth = getCurrentMonth(addingMonth: currentMonth)

    // currentMonth가 리턴한 month의 모든 날짜를 구하기
    // map과 비슷하게 동작하지만, 변환 과정에서 nil 값을 걸러내고, 옵셔널이 아닌 값만 반환하는 특징
    var days = presentedMonth.getAllDates().compactMap { date -> DateValue in
      // date = 2023-12-31 15:00:00 +0000
      let day = calendar.component(.day, from: date)

      // DateValue = DateValue(id: "6D2CCF74-1217-4370-8D5E-9A7F2F4A0C3C", day: 31, date: 2023-12-31 15:00:00 +0000)
      return DateValue(day: day, date: date)
    }

    // days로 구한 month의 가장 첫 날이 시작되는 요일 구하기
    // Int로 리턴함. 일요일 1 ~ 토요일 7
    let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())

    // month의 가장 첫날이 시작되는 요일 이전을 채워주는 과정
    // 만약 1월 1일이 수요일에 시작된다면 일~화요일까지 공백이니까 이 자리를 채워주어야 수요일부터 시작되는 캘린더 모양이 생성됨
    // 그래서 만약 수요일(4)이 시작이라고 하면 일(1)~화(3) 까지 for-in문 돌려서 공백 추가
    // 캘린더 뷰에서 월의 첫 주를 올바르게 표시하기 위한 코드
    for _ in 0 ..< firstWeekday - 1 {
      // day: -1은 공백을 표시한 개념
      days.insert(DateValue(day: -1, date: Date()), at: 0)
    }

    return days
  }

  /// 현재 연도, 월 String으로 변경하는 formatter로 배열을 구하는 함수
  func getYearAndMonthString(currentDate: Date) -> [String] {
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY MMMM"
    formatter.locale = Locale(identifier: "ko_KR")

    let date = formatter.string(from: currentDate)
    // .components(separatedBy: " ")는 공백(" ")을 기준으로 문자열을 나누는 역할을 합니다.
    return date.components(separatedBy: " ")
  }

  // MARK: - 각 월 대표사진 저장 관련

  // 월별 대표 이미지 저장
  func saveMonthlyImage(context: ModelContext, imageData: Data, year: Int, month: Int) {
    let request = FetchDescriptor<MonthlyImage>(
      predicate: #Predicate { $0.year == year && $0.month == month }
    )
    do {
      if let existingImage = try context.fetch(request).first {
        existingImage.uploadedImage = imageData
        try context.save()
      } else {
        let newImage = MonthlyImage(year: year, month: month, uploadedImage: imageData)
        context.insert(newImage)
        try context.save()
      }
    } catch {
      print("이미지 저장 실패: \(error)")
    }
  }

  // 월별 대표 이미지 불러오기
  func loadMonthlyImage(context: ModelContext) {
    let request = FetchDescriptor<MonthlyImage>(
      predicate: #Predicate { $0.year == selectedYear && $0.month == selectedMonth }
    )
    do {
      if let image = try context.fetch(request).first {
        selectedImage = UIImage(data: image.uploadedImage)
        print("이미지 로드 성공")

      } else {
        selectedImage = nil
        print("이미지 없음")
      }
    } catch {
      print("Failed to load monthly image: \(error)")
    }
  }

  func circleColor(for date: Date, polaroids: [ThanksPolaroid]) -> Color {
    if polaroids.contains(where: { Calendar.current.isDate($0.createdAt, inSameDayAs: date) }) {
      return .customBlue // 폴라로이드가 생성된 경우
    } else {
      return .customGray1 // 폴라로이드가 생성되지 않은 경우
    }
  }
}
