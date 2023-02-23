
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
while track != 40:  # the number of trial
    # Inst
    text = visual.TextStim(screen, text="<<<", height=150, color=[1, 1, 1], wrapWidth=2000)
    text.draw()
    screen.flip()

    # Load sound
    s = sound.Sound(path + str(track)+'.wav')   # 양쪽 rms 맞추지 않은 stereo 음원

    #---------
    # MCL dB로 맞추고 무조건 시작 양쪽다 MCL 기준으로 SNR 변화 계속 주기
    # Modify to MCL
    rms_s = np.sqrt(np.mean(s.sndArr*s.sndArr))     # RMS of original sound
    torms = 10**(MCL / 20)*(RMSref)               # RMS modified corresponding on hoping SPL
    Modifed_s = (s.sndArr/rms_s)*(torms)            # Sound with hoping SPL

    # 재생시킬 사운드 변수에 rms 변화시킨 signal 넣기 (stereo file)
    s.sndArr = Modifed_s

    # Modify to hoping SNR
    s_att = s.sndArr[:,0]   # left
    s_utt = s.sndArr[:,1]   # right
    rms_a = np.sqrt(np.mean(s_att * s_att))     # RMS of original sound
    rms_u = np.sqrt(np.mean(s_utt * s_utt))     # RMS of original sound
    torms = 10**(H_SNR / 20)*(rms_u)                  # RMS modified corresponding on hoping SNR / fixed utt
    Modifed_s = (s_att/rms_a)*(torms)            # Sound with hoping SNR

    # left attention 인 경우, 변화준 한쪽 사운드 재생시킬 사운드 변수에 넣기
    s.sndArr[:,0] = Modifed_s

    # 위에서 만든 원하는 snr 을 가진 스테레오 사운드 재생
    s.play()
    print(str(track)+'_snr='+str(H_SNR))
    time.sleep(5)


    # Question
    text = visual.TextStim(screen, text="따라해! \n\n 빨리", height=50, color=[1, 1, 1], wrapWidth=2000)
    text.draw()
    screen.flip()
    # 검사자가 맞았는지 틀렸는지. 1-correct/ 2-떙
    resp = event.waitKeys(keyList=['1', '2'], clearEvents=True)

    # 맞추면
    if resp == ['1']:   # correct
        corr = corr+1

    #  snr -30 보다 높은 구간(노이즈 덜)은 15 dB씩
    if snr > -29:
        if corr == 3:   # 3번 맞추면 snr 낮춤
            snr = snr-15
            print("down")
            corr = 0
        elif resp == ['2']: # 틀리면 snr 올림
            snr = snr+15
            corr = 0
            print("up")
    else:   # snr -30 이하 구간 (노이즈 심함)은 30 dB 씩
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






