
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
import serial

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

# Inst
text = visual.TextStim(screen, text="HTL \n\n puss space ", height=50, color=[1, 1, 1], wrapWidth=2000)
text.draw()
screen.flip()
event.waitKeys(keyList=['space'], clearEvents=True)
'''
#####################################  HTL  ######################################################
port.write('H'.encode())
track = 100
RMSref = 2*10**(-5)
H_SPL = 0      # 첫 시작 SPL
## start HTL test
while True:
    text = visual.TextStim(screen, text=" + ", height=150, color=[1, 1, 1], wrapWidth=2000)
    text.draw()
    screen.flip()

    # Write serial command
    #port.write(b'1')        # for next track
    port.write('1'.encode())

    # Play sound
    print("SPL : {0}".format(int(H_SPL)))
    time.sleep(5)

    # Question
    text = visual.TextStim(screen, text="들리나요? \n\n NO - 1 / OK -2", height=50, color=[1, 1, 1], wrapWidth=2000)
    text.draw()
    screen.flip()

    resp = event.waitKeys(keyList=['1','2'], clearEvents=True)
    print("Respond : {0}".format(int(resp[0])))

    # Responding
    if int(resp[0]) == 1:      # -5
        H_SPL = H_SPL + 5

    elif int(resp[0]) == 2:    # +5
        port.write('X'.encode())
        break

    # Stock Respond

    text = visual.TextStim(screen, text="next ㄱㄷ", height=50, color=[1, 1, 1], wrapWidth=2000)
    text.draw()
    screen.flip()
    time.sleep(1)

    track = track+1

print("Track = {0}  ".format(int(track)))
print("HTL = {0}  dB SPL".format(int(H_SPL)))

HTL = H_SPL
scipy.io.savemat(path + '/hjy/SAVE/HTL_' + subject + '.mat', {'HTL_SPL': H_SPL})
text = visual.TextStim(screen, text="HTL done", height=50, color=[1, 1, 1], wrapWidth=2000)
text.draw()
screen.flip()
time.sleep(3)


######################################  MCL  ################################################################
text = visual.TextStim(screen, text="MCL \n\n puss space ", height=50, color=[1, 1, 1], wrapWidth=2000)
text.draw()
screen.flip()
event.waitKeys(keyList=['space'], clearEvents=True)
port.write('M'.encode())

# HTL + 30 dB 부터
H_SPL = HTL + 30

#
MCL_list = np.array([35,35,40,40,45,45,50,50,55,55,60,60,65,65,70,70,75,75,80,80])
idx = np.where(MCL_list == H_SPL)
HTLIdx = idx[0][0]+6

# Write serial command
port.write(str(HTLIdx-5).encode())

track = int(HTLIdx)
print("Track = {0}".format(track))
## start MCL test
while True:
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
    text = visual.TextStim(screen, text="next ㄱㄷ", height=50, color=[1, 1, 1], wrapWidth=2000)
    text.draw()
    screen.flip()

    #
    resp = event.waitKeys(keyList=['1', '2', '3', '4', '5'], clearEvents=True)
    print("My key : {0}".format(int(resp[0])))
    time.sleep(1)

    # Responding
    if int(resp[0]) == 1:   # -1 track
        track = track - 1
        port.write('1'.encode())

    elif int(resp[0]) == 2: # +1 track
        track = track + 1
        port.write('2'.encode())

    elif int(resp[0]) == 3: # -2 track
        track = track - 2
        port.write('3'.encode())

    elif int(resp[0]) == 4: # +2 track
        track = track + 2
        port.write('4'.encode())

    elif int(resp[0]) == 5:
        port.write('5'.encode())
        break

    print("Track = {0}  ".format(int(track)))

#print("MCL = {0}  dB SPL".format(int(H_SPL)))

MCL = H_SPL
scipy.io.savemat(path + '/hjy/SAVE/MCL_' + subject + '.mat',
                 {'MCL_track': track})
text = visual.TextStim(screen, text="MCL done", height=50, color=[1, 1, 1], wrapWidth=2000)
text.draw()
screen.flip()
time.sleep(3)
'''
########################################  SRT  ##############################################################
# SRT test - LEFT
# correct - 5 up / incorrect - 1 down
text = visual.TextStim(screen, text="SRT \n\n press space", height=50, color=[1, 1, 1], wrapWidth=2000)
text.draw()
screen.flip()
event.waitKeys(keyList=['space'], clearEvents=True)

#
SRT_list = np.array([0,10,20,30,32,34,36,38,40,42,44,46,48,50]);

# Start SRT
# LEFT attention
ChargedB = 0
H_SNR = 0
track = 1
case = 0
SNRIdx = 0
#port.write('S'.encode())
SRTresp = np.zeros([14,])
SRTfreq = np.zeros([14,])

while track < 379:  # 30 track
    #port.write('S'.encode())
    text = visual.TextStim(screen, text="<<<", height=150, color=[1, 1, 1], wrapWidth=2000)
    text.draw()
    screen.flip()

    print(str(track)+'_SNR = '+str(H_SNR)+' dB')
    # Serial command
    SourceTrack = 'R'+str(track + SNRIdx)
    print(SourceTrack)
    port.write(SourceTrack.encode('utf-8'))

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
    SRTfreq[SNRIdx] = SRTfreq[SNRIdx] + 1
    SRTresp[SNRIdx] = SRTresp[SNRIdx] + int(resp[0])/5

    if case == 0:

        if int(resp[0]) < 3:    # correct = 0 / 1 / 2
            ChargedB = -2
            case = 1
        elif 2 < int(resp[0]):  # correct = 3 / 4 / 5
            ChargedB = -10

    elif case == 1:

        if int(resp[0]) < 3:
            ChargedB = -2
        elif 2 < int(resp[0]):
            ChargedB = +2


    H_SNR = H_SNR + ChargedB
    SNRIdx = int(np.where(SRT_list == -H_SNR)[0][0])-1  # exclude 0 dB
    track = track + 13

    #time.sleep(2)

    text = visual.TextStim(screen, text="next", height=50, color=[1, 1, 1], wrapWidth=2000)
    text.draw()
    screen.flip()
    event.waitKeys(keyList=['space'], clearEvents=True)
    '''
    # Serial command for NEXT track
    SourceTrack = 'R'+str(track + SNRIdx)
    print(SourceTrack)
    port.write(SourceTrack.encode('utf-8'))
    
    try:
        
        SourceTrack = str(track + SNRIdx)
        port.write(SourceTrack[0].encode())       # inone
        time.sleep(0.5)
        port.write(SourceTrack[1].encode())       # intwo
        time.sleep(0.5)
        port.write(SourceTrack[2].encode())       # inthree
        
        SourceTrack = "R"+ str(track + SNRIdx)
        port.write(SourceTrack.encode("utf-8"))
    except:     # 자릿수
        port.write('X'.encode())
    '''

    print("----------------")

SRT = H_SNR
print('SRT = ' + str(SRT) + ' dB SNR')
scipy.io.savemat(path + '/hjy/HTL_' + subject + '.mat', {'SRT': SRT})
text = visual.TextStim(screen, text="End", height=50, color=[1, 1, 1], wrapWidth=2000)
text.draw()
screen.flip()
time.sleep(3)






