green ()
{
  GREEN="\033[0;32m";
  NC="\033[0m";
  echo "$GREEN$1$NC";
}

step()
{
  local _message=$1;
  local _sleep=3;

  echo $(green "#####################################################################");
  echo $(green "#####################################################################");
  echo "";
  echo "";
  echo $(green "$_message");
  echo "";
  echo "";
  echo $(green "Will continue in $_sleep seconds");
  echo "";
  echo "";
  sleep $_sleep;
}
