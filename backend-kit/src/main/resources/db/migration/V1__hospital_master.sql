CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE app_user (
    id UUID PRIMARY KEY,
    nickname VARCHAR(50) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 현재 Purple Young의 성형 depth-2 시술부위 카테고리 ID와 이름을 사용한다.
CREATE TABLE hospital_category (
    id BIGINT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE hospital (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    address VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    image_url TEXT NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE hospital_category_mapping (
    hospital_id BIGINT NOT NULL REFERENCES hospital(id),
    category_id BIGINT NOT NULL REFERENCES hospital_category(id),
    PRIMARY KEY (hospital_id, category_id)
);

INSERT INTO app_user (id, nickname)
VALUES
    ('00000000-0000-0000-0000-000000000001', '과제지원자'),
    ('00000000-0000-0000-0000-000000000002', '테스트사용자');

INSERT INTO hospital_category (id, name)
VALUES
    (3, '눈'),
    (4, '코'),
    (5, '얼굴지방성형'),
    (6, '바디지방성형'),
    (7, '안면윤곽/양악'),
    (8, '가슴'),
    (9, '거상성형');

-- 피드의 Picsum 이미지 URL 패턴을 재사용한다. 모든 이미지는 앱 카드에 맞춘 16:9, 800x450 크기다.
INSERT INTO hospital (name, address, description, image_url)
VALUES
    ('퍼플성형외과 강남점', '서울 강남구 테헤란로 101', '눈·코 성형 상담을 제공하는 강남역 인근 병원입니다.', 'https://picsum.photos/id/10/800/450'),
    ('루미에르성형외과 신사점', '서울 강남구 도산대로 201', '안면윤곽과 리프팅 상담을 제공하는 병원입니다.', 'https://picsum.photos/id/11/800/450'),
    ('에버라인성형외과 잠실점', '서울 송파구 올림픽로 88', '눈 성형과 가슴 성형 중심의 상담을 제공합니다.', 'https://picsum.photos/id/12/800/450'),
    ('라온성형외과 홍대점', '서울 마포구 양화로 150', '코 성형과 얼굴 지방 시술 상담을 제공합니다.', 'https://picsum.photos/id/13/800/450'),
    ('더봄성형외과 성수점', '서울 성동구 아차산로 77', '눈 재수술과 안면 윤곽 상담을 제공합니다.', 'https://picsum.photos/id/14/800/450'),
    ('드림라인성형외과 여의도점', '서울 영등포구 국제금융로 10', '바디 지방성형과 가슴 상담을 제공합니다.', 'https://picsum.photos/id/15/800/450'),
    ('에이치성형외과 판교점', '경기 성남시 분당구 판교역로 235', '코 성형과 거상성형 상담을 제공합니다.', 'https://picsum.photos/id/16/800/450'),
    ('미소담성형외과 분당점', '경기 성남시 분당구 황새울로 340', '눈 성형과 얼굴 지방성형 상담을 제공합니다.', 'https://picsum.photos/id/17/800/450'),
    ('클리어성형외과 건대점', '서울 광진구 아차산로 241', '안면윤곽과 양악 관련 상담을 제공합니다.', 'https://picsum.photos/id/18/800/450'),
    ('온유성형외과 노원점', '서울 노원구 동일로 1405', '눈 성형과 리프팅 상담을 제공합니다.', 'https://picsum.photos/id/19/800/450'),
    ('벨라성형외과 목동점', '서울 양천구 목동동로 293', '가슴 성형과 바디 지방성형 상담을 제공합니다.', 'https://picsum.photos/id/20/800/450'),
    ('아름성형외과 마포점', '서울 마포구 마포대로 92', '코 성형과 안면윤곽 상담을 제공합니다.', 'https://picsum.photos/id/21/800/450'),
    ('프리즘성형외과 종로점', '서울 종로구 종로 51', '눈 성형과 코 재수술 상담을 제공합니다.', 'https://picsum.photos/id/22/800/450'),
    ('리앤성형외과 용산점', '서울 용산구 한강대로 95', '얼굴 지방성형과 거상성형 상담을 제공합니다.', 'https://picsum.photos/id/23/800/450'),
    ('유앤유성형외과 합정점', '서울 마포구 독막로 8', '눈 성형과 가슴 성형 상담을 제공합니다.', 'https://picsum.photos/id/24/800/450'),
    ('그린성형외과 수원점', '경기 수원시 팔달구 권광로 181', '코 성형과 바디 지방성형 상담을 제공합니다.', 'https://picsum.photos/id/25/800/450'),
    ('더라인성형외과 인천점', '인천 부평구 부평대로 19', '안면윤곽과 리프팅 상담을 제공합니다.', 'https://picsum.photos/id/26/800/450'),
    ('나비성형외과 일산점', '경기 고양시 일산동구 중앙로 1195', '눈 성형과 얼굴 지방성형 상담을 제공합니다.', 'https://picsum.photos/id/27/800/450'),
    ('모먼트성형외과 부천점', '경기 부천시 원미구 길주로 219', '가슴 성형과 거상성형 상담을 제공합니다.', 'https://picsum.photos/id/28/800/450'),
    ('웨이브성형외과 안양점', '경기 안양시 동안구 시민대로 202', '코 성형과 안면윤곽 상담을 제공합니다.', 'https://picsum.photos/id/29/800/450'),
    ('하이성형외과 강서점', '서울 강서구 공항대로 236', '눈 성형과 리프팅 상담을 제공합니다.', 'https://picsum.photos/id/30/800/450'),
    ('온더성형외과 구로점', '서울 구로구 디지털로 288', '바디 지방성형과 가슴 상담을 제공합니다.', 'https://picsum.photos/id/31/800/450'),
    ('센트럴성형외과 동탄점', '경기 화성시 동탄대로 489', '코 성형과 얼굴 지방성형 상담을 제공합니다.', 'https://picsum.photos/id/32/800/450'),
    ('뷰티플러스성형외과 평촌점', '경기 안양시 동안구 시민대로 214', '안면윤곽과 양악 상담을 제공합니다.', 'https://picsum.photos/id/33/800/450'),
    ('에스원성형외과 미아점', '서울 강북구 도봉로 52', '눈 성형과 코 성형 상담을 제공합니다.', 'https://picsum.photos/id/34/800/450'),
    ('뉴데이성형외과 송도점', '인천 연수구 컨벤시아대로 165', '가슴 성형과 바디 지방성형 상담을 제공합니다.', 'https://picsum.photos/id/35/800/450'),
    ('포레성형외과 광교점', '경기 수원시 영통구 광교중앙로 145', '얼굴 지방성형과 거상성형 상담을 제공합니다.', 'https://picsum.photos/id/36/800/450'),
    ('아이콘성형외과 천호점', '서울 강동구 천호대로 1006', '눈 성형과 안면윤곽 상담을 제공합니다.', 'https://picsum.photos/id/37/800/450'),
    ('리브성형외과 청량리점', '서울 동대문구 왕산로 214', '코 성형과 리프팅 상담을 제공합니다.', 'https://picsum.photos/id/38/800/450'),
    ('오로라성형외과 구리점', '경기 구리시 경춘로 249', '눈 성형과 가슴 성형 상담을 제공합니다.', 'https://picsum.photos/id/39/800/450');

INSERT INTO hospital_category_mapping (hospital_id, category_id)
VALUES
    (1, 3), (1, 4),
    (2, 7), (2, 9),
    (3, 3), (3, 8),
    (4, 4), (4, 5),
    (5, 3), (5, 7),
    (6, 6), (6, 8),
    (7, 4), (7, 9),
    (8, 3), (8, 5),
    (9, 7),
    (10, 3), (10, 9),
    (11, 6), (11, 8),
    (12, 4), (12, 7),
    (13, 3), (13, 4),
    (14, 5), (14, 9),
    (15, 3), (15, 8),
    (16, 4), (16, 6),
    (17, 7), (17, 9),
    (18, 3), (18, 5),
    (19, 8), (19, 9),
    (20, 4), (20, 7),
    (21, 3), (21, 9),
    (22, 6), (22, 8),
    (23, 4), (23, 5),
    (24, 7),
    (25, 3), (25, 4),
    (26, 6), (26, 8),
    (27, 5), (27, 9),
    (28, 3), (28, 7),
    (29, 4), (29, 9),
    (30, 3), (30, 8);
