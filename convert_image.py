from PIL import Image

IMG_W, IMG_H = 120, 68
img = Image.open("cowboy.png").convert("RGB").resize((IMG_W, IMG_H))

with open("image.mem", "w") as f:
    for y in range(IMG_H):
        for x in range(IMG_W):
            r, g, b = img.getpixel((x, y))
            val = ((r >> 3) << 11) | ((g >> 2) << 5) | (b >> 3)  # RGB565
            f.write(f"{val:04x}\n")

print("wrote image.mem (", IMG_W*IMG_H, "pixels )")