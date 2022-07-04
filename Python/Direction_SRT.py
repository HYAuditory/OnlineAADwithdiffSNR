import time, serial
from psychopy import visual, core, event
import pandas as pd
import numpy as np
import time

def text(screen):
    text_R = visual.TextStim(screen, text=">>>", height=150, color=[1, 1, 1])

    text_L = visual.TextStim(screen, text="<<<", height=150, color=[1, 1, 1])

    text_c = visual.TextStim(screen, text=" + ", height=150, color=[1, 1, 1])

    return text_R, text_L, text_c

def Direction(tr, original, opposite, screen, port):
    global text_R, text_L, text_c

    text_R, text_L, text_c = text(screen)
    tr = tr+1
    # ----------------------------- Psychopy Window & Serial Write ------------------------------#
    origin = globals()['text_{}'.format(original)]
    opposite = globals()['text_{}'.format(opposite)]

    if ( tr >= 1 and tr <= 7 ) or (tr >= 15 and tr <= 18) or (tr >= 27 and tr <= 30) or (tr >= 35 and tr <= 41) :      # Represent Origin direction
        # Train 1 set               //     Test session 1 - 3       //    Test session 2 - 3                 //  Test sesstion 3 - standard / opposite

        text_c.draw()       # Draw Fixation
        screen.flip()

        # Interval
        time.sleep(0.5)

        origin.draw()      # Draw Direction
        screen.flip()

    elif ( tr >= 8 and tr <= 14 ) or (tr >= 19 and tr <= 26) or (tr >= 31 and tr <= 34) or (tr >= 42 and tr <= 44) :      # Represent Opposite direction
        # Train 2 set                //     Test 1 session - 2       //     Test 2 session - 3                  //   Test session 3 - opposite / standard

        text_c.draw()       # Draw Fixation
        screen.flip()

        # Interval
        time.sleep(0.5)

        opposite.draw()      # Draw Direction
        screen.flip()

def Direction_R(tr, original, opposite, screen, port):
    global text_R3, text_R2, text_R1, text_L3, text_L2, text_L1, text_c

    text_R3, text_R2, text_R1, text_L3, text_L2, text_L1, text_c = text(screen)

    # ----------------------------- Psychopy Window & Serial Write ------------------------------#
    origin = globals()['text_{}3'.format(original)]
    opposite = globals()['text_{}3'.format(opposite)]

    if ( tr+1 >= 1 and tr+1 <= 7 ) or (tr+1 >= 15 and tr+1 <= 18) or (tr+1 == 22 or tr+1 ==23 or tr+1 == 26) or (tr+1 == 27 or tr+1 == 30):      # Represent Origin direction
        # Train 1 set               //     Test session 1 - 3       //    Test session 2 - 3                 //  Test sesstion 3 - standard / opposite

        text_c.draw()       # Draw Fixation
        screen.flip()

        # Interval
        time.sleep(0.5)

        origin.draw()      # Draw Direction
        screen.flip()

    elif ( tr+1 >= 8 and tr+1 <= 14 ) or (tr+1 >= 19 and tr+1 <= 26) or (tr+1 == 21 or tr+1 == 24 or tr+1 == 25) or (tr+1 == 28 or tr+1 == 29):      # Represent Opposite direction
        # Train 2 set                //     Test 1 session - 2       //     Test 2 session - 3                  //   Test session 3 - opposite / standard

        text_c.draw()       # Draw Fixation
        screen.flip()

        # Interval
        time.sleep(0.5)

        opposite.draw()      # Draw Direction
        screen.flip()
