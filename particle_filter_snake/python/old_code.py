import cv2
import matplotlib.pyplot as plt
import numpy as np

def read_image(path):
    img = cv2.imread(path)

    # cv2.imshow('SNAKE',img)
    # cv2.waitKey(3000)
    return img


def build_img(img,init_img=True,head_indices=None,snake_length=12,save_img=False,pathname='img.png'):
    
    rows = img.shape[0]
    cols = img.shape[1]
    if init_img:
        img = np.zeros((rows,cols,3))
        img[:,:,1] = 255.

    red_pixel = np.array([0., 0., 255.])

    if head_indices is not None:
        if head_indices[0]>=0 & head_indices[0]<=rows & head_indices[1]<=cols & head_indices[1]>=0:
            if head_indices[1]-snake_length+1 >=0:
                img[head_indices[0],head_indices[1]-snake_length+1:head_indices[1],:] = red_pixel
                print("Pixels colored!")
            else:
                print("Snake will colide with bounds!")
        else:
            print("Out of range indices!")
    else:
        img[100,50:50+snake_length-1,:] = red_pixel
    
    if save_img:
        cv2.imwrite(pathname, img)
    cv2.imshow('SNAKE',img)
    cv2.waitKey(2000)
    return img


# read_image('images/snake_color/snake_0000.png')
# size = (200,200,3)
# indices = [150,150]
# arr = np.zeros(size)
# img = build_img(arr,head_indices=indices,save_img=True)

# for i in range(10):
#     indices[0]+=1
#     indices[1]+=1
#     img = build_img(img,False,head_indices=indices,save_img=True)



#############################################

img_0_path = 'images/snake_color/snake_0000.png'
img_0 = read_image(img_0_path)

p=np.zeros((3,200))
n_particles = 200

for i in range(n_particles):
    p[0,i]=np.random.randint(200) # random x coordinates
    p[1,i]=np.random.randint(200) # random y coordinates
    p[2,i]=1 # initilize ???

    img_0[int(p[0,i])][int(p[1,i])][0]=255
    img_0[int(p[0,i])][int(p[1,i])][1]=0
    img_0[int(p[0,i])][int(p[1,i])][2]=0

# cv2.imshow('SNAKE',img_0)
# cv2.waitKey(3000)

k=0

for t in range(1001):

    fname = 'images/snake_color/snake_%(t)04d.png' % {"t":t}

    img_t = read_image(fname)
    cv2.imshow('SNAKE',img_t)
    cv2.waitKey(10)