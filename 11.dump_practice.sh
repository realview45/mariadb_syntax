# 덤프파일 생성
mysqldump -u root -p 스키마명 > 덤프파일명
mysqldump -u root -p board > board_dump.sql

# 덤프파일 적용(복원)
# 아래 실행명령어 위치에 덤프파일이 있어야하고, 스키마는 만들어져 있어야함
mysql -u root -p 스키마명 < 덤프파일명
mysql -u root -p board < board_dump.sql

# 주의사항
# 1)vscode의 인코딩을 utf8로 설정할 필요가 있다
# 2)<를 인식못할때에는 git bash에서 작업할 필요가 있다
