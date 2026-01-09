# NipponQuest_FPGAgame
Nippon Quest is a VGA-based video game in which the player controls a character represented by a 50×50 pixel square moving across a series of horizontal platforms.
The objective is to jump from one platform to another while avoiding the gaps between them. The vertical movement of the character is controlled by the player’s voice.

The name Nippon Quest (meaning “Japan Quest”) originates from a passion for Japan and from inspiration taken from a Japanese video game with similar mechanics.

## Board
Nexys 4 DDR

## Gameplay Mechanics

The character moves exclusively along the y-axis. It cannot fall below the platforms and cannot touch the upper edge of the screen.

Two processes manage the movement:
- The first determines the direction of movement (up or down).
- The second performs the actual movement based on the implemented logic.

The character’s vertical movement depends on the volume of the voice captured by the microphone:
- A louder voice causes the character to rise faster.
- A very weak voice causes the character to descend or remain stationary on the platforms.
- If the character reaches the top edge of the screen, the game ends (game over).

## Platform System

The platforms are rectangular blocks stored in an array. In one process, the five platforms currently visible on screen are selected and moved from right to left using a for loop.

To simplify the initial phase of the game, the first five platforms are connected and have the same size, allowing the player time to prepare. The platform positions are updated whenever frame_count ≥ 500000 clock cycles, corresponding to the VGA signal frequency.

As the score increases, the platforms move at four progressively faster speeds, making the game increasingly challenging.

An alternative approach for platform generation would have involved using a pseudo-random function within the testbench to determine platform lengths. This solution was discarded because it would require re-running synthesis (a time-consuming operation) every time the pattern changed. With that approach, platform layout and length would remain fixed within a single synthesis.

## Voice Control and Microphone

The microphone operates at a frequency of 2.4 MHz and is managed by a finite state machine.
The captured voice volume directly affects the vertical motion of the character, enabling hands-free gameplay.

## Scoring System

The game includes a score displayed on a seven-segment display.
The score is also used to adjust the platform speed:
- The score increases only when the character is in contact with the platforms.
- If the character is airborne, the score is frozen.

## VGA Output

The game is displayed through a VGA connector, operating at a clock frequency of 500,000 cycles (half of the game’s system clock).

The text “Nippon Quest” and the “Game Over” message are stored in a ROM and rendered on screen.
Within the VGA process, the following elements are managed:
- Colors and positions of on-screen text
- A red circle in the background
- Platforms
- Player character

## Contributors
- maya.donofrio@studenti.unitn.it




