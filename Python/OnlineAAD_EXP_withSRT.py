""""""""""""""""""""""""""""""""""""""""""
#        A cost-effective device        #
#           For Online AAD              #
""""""""""""""""""""""""""""""""""""""""""

###### Imports #####
import librosa, warnings, random, time, os, sys, serial, logging, argparse, scipy.io
import numpy as np
import pandas as pd
#from helper import *
from pymtrf import *
from PreProcessing import *
from Comments_SRT import *
from Direction_SRT import *
from Brainflow_stream import *
from EMA import *
from psychopy import visual, core, event
#################################################################################################
#---------------------------------- Experimental SETTING ---------------------------------------#
#################################################################################################
# set info
subject = '0713_phj'             # Subject number
original = 'L'   # or L     # First attention direction
opposite = 'R'   # or R     # opposite direction
arduino = 'COM3'            # Arduino serial port number   bt = 10/cable = 3
cyton = 'COM4'              # OpenBCI board Bluetooth port number
path = 'C:/Users/LeeJiWon/Desktop/OpenBCI/AAD/Python'          # Base Directory

# Connection
port = serial.Serial(arduino, 9600)     # Connect to port of arduino
board, args = Brainflow_stream(cyton)   # Connect to Cyton with Brainflow network
# Set channels number & sampling rate
eeg_channels = board.get_eeg_channels(args.board_id)
aux_channels = board.get_analog_channels(args.board_id)
srate = board.get_sampling_rate(args.board_id)
# ----------------------------------- Load Speech segment data -----------------------------------#
# Load Stimulus data
envelope_AAK = np.load(path + '/data/AAK_envelope.npy')     # 60 by 3840
envelope_SAT = np.load(path + '/data/SAT_envelope.npy')
# 60 by 3840 / trial by time / 1-30 : Twenty / 31-60 Journey // sampling rate : 64 Hz
stim_J = envelope_AAK[:30, :]
stim_T = envelope_AAK[30:, :]
stim_S1 = envelope_SAT[:30, :]
stim_S2 = envelope_SAT[30:, :]
# ---------------------------------------- Parameter Setting -------------------------------------#
tmin = 0
tmax = 250          # Time-lag
Dir = -1            # Backward
reg_lambda = 10     # Lambda value
fs = 64             # post sampling rate

# Set int
ACC = []
Correct = []
Correct2 = []
Answer = []
start = []
end = []
Self_answer = []
Resp_time = []

#####################################################################################################
# Make the window for visual presentation
screen = visual.Window([960, 900], screen=1, pos=[600, 0], fullscr=True,
                       winType='pyglet', allowGUI=False, allowStencil=False,
                       monitor='testMonitor', color=[-1, -1, -1], blendMode='avg',
                       units='pix')

# ------------------------------------------- Intro ------------------------------------------------#
# Load Intro command file
file_qaak = pd.read_excel(path + "/Excel_SRT/question_AAK.xlsx")
file_qsat = pd.read_excel(path + "/Excel_SRT/question_SAT.xlsx")
file_prep = pd.read_excel(path + "/Excel_SRT/prePractice_SRT.xlsx")

event.waitKeys(keyList=['space'], clearEvents=True)
Comments('intro', path, screen, original)
# -------------------------------------------- Practice --------------------------------------------#
# Presentation Command for practice before experiment
for q in range(0,2):
    text = visual.TextStim(screen, text=file_prep.comment1[q], height=40, color=[1, 1, 1], wrapWidth=1000)
    text.draw()
    screen.flip()
    event.waitKeys(keyList=['space'], clearEvents=True)

port.write('R'.encode())

# part 1
for p in range(0, 2):
    port.write('N'.encode())            # For practice speech
    practice_1(p, path, screen)
    time.sleep(1)

# Comments
for q in range(0,2):
    text = visual.TextStim(screen, text=file_prep.comment2[q], height=40, color=[1, 1, 1], wrapWidth=1000)
    text.draw()
    screen.flip()
    event.waitKeys(keyList=['space'], clearEvents=True)

# part 2
for p in range(0, 4):
    port.write('N'.encode())            # For practice speech
    practice_2(p, path, screen)
    time.sleep(1)

port.write('E'.encode())

# ==================================================================================================#
# -------------------------------------- START EXPERIMENT ------------------------------------------#
# ==================================================================================================#
model = np.zeros([15,17,1])
inter = np.zeros([15,1])
RAWData = np.zeros((16, 0))    # EEG 16 channel by 1
AUXData = np.zeros((3, 0))     # Trigger 3 channel by 1
corr_S1 = np.zeros((28, 46))
corr_S2 = np.zeros((28, 46))
acc = np.zeros((28, 46))
model_wt = np.zeros([15,17,1])
inter_wt = np.zeros([15,1])
EmaCorr_S1 = np.zeros((28,46))
EmaCorr_S2 = np.zeros((28,46))

cond = ['MCL', '20', '90', 'SRT']
# 직접 셋팅 지정한 trials에 맞게..
cond_MCL = np.array([15,22,24,27,33,38,42])
cond_20 = np.array([17,20,25,28,32,36,41])
cond_90 = np.array([16,19,23,30,34,37,40])
cond_SRT = np.array([18,21,26,29,31,35,39])

for i in range(0,4):
    globals()['ACC_{}'.format(cond[i])] = []

# Comment before first session.
Comments('practice', path, screen, original)
port.write('A'.encode())

tr = 0  # trial number
z = 1   # To avoid repeat when detect trigger
j = 0   # Question number

# Comment before first session.
Comments(tr, path, screen, original)

# ----------------------------------------- Start 30 trial ------------------------------------------#
# Throw data which don't need
input = board.get_board_data()

while tr < 42:
    if z == 1:
        Direction(tr, original, opposite, screen, port)
        port.write(b'1')        # Signal for trial onset to arduino
        z = 0

    # For Next trial, reset the data format
    eeg_record = np.zeros((16, 0))
    aux_record = np.zeros((3, 0))
    model_w = np.zeros([15, 17, 1])  # reset
    inter_w = np.zeros([15, 1])

    # What condition of snr
    for i in range(0,4):
        cc = np.where(globals()['cond_{}'.format(cond[i])] == tr+1)

        if len(cc[0]) == 1:  # test set 이자 해당 condition!
            condition = np.array([cond[i]])
            break
        else: condition = np.array([])

    # Data acquisition
    input = board.get_board_data()
    eeg_record = np.concatenate((eeg_record, -input[eeg_channels, :]), axis=1)   #If you connected with cathode electrode on openBCI board, you should transmit cathode of EEG data
    aux_record = np.concatenate((aux_record, input[aux_channels, :]), axis=1)

    # ----------------------------- Trigger detection -----------------------------#
    if 1 in input[aux_channels, :][1, :]:   # if the trigger is detected at 12 pin, start process. (include beep sound)
        print("Input Trigger {0}".format(tr + 1))
        print("Start Sound")
        try:
            print("Condition - {}".format(condition[0]))
        except: print("Condition - MCL")
        # Find onset point
        index = np.where(aux_record[1, :] != 0)
        onset = index[0][0]
        # Format per trial
        i = 0       # Window number
        work = 0    # Time count
        check = -3  # attention cue sound 3 second

        # ----------------------------- Working while 60s = one trial-----------------------------#
        # Find speech onset point exclude attention cue sound
        speech = onset + (srate * 3) + 1
        while i != 46:          # During 46 windows

            # If the processing time exceeds 1s, no time sleep
            if work > 1:
                work = 1
            # Wait 1 second to be stacked EEG data and update EEG data per 1 second
            time.sleep(1 - work)
            # Visualize Time
            check = check + 1
            print("Running Time : {0}s".format(check))
            # Time counting
            start = time.perf_counter()

            # Acquire data
            input = board.get_board_data()
            eeg_record = np.concatenate((eeg_record, -input[eeg_channels, :]), axis=1)  # channel by time
            aux_record = np.concatenate((aux_record, input[aux_channels, :]), axis=1)

            # Work time
            end = time.perf_counter()
            work = end - start
            # Stack data until 15s and window sliding per 1s
            # Go to next step after 15s.
            if check >= 15:
                # Adjust data as acquired from that time.
                win = eeg_record[:, speech+(srate*(i)):]      # channel by time

                if len(win.T) > srate * (15):   # when exceed long of 15 second
                    win = eeg_record[:, speech + srate * (i): speech + srate * (15 + i)]      # 15 by 1875

                # ----------------------------- Pre-processing -----------------------------#
                win = np.delete(win, 7, axis=0)                 # delete 7 row ( 8 channel/Fp1 )
                win = Preproccessing(win, srate, 0.5, 8, 601)   # data, sampling rate, low-cut, high-cut, filter order
                data_l = len(win.T)                             # To check the length of inputted data
                # ============================== Train set ==================================#
                if tr < 14:  # int train
                    state = "Train set"
                    # Train decode model
                    model, tlag, inter = mtrf_train(stim_J[tr:tr+1, 64*(i):64*(i)+data_l].T, win.T, fs, Dir,
                                                            tmin, tmax, reg_lambda)
                    model_w = np.add(model_w, model)
                    inter_w = np.add(inter_w, inter)
                # ============================== Test set ===================================#
                else:
                    state = "Test set"
                    # Reconstruct speech
                    pred, corr_s1, p, mse = mtrf_predict(stim_S1[tr-14:tr-13, 64*(i):64*(i)+data_l].T, win.T, model, fs,
                                                     Dir, tmin, tmax, inter)
                    pred, corr_s2, p, mse = mtrf_predict(stim_S2[tr-14:tr-13, 64*(i):64*(i)+data_l].T, win.T, model, fs,
                                                     Dir, tmin, tmax, inter)
                    #'''
                    # Compare with both correlation values
                    if corr_s1 > corr_s2:
                        acc[tr-14,i] = 1
                        print("acc=1")
                    else:
                        acc[tr-14,i] = 0
                        print("acc=0")

                    # Stock correlation value per window(i)
                    corr_S1[tr-14,i] = np.array(corr_s1)
                    corr_S2[tr-14,i] = np.array(corr_s2)
                    '''
                    # Exponential Moving Average
                    EmaCorr_S1, EmaCorr_S2 = EMA(corr_S1, corr_S2, EmaCorr_S1, EmaCorr_S2, i, tr)

                    # Compare with both correlation values
                    if EmaCorr_S1[tr - 14, i] > EmaCorr_S2[tr - 14, i]:
                        acc[tr-14, i] = 1
                    else:
                        acc[tr-14, i] = 0
                    '''
                # Plus window number
                i = i + 1

                # Time count
                end = time.perf_counter()
                work = end - start
        # ------------------------ End one trial ------------------------#
        # Calculate per trial
        if state == "Train set":
            # Sum decoder model to average
            model_wt = np.add(model_wt, model_w)
            inter_wt = np.add(inter_wt, inter_w)

            # Average at last train trial
            if tr == 13:
                model = model_wt / (46 * 14)    # number of window * of trial
                inter = inter_wt / (46 * 14)

        elif state == "Test set":
            # Collect Accuracy per trial
            ACC = np.append(ACC, np.mean(acc[tr-14:tr-13,:]))
            globals()['ACC_{}'.format(condition[0])] = np.append(globals()['ACC_{}'.format(condition[0])], np.mean(acc[tr-14:tr-13,:]))
            try :
                print("\n==================================\n")
                print("Present Accuracy = {0}%".format(globals()['ACC_{}'.format(condition[0])][-1] * 100))
                print("MCL Accuracy = {0}%".format(np.mean(ACC_MCL) * 100))
                print("-20dB Accuracy = {0}%".format(np.mean(ACC_20) * 100))
                print("90 % Accuracy = {0}%".format(np.mean(ACC_90) * 100))
                print("SRT % Accuracy = {0}%".format(np.mean(ACC_SRT) * 100))
                print("\n==================================\n")
            except: pass

        # --------------------------- Questions --------------------------- #
        try:
            print("Question Time")
            if state == "Train set":
                correct, answer, self_answer,respt = Question(j, tr, path, screen)
                Correct.append(correct)
                #Answer.append(answer)

            else:       # test set
                correct2, answer2, self_answer,respt = Question(j, tr, path, screen)
                Correct2.append(correct2)
                Self_answer.append(self_answer)
                Resp_time.append(respt)
            j = j + 1
        except KeyError:  # for error once present last question
            pass

        if tr == 13:
            j = 0

        #=======  Data acquisition for rest  =======#
        input = board.get_board_data()
        eeg_record = np.concatenate((eeg_record, -input[eeg_channels, :]), axis=1)  # channel by time
        aux_record = np.concatenate((aux_record, input[aux_channels, :]), axis=1)

        #===== Stack eeg_record per trial & Save =====#
        RAWData = np.concatenate((RAWData, eeg_record), axis=1)
        AUXData = np.concatenate((AUXData, aux_record), axis=1)

        # =================================== SAVE DATA ===================================== #
        # Save per trial - RAW data, AUX data, accuracy ,behavior
        # numpy file
        np.save(path + '/save_data/RAW_' + subject, RAWData)
        np.save(path + '/save_data/AUX_' + subject, AUXData)
        np.save(path + '/save_data/Corr_att_' + subject, corr_S1)
        np.save(path + '/save_data/Corr_unatt_' + subject, corr_S2)
        #np.save(path + '/save_data/EMACorr_att_' + subject, EmaCorr_S1)
        #np.save(path + '/save_data/EMACorr_unatt_' + subject, EmaCorr_S2)
        np.save(path + '/save_data/Behavior1_' + subject, Correct)
        np.save(path + '/save_data/Behavior2_' + subject, Correct2)
        np.save(path + '/save_data/Self-report_' + subject, Self_answer)
        np.save(path + '/save_data/Resptime_' + subject, Resp_time)
        np.save(path + '/save_data/Accuracy_' + subject, ACC*100)
        np.save(path + '/save_data/modelwt_' + subject, model_wt)
        np.save(path + '/save_data/model_' + subject, model)
        np.save(path + '/save_data/interwt_' + subject, inter_wt)
        np.save(path + '/save_data/inter_' + subject, inter)

        # Mat file
        scipy.io.savemat(path + '/save_data/RAW_' + subject + '.mat', {'RAW': RAWData})
        scipy.io.savemat(path + '/save_data/AUX_' + subject + '.mat', {'AUX': AUXData})
        scipy.io.savemat(path + '/save_data/Behavior1_' + subject + '.mat', {'Behavior_1': Correct})
        scipy.io.savemat(path + '/save_data/Behavior2_' + subject + '.mat', {'Behavior_2': Correct2})
        scipy.io.savemat(path + '/save_data/Accuracy_' + subject + '.mat', {'Acc': ACC*100})
        scipy.io.savemat(path + '/save_data/Self-report_' + subject + '.mat', {'Self_answer': Self_answer})
        scipy.io.savemat(path + '/save_data/Resptime_' + subject + '.mat', {'Resp_time': Resp_time})
        scipy.io.savemat(path + '/save_data/Corr_att_' + subject + '.mat', {'corr_att': corr_S1})
        scipy.io.savemat(path + '/save_data/Corr_unatt_' + subject + '.mat', {'corr_unatt': corr_S2})

        for i in range(0,4):
            np.save(path + '/save_data/Accuracy_'+cond[i]+'_'+ subject, globals()["ACC_{}".format(cond[i])]*100)
            scipy.io.savemat(path + '/save_data/Accuracy_' + cond[i] + '_' + subject+'.mat', {'Acc_'+cond[i]: globals()["ACC_{}".format(cond[i])]*100})
        #np.save(path + '/save_data/Answer_' + subject, Answer)

        # Format current trial
        tr = tr + 1
        z = 1
        # ------------------ comment about next session ---------------------#
        Comments(tr, path, screen, original)

#################################################################################################
#                                       EXPERIMENT FINISH                                       #
#################################################################################################

# END
print("The End")
final = visual.TextStim(screen, text="실험이 종료되었습니다. \n\n감사합니다!", height=40, color=[1, 1, 1], wrapWidth=1000)
final.draw()
screen.flip()
time.sleep(3)

# Total accuracy
print("\n===================================\n")
print("=== Total Accuracy = {0}% ===".format(np.mean(ACC)*100))
print("MCL Accuracy = {0}%".format(np.mean(ACC_MCL) * 100))
print("-20dB Accuracy = {0}%".format(np.mean(ACC_20) * 100))
print("90 % Accuracy = {0}%".format(np.mean(ACC_90) * 100))
print("SRT % Accuracy = {0}%".format(np.mean(ACC_SRT) * 100))
print("\n===================================\n")

port.close()
screen.close()
board.stop_stream()
board.release_session()
