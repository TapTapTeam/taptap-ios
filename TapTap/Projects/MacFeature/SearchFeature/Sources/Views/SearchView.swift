import SwiftUI
import Core
import DesignSystem

public struct SearchView: View {
  @ObservedObject private var viewModel: SearchViewModel
  @State private var isDropdownOpen = false
  @State private var buttonFrame: CGRect = .zero
  private let onTap: (ArticleItem) -> Void
  
  public init(
    viewModel: SearchViewModel,
    onTap: @escaping (ArticleItem) -> Void
  ) {
    self.viewModel = viewModel
    self.onTap = onTap
  }
}

public extension SearchView {
  var body: some View {
    ZStack(alignment: .topTrailing) {
      if isDropdownOpen {
        Color.clear
          .contentShape(Rectangle())
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .onTapGesture { isDropdownOpen = false }
          .zIndex(1)
      }
      
      VStack(spacing: 20) {
        HStack(spacing: 0) {
          Text("'\(viewModel.query)' 관련 결과 ")
          
          Text("\(viewModel.filteredResults.count)")
            .foregroundStyle(.bl6)
          
          Text("개")
          
          Spacer()
          
          SearchCategoryButton(selectedCategory: viewModel.selectedCategory) {
            isDropdownOpen.toggle()
          }
          
          .background(
            GeometryReader { geo in
              Color.clear
                .onAppear {
                  buttonFrame = geo.frame(in: .named("searchViewCoordinate"))
                }
                .onChange(of: geo.frame(in: .named("searchViewCoordinate"))) { _, frame in
                  buttonFrame = frame
                }
            }
          )
        }
        .font(.B2_M)
        
        if viewModel.searchResults.isEmpty {
          Spacer()
          SearchResultEmptyView(query: viewModel.query)
          Spacer()
        } else {
          SearchResultView(
            items: viewModel.filteredResults,
            onTap: { item in
              onTap(item)
            }
          )
        }
      }
      .zIndex(0)
      
      if isDropdownOpen {
        SearchCategoryDropdown(
          items: viewModel.categoryItems,
          selectedItem: viewModel.selectedCategory
        ) { selected in
          viewModel.selectCategory(selected)
          isDropdownOpen = false
        }
        .padding(.top, buttonFrame.maxY + 2)
        .zIndex(2)
      }
    }
    .coordinateSpace(name: "searchViewCoordinate") // GeometryReader에서 사용할 이름 선언
    .frame(width: 600)
    .frame(maxHeight: .infinity, alignment: .top)
    .onChange(of: viewModel.query) { _, _ in
      isDropdownOpen = false
    }
  }
}
