Basic Git Workflow
	-- Create new branch
	-- Make changes
	-- Review&merge onto master

	Please never push directly to master.
-------------------------------------------------
Setting up
	-- Once in your prefered directory
	$git init
	$git remote add origin https://github.com/qileng/T0.git
	$git pull origin master
	-- Alternatively, without creating a new directory
	$git clone https://github.com/qileng/T0.git

-------------------------------------------------
Branching
	-- Create a new branch
	$git branch foo
	-- Switch to a specific branch
	$git checkout foo
	-- Check all of your branches and which one you are currently on
	$git branch
