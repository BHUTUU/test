#!/bin/bash
: '
By: Suman Kumar ~BHUTUU
APT REPOSITORY MANUFACTURER
MADE WITH LOVE FOR EVERYONE JUST FOR FREE!
'
set -x    #for debug mode
#Requrements:
#TREE
if ! hash tree >/dev/null 2>&1; then apt install tree -y; fi
#gnupg
if ! hash gpg> /dev/null 2>&1; then apt install gnupg -y; fi
#<-x->

CWD=$(pwd)
DebPerm() {
  chmod 0755 $1/DEBIAN
  if [[ -f $1/DEBIAN/postinst ]]; then
    chmod 0555 $1/DEBIAN/postinst
  fi
  if [[ -f $1/DEBIAN/preinst ]]; then
    chmod 0555 $1/DEBIAN/preinst
  fi
}
AARCH64() {
  DebPerm $1
  dpkg-deb -b $1
  mv ${1}.deb ${1}.aarch64.deb
  mv -v ${1}.aarch64.deb debs.all > /dev/null 2>&1
}
ALL() {
  DebPerm $1
  dpkg-deb -b $1
  mv ${1}.deb ${1}.all.deb
  mv -v ${1}.all.deb debs.all > /dev/null 2>&1
  sed -i 's/all/arm/g' $1/DEBIAN/control
  sed -i 's/Instarmed/Installed/g' $1/DEBIAN/control
  ARM $1
  sed -i 's/arm/aarch64/g' $1/DEBIAN/control
  AARCH64 $1
  sed -i 's/aarch64/i686/g' $1/DEBIAN/control
  I686 $1
  sed -i 's/i686/x86_64/g' $1/DEBIAN/control
  X86_64 $1
  sed -i 's/x86_64/all/g' $1/DEBIAN/control
}
ARM() {
  DebPerm $1
  dpkg-deb -b $1
  mv ${1}.deb ${1}.arm.deb
  mv -v ${1}.arm.deb debs.all > /dev/null 2>&1
}
I686() {
  DebPerm $1
  dpkg-deb -b $1
  mv ${1}.deb ${1}.i686.deb
  mv -v ${1}.i686.deb debs.all > /dev/null 2>&1
}
X86_64() {
  DebPerm $1
  dpkg-deb -b $1
  mv ${1}.deb ${1}.x86_64.deb
  mv -v ${1}.x86_64.deb debs.all > /dev/null 2>&1
}
main() {
  rm -rf $1/dists > /dev/null 2>&1
  rm -rf debs.all > /dev/null 2>&1
  mkdir debs.all > /dev/null 2>&1
  dirs=($(ls))
  for i in "${dirs[@]}"; do
    debdir=$(tree ${i} | grep -w "DEBIAN")
    if [[ ! -z ${debdir} ]]; then
      Archi=$(cat ${i}/DEBIAN/control | grep -w "Architecture" | sed -e 's/Architecture: //g')
      if [[ $Archi == *'aarch64'* ]]; then
        AARCH64 ${i}
      elif [[ $Archi == *'all'* ]]; then
        ALL ${i}
      elif [[ $Archi == *'arm'* ]]; then
        ARM ${i}
      elif [[ $Archi == *'i686'* ]]; then
        I686 ${i}
      elif [[ $Archi == *'x86_64'* ]]; then
        X86_64 ${i}
      else
        printf "\033[32m Check Architecture value in control file of program:-> ${i}\033[00m\n"
      fi
    else
      printf "\033[34m There is no any DEBIAN type package found in the current directory to build\033[00m\n"
    fi
  done
  if ! hash termux-apt-repo > /dev/null 2>&1; then
    apt install termux-apt-repo -y
  fi
  termux-apt-repo debs.all $1 $2 $3
  cd $1/dists/$2 > /dev/null 2>&1
  sed -i "s/termux/$4/g" Release
  gpg --clear-sign Release
  mv Release.* InRelease > /dev/null 2>&1
}
if [[ ! -z $1 || ! -z $2 || ! -z $3 ]]; then
main $1 $2 $3 $4
else
  echo -e "
  ++++++++++++++
    HELP MENU
  ==============
    bash build.sh PATH-TO-YOUR-REPO-FILE CODENAME BRANCH DISTRO


    EXAMPLE:-
    bash build.sh bhutuu.pwn.repo bhutuu main pwn-term
  "
fi
