alias getSshFingerprint='ssh-keygen -E md5 -lf ~/.ssh/id_rsa.pub'

# Git account management
export GIT_ACCOUNT="null"
export WORK_EMAIL=""
export PERSONAL_EMAIL=""
# TODO: dynamically configure multiple accounts
export GITHUB_TOKEN=""

checkGit() {
	EMAIL="$(grep -io '[A-Z0-9._%+-]\+@[A-Z0-9.-]\+\.[A-Z]\{2,4\}' ~/.ssh/id_rsa.pub)"
    if [ $EMAIL = $PERSONAL_EMAIL ]; then
        export GIT_ACCOUNT="personal"
		echo "Current git account: Personal"
	elif [ $EMAIL = $WORK_EMAIL ]; then
		export GIT_ACCOUNT="work"
		echo "Current git account: Work"
    fi
}
gitPersonal() {
	checkGit

    if [ $GIT_ACCOUNT = "work" ]; then
        echo "Switching to personal"
        ssh-add -D

        mkdir -p ~/.ssh/backup
        mv ~/.ssh/id_rsa ~/.ssh/backup/work
        mv ~/.ssh/id_rsa.pub ~/.ssh/backup/work.pub

        mv ~/.ssh/backup/personal ~/.ssh/id_rsa
        mv ~/.ssh/backup/personal.pub ~/.ssh/id_rsa.pub

        git config --global user.email $PERSONAL_EMAIL

        eval "$(ssh-agent -s)"

        ssh-add -K ~/.ssh/id_rsa
        if [ $? -eq 0 ]; then
            echo "Successfully added personal key"

            ssh -T git@github.com
            if [ $? -eq 1 ]; then
                echo "Successfully auth'd to personal Github"

                export GIT_ACCOUNT="personal"
                echo "Now using personal git account"
            else
                echo "Error authing to personal Github"
                gitWork # Switch back
            fi
        else
            echo "Error adding key"
            gitWork # Switch back
        fi
    elif [ $GIT_ACCOUNT = "personal" ]; then
        echo "Already using personal account."
    else
        echo "GIT_ACCOUNT set improperly"
    fi
}
gitWork() {
	checkGit

	if [ $GIT_ACCOUNT = "personal" ]; then
        echo "Switching to work"
		ssh-add -D
        
        mkdir -p ~/.ssh/backup
		mv ~/.ssh/id_rsa ~/.ssh/backup/personal
		mv ~/.ssh/id_rsa.pub ~/.ssh/backup/personal.pub

		mv ~/.ssh/backup/work ~/.ssh/id_rsa
		mv ~/.ssh/backup/work.pub ~/.ssh/id_rsa.pub

		git config --global user.email $WORK_EMAIL

		eval "$(ssh-agent -s)"
		
        ssh-add -K ~/.ssh/id_rsa
        if [ $? -eq 0 ]; then
            echo "Successfully added work key"

            ssh -T git@github.com
            if [ $? -eq 1 ]; then
                echo "Successfully auth'd to work Github"
                
                export GIT_ACCOUNT="work"
                echo "Now using work git account"
            else
                echo "Error authing to work Github"
                gitPersonal # Switch back
            fi
        else
            echo "Error adding key"
            gitPersonal # Switch back
        fi
	elif [ $GIT_ACCOUNT = "work" ]; then
		echo "Already using work account."
	else
		echo "GIT_ACCOUNT set improperly"
	fi
}

