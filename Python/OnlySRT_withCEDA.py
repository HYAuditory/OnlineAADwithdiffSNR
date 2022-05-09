
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
import serial, string, math
import pandas as pd
# Set
#path = 'C:/Users/Jae Ho/Desktop/hy-kist/Matrix_sound/test source_matixAADC'
path = 'C:/Users/LeeJiWon/Desktop/hykist/AAD/MatrixSentence'

subject = '0429_hjy'

arduino = 'COM10'            # Arduino serial port number (BT)

# Connection
port = serial.Serial(arduino, 9600)     # Connect to port of arduino

# Make the window for visual presentation
screen = visual.Window([960, 900], screen=2, pos=[600, 0], fullscr=False,
                       winType='pyglet', allowGUI=False, allowStencil=False,
                       monitor='testMonitor', color=[-1, -1, -1], blendMode='avg',
                       units='pix')
file = pd.read_excel(path + "/intro_HTLMCLSRT.xlsx")
########################################  SRT_LEFT  ##############################################################

####### Intro SRT_L #######
p = 1
for i in range(0, len(file)):
    text = visual.TextStim(screen, text=file.SRT_L[i], height=30, color=[1, 1, 1], wrapWidth=2000)
    n = file.SRT_L[i]

    while file.Num[i] == len(file.SRT_L):  # practice
        time.sleep(3)
        # play
        port.write('P'.encode())
        text = visual.TextStim(screen, text="<<<", height=150, color=[1, 1, 1], wrapWidth=2000)

        text.draw()
        screen.flip()
        time.sleep(4)
        # respond
        text = visual.TextStim(screen, text="따라해 \n\n 빨리", height=50, color=[1, 1, 1], wrapWidth=2000)
        text.draw()
        screen.flip()
        # 내가 입력, 맞은 갯수를
        resp = event.waitKeys(keyList=['0', '1', '2', '3', '4', '5'], clearEvents=True)  # correct
        print('Correct = ' + str(resp))
        event.waitKeys(keyList=['space'], clearEvents=True)
        text = visual.TextStim(screen, text="next", height=50, color=[1, 1, 1], wrapWidth=2000)
        text.draw()
        screen.flip()

        p = p + 1
        if p == 3:
            break

    try:  # nan 즉 comment 끝이면 break
        np.isnan(n)
        break
    except:
        text.draw()
        screen.flip()

    key = event.waitKeys(keyList=["space", "escape"], clearEvents=True)
    if key == ["escape"]:
        core.quit()

time.sleep(3)

# SRT test - LEFT
# correct - 5 up / incorrect - 1 down
text = visual.TextStim(screen, text="SRT_LEFT \n\n press space", height=50, color=[1, 1, 1], wrapWidth=2000)
text.draw()
screen.flip()
event.waitKeys(keyList=['space'], clearEvents=True)
print("================================")
print("========== SRT_RIGHT ===========")
print("=======  Change SD card! =======")
print("================================")
##
SRT_list = np.array([0,10,20,30,32,34,36,38,40,42,44,46,48,50])
Alph_list = list(string.ascii_lowercase)
# Start SRT
# LEFT attention
ChargedB = 0
H_SNR = 0     # first dB SNR
track = 1
case = 0
SNRIdx = 0
ChargeTrk = 0   # first track
#port.write('S'.encode())
SRTresp_L = np.zeros([14,])
SRTfreq_L = np.zeros([14,])
port.write('S'.encode())

while track < 13*20:  # 20 track

    text = visual.TextStim(screen, text="<<<", height=150, color=[1, 1, 1], wrapWidth=2000)
    text.draw()
    screen.flip()

    print(str(track)+'_SNR = '+str(H_SNR)+' dB')
    # Serial command
    toArdCom = Alph_list[ChargeTrk]

    CurrentTrack = track + SNRIdx
    print("Current Track = {0}".format(CurrentTrack))
    print("To Ard = {0}".format(toArdCom))
    print(" + track = {0}".format(ChargeTrk))
    port.write(toArdCom.encode())   # arduino track에서 +할 숫자 보내

    time.sleep(5)

    # Repeat
    text = visual.TextStim(screen, text="따라해 \n\n 빨리", height=50, color=[1, 1, 1], wrapWidth=2000)
    text.draw()
    screen.flip()
    # 내가 입력, 맞은 갯수를
    resp = event.waitKeys(keyList=['0', '1', '2', '3', '4', '5'], clearEvents=True)    # correct
    print('Correct = '+str(resp))

    # dB 에 맞게 반응 넣기
    SNRIdx = int(np.where(SRT_list == -H_SNR)[0][0])
    SRTfreq_L[SNRIdx] = SRTfreq_L[SNRIdx] + 1
    SRTresp_L[SNRIdx] = SRTresp_L[SNRIdx] + int(resp[0])/5

    if case == 0:

        if int(resp[0]) < 3:    # correct = 0 / 1 / 2
            ChargedB = +2
            case = 1
        elif 2 < int(resp[0]):  # correct = 3 / 4 / 5
            ChargedB = -10

    elif case == 1:

        if int(resp[0]) < 3:
            ChargedB = +2
        elif 2 < int(resp[0]):
            ChargedB = -2

    H_SNR = H_SNR + ChargedB
    SNRIdx = int(np.where(SRT_list == -H_SNR)[0][0])
    track = track + 14
    ChargeTrk = (track + SNRIdx) - CurrentTrack     # 현재 arduino의 track 에서 + 시켜야할 num

    text = visual.TextStim(screen, text="next", height=50, color=[1, 1, 1], wrapWidth=2000)
    text.draw()
    screen.flip()
    event.waitKeys(keyList=['space'], clearEvents=True)

    print("----------------")

#print('SRT = ' + str(SRT) + ' dB SNR')
scipy.io.savemat(path + '/hjy/SAVE/SRTfreq_L' + subject + '.mat', {'SRTfreq_L': SRTfreq_L})
scipy.io.savemat(path + '/hjy/SAVE/SRTresp_L' + subject + '.mat', {'SRTresp_L': SRTresp_L})
text = visual.TextStim(screen, text="End", height=50, color=[1, 1, 1], wrapWidth=2000)
text.draw()
screen.flip()
port.write('0'.encode())
time.sleep(3)

########################################  SRT_RIGHT  ##############################################################

# Start SRT
# LEFT attention
ChargedB = 0
H_SNR = 0     # first dB SNR
track = 1
case = 0
SNRIdx = 0
ChargeTrk = 0   # first track

SRTresp_R = np.zeros([14,])
SRTfreq_R = np.zeros([14,])
port.write('S'.encode())

while track < 13*20:  # 20 track

    text = visual.TextStim(screen, text=">>>", height=150, color=[1, 1, 1], wrapWidth=2000)
    text.draw()
    screen.flip()

    print(str(track)+'_SNR = '+str(H_SNR)+' dB')
    # Serial command
    toArdCom = Alph_list[ChargeTrk]

    CurrentTrack = track + SNRIdx
    print("Current Track = {0}".format(CurrentTrack))
    print("To Ard = {0}".format(toArdCom))
    print(" + track = {0}".format(ChargeTrk))
    port.write(toArdCom.encode())   # arduino track에서 +할 숫자 보내

    time.sleep(5)

    # Repeat
    text = visual.TextStim(screen, text="따라해 \n\n 빨리", height=50, color=[1, 1, 1], wrapWidth=2000)
    text.draw()
    screen.flip()
    # 내가 입력, 맞은 갯수를
    resp = event.waitKeys(keyList=['0', '1', '2', '3', '4', '5'], clearEvents=True)    # correct
    print('Correct = '+str(resp))

    # dB 에 맞게 반응 넣기
    SNRIdx = int(np.where(SRT_list == -H_SNR)[0][0])
    SRTfreq_R[SNRIdx] = SRTfreq_R[SNRIdx] + 1
    SRTresp_R[SNRIdx] = SRTresp_R[SNRIdx] + int(resp[0])/5

    if case == 0:

        if int(resp[0]) < 3:    # correct = 0 / 1 / 2
            ChargedB = +2
            case = 1
        elif 2 < int(resp[0]):  # correct = 3 / 4 / 5
            ChargedB = -10

    elif case == 1:

        if int(resp[0]) < 3:
            ChargedB = +2
        elif 2 < int(resp[0]):
            ChargedB = -2

    H_SNR = H_SNR + ChargedB
    SNRIdx = int(np.where(SRT_list == -H_SNR)[0][0])
    track = track + 14
    ChargeTrk = (track + SNRIdx) - CurrentTrack     # 현재 arduino의 track 에서 + 시켜야할 num

    text = visual.TextStim(screen, text="next", height=50, color=[1, 1, 1], wrapWidth=2000)
    text.draw()
    screen.flip()
    event.waitKeys(keyList=['space'], clearEvents=True)

    print("----------------")


#print('SRT = ' + str(SRT) + ' dB SNR')
scipy.io.savemat(path + '/hjy/SAVE/SRTfreq_R' + subject + '.mat', {'SRTfreq_R': SRTfreq_R})
scipy.io.savemat(path + '/hjy/SAVE/SRTresp_R' + subject + '.mat', {'SRTresp_R': SRTresp_R})
text = visual.TextStim(screen, text="End", height=50, color=[1, 1, 1], wrapWidth=2000)
text.draw()
screen.flip()
port.write('0'.encode())
time.sleep(3)

'''

def sigmoid(x):
    return 1 / (1 +np.exp(-x))

sigm_val = np.zeros([len(SRTfreq),1])
xx = np.array([])

for i in range(len(SRTfreq)):
    sigm_val[i] = SRTresp[i]/SRTfreq[i]

check = np.isnan(sigm_val) # true = nan


y = sigm_val[np.logical_not(np.isnan(sigm_val))]
x = np.arange(1,8,1)


x = np.arange(-5, 5, 1)
sigm = sigmoid(y.T)


a = np.radians()
'''