# 서버 시작시 진행중인 토너먼트들에 대해 스케쥴 재설정
# rake 작업시엔 실행되지 않도록 조건처리
unless ( File.basename($0) == 'rake')
  Tournament.retry_set_schedule
end
