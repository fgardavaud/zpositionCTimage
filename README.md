# Hello and welcome,

## purpose
Extract the z position of CT images for smartstep/smartview CT images (in GE CT platform) and plot an histogram with different bin to analyze if operator have been performed exposition in the same anatomical area.
By doing this you will be able to determine if the patient have been over-exposed.

## CT protocol

This program have been designed to analyze GE CT images created with smartstep/smartview protocols. In my clinical routine, smartview/smartstep images have configurated as 3 consecutive CT images.

**If your clinical protocol are different than 3 consecutive CT images, you will have to adapt a little this program from line 163 to 167**

## Images path
The CT smartstep/smartview images have to be placed in one same image folder.
To extract correctly CT images from CT scanner, Dicom Viewving solution such as [Horos](https://horosproject.org) is highly recommended. 

## Matlab system requirement
This code has been tested in Matlab v9.3  and 9.4 (2017b and 2018a annual version respectively). 
As, this code don't involve complex function it supposed to work on any recent Matlab version.

## Matlab toolbox requirement

The following toolbox is required to perform this program :

- Image processing toolbox

## Extra-function requirement

This program use uipickfile function : an extra function developed by Douglas Schwarz, included in this repo and available on this [link](https://fr.mathworks.com/matlabcentral/fileexchange/10867-uipickfiles-uigetfile-on-steroids). If you do so, export the CT images with flat folder tree option.
To be able to work correctively on the 3 main OS system, this extra function is used to replace the bug on uigetdir Matlab function (the title on the window to choose images don't appear on Linux and Mac system).

## OS platform

This code have been developed on macOS platform.
**But**, all the function are other OS platform proof. No adaptation have to be implement by the user.


The code have been exhaustively commented, as you can understand the function of every code block. If not you can e-mail me. I would try to support you the best I can.

## CT images sample

A CT images sample folder have been included in this repo. You can use this to test the program. To do so, you have to decompress the 7-zip archive with aditionnal software such as [7-zip](https://www.7-zip.org) on Windows or [keka](https://www.keka.io/en/) on macOS.

-----

Have a nice utilization and contribution.

## Authors

Francois Gardavaud
