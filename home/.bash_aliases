alias 'ls'='ls --classify --color=auto --group-directories-first -H'
alias 'll'='ls -l'
alias 'grep'='grep -P --color=auto --exclude=tags --exclude-dir=Fixtures'
alias 'rmorig'='find -type f -name *.orig -exec rm -i {} \;'
alias 'rmrej'='find -type f -name *.rej -exec rm -i {} \;'
alias 'rmdotdirfiles'='find -type f -name ".directory" -exec rm -i {} \;'
alias 'open'='xdg-open'
alias 'ack'='ack --color-match="bright_black on_bright_white" --ignore-dirs=Fixtures'
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
    find include/classes/Functions/ -name "*php" -not -name "Modules.php" -exec grep "static function" {} \; | \
    sed 's/ *final public static function \([^(]\+\)(.*/\1/' | \
    grep -vi '^(I|IMG|simpleCheckBox|getStatus|toArray|basicCheckBox|toHMS?|fromHMS?|formatTime|formatTotal|xprintf|getWorkOrders|sendOfflineEventNotices|deleteWorkOrder|addWorkOrderJob|make_max_payrolled_table|deletePayrollEvent|getWorkOrderArray|deleteWorkOrderJob|deleteCust|flushScheduler|systemCommand|adjustRangeDstUser|SimpleSelect|overtime_policy_payrolled|get_users_clock_events_for_period|extend_week_boundary_table|wwg_move_employee|get_employee_types_assoc|deleteType|getUsersScheduleForDay)$' | 
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

function whatIsLeftToTest() {
    for file in $(find include/classes/Entities/ -name "*php"); do
        file=${file/include\/classes\//};
        test=${file/.php/Test.php};
        [ -e "tests/${test}" ] || echo "We still need to make a test for ${file}";
    done;
}

# Put a new line before a @return in PHP Doc
#find -name "*php" -exec perl -0777 -pi -e "s/( *)(\* \@param.*\n)( *\* \@return)/\1\2\1*\n\3/gm" {} \;

alias 'tmux'='tmux -2'


function retag2-0-0() {
    git tag -d rel-2-0-0 && git push origin :refs/tags/rel-2-0-0 && git tag -a rel-2-0-0 -m "Tagging 2.0.0 for testing" && git push --tags
}
