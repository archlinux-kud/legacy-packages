#!/usr/bin/env bash

AURROOT=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
PKGBASE=$(grep pkgbase= "$AURROOT"/PKGBUILD | cut -d '=' -f 2)
KERNVER=$(< "$AURROOT"/src/version)
MODROOT=/usr/lib/modules/$KERNVER
SIGN_FILE=$MODROOT/build/scripts/sign-file
MODULES=$(find /var/lib/dkms/*/*/"$KERNVER"/ -name '*.ko*')
HASH=$(grep SIG_SHA "$AURROOT"/linux/arch/x86/configs/"${PKGBASE/linux-}"_defconfig | sed -e s/.*._// -e s/=y//)
[[ -z $HASH ]] && HASH=SHA1

export AURROOT PKGBASE KERNVER MODROOT SIGN_FILE MODULES HASH

sign_modules() {
    for i in $MODULES; do
        EXTENSION=$(echo -n "$i" | tail -c 3)
        case ${EXTENSION/.} in
            gz) COMPRESS=gzip ;;
            xz) COMPRESS=xz ;;
            *) unset EXTENSION ;;
        esac
        [[ -n $COMPRESS ]] && $COMPRESS -d "$i"
        $SIGN_FILE ${HASH,,} "$AURROOT"/"$PKGBASE".{pem,x509} "${i/$EXTENSION}"
        [[ -n $COMPRESS ]] && $COMPRESS "${i/$EXTENSION}"
        cp -f "$i" "$(find "$MODROOT"/kernel -name "$(basename "$i")")"
    done
}

sudo -E su -c "$(declare -f sign_modules) && sign_modules" || exit 1
