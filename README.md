# Waterproof USB2.0 connector retrofit kit

This module provides printable versions of an amphenol IP67 USB conenctor.

This module expects threadlib to be in your openscad library path:
https://github.com/adrianschlatter/threadlib

## examples:

### A weatherproofing cap
Matches [Amphenol UA-20BFMM-SL7A01](https://octopart.com/ua-20bfmm-sl7a01-amphenol+ltw-81787340)

```
use <waterproof_usb.scad>
cap();

```
![a weather cap](/images/socket_cap.png)


### An enclosure
replaces the overmoulding of a USB extension cable [jaycar XC4124](https://www.jaycar.com.au/20m-usb-extension-cable/p/XC4124)

```
use <waterproof_usb.scad>
repeater_case();

```
![an enclosure](/images/case_v1.png)


