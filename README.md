# taptap-ios

![Release](https://img.shields.io/github/v/release/dbsghdz1/taptap-ios?display_name=tag&sort=semver)
![iOS](https://img.shields.io/badge/iOS-18.6%2B-blue)
![Swift](https://img.shields.io/badge/Swift-6-orange)


탭탭 iOS 레포지토리입니다.

## 💡 Feature
1. **Safari 확장프로그램**을 통해 기사를 읽으며 동시에 문장별 하이라이트와 메모를 남기기
<img width="1024" alt="image" src="https://github.com/user-attachments/assets/43b96fcd-3453-4afc-8b4f-c0b8112ecf85" />

----

2. 앱에서 **내가 만든 뉴스 요약본**을 스크랩하기
<img width="1024" alt="image" src="https://github.com/user-attachments/assets/b3cef24b-7117-4a54-a07b-c03398ea965a" />

<br>

## 🧱 Architecture
- **The Composable Architecture (TCA)** 기반으로 상태, 액션, 이펙트를 일관되게 관리
- **App Group + Share Extension** 으로 브라우저에서 선택한 문장을 앱으로 전달
- **SwiftData** 를 사용해 하이라이트/메모를 로컬에 저장
- **Tuist 기반 모듈 분리**(Nbs, DesignSystem, Domain, Feature)

<br>

## 🛠 Tech Stack
### Envrionment
<div align="left">
<img src="https://img.shields.io/badge/git-%23F05033.svg?style=for-the-badge&logo=git&logoColor=white" />
<img src="https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white" />
<img src="https://img.shields.io/badge/SPM-FA7343?style=for-the-badge&logo=swift&logoColor=white" />
</div>

### Development
<div align="left">
<img src="https://img.shields.io/badge/Xcode-007ACC?style=for-the-badge&logo=Xcode&logoColor=white" />
<img src="https://img.shields.io/badge/SwiftUI-42A5F5?style=for-the-badge&logo=swift&logoColor=white" />
<img src="https://img.shields.io/badge/VSCode-007ACC?style=for-the-badge&logo=visualstudiocode&logoColor=white" />
</div>

### Communication
<div align="left">
<img src="https://img.shields.io/badge/Miro-FFFC00.svg?style=for-the-badge&logo=Miro&logoColor=050038" />
<img src="https://img.shields.io/badge/Notion-white.svg?style=for-the-badge&logo=Notion&logoColor=000000" />
<img src="https://img.shields.io/badge/Figma-F24E1E?style=for-the-badge&logo=figma&logoColor=white" />
</div>

<br>

## 🚀 Getting Started
```sh
# 1. 프로젝트 clone
git clone https://github.com/dbsghdz1/taptap-ios.git

# 2. Tuist 설치 
tuist install

# 3. 프로젝트 생성 및 Xcode 실행
tuist generate
```
<br>

## 📚 Documentation
👉 자세한 내용은 [Wiki](https://github.com/dbsghdz1/taptap-ios/wiki)를 확인하세요!
