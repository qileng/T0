T0
------------------------------------------------
https://guides.github.com/introduction/flow/<br/>

Basic Git Workflow <br/>
1. Create new branch </br>
2. Make changes</br>
3. Review&merge onto master</br>
	Please never push directly to master.
	
Git Integration with Xcode9 <br/>
	1. Choose "Clone an existing project" at startup.<br/>
	2. Follow instructions to enter URL, your github account information, and location. <br/>
	3. Open/Create a file to open the editor (I have no idea why the editor cannot be opened without a file). <br/> 
	4. Hit command+2 or in the toolbar, go to View->Navigators->Show Source Control Navigator. <br/>
	5. Then you can create a new branch by right-clicking master. <br/>
	6. After you're done with editing, hit option+command+C or in the toolbar, go to Source Control->Commit. <br/>
	7. Commit screen is really straight-forward, you have the option to push to a remote branch at the time. It automatically set up everything for you. <br/>
	8. Remember to pull everytime before you start working on something. <br/>

Miscellaneous <br/>
	1. I use tab character for indentation in this file. Although I set tab as 4 spaces in Xcode, a tab character here is still 8 spaces. It works as 4 spaces when I open it in Vim. It does seem like a whitespace in Xcode is only half the width of a whitespace in Vim. So anyway to get around that, in Preference->Text Editing->Indentation, set tab key to "insert tab character" instead of "insert whitespaces". Honestly, I don't like Xcode already. <br/>

Using command line <br/>

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
	2. If you want to pull someone's branch for the first time <br/>
	`git branch <branch>` </br>
	`git branch -u origin/<branch>` This links your local branch with the branch in github</br>
	`git pull`</br>
	3. Avoid editing the same part of code at the same time. I'm not sure if manually solve conflict is the only way when auto-merge fails. <br/>

	

