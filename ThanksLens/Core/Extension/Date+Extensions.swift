//
//  Date+Extensions.swift
//  ThanksLens
//
//  Created by 김현기 on 4/23/25.
//

import Foundation

extension Date {
  // 현재 월의 날짜를 Date 배열로 만들어주는 함수
  func getAllDates() -> [Date] {
    // 현재 날짜 캘린더 가져오기
    let calendar = Calendar.current
    // 현재 월의 첫 날(startDate) 구하기
    // -> 일자를 지정하지 않고 year과 month만 구하기 때문에 해당 해와 해당 달의 첫날을 이런식으로 구할 수 있다.
    let startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: self)) ?? Date()
    // 현재 월의 일자 범위 (날짜 수 가져오기)
    let range = calendar.range(of: .day, in: .month, for: startDate)!
    // range의 각각의 날짜(day)들을 Date로 맵핑해서 배열로 만들기
    return range.compactMap { day -> Date in
      // to: {현재 날짜, 일자}에 day를 더해서 새로운 날짜 만듬
      calendar.date(byAdding: .day, value: day - 1, to: startDate) ?? Date()
    }
  }
}
