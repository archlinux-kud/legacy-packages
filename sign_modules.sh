#!/usr/bin/env bash

PKGBASE=linux-vk
KERNVER=""
AURROOT=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
MODROOT=/usr/lib/modules/${KERNVER}
SIGN_FILE=${MODROOT}/build/scripts/sign-file

find ${MODROOT}/kernel/ -name '*.ko' -exec sudo ${SIGN_FILE} sha384 \
     "${AURROOT}"/${PKGBASE}.pem "${AURROOT}"/${PKGBASE}.x509 {} \;
