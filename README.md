# T0      [![Build Status](https://travis-ci.org/qileng/T0.svg?branch=TESTING)](https://travis-ci.org/qileng/T0)
## HALP
------------------------------------------------

### Team Account Info:

Apple Account: halptest0@gmail.com </br>
Password: unX-DQ2-mA4-buZ </br>

### Installation Requirement:
1. Xcode 9.3 or higher.
2. iOS 11.3 or higher (Guaranteed on simulator if Xcode 9.3 or higher installed).
3. Internet Connection required for logging into test account and signing up.

### Installation Instructions:
1. Visit `https://github.com/qileng/T0/releases`
2. Download source code zip of newest release.
3. Unzip and put the folder into desired destination.
4. Use `Xcode` to open `<Destination>/T0/HALP/HALP.xcodeproj`.

### Running Instruction:

#### It is suggested to run the App on actual iPhone if you have `iPhone 8`, `iPhone 7`, or `iPhone 6s` for smoother experience. 
#### All testcases should be run sequentially, and all workflows should be executed before the alternative workflows.

#### 1. Run the App on simulator<br/>
1. From top-left corner of the Xcode window, You will see `HALP>Some Device` right next to `Run` and `Stop`.
2. Click the device button, from the drop-down menu, choose `iPhone 8`.
3. Click run.
4. Wait for simulator to boot and app will automatically launch after the simulator boots. Click `Allow` when asked for approval of notifications.


#### 2. Run the App on your device (iPhone 8 or same size device including iPhone 7&6s)<br/>
1. Log into the above shared Apple ID from Xcode Menu Bar: `Xcode`->`Preference`->`Account`->`+`->`Apple ID`.
2. Connect your iPhone with your mac.
3. From Xcode Menu Bar: `Window`->`Devices and Simulators`.
4. If you see a yellow warning says "XXX is not paired with your computer", go ahead and click `Trust` on your iPhone.
5. Enter passcode on your iPhone.
6. You will see a yellow warning ways "Preparing debugger support for XXX". Patiently wait for around 10 minutes until the warning goes away.
7. From the top-left corner of Xcode window, use the dropdown list to select your device. It should be right next to the run and stop button.
8. Click the blue `HALP` project file on the very top of file explorer.
9. In `General`->`Signing`->`Team`, use drop down menu to select `Team Zero(Personal Team)`.
10. Hit run.
11. After Xcode installs the app, a warning will prompt. Proceed and go to `Setting`->`General`->`Device Management`->`Some Apple ID` and `Trust` it.
12. Hit run again, app will automatically launch. Click `Allow` when asked for approval of notifications.


#### 3. In case the App crashes, click `Run` again to restart the App.

### Known Bugs:
1. If you swipe too fast into and out of Clock View, the application tends to crash.
2. Animation on certain pages will mess up if swiping between pages stops before it completes. This is caused by a iOS bug which certain system functions will not be called properly. This is commonly caused by gesture lag on simulator but is very rare on actual iPhone.
3. The circular gradient background of clock face in Clock View does not go away when task detail page pops up. This bug only happens on rare occasions. The cause of this bug is unknown.
4. Database saving method sometimes adds extra whitespace at the end of the Task Description field, which causes the system to treat blank description as valid input and a display blank message in List View.
5. When a dynamic task is rescheduled, it will appear as a fixed task in system.
6. When the user creates a new task with the Start Time toggle off, and then later edits the same task with the Start Time toggle on, the application does not set this new start time correctly across all pages. It sets the Start Time to a default 12AM and does not change. 
7. When using an iPhone with a size other than iPhone 8, the clock background in ClockView is not centralized when the application first starts up. It then resizes itself later while using the application. This is due to a constraint error.
8. When using an iPhone with a size other than iPhone 8, the bubble icons in Clock View do not align correctly. Once again, this is due to a constraint error.
9. Currently, the user can swipe out of the Task Edit Page on List View onto Clock View/Setting Page. This is more of an inconvenience than a bug.


#### 4. Test Accounts.
Test Account #1 (To be created in TUC#1):</br>
Username: user1@test.com</br>
Password: 12345678</br>

Test Account #2:</br>
Username: user2@test.com</br>
Password: 12345678</br>

Test Account #3:</br>
Username: user3@test.com</br>
Password: 12345678</br>

Test Account #4:</br>
Username: user4@test.com</br>
Password: 12345678</br>

Test Account #5:</br>
Username: user5@test.com</br>
Password: 12345678</br>

#### 5. Technical Points of Contact.
Person 1: </br>
Name: Haozhi "Flik" Hu (Software Development Lead)</br> 
Phone: +1 (858) 666-5270 </br>
E-mail: hah045@ucsd.edu </br>

Person 2: </br>
Name: Tianyi Wu (Database Specialist)</br>
Phone: +1 (858) 265-7002 </br>
E-mail: tiw206@ucsd.edu </br>
