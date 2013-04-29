alias ls='ls --classify --color=auto --group-directories-first -H'
alias ll='ls -l'
alias egrep='egrep --color=auto --exclude=tags'
alias 'rmorig'='find -type f -name *.orig -exec rm -i {} \;'
alias 'rmrej'='find -type f -name *.rej -exec rm -i {} \;'
alias 'rmdotdirfiles'='find -type f -name ".directory" -exec rm -i {} \;'
alias 'open'='xdg-open'
alias 'stripWhiteSpace'='egrep -rlI " +$" * | xargs -I {} sed -i "s/ \+$//" {}'

changeChromeKey() {
    key="$1"; Key="$2";
    sed -i "s/\"$key\"/\"$Key\"/" _locales/en/messages.json;
    sed -i "s/message=\"$key\"/message=\"$Key\"/g" html/*;
    sed -i "s/tr([\"']$key[\"'])/tr(\"$Key\")/g" js/pages/*;
}

copyTheThings(){
    for i in 16 22 32 48; do
        file=/usr/share/icons/oxygen/${i}x${i}/$1;
        basename=$(basename $file);
        basename=${basename//_/-}
        cp $file layout/oxygen/${i}/${basename}
    done;
}

function checkForBadFunctions() {
    find include/classes/Functions/ -name "*php" -exec grep "static function" {} \; | \
    sed 's/ *final public static function \(.*\)(.*/\1/' | \
    grep -vi '^\(I\|IMG\)$' | \
    while read fn; do
        grep -PrniI --color --exclude=tags --exclude-dir=vendor --include=*php '(?<!(::|n |w |->|.\$))\b'$fn'\b' * ;
    done
}

function whatVersionsAreWeOn() {
    echo "Edition Stable Release Develop" | awk '{ printf("%-7s %-10s %-10s %-10s\n", $1, $2, $3, $4); }'
    awk 'BEGIN { while (a++<38) s=s "-"; print s }'

    for i in `seq 8 11`; do
        git tag | grep rel-1-$i- | awk -F- '{ printf("1.%-5s %-10s %-10s %-10s\n", '$i', "1.'$i'."$4, "1.'$i'."$4+1, "1.'$i'."$4+2); }' | sort -k2 -V | tail -1
    done
}


#find -name "*php" -exec perl -0777 -pi -e "s/( *)(\* \@param.*\n)( *\* \@return)/\1\2\1*\n\3/gm" {} \;
