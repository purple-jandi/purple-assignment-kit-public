# 퍼플영(Purple Young) 채용 과제 (Assignment Kit)

퍼플영 개발자 채용을 위한 실무 역량 평가 과제용 리포지토리입니다.
본 가이드를 따라 지원하신 포지션에 맞는 과제를 수행해 주시기 바랍니다.

> **평가 기준**: 본 과제는 단순히 돌아가는 코드를 넘어서, 구현의 정확성뿐만 아니라 아키텍처 성숙도, 예외 처리, 그리고 렌더링 최적화 역량을 중점적으로 평가합니다. 특히 제안된 필수 기능 외에 지원자의 창의성을 볼 수 있는 '자율 기능'의 구현 논리(Rationale)를 가장 중요하게 봅니다.

## 🚀 전형 선택 (Choose Your Path)

당신은 어떤 포지션에 지원하셨나요? 아래의 버튼(링크)을 클릭하여 해당 전형의 상세 미션을 확인해 주세요.

| 전형 구분 | 스타터 키트 및 가이드 | 핵심 평가 항목 |
| :--- | :--- | :--- |
| **Frontend (Web)** | [web-kit/ 바로가기](./web-kit/) | Next.js, 무한 스크롤, 라우터 동기화, **자율 기능 3개 이상 필수** |
| **Mobile (Flutter)** | [flutter-kit/ 바로가기](./flutter-kit/) | Riverpod 아키텍처, 멀티파트 업로드, **자율 기능 3개 이상 필수** |
| **Backend / Full-stack** | [backend-kit/ 바로가기](./backend-kit/) | Spring Boot, PostgreSQL, API 계약, 테스트 및 앱 연동 |

---

## 🛠 [STEP 0] 공통 환경 구성 (Mock API)

Web·Mobile 전형은 로컬에서 구동되는 **가상 API 서버(Mock API)** 연동을 전제로 합니다. 과제 수행 전 반드시 아래 단계를 완료해 주세요.

1. **Docker 설치**: 로컬에 Docker Desktop이 설치되어 있어야 합니다.
2. **서버 구동**:
   ```bash
   cd mock-api
   docker compose up
   ```
3. **확인**: 
   - API 서버: `http://localhost:3000`
   - **Swagger UI (명세)**: `http://localhost:8082` (구동 후 가장 먼저 확인해 주세요!)

> Backend / Full-stack 전형은 Mock API 대신 `backend-kit`의 PostgreSQL Docker 환경과 Spring Boot 서버를 사용합니다. 자세한 실행 및 제출 기준은 [backend-kit README](./backend-kit/README.md)를 확인해 주세요.

---

## 📮 과제 제출 방법

1. **비공개 리포지토리 생성**: 본인 GitHub 계정에 **Private 리포지토리**를 생성합니다. (전체 공개 금지)
2. **결과물 업로드**: 완성된 코드와 본인의 설계 의도를 담은 `README.md`를 업로드합니다.
3. **담당자 초대**: 채용 담당자 계정(`engineering-team-source`)을 **Collaborator**로 반드시 초대해 주세요.
4. **URL 제출**: 안내받은 구글 폼 링크를 통해 리포지토리 주소를 제출합니다.

> [!IMPORTANT]
> **보안 주의사항**: 본 과제의 소스코드 및 API 구조는 퍼플영의 자산입니다. 외부(블로그, 공개 저장소 등)에 노출될 경우 채용이 취소될 수 있으며 법적 책임이 발생할 수 있습니다.

---
**퍼플영과 함께 성장할 지원자분들의 멋진 결과물을 기대합니다.**
