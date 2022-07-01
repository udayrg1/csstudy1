menu_choice=""
record_file="inventory.txt"
temp_file=/tmp/ldb.$$
touch $temp_file; chmod 644 $temp_file
trap 'rm -f $temp_file' EXIT


get_return(){
echo 'Press return'
read x
return 0
}

get_confirm(){
echo 'Are you sure?'
while true
do
  read x
  case "$x" in
      y|yes|Y|Yes|YES)
      return 0;;
      n|no|N|No|NO)
          echo 'cancelled'
          return 1;;
      *) echo 'Please enter yes or no';;
  esac
done
}

set_menu_choice(){
clear
echo 'Options:-'
echo 'a) Add new Books records'
echo 'b) Find Books'
echo 'c) Edit Books'
echo 'd) Remove Books'
echo 'e) View Books'
echo 'f) Quit'
echo 'Please enter the choice then press enter'
read menu_choice
return
}

insert_record(){
echo $* >>$record_file
return
}


add_books(){


echo 'Enter Books title:-'
read tmp
liBooksName=${tmp%%,*}

echo 'Enter Auther Name:-'
read tmp
liAutherNum=${tmp%%,*}

echo 'Enter Publisher Name:-'
read tmp
liPublisherName=${tmp%%,*}

echo 'Enter Books count:-'
read tmp
liBookscount=${tmp%%,*}


echo 'About to add new entry\n'
echo "$liBooksName  $liAutherNum  $liPublisherName  $liBookscount"

if get_confirm; then
   insert_record $liBooksName,$liAutherNum,$liPublisherName,$liBookscount
fi

return
}

find_books(){
  echo "Enter book title to find:"
  read book2find
  grep $book2find $record_file > $temp_file

  linesfound=`cat $temp_file|wc -l`

  case `echo $linesfound` in
  0)    echo "Sorry, nothing found"
        get_return
        return 0
        ;;
  *)    echo "Found the following"
        cat $temp_file
        get_return
        return 0
  esac
return
}

remove_books() {

  linesfound=`cat $record_file|wc -l`

   case `echo $linesfound` in
   0)    echo "Sorry, nothing found"
         get_return
         return 0
         ;;
   *)    echo "Found the following"
         cat $record_file ;;
        esac
 echo "Type the books titel which you want to delete"
 read searchstr

  if [ "$searchstr" = "" ]; then
      return 0
   fi
 grep -v "$searchstr" $record_file > $temp_file
 mv $temp_file $record_file
 echo "Book has been removed"
 get_return
return
}

view_books(){
echo "List of books are"

cat $record_file
get_return
return
}



edit_books(){

echo "list of books are"
cat $record_file
echo "Type the tile of book you want to edit"
read searchstr
  if [ "$searchstr" = "" ]; then
     return 0
  fi
  grep -v "$searchstr" $record_file > $temp_file
  mv $temp_file $record_file
echo "Enter the new record"
add_books

}

rm -f $temp_file
if [!-f $record_file];then
touch $record_file
fi

clear
echo 'Mini library Management'
quit="n"
while [ "$quit" != "y" ];
do

set_menu_choice
case "$menu_choice" in
a) add_books;;
b) find_books;;
c) edit_books;;
d) remove_books;;
e) view_books;;
f) quit=y;;
*) echo "Sorry, choice not recognized";;
esac
done

rm -f $temp_file
echo "Done"

exit 0
