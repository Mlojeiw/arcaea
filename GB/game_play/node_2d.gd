extends Node2D


@export var viewport: SubViewport# 指向 SubViewport 的相对路径

func _ready():
	generate_judge_line_texture()
func generate_judge_line_texture():
	var width = 1024
	# 原始设计尺寸（像素），可自由调整这些值
	var bottom_purple_h = 0.8   # 底部浅紫色高度
	var glow_h = 0.3 # ★ 黑色上下的深紫色发光高度，调大这个值
	var black_h = 1.3          # 中间黑色高度

	# 放大系数，用于消除小数，保证像素精度
	var scale_factor = 10.0
	var bp = int(bottom_purple_h * scale_factor)  # 16
	var gl = int(glow_h * scale_factor)           # 20（原来是3，现在是20，明显变宽）
	var bk = int(black_h * scale_factor)          # 10

	var height = bp + gl + bk + gl + bp           # 总高度

	var img = Image.create(width, height, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))  # 透明背景

	# 颜色定义
	var light_purple = Color(0.8, 0.6, 0.9, 0.252)   # 底部浅紫色
	var dark_purple = Color(0.7, 0.4, 1.0, 1.0)  # ★ 黑色旁边的深紫色（更暗更浓）
	var black = Color(0.2, 0.1, 0.3, 1.0) 

	var y = 0

	# 1. 底部浅紫色
	for i in range(bp):
		for x in range(width):
			img.set_pixel(x, y + i, light_purple)
	y += bp

	# 2. 深紫色发光（黑色下边缘）
	for i in range(gl):
		# 从浅紫色渐变到黑色，但这里直接画深紫色也可以（如果你想纯色）
		# 为了让过渡自然，我们可以用深紫色直接填充
		for x in range(width):
			img.set_pixel(x, y + i, dark_purple)
	y += gl

	# 3. 纯黑线
	for i in range(bk):
		for x in range(width):
			img.set_pixel(x, y + i, black)
	y += bk

	# 4. 深紫色发光（黑色上边缘，与下面对称）
	for i in range(gl):
		for x in range(width):
			img.set_pixel(x, y + i, dark_purple)
	y += gl

	# 5. 顶部浅紫色
	for i in range(bp):
		for x in range(width):
			img.set_pixel(x, y + i, light_purple)

	var tex = ImageTexture.create_from_image(img)
	img.save_png("res://judge_line.png")



	return tex
