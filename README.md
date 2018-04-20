T0
------------------------------------------------

Basic Git Workflow <br/>
	1. Create new branch </br>
	2. Make changes</br>
	3. Review&merge onto master</br>
	Please never push directly to master.

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
