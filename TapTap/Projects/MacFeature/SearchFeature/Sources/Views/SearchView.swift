import SwiftUI
import DesignSystem

public struct SearchView: View {
  @ObservedObject private var viewModel: SearchViewModel
  
  public init(viewModel: SearchViewModel) {
    self.viewModel = viewModel
  }
}

public extension SearchView {
  var body: some View {
    VStack(spacing: 20) {
      HStack {
        Text("'\(viewModel.query)' 관련 결과 \(viewModel.searchResults.count)개")
          .font(.B2_M)
        Spacer()
      }
      
      if viewModel.searchResults.isEmpty {
        Spacer()
        
        SearchResultEmptyView(query: viewModel.query)
        
        Spacer()
      } else {
        SearchResultView(
          items: viewModel.searchResults,
          onTap: { item in
            print(item.title)
          }
        )
      }
    }
    .frame(width: 600)
    .frame(maxHeight: .infinity)
  }
}
