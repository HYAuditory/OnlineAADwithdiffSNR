
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
subject = '05_hjy'
arduino = 'COM10'            # Arduino serial port number (BT)

# Connection
port = serial.Serial(arduino, 9600)     # Connect to port of arduino

# Make the window for visual presentation
screen = visual.Window([960, 900], screen=2, pos=[600, 0], fullscr=False,
                       winType='pyglet', allowGUI=False, allowStencil=False,
                       monitor='testMonitor', color=[-1, -1, -1], blendMode='avg',
                       units='pix')

file = pd.read_excel(path + "/intro_MCLSRT.xlsx")

####### Intro exp #######
for i in range(0,len(file)):
    text = visual.TextStim(screen, text=file.Intro[i], height=30, color=[1, 1, 1], wrapWidth=2000)
    n = file.Intro[i]

    try:    # nan 즉 comment 끝이면 break
        np.isnan(n)
        break
    except:
        text.draw()
        screen.flip()

    key = event.waitKeys(keyList=["space", "escape"], clearEvents=True)
    if key == ["escape"]:
        core.quit()

######################################  MCL  ################################################################

#text = visual.TextStim(screen, text="MCL \n\n puss space ", height=50, color=[1, 1, 1], wrapWidth=2000)
#text.draw()
#screen.flip()
event.waitKeys(keyList=['space'], clearEvents=True)
print("========== MCL ===========")
# HTL + 30 dB 부터
H_SPL = 35

# list
Alph_list = list(string.ascii_lowercase)
MCL_list = np.array([35,40,45,50,55,60,65,70,75,80])
# for first track of MCL test

idx = np.where(MCL_list == H_SPL)
track = idx[0][0]+8

####### Intro MCL #######
for i in range(0,len(file)):
    text = visual.TextStim(screen, text=file.MCL[i], height=30, color=[1, 1, 1], wrapWidth=2000)
    n = file.MCL[i]

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

## start MCL test
port.write('M'.encode())        # !! callibration 후에 첫 트랙번호가 두자리수 안넘아가는지 확인 !!
while True:

    print("Track = {0}".format(track))
    print("SPL : {0} dB".format(H_SPL))
    toArdCom = Alph_list[track - 1] # 증가 + HTL 5 track
    port.write(str(toArdCom).encode())
    text = visual.TextStim(screen, text=" + ", height=150, color=[1, 1, 1], wrapWidth=2000)
    text.draw()
    screen.flip()

    time.sleep(5)

    # Question
    text = visual.TextStim(screen, text="어떤가요? \n\n 1. 너무 작다  2. 작다. \n 3. 편하지만 약간 작다.  4. 편하다. \n 5. 편하지만 약간 크다. 6. 크지만 괜찮다. \n 7. 불편할 정도로 크다.", height=50, color=[1, 1, 1], wrapWidth=2000)
    text.draw()
    screen.flip()

    resp = event.waitKeys(keyList=['1', '2', '3', '4', '5', '6', '7', '0'], clearEvents=True)
    print("Respond : {0}".format(int(resp[0])))

    #
    text = visual.TextStim(screen, text="NEXT", height=50, color=[1, 1, 1], wrapWidth=2000)
    text.draw()
    screen.flip()

    #
    resp = event.waitKeys(keyList=['1', '2', '0'], clearEvents=True)
    print("My key : {0}".format(int(resp[0])))
    time.sleep(1)

    # Responding
    if int(resp[0]) == 1:   # -1 track
        track = track - 1
        H_SPL = H_SPL - 5

    elif int(resp[0]) == 2: # +1 track
        track = track + 1
        H_SPL = H_SPL + 5

    elif int(resp[0]) == 0:
        port.write('0'.encode())
        break

    print("-------------")

MCL = H_SPL
print("** MCL == {0} dB **".format(MCL))
scipy.io.savemat(path + '/hjy/SAVE/MCL_' + subject + '.mat',
                 {'MCL_SPL': MCL})
text = visual.TextStim(screen, text="쾌적역치레벨 검사가 끝났습니다", height=50, color=[1, 1, 1], wrapWidth=2000)
text.draw()
screen.flip()
event.waitKeys(keyList=['space'], clearEvents=True)

########################################  SRT_LEFT  ##############################################################
####### Intro SRT_L #######
#text = visual.TextStim(screen, text="SRT_LEFT \n\n press space", height=50, color=[1, 1, 1], wrapWidth=2000)
#text.draw()
#screen.flip()
#event.waitKeys(keyList=['space'], clearEvents=True)
print("================================")
print("========== SRT_LEFT ===========")
print("=======  Change SD card! =======")
print("================================")

for i in range(0, len(file)):
    text = visual.TextStim(screen, text=file.SRT_L[i], height=30, color=[1, 1, 1], wrapWidth=2000)
    n = file.SRT_L[i]

    try:  # nan 즉 comment 끝이면 break
        np.isnan(n)
        break
    except:
        text.draw()
        screen.flip()

    # practice
    if file.Num[i] == len(file.SRT_L)-1:
        for x in range(0,2):
            time.sleep(3)
            # play
            port.write('P'.encode())
            text = visual.TextStim(screen, text="<<<", height=150, color=[1, 1, 1], wrapWidth=2000)

            text.draw()
            screen.flip()
            time.sleep(4)
            # respond
            text = visual.TextStim(screen, text="들으신 문장을 따라 말해주세요.", height=50, color=[1, 1, 1], wrapWidth=2000)
            text.draw()
            screen.flip()
            # 내가 입력, 맞은 갯수를
            resp = event.waitKeys(keyList=['0', '1', '2', '3', '4', '5'], clearEvents=True)  # correct
            print('Correct = ' + str(resp))
            event.waitKeys(keyList=['space'], clearEvents=True)
            if x == 0:
                text = visual.TextStim(screen, text="NEXT", height=50, color=[1, 1, 1], wrapWidth=2000)
                text.draw()
                screen.flip()

    key = event.waitKeys(keyList=["space", "escape"], clearEvents=True)
    if key == ["escape"]:
        core.quit()
time.sleep(3)

# SRT test - LEFT
##
SRT_list = np.array([0,10,20,30,32,34,36,38,40,42,44,46,48,50])
Alph_list = list(string.ascii_lowercase)

for i in SRT_list:
    globals()['RespL_SNR{}'.format(i)] = np.array([])

# Start SRT
# LEFT attention
count = 0
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

while count < 15:  # 20 track

    text = visual.TextStim(screen, text="<<<", height=150, color=[1, 1, 1], wrapWidth=2000)
    text.draw()
    screen.flip()

    print(str(track)+'_SNR = '+str(H_SNR)+' dB')
    # Serial command
    toArdCom = Alph_list[ChargeTrk]

    CurrentTrack = track + SNRIdx
    print("Current Track = {0}".format(CurrentTrack))
    #print("To Ard = {0}".format(toArdCom))
    print("Count = {0}".format(count+1))
    port.write(toArdCom.encode())   # arduino track에서 +할 숫자 보내

    time.sleep(5)

    # Repeat
    text = visual.TextStim(screen, text="들으신 문장을 따라 말해주세요.", height=50, color=[1, 1, 1], wrapWidth=2000)
    text.draw()
    screen.flip()
    # 내가 입력, 맞은 갯수를
    resp = event.waitKeys(keyList=['0', '1', '2', '3', '4', '5'], clearEvents=True)    # correct
    print('Correct = '+str(resp))

    # dB 에 맞게 반응 넣기
    SNRIdx = int(np.where(SRT_list == -H_SNR)[0][0])


    globals()['RespL_SNR{}'.format(SRT_list[SNRIdx])] = np.append(globals()['RespL_SNR{}'.format(SRT_list[SNRIdx])],
                                                                 int(resp[0]) / 5)
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

    text = visual.TextStim(screen, text="NEXT", height=50, color=[1, 1, 1], wrapWidth=2000)
    text.draw()
    screen.flip()
    event.waitKeys(keyList=['space'], clearEvents=True)
    count = count + 1
    print("----------------")

#print('SRT = ' + str(SRT) + ' dB SNR')

for i in SRT_list:
    if len(globals()['RespL_SNR{}'.format(i)]) != 0:
        scipy.io.savemat(path + '/hjy/SAVE/RespL_SNR' +str(i)+'_' + subject + '.mat', {'RespL_SNR'+str(i): globals()['RespL_SNR{}'.format(i)]})


text = visual.TextStim(screen, text="왼쪽 검사가 마무리되었습니다.", height=50, color=[1, 1, 1], wrapWidth=2000)
text.draw()
screen.flip()
port.write('0'.encode())
time.sleep(3)

########################################  SRT_RIGHT  ##############################################################
#
text = visual.TextStim(screen, text="쉬는 시간입니다. \n\n 궁금하신 점이 있으시다면 말씀해주세요.", height=50, color=[1, 1, 1], wrapWidth=2000)
text.draw()
screen.flip()
event.waitKeys(keyList=['space'], clearEvents=True)
print("================================")
print("========== SRT_RIGHT ===========")
print("=======  Change SD card! =======")
print("================================")

for i in range(0, len(file)):
    text = visual.TextStim(screen, text=file.SRT_R[i], height=30, color=[1, 1, 1], wrapWidth=2000)
    n = file.SRT_R[i]

    try:  # nan 즉 comment 끝이면 break
        np.isnan(n)
        break
    except:
        text.draw()
        screen.flip()

    # practice
    if file.Num[i] == 2:
        for x in range(0,2):
            time.sleep(3)
            # play
            port.write('P'.encode())
            text = visual.TextStim(screen, text=">>>", height=150, color=[1, 1, 1], wrapWidth=2000)

            text.draw()
            screen.flip()
            time.sleep(4)
            # respond
            text = visual.TextStim(screen, text="들으신 문장을 따라 말해주세요.", height=50, color=[1, 1, 1], wrapWidth=2000)
            text.draw()
            screen.flip()
            # 내가 입력, 맞은 갯수를
            resp = event.waitKeys(keyList=['0', '1', '2', '3', '4', '5'], clearEvents=True)  # correct
            print('Correct = ' + str(resp))
            event.waitKeys(keyList=['space'], clearEvents=True)
            if x == 0:
                text = visual.TextStim(screen, text="NEXT", height=50, color=[1, 1, 1], wrapWidth=2000)
                text.draw()
                screen.flip()

    key = event.waitKeys(keyList=["space", "escape"], clearEvents=True)
    if key == ["escape"]:
        core.quit()

time.sleep(3)

for i in SRT_list:
    globals()['RespR_SNR{}'.format(i)] = np.array([])
# Start SRT
# RIGHT attention
count = 0
ChargedB = 0
H_SNR = 0     # first dB SNR
track = 1
case = 0
SNRIdx = 0
ChargeTrk = 0   # first track

SRTresp_R = np.zeros([14,])
SRTfreq_R = np.zeros([14,])
port.write('S'.encode())

while count < 15:  # 20 track  # 20 track

    text = visual.TextStim(screen, text=">>>", height=150, color=[1, 1, 1], wrapWidth=2000)
    text.draw()
    screen.flip()

    print(str(track)+'_SNR = '+str(H_SNR)+' dB')
    # Serial command
    toArdCom = Alph_list[ChargeTrk]

    CurrentTrack = track + SNRIdx
    print("Current Track = {0}".format(CurrentTrack))
    #print("To Ard = {0}".format(toArdCom))
    print("Count = {0}".format(count+1))
    port.write(toArdCom.encode())   # arduino track에서 +할 숫자 보내

    time.sleep(5)

    # Repeat
    text = visual.TextStim(screen, text="들으신 문장을 따라 말해주세요.", height=50, color=[1, 1, 1], wrapWidth=2000)
    text.draw()
    screen.flip()
    # 내가 입력, 맞은 갯수를
    resp = event.waitKeys(keyList=['0', '1', '2', '3', '4', '5'], clearEvents=True)    # correct
    print('Correct = '+str(resp))

    # dB 에 맞게 반응 넣기
    SNRIdx = int(np.where(SRT_list == -H_SNR)[0][0])
    globals()['RespR_SNR{}'.format(SRT_list[SNRIdx])] = np.append(globals()['RespR_SNR{}'.format(SRT_list[SNRIdx])],
                                                                 int(resp[0]) / 5)

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

    text = visual.TextStim(screen, text="NEXT", height=50, color=[1, 1, 1], wrapWidth=2000)
    text.draw()
    screen.flip()
    event.waitKeys(keyList=['space'], clearEvents=True)

    print("----------------")
    count = count + 1

#print('SRT = ' + str(SRT) + ' dB SNR')
for i in SRT_list:
    if len(globals()['RespR_SNR{}'.format(i)]) != 0:
        scipy.io.savemat(path + '/hjy/SAVE/RespR_SNR' + str(i) +'_'+ subject + '.mat', {'RespR_SNR'+str(i): globals()['RespR_SNR{}'.format(i)]})

### end
text = visual.TextStim(screen, text="End", height=50, color=[1, 1, 1], wrapWidth=2000)
text.draw()
screen.flip()
port.write('0'.encode())
time.sleep(3)
