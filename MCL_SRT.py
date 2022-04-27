
# Most Comfortable Level Test
# up 5dB

from math import log10, sqrt
import numpy as np
from scipy import stats
from scipy.io import wavfile
from playsound import playsound
from psychopy import sound,visual, core,event
import time, serial, logging, scipy.io
from sklearn.metrics import mean_squared_error
from math import sqrt



# Set
path = 'C:/Users/LeeJiWon/Desktop/hykist/AAD/MatrixSentence'
subject = 'hjy'

# Make the window for visual presentation
screen = visual.Window([960, 900], screen=2, pos=[600, 0], fullscr=False,
                       winType='pyglet', allowGUI=False, allowStencil=False,
                       monitor='testMonitor', color=[-1, -1, -1], blendMode='avg',
                       units='pix')

# Inst
text = visual.TextStim(screen, text="MCL \n\n puss space ", height=50, color=[1, 1, 1], wrapWidth=2000)
text.draw()
screen.flip()
event.waitKeys(keyList=['space'], clearEvents=True)

#
track = 100
RMSref = 2*10**(-5)
H_SPL = 60      # 첫 시작 SPL > 평균 순음역치 등.

## start MCL test
while True:
    text = visual.TextStim(screen, text=" + ", height=150, color=[1, 1, 1], wrapWidth=2000)
    text.draw()
    screen.flip()
    # Load sound - mono matrix setence source
    s = sound.Sound(path + '/200_quiet/[0]Q' + str(track) + '.wav')

    #SPL = 20*log10(rms_s/RMSref)    # dB
    # Modify SPL of original source to hoping dB SPL
    rms_s = np.sqrt(np.mean(s.sndArr*s.sndArr))     # RMS of original sound
    torms = 10**(H_SPL / 20)*(RMSref)               # RMS modified corresponding on hoping dB SPL
    Modifed_s = (s.sndArr/rms_s)*(torms)            # Sound with hoping SPL
    s.sndArr = Modifed_s

    # Play sound
    s.play()
    print("SPL : {0}".format(int(H_SPL)))
    time.sleep(5)

    # Question
    text = visual.TextStim(screen, text="어떰? \n\n 작? / 괜춘? / 큼?", height=50, color=[1, 1, 1], wrapWidth=2000)
    text.draw()
    screen.flip()

    resp = event.waitKeys(keyList=['1','2','5'], clearEvents=True)
    print("Respond : {0}".format(int(resp[0])))

    # Responding
    if int(resp[0]) == 1:      # -5
        H_SPL = H_SPL - 5

    elif int(resp[0]) == 2:    # +5
        H_SPL = H_SPL + 5

    elif int(resp[0]) == 5:
        break

    # Stock Respond

    text = visual.TextStim(screen, text="next ㄱㄷ", height=50, color=[1, 1, 1], wrapWidth=2000)
    text.draw()
    screen.flip()
    time.sleep(1)

    track = track+1

print("Track = {0}  ".format(int(track)))
print("MCL = {0}  dB SPL".format(int(H_SPL)))

MCL = H_SPL
scipy.io.savemat('C:/Users/LeeJiWon/Desktop/OpenBCI/AAD/Python/save_data/MCL_' + subject + '.mat', {'MCL': H_SPL})
text = visual.TextStim(screen, text="MCL done", height=50, color=[1, 1, 1], wrapWidth=2000)
text.draw()
screen.flip()
time.sleep(3)

######################################################################################################
# SRT test
text = visual.TextStim(screen, text="SRT \n\n press space", height=50, color=[1, 1, 1], wrapWidth=2000)
text.draw()
screen.flip()
event.waitKeys(keyList=['space'], clearEvents=True)

# Start SRT
# LEFT attention
ChargedB = 0
H_SNR = 0
track = 1
while True:

    text = visual.TextStim(screen, text="<<<", height=150, color=[1, 1, 1], wrapWidth=2000)
    text.draw()
    screen.flip()

    # Play sound
    s = sound.Sound(path +'/hjy/SRT_source/ms_'+ str(track)+'.wav')

    # MCL dB로 맞추고 무조건 시작 양쪽다 MCL 기준으로 SNR 변화 계속 주기
    # Modify levle of original sound to MCL
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
    s.sndArr[:,0] = Modifed_s       # left 0 / right 1

    s.play()
    print(str(track)+'_SNR = '+str(H_SNR)+' dB')
    time.sleep(5)

    # Repeat
    text = visual.TextStim(screen, text="따라해! \n\n 빨리", height=50, color=[1, 1, 1], wrapWidth=2000)
    text.draw()
    screen.flip()
    resp = event.waitKeys(keyList=['1', '2', '3', '4', '5'], clearEvents=True)     # 1 - ok / 2 - fail

    if int(resp[0]) == 1:
        ChargedB = -5
    elif int(resp[0]) == 2:
        ChargedB = +5
    elif int(resp[0]) == 3:
        ChargedB = -2
    elif int(resp[0]) == 4:
        ChargedB = +2
    elif int(resp[0]) == 5:
        break

    H_SNR = H_SNR + ChargedB
    track = track + 1


SRT = H_SNR
print('SRT = ' + str(SRT) + ' dB SNR')
scipy.io.savemat('C:/Users/LeeJiWon/Desktop/OpenBCI/AAD/Python/save_data/SRT_' + subject + '.mat', {'SRT': SRT})
text = visual.TextStim(screen, text="End", height=50, color=[1, 1, 1], wrapWidth=2000)
text.draw()
time.sleep(3)
screen.flip()







