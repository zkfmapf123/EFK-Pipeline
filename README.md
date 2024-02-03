# EFK Pipeline

![archi](./public/arch.jpg)
![archi-2](./public/arch-2.jpg)
![arch-3](./public/arch-3.jpg)

> Elastic RDB의 차이점 

| Elastic Search | RDB |
|-------|-------|
| 인덱스 | 데이터베이스 |
| 샤드 | 파티션 |
| 타입 | 테이블 |
| Document | 행 |
| 필드 | 열 |
| 매핑 | 스키마 |
| Query DSL | SQL |

> Elastic Search의 검색이 빠른이유 (Inverted Index)

- 기존의 DB 검색방식

```sh
    ## Colum 기준으로 Read
            ID  Text
    Read->  A   aaa
    Read->  B   bbb
    Read->  C   ccc
    Read->  D   ddd
```

- ES의 검색방식

```sh
ID  Text
A   hello a world
B   bye world
C   bye name
D   hello bye leedonggyu

## 역색인 생성 (구문분석을 통해서 다시 역색인 테이블로 정리한다)
Term        ID 
hello       A,D
world       A,B
bye         B,C,D
name        C
leedonggyu  D
a           A
```

- 장점 / 단점
    
    - 문서가 많아도 빠르게 검색 가능
    - 필요없는 단어의 경우 검색을 느려지게 만듬 (a, the, and, leedonggyu)
    - ***Stop Words 설정을 통해서 인덱스에서 제거, 검색어에 등장해도 무시 가능
    - 업데이트, 삭제 및 삽입의 대해서는 유지관리 비용이 큼
