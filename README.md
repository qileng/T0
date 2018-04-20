Basic Git Workflow <br/>
	-- Create new branch__
	-- Make changes__
	-- Review&merge onto master__
	Please never push directly to master.__
-------------------------------------------------
Setting up <br/>
	-- Once in your prefered directory__
	$git init
	$git remote add origin https://github.com/qileng/T0.git
	$git pull origin master
	-- Alternatively, without creating a new directory__
	$git clone https://github.com/qileng/T0.git

-------------------------------------------------
Branching <br/>
	-- Create a new branch
	$git branch foo
	-- Switch to a specific branch
	$git checkout foo
	-- Check all of your branches and which one you are currently on
	$git branch
	-- After you commit new changes to your local branch, push it to github as a
	new remote branch
	$git push -u origin foo
	-- Then go to Github page https://github.com/qileng/T0.git to make a new 
	pull request.
	-- Ideally, if there's no conflict, it can then be simply merged by clicking
	the merge button.
