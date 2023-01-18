#!/usr/bin/env bash

SCRIPT_DIR=$(dirname $(realpath $0))
WRITING_DIR=${SCRIPT_DIR/\/.writing/}

####### defaults #########
YAML=$SCRIPT_DIR/frontmatter.yml
OUTPUT_FORMAT=docx
TEMPLATE=md2long.sh
SCENE_BREAK="\n\n### #\n\n"
LINE_BREAK="\n"

####### options #########
while getopts "hy:esf:" opt; do
  case $opt in
    y) YAML=$OPTARG ;;
    e) OUTPUT_FORMAT=epub ;;
    s) TEMPLATE=md2short.sh ;;
    f) OUTPUT_FORMAT=$OPTARG ;;
    h) echo "USAGE: compile [-y frontmatter.yml ] [ -e | -f format ] FILE.msk" ;;
  esac
done
shift $((OPTIND-1))
msk=$1

echo -e "*********** compiling *******************\033[19D$msk "

chapter() {
  dir=$1
  if [[ $(egrep -c "^compile: *0$" $dir/folder.txt) -eq 0 ]]; then
    chaptitle=$(cat $dir/folder.txt | egrep "^title:" | sed 's/^title: *//g')
    chapsubtitle=$(cat $dir/folder.txt | egrep "^summarySentence:" | sed 's/^summarySentence: *//g')
    echo "# $chaptitle  -  $chapsubtitle"
    for md in $dir/*.md; do
      if [[ $(egrep -c "^compile: *0$" $md) -eq 0 ]]; then
        start=$(( $(egrep -n -m1 '^$' $md | cut -d: -f1) + 2 ))
        echo >> $md
        tail -n +$start $md | while read line; do echo "$line"; echo -ne $LINE_BREAK; done
        echo -ne $SCENE_BREAK
      fi
    done
  fi
}

dir2md() {
  shortbooktitle=$(cat $1/infos.txt | egrep "^Title:" | sed 's/^Title: *//g')
  booktitle=$(cat $1/infos.txt | egrep "^Subtitle:" | sed 's/^Subtitle: *//g')
  compiled_md=$(mktemp /tmp/XXXXXXXX.md)
  cat $YAML | sed "s/^title:\ .*$/title: \"$shortbooktitle\"/g; s/^short_title:\ .*$/short_title: \"$shortbooktitle\"/g" > $compiled_md
  for dir in $1/outline/*; do
    if [[ -d $dir ]]; then
      chapter $dir >> $compiled_md
    fi
  done
  echo "*********** markdown compiled ***********"
}

compile() {
  if [[ -f $msk ]]; then
    if [[ $(cat $msk | wc -c) -eq 1 ]]; then
      dir2md ${msk%\.*}
    else
      #unzip the msk
      unzipped_dir=$(mktemp -d /tmp/XXXXXXXX)
      unzip -qou "$msk" -d $unzipped_dir
      dir2md $unzipped_dir
      rm -rf $unzipped_dir
    fi
  elif [[ -d $msk && -f $msk/infos.txt ]]; then
    dir2md $msk
  else
    echo No book specified
    exit
  fi
}

###### main ###########
case $OUTPUT_FORMAT in
  docx)
    compile
    echo -en "\033[1;38;5;94m"
    $SCRIPT_DIR/pandoc-templates/bin/$TEMPLATE --output "$booktitle.$OUTPUT_FORMAT" --overwrite $compiled_md #&> /dev/null
  ;;
  epub)
    compile
    echo -en "\033[1;38;5;94m"
    pandoc --from=markdown --to=epub --css=$SCRIPT_DIR/epub.css --output="$booktitle.$OUTPUT_FORMAT" --toc $compiled_md #&> /dev/null
  ;;
  *)
    echo -e "What on Earth is a \033[1m$OUTPUT_FORMAT\033[0m?"
    echo "******* exiting because of reasons ******"
    exit 1
  ;;
esac
    echo -en "\033[1;38;5;95m"
echo "*********** pandoc finished *************"
rm $compiled_md
# echo $compiled_md
# echo $unzipped_dir
echo -e "\n\033[1m$booktitle.$OUTPUT_FORMAT\033[0m\n"
