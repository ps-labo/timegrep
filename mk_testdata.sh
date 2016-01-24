#!/bin/bash

declare -A ampm_lang
declare -A datetime_format_lang_c
declare -A datetime_format_ampm

ampm_lang=(
	["Linux"]=es_VE
	["Darwin"]=en_GB
)

datetime_format_lang_c=(
		 [0]='+%d/%b/%Y:%H:%M:%S %z'
		 [1]='+%d/%m/%Y:%H:%M:%S'
		 [2]='+%d/%b/%Y:%H:%M:%S'
		 [3]='+%d/%b/%Y %H:%M:%S %z'
		 [4]='+%d/%m/%Y %H:%M:%S'
		 [5]='+%d/%b/%Y %H:%M:%S'
		 [6]='+%m %d, %Y %H:%M:%S'

		 [7]='+%m %d, %Y %l:%M:%S %p'
		 [8]='+%b %d, %Y %l:%M:%S %p'

		 [9]='+%m %d, %Y %I:%M:%S %p'
		[10]='+%b %d, %Y %I:%M:%S %p'

		[11]='+%d/%b/%Y:%H:%M:%S %z'
		[14]='+%d/%b/%Y %H:%M:%S %z'

		[12]='+%d/%m/%Y:%H:%M:%S'
		[13]='+%d/%b/%Y:%H:%M:%S'
		[15]='+%d/%m/%Y %H:%M:%S'
		[16]='+%d/%b/%Y %H:%M:%S'
		[22]='+%Y/%m/%d %H:%M:%S'
		[23]='+%Y-%m-%d %H:%M:%S'
		[24]='+%Y/%m/%dT%H:%M:%S'
		[25]='+%Y-%m-%dT%H:%M:%S'
		[26]='+%a %b %d %H:%M:%S %Y'
		[27]=''
)

datetime_format_lang_ampm=(
		[0]=+'%m %d, %Y %l:%M:%S %p'
		[1]=+'%m %d, %Y %I:%M:%S %p'
)

testdata_num=0

main() {

	now=$( date +"%s" )

	# 今日より２日前の日時
	start=$(( now - 86400 * 2 ))

	for i in ${!datetime_format_lang_c[@]} ; do
		testdata_num=$(( testdata_num + 1 ))
		cp -p /dev/null testdata.${testdata_num}

		datetime_format=${datetime_format_lang_c[${i}]}
		for datetime in $( seq ${start} 60 ${now} ) ; do
			(
				export LANG=C
				if [ "${datetime_format}" == "" ]; then
					datetime_string=$( date --date "@${datetime}" )
				else
					datetime_string=$( date --date "@${datetime}" "${datetime_format}" )
				fi

				left=$(( now - datetime ))
				echo -en "${start} -> ${datetime} -> ${now}, left ${left}, ${datetime_string} ${datetime_format} \r" > /dev/stderr
				echo "${datetime_string}" >> testdata.${testdata_num}
			)

		done

		echo "" > /dev/stderr
	done

	for i in ${!datetime_format_lang_ampm[@]} ; do
		testdata_num=$(( testdata_num + 1 ))
		cp -p /dev/null testdata.${testdata_num}

		datetime_format=${datetime_format_lang_ampm[${i}]}
		for datetime in $( seq ${start} 60 ${now} ) ; do
			(
				export LANG=${ampm_lang["$(uname)"]}
				datetime_string=$( date --date "@${datetime}" "${datetime_format}" )

				left=$(( now - datetime ))
				echo -en "${start} -> ${datetime} -> ${now}, left ${left}, ${datetime_string} ${datetime_format} \r" > /dev/stderr
				echo "${datetime_string}" >> testdata.${testdata_num}
			)
		done
		echo "" > /dev/stderr
	done

		testdata_num=$(( testdata_num + 1 ))
		cp -p /dev/null testdata.${testdata_num}
		for datetime in $( seq ${start} 60 ${now} ) ; do
			(
				export LANG=ja_JP.utf8
				datetime_string=$( date --date "@${datetime}" )

				left=$(( now - datetime ))
				echo -en "${start} -> ${datetime} -> ${now}, left ${left}, ${datetime_string} ${datetime_format} \r" > /dev/stderr
				echo "${datetime_string}" >> testdata.${testdata_num}
			)
		done
		echo "" > /dev/stderr
}


#        13/Nov/2012:13:20:07 +0900 ( like as apache format )
#        13/11/2012 13:20:07
#        13/11/2012:13:20:07
#        11 13, 2012 13:20:07
#        11 13, 2012 01:20:07 pm
#        11 13, 2012 01:20:07 PM
#        2012/11/13 13:20:07
#        2012年 11月13日 火曜日 13時20分07秒 JST
#        Tue Nov 13 13:20:07 JST 2012
#        1352780407

main "$@"
