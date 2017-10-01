# Car Project
*17 June 2017*

The objective of this electrical engineering project was to design and code a small car that could follow an unbroken path of black electrical tape and turn an LED on and off when it detects a magnet under the tape.

This was a collaborative project between myself, Taasin Saquib, and Michael Zhou. <br />
We all worked on circuitry and the final report, and I primarily contributed to the introduction, "how we analyzed the test data", "how we interpreted the data", and finally the results and discussion section. <br />
I solely wrote the arduino PD code (PID but we were not required to use integration), and conducted the testing and analysis of our infrared sensors.

Final_Test.mov contains a video of part of the final test our car was judged on. The turns it makes were sharper than the day before, and we believe this to be due to the nine volt battery and the Arduino Nano's internal battery running low after a week of testing and no replacement or charging. This most likely lead to lower voltage being supplied to the LEDs and/or the photodiodes, so the readings that were being processed by the Arduino Code were off. <br />
This slight issue only subtly affected the performance of our car, as it still passed every single test it was being assessed on.
