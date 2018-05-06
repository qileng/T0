T0
------------------------------------------------
https://guides.github.com/introduction/flow/<br/>

Team Account Info:
1. Gmail: teamzeroT0@gmail.com </br>
Password: unX-DQ2-mA4-buZ

2. Apple Account: teamzeroT0@gmail.com </br>
Password: unX-DQ2-mA4-buZ </br>
Security Questions: </br>
Q: What is first film you saw in theatre? </br>
A: Gary </br>
Q: What is your dream job? </br>
A: Gillespie </br>
Q: In what city did your parents first meet? </br>
A: Gary Gillespie </br>


Basic Git Workflow <br/>
1. Create new branch </br>
2. Make changes</br>
3. Review&merge onto master</br>
	Please never push directly to master.
	
Git Integration with Xcode9 <br/>
1. Choose "Clone an existing project" at startup.<br/>
2. Follow instructions to enter URL, your github account information, and location. <br/>
3. Now the project window should display. If not, open HALP.xcodeproj. <br/> 
4. Hit command+2 or click the second icon in the nav bar in top left.<br/>
5. Then you can create a new branch by right-clicking master. <br/>
6. After you're done with editing, hit option+command+C or in the toolbar, go to Source Control->Commit. <br/>
7. Commit screen is really straight-forward, you have the option to push to a remote branch at the time. It automatically set up everything for you. <br/>
8. If you see a folder xcuserdata/ in the commit screen, don't select that. It's completely private settings and I added it in git ignore but xcode still shows a checkbox right next to it.
9. Remember to update your working branch before you start working on something. <br/>
10. First, hit option+command+X or in the toolbar, go to Source Control->Pull and select origin/master when prompted. This will pull master from github.
11. Then in Source Control Navigator, right-click local master, and select merge `master` into `<working branch>`.

Run the App on your device <br/>
1. Log into shared Apple ID, which we don't have one now.
2. Click on the project icon from the left column and select that account in signing->team. 
3. Connect your device.
4. From the top of project window, use the dropdown list to select your device. It should be right next to the run and stop button.
5. Hit run.
6. It may say something like "your iphone is busy, preparing debugger tools". If that happens, follow https://stackoverflow.com/questions/46316373/xcode-9-iphone-is-busy-preparing-debugger-support-for-iphone
7. After Xcode installs the app, go to Setting->General->Device Management->Some Apple ID and trust it.

Useful functionality on Github.com:
1. In the Issues tab, you can find a list of current issues. If you decide to work on one, please assign the issue to yourself by clicking on that issue and edit the assignees on the right. After that, you can go to project tab and move the corresponding issue into "In progress" tab so that others know you're currently working on it.
2. When you submit a new pull request, besides describing what you did, you can also add "resolve #xx" in comments. By doing this, your pull request will automatically be linked with issue #xx. The linked issue will be automatically solved when your pull request be merged.
3. You can check out the overview of our project in the project tab. You can find all issues we currently have and their status here. 
4. You can add new issues at any time. Try to be specific and try to label your issues. You can also add "help wanted" label to your issue if you need any help.





Using command line: <br/>

Setting up <br/>
1. Once in your prefered directory </br>
	`git init`</br>
	`git remote add origin https://github.com/qileng/T0.git `</br>
	`git pull origin master`</br>
2. Alternatively, without creating a new directory </br>
	`git clone https://github.com/qileng/T0.git`</br>


Branching <br/>
1. Create a new branch</br>
	`git branch foo`</br>
2. Switch to a specific branch</br>
	`git checkout foo`</br>
3. Check all of your branches and which one you are currently on
	`git branch`</br>
4. After you commit new changes to your local branch, push it to github as a
	new remote branch</br>
	`git push -u origin foo`</br>
		After the first time `$git push origin foo`</br>
5. Then go to Github page https://github.com/qileng/T0. Click on `branches`, click `new pull request` under your branch to make a new 
	pull request.</br>
6. Ideally, if there's no conflict, it can then be simply merged by clicking
	the merge button.

Collaboration <br/>
1. If you work with someone else in the same branch, make sure you pull everytime before you start. <br/>
	`git checkout <branch>` Make sure you're in your working branch </br>
	`git pull origin/master` This will fetch every branch from Github </br>
2. If you want to pull someone's branch for the first time <br/>
	`git branch <branch>` </br>
	`git branch -u origin/<branch>` This links your local branch with the branch in github</br>
	`git pull`</br>
3. Avoid editing the same part of code at the same time. I'm not sure if manually solve conflict is the only way when auto-merge fails. <br/>

	

