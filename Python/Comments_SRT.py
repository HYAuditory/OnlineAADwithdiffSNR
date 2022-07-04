from psychopy import visual, core, event
import pandas as pd
import time
import numpy as np

correct = []
answer = []

def practice_1(p, path, screen):
    print("practice")
    file = pd.read_excel(path + "/Excel_SRT//prePractice_SRT.xlsx")

    if p == 0:
        text = visual.TextStim(screen, text = "<<<", height=150, color=[1, 1, 1], wrapWidth=1500)
        text.draw()
        screen.flip()
        time.sleep(18)
    if p == 1:
        text = visual.TextStim(screen, text=">>>", height=150, color=[1, 1, 1], wrapWidth=1500)
        text.draw()
        screen.flip()
        time.sleep(18)

    # Question 1
    text = visual.TextStim(screen, text = file.tweenty_Q1_practice[p], height=38, color=[1, 1, 1], wrapWidth=1000)
    text.draw()
    screen.flip()

    key1 = event.waitKeys(keyList=['1', '2', '3', '4'], clearEvents=True)
    if int(key1[0]) == file.tweenty_A1_practice[p]:
        print("True")
    else:
        print("False")

    # Question 2
    text = visual.TextStim(screen, text = file.journey_Q1_practice[p], height=38, color=[1, 1, 1], wrapWidth=1000)
    text.draw()
    screen.flip()

    key2 = event.waitKeys(keyList=['1', '2', '3', '4'], clearEvents=True)
    if int(key2[0]) == file.journey_A1_practice[p]:
        print("True")
    else:
        print("False")

    text = visual.TextStim(screen, text = "+", height=150, color=[1, 1, 1], wrapWidth=1500)
    text.draw()
    screen.flip()
    time.sleep(0.5)

def practice_2(p, path, screen):
    print("practice2_{}".format(p+1))
    file = pd.read_excel(path + "/Excel_SRT/prePractice_SRT.xlsx")

    if p < 2:
        text = visual.TextStim(screen, text = "<<<", height=150, color=[1, 1, 1], wrapWidth=1500)
        text.draw()
        screen.flip()
        time.sleep(18)

    elif p >= 2:
        text = visual.TextStim(screen, text=">>>", height=150, color=[1, 1, 1], wrapWidth=1500)
        text.draw()
        screen.flip()
        time.sleep(18)

    # Question 1
    text = visual.TextStim(screen, text = file.SAT2_Q1_practice[p], height=38, color=[1, 1, 1], wrapWidth=1000)
    text.draw()
    screen.flip()

    # Respond
    key1 = event.waitKeys(keyList=['1', '2', '3', '4'], clearEvents=True)
    if int(key1[0]) == file.SAT2_A1_practice[p]:
        print("True")
    else:
        print("False")

    # Question 2
    text = visual.TextStim(screen, text = file.SAT1_Q1_practice[p], height=38, color=[1, 1, 1], wrapWidth=1000)
    text.draw()
    screen.flip()

    # Respond
    key2 = event.waitKeys(keyList=['1', '2', '3', '4'], clearEvents=True)
    if int(key2[0]) == file.SAT1_A1_practice[p]:
        print("True")
    else:
        print("False")

    # Self-Report
    text = visual.TextStim(screen, text = file.Self_report[0], height=40, color=[1, 1, 1], wrapWidth=1000)
    text.draw()
    screen.flip()

    # Self-Report Respond
    key2 = event.waitKeys(keyList=['1', '2', '3', '4','5'], clearEvents=True)
    print("Respond = {}".format(key2))

    text = visual.TextStim(screen, text = "+", height=150, color=[1, 1, 1], wrapWidth=1500)
    text.draw()
    screen.flip()
    time.sleep(0.5)

def Question(j, tr, path, screen):
    correct = []
    answer = []
    self_answer = []
    respt = []
    file = pd.read_excel(path + "/Excel_SRT/question_AAK.xlsx")
    file2 = pd.read_excel(path + "/Excel_SRT/question_SAT.xlsx")
    size = 38


    if tr+1 <= 14:  # train - part 1
        try :
            # Question 1
            text3 = visual.TextStim(screen, text = file.tweenty_Q1[j], height=size, color=[1, 1, 1], wrapWidth=1000)
            text3.draw()
            screen.flip()
            key = event.waitKeys(keyList=['1', '2', '3', '4'], clearEvents=True)

            answer.append(key)
            if file.tweenty_A1[j] == int(key[0]):
                correct.append("T")
                print("True")
            else:
                correct.append("F")
                print("False")

            # Question 2
            text3 = visual.TextStim(screen, text = file.tweenty_Q2[j], height=size, color=[1, 1, 1], wrapWidth=1000)
            text3.draw()
            screen.flip()
            key = event.waitKeys(keyList=['1', '2', '3', '4'], clearEvents=True)

            answer.append(key)
            if file.tweenty_A2[j] == int(key[0]):
                correct.append("T")
                print("True")
            else:
                correct.append("F")
                print("False")

            # Question 3
            text3 = visual.TextStim(screen, text = file.journey_Q1[j], height=size, color=[1, 1, 1], wrapWidth=1000)
            text3.draw()
            screen.flip()
            key = event.waitKeys(keyList=['1', '2', '3', '4'], clearEvents=True)

            answer.append(key)
            if file.journey_A1[j] == int(key[0]):
                correct.append("T")
                print("True")
            else:
                correct.append("F")
                print("False")

            # Question 4
            text3 = visual.TextStim(screen, text = file.journey_Q2[j], height=size, color=[1, 1, 1], wrapWidth=1000)
            text3.draw()
            screen.flip()
            key = event.waitKeys(keyList=['1', '2', '3', '4'], clearEvents=True)

            answer.append(key)
            if file.journey_A2[j] == int(key[0]):
                correct.append("T")
                print("True")
            else:
                correct.append("F")
                print("False")
        except:
            correct.append("N")

    else: # test - part2
        try:
            # Question 1
            text3 = visual.TextStim(screen, text=file2.SAT130_Q1[j], height=size, color=[1, 1, 1], wrapWidth=1000)
            text3.draw()
            screen.flip()
            Q1_on = time.perf_counter()
            key = event.waitKeys(keyList=['1', '2', '3', '4'], clearEvents=True)
            Q1_off = time.perf_counter()

            answer.append(key)
            if file2.SAT130_A1[j] == int(key[0]):
                correct.append("T")
                print("True")
            else:
                correct.append("F")
                print("False")

            # Question 2
            text3 = visual.TextStim(screen, text=file2.SAT130_Q2[j], height=size, color=[1, 1, 1], wrapWidth=1000)
            text3.draw()
            screen.flip()
            Q2_on = time.perf_counter()
            key = event.waitKeys(keyList=['1', '2', '3', '4'], clearEvents=True)
            Q2_off = time.perf_counter()

            answer.append(key)
            if file2.SAT130_A2[j] == int(key[0]):
                correct.append("T")
                print("True")
            else:
                correct.append("F")
                print("False")

            # Question 3
            text3 = visual.TextStim(screen, text=file2.SAT3160_Q1[j], height=size, color=[1, 1, 1], wrapWidth=1000)
            text3.draw()
            screen.flip()
            Q3_on = time.perf_counter()
            key = event.waitKeys(keyList=['1', '2', '3', '4'], clearEvents=True)
            Q3_off = time.perf_counter()

            answer.append(key)
            if file2.SAT3160_A1[j] == int(key[0]):
                correct.append("T")
                print("True")
            else:
                correct.append("F")
                print("False")

            # Question 4
            text3 = visual.TextStim(screen, text=file2.SAT3160_Q2[j], height=size, color=[1, 1, 1], wrapWidth=1000)
            text3.draw()
            screen.flip()
            Q4_on = time.perf_counter()
            key = event.waitKeys(keyList=['1', '2', '3', '4'], clearEvents=True)
            Q4_off = time.perf_counter()

            answer.append(key)
            if file2.SAT3160_A2[j] == int(key[0]):
                correct.append("T")
                print("True")
            else:
                correct.append("F")
                print("False")

            respt.append([(Q1_off-Q1_on), (Q2_off-Q2_on), (Q3_off-Q3_on), (Q4_off-Q4_on)])

            # Self-Report
            text3 = visual.TextStim(screen, text=file2.SAT_Self[0], height=size, color=[1, 1, 1], wrapWidth=1000)
            text3.draw()
            screen.flip()
            key = event.waitKeys(keyList=['1', '2', '3', '4', '5'], clearEvents=True)

            self_answer.append(key)
            print("Respond = {}".format(key))

        except:
            correct.append("N")


    # Interval
    text = visual.TextStim(screen, text=" + ", height=150, color=[1, 1, 1], wrapWidth=2000)
    text.draw()
    screen.flip()

    return correct, answer, self_answer, respt

def Comments(tr,path, screen, ori):
    n = []

    if ori == 'L':
        file_2 = pd.read_excel(path + "/Excel_SRT/Comments_SRT_L.xlsx")
    elif ori == 'R':
        file_2 = pd.read_excel(path + "/Excel_SRT/Comments_SRT_R.xlsx")

    text2 = visual.TextStim(screen, text="'스페이스 바' 를 누르시면 다음 페이지로 넘어갑니다.", pos=(0, -300), height=33,
                            color=[1, 1, 1], wrapWidth=1500)
    size = 35
    width = 1000

    try:
        # Comment
        for i in range(0,15):

            if tr == 'intro':
                print("Intro")
                text = visual.TextStim(screen, text=file_2.intro[i], height=size, color=[1, 1, 1], wrapWidth=width)
                n = file_2.intro[i]

            elif tr == 'practice':
                text = visual.TextStim(screen, text=file_2.practice[i], height=size, color=[1, 1, 1], wrapWidth=width)
                n = file_2.practice[i]

            elif tr+1 == 1:     # Train Session 1
                print("Train Seession 1")
                text = visual.TextStim(screen, text=file_2.train1[i], height=size, color=[1, 1, 1], wrapWidth=width)
                n = file_2.train1[i]

            elif tr == 7:     # Train Session 2
                print("Train Seession 2")
                text = visual.TextStim(screen, text=file_2.train2[i], height=size, color=[1, 1, 1], wrapWidth=width)
                n = file_2.train2[i]

            elif tr == 14:    # Test session 1
                print("Test session 1")
                text = visual.TextStim(screen, text=file_2.test1[i], height=size, color=[1, 1, 1], wrapWidth=width)
                n = file_2.test1[i]

            elif tr == 22:    # Test session 2
                print("Test session 2")
                text = visual.TextStim(screen, text=file_2.test2[i], height=size, color=[1, 1, 1], wrapWidth=width)
                n = file_2.test2[i]

            elif tr == 30:    # Test session 3
                print("Test session 3")
                text = visual.TextStim(screen, text=file_2.test3[i], height=size, color=[1, 1, 1], wrapWidth=width)
                n = file_2.test3[i]
                text2 = visual.TextStim(screen, text="", pos=(0, -330), height=33,
                                        color=[1, 1, 1], wrapWidth=1500)
            elif tr == 37:    # Test session 4
                print("Test session 4")
                text = visual.TextStim(screen, text=file_2.test4[i], height=size, color=[1, 1, 1], wrapWidth=width)
                n = file_2.test4[i]
                text2 = visual.TextStim(screen, text="", pos=(0, -330), height=33,
                                        color=[1, 1, 1], wrapWidth=1500)
            try:
                np.isnan(n)
                break
            except:
                text2.draw()
                text.draw()
                screen.flip()

            key = event.waitKeys(keyList=["space", "escape"], clearEvents=True)
            if key == ["escape"]:
                core.quit()
    except:
        pass

