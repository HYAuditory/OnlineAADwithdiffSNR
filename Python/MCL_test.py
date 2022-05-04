
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
path = 'C:/Users/LeeJiWon/Desktop/hykist/AAD/MatrixSentence/200_quiet/[0]Q'
subject = 'hjy'

track = 1
H_SPL = 60      # 첫 시작 SPL > 평균 순음역치 등.
RMSref = 2*10**(-5)

# Make the window for visual presentation
screen = visual.Window([960, 900], screen=2, pos=[600, 0], fullscr=False,
                       winType='pyglet', allowGUI=False, allowStencil=False,
                       monitor='testMonitor', color=[-1, -1, -1], blendMode='avg',
                       units='pix')

# Inst
text = visual.TextStim(screen, text="MCL \n\n puss space ", height=150, color=[1, 1, 1], wrapWidth=2000)
text.draw()
screen.flip()
event.waitKeys(keyList=['space'], clearEvents=True)

## start MCL test
while True:
    text = visual.TextStim(screen, text=" + ", height=150, color=[1, 1, 1], wrapWidth=2000)
    text.draw()
    screen.flip()
    # Load sound
    s = sound.Sound(path + str(track+100) + '.wav')

    #SPL = 20*log10(rms_s/RMSref)    # dB
    # Modify RMS / SNR
    rms_s = np.sqrt(np.mean(s.sndArr*s.sndArr))     # RMS of original sound
    torms = 10**(H_SPL / 20)*(RMSref)               # RMS modified corresponding on hoping SPL
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

print("MCL = {0}  dB SPL".format(int(H_SPL)))
text = visual.TextStim(screen, text="End", height=50, color=[1, 1, 1], wrapWidth=2000)
text.draw()
time.sleep(3)
screen.flip()
scipy.io.savemat('C:/Users/LeeJiWon/Desktop/OpenBCI/AAD/Python/save_data/MCL_' + subject + '.mat', {'MCL_': H_SPL})

print("a")






