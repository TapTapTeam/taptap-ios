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
      HStack(spacing: 0) {
        Text("'\(viewModel.query)' 관련 결과 ")
        
        Text("\(viewModel.searchResults.count)")
          .foregroundStyle(.bl6)
        
        Text("개")
          
        Spacer()
      }
      .font(.B2_M)
      
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
