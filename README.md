Basic Git Workflow <br/>
	1. Create new branch
	2. Make changes
	3. Review&merge onto master
	$Please never push directly to master.
-------------------------------------------------
Setting up <br/>
	1. Once in your prefered directory
	$git init
	$git remote add origin https://github.com/qileng/T0.git
	$git pull origin master
	2. Alternatively, without creating a new directory
	$git clone https://github.com/qileng/T0.git

-------------------------------------------------
Branching <br/>
	1. Create a new branch
	$git branch foo
	2. Switch to a specific branch
	$git checkout foo
	3. Check all of your branches and which one you are currently on
	$git branch
	4. After you commit new changes to your local branch, push it to github as a
	new remote branch
	$git push -u origin foo
	..* After the first time $git push origin foo
	5. Then go to Github page https://github.com/qileng/T0.git to make a new 
	pull request.
	6. Ideally, if there's no conflict, it can then be simply merged by clicking
	the merge button.
