from PIL import Image

# 스프라이트 이미지 파일명 (현재 폴더에 있는 파일)
sprite_file = "itemicon1.png"

# 아이콘 하나의 크기
icon_width = 64
icon_height = 64

# 생성될 CSS 파일 이름
output_file = "sprite_items.css"

# 이미지 열기
sprite = Image.open(sprite_file)
sheet_width, sheet_height = sprite.size

# 스프라이트 시트의 행과 열 계산
cols = sheet_width // icon_width
rows = sheet_height // icon_height

with open(output_file, "w", encoding="utf-8") as f:
    f.write("/* 스프라이트 아이템 CSS 자동 생성 */\n")
    f.write(".item-icon {\n")
    f.write(f"  background-image: url('{sprite_file}');\n")
    f.write("  background-repeat: no-repeat;\n")
    f.write(f"  width: {icon_width}px;\n")
    f.write(f"  height: {icon_height}px;\n")
    f.write("  display: inline-block;\n")
    f.write("}\n\n")

    count = 0
    for row in range(rows):
        for col in range(cols):
            name = f"item-{count}"
            x = -col * icon_width
            y = -row * icon_height
            f.write(f".{name} " + "{\n")
            f.write(f"  background-position: {x}px {y}px;\n")
            f.write("}\n")
            count += 1

print(f"CSS 파일 생성 완료: {output_file}")
