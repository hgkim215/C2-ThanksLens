//
//  CustomCalendarView.swift
//  ThanksLens
//
//  Created by 김현기 on 4/22/25.
//

import SwiftData
import SwiftUI

struct DateValue: Identifiable {
  var id: String = UUID().uuidString
  var day: Int
  var date: Date
}

struct ThanksCalendarView: View {
  @ObservedObject var calendarViewModel: CalendarViewModel

  @Query var thanksPolaroids: [ThanksPolaroid]

  var body: some View {
    VStack {
      YearMonthHeaderView(calendarViewModel: calendarViewModel)

      CalendarContentView(calendarViewModel: calendarViewModel, polaroids: thanksPolaroids)
    }
  }

  // MARK: - YearMonth 헤더 뷰

  struct YearMonthHeaderView: View {
    @ObservedObject var calendarViewModel: CalendarViewModel

    @State var isDateChangeSheetPresented: Bool = false

    var yearMonthText: Text {
      let yearMonthList: [String] = calendarViewModel.getYearAndMonthString(currentDate: calendarViewModel.currentDate)

      return Text("\(yearMonthList[0])년 \(yearMonthList[1])")
    }

    var body: some View {
      HStack {
        // 연도, 월 텍스트
        yearMonthText
        // 날짜 이동 시트 버튼
        Image(systemName: "chevron.down")
      }
      .onTapGesture {
        isDateChangeSheetPresented.toggle()
      }
      .sheet(isPresented: $isDateChangeSheetPresented) {
        MyDatePicker(calendarViewModel: calendarViewModel, isDateChangePresented: $isDateChangeSheetPresented)
          .presentationDetents([.fraction(0.4)])
      }
      .font(.PoorStory(size: 20))
      .foregroundStyle(.customP1)
    }
  }

  // MARK: - CalendarContent뷰

  struct CalendarContentView: View {
    @ObservedObject var calendarViewModel: CalendarViewModel
    var polaroids: [ThanksPolaroid]

    @State private var offset: CGSize = .init()

    var body: some View {
      VStack {
        WeekdayHeaderView()
        DateGridView(calendarViewModel: calendarViewModel, polaroids: polaroids)
      }
      .padding(.top, 10)
    }

    // MARK: - Weekday 헤더 뷰

    struct WeekdayHeaderView: View {
      private let weekdays: [String] = ["일", "월", "화", "수", "목", "금", "토"]

      var body: some View {
        HStack {
          ForEach(weekdays, id: \.self) { weekday in
            Text(weekday)
              .font(.PoorStory(size: 20))
              .frame(maxWidth: .infinity)
              .foregroundStyle(weekday == "토" || weekday == "일" ? .customP1 : .customP2)
          }
        }
      }
    }

    // MARK: - DateGrid 뷰

    struct DateGridView: View {
      @ObservedObject var calendarViewModel: CalendarViewModel
      var polaroids: [ThanksPolaroid]

      private let columns = Array(repeating: GridItem(.flexible()), count: 7)

      var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
          ForEach(calendarViewModel.extractDate(currentMonth: calendarViewModel.currentMonth)) { value in
            if value.day != -1 {
              DateButton(
                calendarViewModel: calendarViewModel,
                polaroids: polaroids,
                value: value
              )
            } else {
              // 빈 날짜 -1
              Text("\(value.day)").hidden()
            }
          }
        }
      }
    }

    // MARK: - 날짜 버튼

    struct DateButton: View {
      @ObservedObject var calendarViewModel: CalendarViewModel

      @EnvironmentObject var homeViewModel: HomeViewModel
      @EnvironmentObject var galleryViewModel: GalleryViewModel

      var polaroids: [ThanksPolaroid]
      var value: DateValue

      // 오늘인지 아닌지 확인
      private var isToday: Bool {
        Calendar.current.isDateInToday(value.date)
      }

      // 해당 날짜가 무슨 요일인지 (일요일이면 Red로)
      private var dayOfWeek: Int {
        Calendar.current.component(.weekday, from: value.date)
      }

      // 날짜 선택되었을 시
      private var isSelected: Bool {
        calendarViewModel.isSameDay(date1: value.date, date2: calendarViewModel.selectedDate)
      }

      var body: some View {
        VStack {
          Button {
            calendarViewModel.selectedDate = value.date
            galleryViewModel.selectedDate = value.date

            homeViewModel.changeSelectedTab(.gallery)
          } label: {
            VStack(spacing: 3) {
              Text(isToday ? "오늘" : "")
                .font(.Gaegu_Regular(size: 14))
                .foregroundStyle(.customP1)
                .padding(.bottom, -5)

              Text("\(value.day)")
                // 감사사진을 올린 날과 안 올린 날 색깔 다르게하기
                .foregroundStyle(.customP1)
                .font(.Gaegu_Bold(size: 18))

              Circle()
                // 감사 사진 올린 날과 안 올린 날 색깔 다르게하기
                .fill(calendarViewModel.circleColor(for: value.date, polaroids: polaroids))
                .frame(width: 6, height: 6)
            }
            .background(
              Circle()
                .fill(isSelected ? .customP3 : .customP4)
                .frame(width: 50, height: 50)
                .opacity(isSelected ? 1 : 0)
            )
          }
        }
        .disabled(value.date > Date() ? true : false)
      }
    }
  }
}

#Preview {
  ThanksCalendarView(calendarViewModel: CalendarViewModel())
}
