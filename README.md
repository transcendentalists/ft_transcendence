# 트렌센던스, 커뮤니티 기반의 게임 SPA 서비스

**ft_transcendence**는 루비 온 레일즈(RoR)과 BackBone.js를 이용하여 실시간 게임 서비스(SPA)를 만든 프로젝트입니다.


## Developer
김은휼, 주정현, 이요한, 우인준, 남상혁 다섯 명에 의해 만들어졌습니다. 이 프로젝트는 페어 프로그래밍에 의해 진행된 프로젝트입니다. 데이터베이스 설계부터 UI까지 모든 팀원이 함께 참여하였습니다.

## Why
12,000명이 넘는 ecole 42의 유저들이 관계성이 부족하고 이어서 동료학습의 효과가 떨어진다고 보았습니다. 각자의 캠퍼스/길드(코알라시옹)을 기반으로 친해질 수 있는 서비스로 만들고 싶었습니다. 따라서 언어적 장벽이 없는 게임이 네트워킹의 매개로 적합하다고 생각했습니다. 시간 표시나 토너먼트 스케쥴링 역시 해외를 고려하여 글로벌 서비스를 만든다는 관점으로 시간을 처리하였고, 게임 규칙의 다변화나 디자인 등 사용자 경험에 신경에 써서 어플리케이션을 만들었습니다.

## Feature
- 길드
  - 길드 시스템 구현
  - 길드 오너/관리자/멤버로 길드 멤버십 등급화
  - 길드 간 전쟁 모듈
  - 길드 랭킹 구현
- 채팅
  - 개인 및 그룹간 채팅 구현
  - 그룹 채팅 룸 오너/관리자/멤버로 그룹 멤버십 등급화
- 게임
  - 1:1 실시간 아케이드 게임 구현
  - 랜덤 대전 및 초대 기능을 이용한 대전 모드 구현
  - 게임 규칙 다변화
- 상태창
  - 유저별 프로필 페이지 구현
  - 2차 인증 및 활성화 선택 기능 제공
  - 온라인으로 접속한 유저 목록 사이드바 구현
  - 친구 신청 및 친구 접속 상태 확인 기능 제공

## Stack
- **RubyOnRails**: ActiveRecord, ActiveJob, ActionCable 등 모델, Job, 실시간 처리까지 모두 자체 모듈로 제공
- **Backbone.js**: MV* 라이브러리로서 다양한 패턴을 유연하게 적용 가능
- **FactoryBot, RSpec**: 백엔드 테스트에 가장 유용하게 사용되는 레일즈 gem 패키지
- **Semantic UI**: 클래스 기반의 간편한 스타일링 가능

## Process
요구사항 분석부터 테스트까지 게임 SPA 개발 프로젝트의 전 과정을 담은 문서가 작성되어 있습니다.
* [개발기 읽기](https://drive.google.com/file/d/1mqr0p9Wmgz9ZuCa5QlQEMeDpJ1OrDmPr/view?usp=sharing)

## Performance
서비스 전체적으로 속도 저하가 있는 영역을 진단 후 아래와 같은 지점들에서 성능 개선을 진행하였습니다.

* case 1)
  * **berfore**: front에서 리소스를 요청할 때, 실제 front에서 필요한 부분보다 resource의 데이터가 풍부하여 데이터를 필터링하는 경우 속도가 느려짐  
  * **after**: front에서 요청하는 리소스를 그대로 응답, 속도 향상, front의 리소스에 대한 요구사항이 변경될 때에도 유연하게 대응할 수 있었음

* case 2)
  * **before**: front에서 리소스를 요청하는 과정에서 연관 데이터를 따로 요청하는 경우(길드, 길드 멤버, 길드 멤버쉽 등) Request 수가 많아서 속도가 느려짐  
  * **after**: 테이블에 직접 관계가 있는 연관 데이터의 경우 연관 데이터의 id가 아니라 리소스 데이터 전체를 응답에 포함시키도록 변경

* case 3)
  * **before**: 아케이드 게임에서 실제 서버에 player의 맵 좌표 상 이동을 요청하고, 응답을 기반으로 위치를 움직이면 게임 진행이 불가능할만큼 느리고 밸런스도 맞지 않음  
  * **after**: 게임 로직을 클라이언트 단으로 옮겨 프론트에서 플레이어는 움직이며 백엔드에 보고, 중간중간 서버로부터 데이터를 검증 및 회신 받아 갱신하도록 조정
