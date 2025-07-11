autoload -U colors && colors
PS1="%{$fg[yellow]%}%n%{$reset_color%}@%{$fg[yellow]%}🦬 %{$fg[yellow]%}%(5~|%-1~/.../%3~|%4~) %{$reset_color%}$ "

export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

alias crun='cargo -q run'
alias l='ls --color=always'
alias ll='l -la'

alias f='2> /dev/null find / -name '
alias fd='2> /dev/null find / -type d -name '
alias fh='2> /dev/null find . -name '
alias fhd='2> /dev/null find . -type d -name '
alias fgits='2>/dev/null find ~ -type d -maxdepth 3 -name .git'
alias ffiles='find . -type f -maxdepth'
alias fdirs='find . -type d -maxdepth'
alias fexe='2> /dev/null find . -type f -perm +111'

alias grep='grep -E --color=always'
alias rgrep='grep -r'
alias ungrep='grep -v'

alias hn='head -n'
alias tn='tail -n'
alias hor='cut -d " " -f'

gdhh() {
	git diff HEAD~"${1:-1}"..HEAD;
}

alias gc='git checkout'
alias gcm='gc main'
alias gpom='git pull origin main'
alias gull='git pull'
alias gush='git push'
alias ga='git add'
alias gcom='git commit -m'
alias gcam='git commit -am'
alias gs='git status'
alias gb='git branch'
alias gdiff='git diff'
alias gdm='git diff main'
alias gdel='git branch -d'
alias currb='git branch --show-current'
alias glog='git log | grep "[ ]{4}" | ungrep "^[ ]+$" | hn'
alias glogv='git log | hn'
alias ginitcom='gall "Initial commit"'

alias xn='xargs -n1'
alias xzsh='xargs -n1 -I% zsh -c'

alias dc='docker-compose'
alias yesterday='date -d "1 day ago"'

rep() {
	python3 -c "print('$1' * $2)"
}

cdup() {
	cd $(rep "../" $1);
}

ver() { 
	sed "$1p;d" 
}

cdto() {
	cd $(fgits | ver $1 | sed s/.git$//g);
}


gall() {
	git add .;
	git commit -m "$@";
	git push -u origin $(currb);
}

alias _getdir="rev | cut -d'/' -f 2-99 | rev"
fcd() {
	local regex="$1";
	local out=$(ffiles 8 2>/dev/null | grep $regex | _getdir);
	echo $out;

	if [ -z $out ]; then
		out=$(fdirs 8 2>/dev/null | grep $regex);
		echo $out;
	fi

	if [ -z $out ]; then 
		echo "No Matches for $regex" >&2; 
		return;
	fi

	cd $out;
}

fkit() {
	echo_red "Save a diff file to restore/preview these changes?";
	read inp;
	if [[ $inp = "y" ]]; then
		local stash_preview_file="$(currb)-$(date +'%s')"; 
		echo "Stash saved in $stash_preview_file";
		git diff > ~/stashes/"$stash_preview_file";
	fi
	git stash;
	git stash drop;
}

echo_red() {
    echo -e "\e[1;31m$@\b\e[0m"
}

## deletes the current branch gracefully.
gdelme() {
	local curr_branch=$(currb);
	if [[ "$curr_branch" = "main" ]]; then
		echo_red Cannot delete main.; 
		return;
	fi

	git checkout main;
	if [ $? -ne 0 ]; then
		echo -e "\e[1;31mCheckout failed, stash and abandon current changes?\b\e[em";
		read inp;
		if [ "$inp" = "y" ]; then
			git stash;
			git stash drop; 
			git checkout main;
		else
			echo "No deletion done."; 
			return;
		fi
	fi

	git branch -D $curr_branch;
}

syncrc() {
	cp ~/.zshrc ~/dotfiles/;
	cd ~/dotfiles/;
	git add .;
	git commit -m "sync zshrc";
	git push;
	cd -;
}
### DOWNLOAD MANAGERS I HAVE: homebrew (brew), curl, no apt-get 

alias code="~/Downloads/'Visual Studio Code.app'/Contents/Resources/app/bin/code"
