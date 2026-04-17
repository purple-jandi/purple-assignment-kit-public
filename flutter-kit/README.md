# Flutter 과제 스타터 키트

본 프로젝트는 퍼플영(Purple Young) Flutter 개발자 채용 과제를 위한 스타터 키트입니다.

## 🚀 시작하기

1. **공통 환경 구성 (필수)**
   - 본 과제는 로컬 Mock API 서버 연동이 필수입니다.
   - **[루트 디렉토리의 README.md](../README.md)**에 기술된 `[STEP 0] 공통 환경 구성` 가이드에 따라 Docker 서버를 먼저 구동해 주세요.

2. **의존성 설치 및 코드 생성**
   ```bash
   flutter pub get
   dart run build_runner build --delete-conflicting-outputs
   ```

3. **앱 실행**
   - 에뮬레이터 또는 실기기에서 앱을 실행합니다.

## 🎯 과제 전형 요구사항

> **안내사항**: 본 과제는 제공되는 저장소 루트의 `mock-api` (Docker 환경)를 구동하여 연동해주시면 됩니다. 구현의 정확성뿐만 아니라 아키텍처 성숙도, 예외 처리, 그리고 렌더링 최적화 역량을 중점적으로 평가합니다.

### 1️⃣ 코어 기능 구현
- [ ] **피드 목록 조회**: 대용량 리스트 렌더링을 위한 무한 스크롤(Infinite Scroll) 처리 구현
- [ ] **멀티파트 업로드**: 로컬 환경의 영상/사진 파일 선택 및 서버 미디어 전송(Multipart)
- [ ] **UX 고도화**: 좋아요 기능 클릭 시, 서버 지연을 감추기 위한 **낙관적 업데이트(Optimistic Update)** 패턴 적용 필수

### ✨ 2️⃣ 지원자 자율 기능 추가 (3개 이상 필수)
- [ ] **자율 기능 구현**: 본 앱의 완성도를 높일 수 있는 새로운 기능 또는 UX 개선 사항을 **3가지 이상** 자유롭게 제안하고 구현해 주세요. (예시는 제공하지 않으며, 지원자의 창의성과 프로덕트 감각을 평가합니다.)
- [ ] **구현 근거 기술**: 각 기능의 **기획 의도**와 이를 실현하기 위해 사용한 **기술적 핵심 포인트**를 README에 상세히 기록해 주세요. (이 과정이 변별력의 핵심입니다.)
- [ ] **📝 문서화 의무**: `README.md`를 필수 작성하여 환경 셋업 가이드, 앱 아키텍처 계층 설계, 그리고 **상태 관리 로직 설계 이유**를 명확히 기술해 주세요.
- [ ] **🚨 에러 방어 로직**: 미디어 업로드 API의 응답 URL 오류(404, 포트 불일치 등) 상황에 대비한 클라이언트 레벨의 안전한 예외 방어 (의도된 시스템 트랩)
- [ ] **🏗️ 아키텍처 성숙도**: `Riverpod` 기반의 계층형 아키텍처 (Data - Domain - Presentation Layer) 분리 적용 필수 및 의존성 주입(DI) 활용

> **🚨 필수 산출물 및 제출 방법**: 
> 1. 작업 완료 후 본인의 설계 의도, 로컬 실행 방법, Riverpod 상태 관리 로직을 기술한 `README.md` 문서를 별도 작성(또는 본 파일 수정)해 주세요.
> 2. 구체적인 제출 상세 절차(GitHub 초대 및 비공개 리포지토리 생성 등)는 **[루트 디렉토리의 README.md](../README.md)** 섹션을 확인해 주세요.
## Stack
- **State Management**: Riverpod
- **Routing**: GoRouter (ShellRoute)
- **Code Generation**: build_runner, freezed, riverpod_generator

## Directory Structure
```text
lib/
├── core/          # Core modules (network, models, constants)
├── features/      # Feature-based screens and logic
│   ├── home/      # Home Tab
│   ├── search/    # Search Tab
│   ├── profile/   # Profile Tab
│   ├── settings/  # Settings Tab
│   └── shell/     # Main Layout with BottomNavigationBar
├── routes/        # Router configuration
└── widgets/       # Shared UI components
```
   
## Boilerplate (모델 / API / Repository / State)

이 프로젝트는 아래 조합을 기본으로 사용합니다.

- 데이터 모델: `freezed` + `json_serializable`
- API: `retrofit` + `dio`
- 상태관리: `flutter_riverpod` (`NotifierProvider`/`Notifier`)

### 1) 데이터 모델(Freezed + JsonSerializable) 예제

`lib/core/model/example_user.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'example_user.freezed.dart';
part 'example_user.g.dart';

@freezed
@JsonSerializable(explicitToJson: true)
class ExampleUser with _$ExampleUser {
  const factory ExampleUser({
    @Default('') String id,
    @Default('') String name,
    DateTime? createdAt,
  }) = _ExampleUser;

  factory ExampleUser.fromJson(Map<String, dynamic> json) =>
      _$ExampleUserFromJson(json);
}
```

코드 생성:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 2) API(Retrofit) 보일러플레이트 예제

`lib/core/network/example/example_api.dart`

```dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:purple_young_mobile/core/model/api_common.dart';

part 'example_api.g.dart';

@RestApi()
abstract class ExampleApi {
  factory ExampleApi(Dio dio, {String baseUrl}) = _ExampleApi;

  @GET('/api/v1/example/{id}')
  Future<ApiResponse> getExample(
    @Path('id') String id, {
    @Extras() Map<String, dynamic>? extras,
  });
}
```

### 3) Repository 보일러플레이트 예제

`lib/core/repository/example_repository.dart`

```dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purple_young_mobile/core/model/api_common.dart';
import 'package:purple_young_mobile/core/model/example_user.dart';
import 'package:purple_young_mobile/core/network/dio_provider.dart';
import 'package:purple_young_mobile/core/network/network_constants.dart';
import 'package:purple_young_mobile/core/network/example/example_api.dart';

final exampleApiProvider = Provider<ExampleApi>((ref) {
  final dio = ref.watch(dioProvider);
  return ExampleApi(dio);
});

final exampleRepositoryProvider = Provider<ExampleRepository>((ref) {
  final api = ref.watch(exampleApiProvider);
  return ExampleRepository(api);
});

class ExampleRepository {
  ExampleRepository(this._api);
  final ExampleApi _api;

  Future<ExampleUser> fetchExample(String id) async {
    try {
      final response = await _api.getExample(id, extras: authenticatedExtras);
      ApiException.throwIfFailed(response, fallbackMessage: '조회에 실패했습니다.');

      final data = response.data;
      if (data is Map<String, dynamic>) return ExampleUser.fromJson(data);
      throw const ApiException(message: '응답 형식이 올바르지 않습니다.');
    } on DioException catch (error) {
      ApiException.throwWithDioException(error, fallbackMessage: '조회에 실패했습니다.');
    }
  }
}
```

### 4) State(Riverpod Notifier) 보일러플레이트 예제

`lib/core/state/example_state.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:purple_young_mobile/core/model/example_user.dart';
import 'package:purple_young_mobile/core/repository/example_repository.dart';

part 'example_state.freezed.dart';
part 'example_state.g.dart';

@freezed
class ExampleState with _$ExampleState {
  const factory ExampleState({
    ExampleUser? data,
    @Default(false) bool isLoading,
    Object? error,
  }) = _ExampleState;
}

@riverpod
class ExampleNotifier extends _$ExampleNotifier {
  @override
  ExampleState build() => const ExampleState();

  ExampleRepository get _repository => ref.read(exampleRepositoryProvider);

  Future<void> fetch(String id) async {
    if (state.isLoading) return;
    
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final data = await _repository.fetchExample(id);
      state = state.copyWith(data: data, isLoading: false, error: null);
    } catch (error) {
      state = state.copyWith(isLoading: false, error: error);
    }
  }
}
```
