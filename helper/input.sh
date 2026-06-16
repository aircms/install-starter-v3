dbName=$1;
domain=$2;
tinyKey=$3;

if [ ${#dbName} = 0 ]; then
  echo "Database name:";
  read dbName;
fi;

if [ ${#domain} = 0 ]; then
  echo "Main domain name:";
  read domain;
fi;

if [ ${#tinyKey} = 0 ]; then
  echo "TinyMce key:";
  read tinyKey;
fi;

folderName=$dbName;

echo "---------------------------------------------------------------------";
echo "Will be created:";
echo - $(green "$domain");
echo - $(green "fs.$domain");
echo - $(green "admin.$domain");
echo "---------------------------------------------------------------------";
echo "Folder:         /var/www/$(green $folderName)";
echo "---------------------------------------------------------------------";
echo "Database name:  $(green $dbName)";
echo "---------------------------------------------------------------------";
echo "TinyMce key:    $(green $tinyKey)";
echo "---------------------------------------------------------------------";
echo "Press [ENTER] to continue or CTRL+C to cancel";
read _confirm;
echo "---------------------------------------------------------------------";
echo "Great, Lets start!";
echo "---------------------------------------------------------------------";
