T0
------------------------------------------------
https://guides.github.com/introduction/flow/<br/>

Basic Git Workflow <br/>
	1. Create new branch </br>
	2. Make changes</br>
	3. Review&merge onto master</br>
	Please never push directly to master.

Setting up <br/>
	1. Once in your prefered directory </br>
	`git init`
	`git remote add origin https://github.com/qileng/T0.git `
	`git pull origin master`
	2. Alternatively, without creating a new directory </br>
	`git clone https://github.com/qileng/T0.git`


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
	`git branch <branch> 
	`git branch -u origin/<branch>` This links your local branch with the branch in github
	`git pull`
	3. Avoid editing the same part of code at the same time. I'm not sure if manually solve conflict is the only way when auto-merge fails. <br/>
