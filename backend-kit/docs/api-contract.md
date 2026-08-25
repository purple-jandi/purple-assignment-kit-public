# 앱 · API 계약

모든 요청은 과제용 사용자 헤더를 사용합니다.

```http
X-User-Id: 00000000-0000-0000-0000-000000000001
```

## 제공 API

`GET /api/v1/hospitals?category={categoryName}`

- 활성 병원을 반환합니다.
- `category`는 선택값입니다.
- 이 API는 병원 선택 화면을 위한 읽기 전용 API입니다. 후보자는 필요하면 구현할 수 있으나, 핵심 평가 대상은 상담 요청 도메인입니다.

## 구현할 API

| API | 설명 |
| --- | --- |
| `POST /api/v1/consultation-requests` | 초안 생성 |
| `PUT /api/v1/consultation-requests/{requestId}` | 초안 수정 |
| `POST /api/v1/consultation-requests/{requestId}/submit` | 제출. 재시도 시 같은 결과가 보장돼야 함 |
| `POST /api/v1/consultation-requests/{requestId}/cancel` | 제출 요청 취소 |
| `GET /api/v1/consultation-requests` | 내 요청 목록 |
| `GET /api/v1/consultation-requests/{requestId}` | 요청 상세와 상태 이력 |

### 요청·응답 예시

```json
POST /api/v1/consultation-requests
{
  "content": "피부 레이저 시술 상담을 받고 싶습니다.",
  "hospitalIds": [1, 5]
}
```

```json
201 Created
{
  "id": "a4b3...",
  "status": "DRAFT",
  "content": "피부 레이저 시술 상담을 받고 싶습니다.",
  "hospitalIds": [1, 5],
  "createdAt": "2026-08-25T12:00:00Z"
}
```

제출 API는 `Idempotency-Key` 헤더 또는 동등한 중복 방지 정보를 사용할 수 있습니다. 오류 응답 형식과 HTTP 상태 코드는 일관되게 설계하고 README에 설명하세요.
