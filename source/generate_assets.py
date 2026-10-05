"""Rebuild original candle meshes and textures. Python 3 + Pillow."""
from pathlib import Path
import math, random
from PIL import Image, ImageDraw
root=Path(__file__).resolve().parents[1]
(root/'models').mkdir(exist_ok=True);(root/'textures').mkdir(exist_ok=True)
rng=random.Random(451)
im=Image.new('RGBA',(64,64));px=im.load()
for x in range(64):
    g=math.sin(x*.42)*5
    for y in range(64):
        n=g+rng.uniform(-2,2)
        px[x,y]=(int(239+n),int(221+n),int(181+n),255)
d=ImageDraw.Draw(im)
for x,l in [(7,17),(23,9),(40,24),(53,13)]:
    d.line([(x,0),(x, l)],fill=(255,241,207,255),width=2)
    d.ellipse((x-1,l-2,x+1,l+2),fill=(255,241,207,255))
# A tiny dark texture patch supplies the wick without another material.
d.rectangle((0,58,5,63),fill=(39,29,20,255))
im.save(root/'textures/hogwarts_candles_wax.png')
strip=Image.new('RGBA',(32,256))
for i in range(8):
    f=Image.new('RGBA',(32,32));dr=ImageDraw.Draw(f)
    shift=[0,1,2,1,0,-1,-2,-1][i];tip=3+(i%3)
    dr.polygon([(16+shift,tip),(20+shift,11),(23,17),(22,24),(19,29),(13,29),(10,25),(9,20),(12,12)],fill=(255,119,22,255))
    dr.polygon([(16+shift,8),(19,16),(20,22),(18,27),(14,28),(11,23),(13,17)],fill=(255,199,55,255))
    dr.polygon([(16,17),(18,23),(17,28),(14,28),(13,24)],fill=(255,249,187,255))
    strip.paste(f,(0,i*32))
strip.save(root/'textures/hogwarts_candles_flame.png')
# One animated atlas avoids OBJ material-order differences between engines.
atlas=Image.new('RGBA',(64,64*8))
for i in range(8):
    atlas.paste(im.resize((32,32)),(0,i*64))
    atlas.paste(strip.crop((0,i*32,32,(i+1)*32)),(32,i*64))
atlas.save(root/'textures/hogwarts_candles_atlas.png')

for size,bottom in [('tall',-.46),('short',-.16)]:
    lines=['# Original candle mesh. Single animated atlas: stable wax left, flame right.']
    vi=ti=0
    material='wax'
    def face(points,uvs):
        global vi,ti
        refs=[]
        for p,uv in zip(points,uvs):
            lines.append('v %.7f %.7f %.7f'%p)
            mapped=(uv[0]*.5+(0 if material=='wax' else .5),.5+uv[1]*.5)
            lines.append('vt %.7f %.7f'%mapped)
            vi+=1;ti+=1;refs.append(f'{vi}/{ti}')
        # Triangulation makes OBJ loading predictable.
        for j in range(1,len(refs)-1):lines.append('f '+' '.join([refs[0],refs[j],refs[j+1]]))
    lines += ['g candle','usemtl candle']
    n=12;rad=.07;top=.23
    for i in range(n):
        a=2*math.pi*i/n;b=2*math.pi*(i+1)/n
        p=(rad*math.cos(a),rad*math.sin(a));q=(rad*math.cos(b),rad*math.sin(b))
        face([(p[0],bottom,p[1]),(p[0],top,p[1]),(q[0],top,q[1]),(q[0],bottom,q[1])],[(i/n,.10),(i/n,.87),((i+1)/n,.87),((i+1)/n,.10)])
        # Top cap winds upward; bottom cap winds downward.
        uv=[(.5,.5),(.5+math.cos(b)*.2,.5+math.sin(b)*.2),(.5+math.cos(a)*.2,.5+math.sin(a)*.2)]
        face([(0,top,0),(q[0],top,q[1]),(p[0],top,p[1])],uv)
        face([(0,bottom,0),(p[0],bottom,p[1]),(q[0],bottom,q[1])],uv)
    # Wick: cross planes, dark patch in wax texture.
    for points in [[(-.009,.23,0),(.009,.23,0),(.009,.275,0),(-.009,.275,0)],[(0,.23,-.009),(0,.23,.009),(0,.275,.009),(0,.275,-.009)]]:
        face(points,[(.02,.02),(.07,.02),(.07,.07),(.02,.07)])
    material='flame'
    # Two crossed, double-sided planes. Pixel flame fills only their center.
    for points in [[(-.125,.255,0),(.125,.255,0),(.125,.495,0),(-.125,.495,0)],[(0,.255,-.125),(0,.255,.125),(0,.495,.125),(0,.495,-.125)]]:
        face(points,[(0,0),(1,0),(1,1),(0,1)])
    (root/'models'/f'hogwarts_candles_{size}.obj').write_text('\n'.join(lines)+'\n')
print('Generated 2 meshes, wax texture and 8-frame flame strip.')
