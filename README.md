# PIC10F320 Binary Counter

A simple PIC10F320 application that counts, in binary, and shows the result
using a 8 LEDs for each bit. This project is intended to demonstrate extending
the PIC10F320's 3 output pins to 8 output pins using a shift register.

## Build and Run

To build this application, use MPLAB X IDE.

## Circuit

A shift register, [74AHC595](https://www.ti.com/lit/ds/symlink/sn74ahc595.pdf)
in this case, is connected to the three output pins of the PIC10F320. They are
connected as follows:

* `RA0` connects to `SER`
* `RA1` connects to `RCLK`
* `RA2` connects to `SRCLK`

The 8 output bytes of the shift register (`QA` through `QH`) are connected to
built-in resister LEDs which are then connected to ground.