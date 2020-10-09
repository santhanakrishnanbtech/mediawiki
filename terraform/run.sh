#!/usr/bin/env bash

echo -e "\n-------------------[ MEDIA WIKI ]------------------------"
echo -e " \n1) dev \n2) uat \n3) prod\n4) exit\n";
read -p ">> Select your deployment: " selection;
echo

dev(){
  bash env/dev/test.sh
}

uat(){
  bash $0
}

prod(){
  bash $0
}

case $selection in
   "dev")
      echo -e "Development Environment \n"
      dev
      ;;
   "uat")
      echo -e "UAT is still under development \n"
      uat
      ;;
   "prod")
      echo -e "Production is still under development \n"
      prod
      ;;
   "exit")
      echo -e "Bye !!! \n"
      exit
      ;;
   *)
     echo "Invalid Option !!!"
     bash $0
     ;;
esac