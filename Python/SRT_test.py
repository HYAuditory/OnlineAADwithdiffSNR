
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
path = 'C:/Users/LeeJiWon/Desktop/hykist/AAD/MatrixSentence/hjy/testsource_matrixAADC/ms'
track = 1
snr = 0
corr = 0

# Make the window for visual presentation
screen = visual.Window([960, 900], screen=2, pos=[600, 0], fullscr=False,
                       winType='pyglet', allowGUI=False, allowStencil=False,
                       monitor='testMonitor', color=[-1, -1, -1], blendMode='avg',
                       units='pix')


## start
MCL = 70  # MCL test 통해 구한 SPL
H_SNR = -20
while track != 40:
    # Inst
    text = visual.TextStim(screen, text="<<<", height=150, color=[1, 1, 1], wrapWidth=2000)
    text.draw()
    screen.flip()

    # Play sound
    s = sound.Sound(path + str(track)+'.wav')

    # MCL dB로 맞추고 무조건 시작 양쪽다 MCL 기준으로 SNR 변화 계속 주기
    # Modify to MCL
    rms_s = np.sqrt(np.mean(s.sndArr*s.sndArr))     # RMS of original sound
    torms = 10**(MCL / 20)*(RMSref)               # RMS modified corresponding on hoping SPL
    Modifed_s = (s.sndArr/rms_s)*(torms)            # Sound with hoping SPL
    s.sndArr = Modifed_s


    # Modify to hoping SNR
    s_att = s.sndArr[:,0]
    s_utt = s.sndArr[:,1]
    rms_a = np.sqrt(np.mean(s_att * s_att))     # RMS of original sound
    rms_u = np.sqrt(np.mean(s_utt * s_utt))     # RMS of original sound
    torms = 10**(H_SNR / 20)*(rms_u)                  # RMS modified corresponding on hoping SNR / fixed utt
    Modifed_s = (s_att/rms_a)*(torms)            # Sound with hoping SNR
    s.sndArr[:,0] = Modifed_s

    s.play()
    print(str(track)+'_snr='+str(H_SNR))
    time.sleep(5)


    # Question
    text = visual.TextStim(screen, text="따라해! \n\n 빨리", height=50, color=[1, 1, 1], wrapWidth=2000)
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






