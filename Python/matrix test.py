
# Matrix sentence Test
# 3c - Up / 1f - Down

from math import log10, sqrt
import numpy as np
from scipy import stats
from scipy.io import wavfile
from playsound import playsound
from psychopy import sound,visual, core,event
import time, serial, logging, scipy.io



# Set
path = 'C:/Users/LeeJiWon/Desktop/Matrix sentence/hjy/testsource_matrixAADC/ms'
track = 1
snr = 0
corr = 0

# Make the window for visual presentation
screen = visual.Window([960, 900], screen=2, pos=[600, 0], fullscr=False,
                       winType='pyglet', allowGUI=False, allowStencil=False,
                       monitor='testMonitor', color=[-1, -1, -1], blendMode='avg',
                       units='pix')


## start
#for track in range(1,9):
while track != 40:
    # Inst
    text = visual.TextStim(screen, text="<<<", height=150, color=[1, 1, 1], wrapWidth=2000)
    text.draw()
    screen.flip()

    # Play sound
    s = sound.Sound(path+str(1)+'_snr('+str(snr)+').wav')
    s.play()
    print(str(track)+'_snr='+str(snr))
    time.sleep(5)

    # Question
    text = visual.TextStim(screen, text="들림? \n\n 그럼 1 아님 2", height=50, color=[1, 1, 1], wrapWidth=2000)
    text.draw()
    screen.flip()
    resp = event.waitKeys(keyList=['1', '2'], clearEvents=True)

    #
    if resp == ['1']:   # correct
        corr = corr+1

    if snr > -29:
        if corr == 3:
            snr = snr-15
            print("down")
            corr = 0
        elif resp == ['2']:
            snr = snr+15
            corr = 0
            print("up")
    else:
        if corr == 3:
            snr = snr-2
            print("down")
            corr = 0
        elif resp == ['2']:
            if snr == -30:
                snr = snr+15
            else:
                snr = snr+2
            corr=0
            print("up")

    text = visual.TextStim(screen, text="next ㄱㄷ", height=50, color=[1, 1, 1], wrapWidth=2000)
    text.draw()
    screen.flip()
    time.sleep(1)

    track = track+1

text = visual.TextStim(screen, text="End", height=50, color=[1, 1, 1], wrapWidth=2000)
text.draw()
screen.flip()

print("a")






