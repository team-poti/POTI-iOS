# poti 
> 복잡한 분철 과정을 한눈에 정리하고, 믿을 수 있는 거래로 자연스럽게 이어주는 플랫폼


## 🍎 iOS Developer
| **[김나연](https://github.com/Yeonnies)** | **[김수민](https://github.com/gleamminn)** | **[박정환](https://github.com/Jhw9n)** | **[이서현](https://github.com/doitexactly)** |
| :---: | :---: | :---: | :---: |
| <img src="https://github.com/Yeonnies.png" width="170" alt=""> | <img src="https://github.com/gleamminn.png" width="170" alt=""> | <img src="https://github.com/Jhw9n.png" width="170" alt=""> | <img src="https://github.com/doitexactly.png" width="170" alt=""> |
| `iOS Lead` | `iOS Developer` | `iOS Developer` | `iOS Developer` |


## 🛠️ Tech Stack & Library

<table>
  <thead>
    <tr>
      <th align="center">기술 / 라이브러리</th>
      <th align="center">목적</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td align="center"><b>UIKit</b></td>
      <td align="left">안정적이고 풍부한 레퍼런스, 우수한 호환성, 예측 가능한 UI 레이아웃 작업</td>
    </tr>
    <tr>
      <td align="center"><b>Moya</b></td>
      <td align="left">간결한 네트워크 요청과 구조화된 관리 방식으로 코드 가독성과 유지보수성 향상</td>
    </tr>
    <tr>
      <td align="center"><b>Combine</b></td>
      <td align="left">비동기 데이터 흐름을 선언적으로 관리, 상태 변화에 따른 UI 업데이트 처리</td>
    </tr>
    <tr>
      <td align="center"><b>Snapkit</b></td>
      <td align="left">간편한 Auto Layout 적용</td>
    </tr>
    <tr>
      <td align="center"><b>Then</b></td>
      <td align="left">UI 코드 작성시 편의성 향상</td>
    </tr>
    <tr>
      <td align="center"><b>Kingfisher</b></td>
      <td align="left">효율적인 이미지 다운로드 및 캐싱을 통해 네트워크 이미지 로딩 성능 향상</td>
    </tr>
    <tr>
      <td align="center"><b>Lottie</b></td>
      <td align="left">JSON 기반 애니메이션 활용을 위해 사용</td>
    </tr>
    <tr>
      <td align="center"><b>Logger</b></td>
      <td align="left">구조화된 로깅을 지원하여 성능 저하 없이 효율적으로 로그 수집 및 분석 가능</td>
    </tr>
    <tr>
      <td align="center"><b>KakaoOpenSDK</b></td>
      <td align="left">카카오 소셜 로그인을 위해 사용</td>
    </tr>
    <tr>
      <td align="center"><b>Swift Concurrency</b></td>
      <td align="left">명확하고 안전한 비동기 흐름 관리를 통해 복잡한 비동기 로직의 가독성과 유지보수성 향상</td>
    </tr>
    <tr>
      <td align="center"><b>MVVM</b></td>
      <td align="left">UI, 비즈니스 로직 분리를 통해 화면 상태 변화를 명확하게 관리, 유지보수성 강화</td>
    </tr>
    <tr>
      <td align="center"><b>Clean Architecture</b></td>
      <td align="left">도메인 중심의 의존성 분리를 통해 변경에 강하고 확장 가능한 구조 구축</td>
    </tr>
  </tbody>
</table>

## 📁 Foldering
```
📁 Project
├── 📁 Application
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   └── AppDIContainer.swift
│
├── 📁 Presentation
│   ├── 📁 Splash
│   ├── 📁 Onboarding
│   ├── 📁 Home
│   ├── 📁 GoodsDetail
│   ├── 📁 Register
│   ├── 📁 MyPage
│   ├── 📁 HistoryDetail
│   ├── 📁 Base
│   │   ├── BaseViewController.swift
│   │   └── BaseViewModel.swift
│   │
│   └── 📁 Common
│       └── UIComponents
│
├── 📁 Domain
│   ├── 📁 Entity
│   ├── 📁 RepositoryInterface
│   └── 📁 UseCase
│
├── 📁 Data
│   ├── 📁 Network
│   │   ├── EndPoint
│   │   └── Service
│   ├── 📁 Repository
│   └── 📁 DTO
│
├── 📁 Global
│   ├── 📁 Resource
│   │   ├── Assets.xcassets
│   │   └── Fonts
│   ├── 📁 Extension
```

## 📣 Convention
### Code Style
[Swift Style Guide](https://github.com/StyleShare/swift-style-guide)를 따릅니다.

### Commit
**- Tag**
<table>
  <thead>
    <tr>
      <th align="center">태그</th>
      <th align="center">사용하는 부분</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td align="center"><b>[feat]</b></td>
      <td align="left">새로운 기능 구현</td>
    </tr>
    <tr>
      <td align="center"><b>[fix]</b></td>
      <td align="left">버그, 오류 해결</td>
    </tr>
    <tr>
      <td align="center"><b>[chore]</b></td>
      <td align="left">코드 수정, 내부 파일 수정, 애매한 것들이나 잡일은 이걸로!</td>
    </tr>
    <tr>
      <td align="center"><b>[add]</b></td>
      <td align="left">라이브러리 추가, 에셋 추가</td>
    </tr>
    <tr>
      <td align="center"><b>[del]</b></td>
      <td align="left">쓸모없는 코드 삭제</td>
    </tr>
    <tr>
      <td align="center"><b>[docs]</b></td>
      <td align="left">README나 WIKI 등의 문서 개정</td>
    </tr>
    <tr>
      <td align="center"><b>[refactor]</b></td>
      <td align="left">전면 수정이 있을 때 사용합니다.</td>
    </tr>
    <tr>
      <td align="center"><b>[setting]</b></td>
      <td align="left">프로젝트 설정관련이 있을 때 사용합니다.</td>
    </tr>
    <tr>
      <td align="center"><b>[merge]</b></td>
      <td align="left">Pull Develop</td>
    </tr>
  </tbody>
</table>

**- Message**
```
(커밋 메세지 형식)
[종류] #이슈번호 - 작업 내용

(기본 커밋 메시지 예시)
[feat] #1 - 메인 UI 구현

(Conflict 해결 시)
[merge] #이슈번호 - Conflict 해결 

(PR을 develop에 merge 시)
[merge] #이슈번호 - 작업 내용 간략히
```

## 🐾 Git Flow
<img src="https://github.com/user-attachments/assets/f551fbc8-a8c0-4c11-8749-8ba8dd3bfa92" width="600" alt="">

**Default Branch & PR Target : `develop`**

모든 개발은 `develop` 브랜치를 중심으로 진행됩니다.

```
1. 작업할 내용에 대해 이슈를 판다. (이슈제목: [태그] 작업 내용)

2. develop 브랜치로부터 새 브랜치를 만든다. (브랜치 명: 타입/#이슈번호)
  - 브랜치 파기 전 최신화 된 develop 브랜치 pull 받기

3. 만든 브랜치에서 작업한다.

4. 커밋은 쪼개서 작성하며 컨벤션을 따라 메시지를 작성한다.

5. 작업할 내용을 다 끝내면 에러 없이 잘 실행되는지 확인 한 후 push 한다.
  - PR 올리기 전 작업 브랜치에 develop 브랜치 pull 받은 뒤 충돌을 해결한 후 push 하는 것을 권장

6. PR을 작성한 후, 팀원들의 코드리뷰를 반영한 뒤 develop 브랜치에 merge한다.
  - 깃허브 내에서 merge 할 때 메시지 변경하기 ([merge #이슈번호 - 작업 내용)
```
