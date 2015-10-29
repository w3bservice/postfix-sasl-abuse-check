#!/usr/local/bin/bash
q=$1
postcat=/usr/local/sbin/postcat
postqueue=/usr/local/sbin/postqueue

function checkIt()
{
	local q=$1
	q="${q//[^A-Z0-9]/}"
	adr=$( ${postcat} -q ${q} )
	sasl=$( echo "${adr}" | egrep -o "sasl_username\=.*" | awk '{ print $1 }' | sed 's/sasl_username\=//' )
	sender=$( echo "${adr}" | egrep "^sender\:" | awk '{ print $NF }' )

	if [ "${sasl}" != "${sender}" ]; then
		echo "${q}: [SPAM] Might be spam, sender (${sender}) and auth-user (${sasl}) doesn't match."
	else
		echo "${q}: [OK] sender (${sender}) and auth-user (${sasl}) matches."
	fi
}

if [ ! -z "${q}" ]; then
	if [ "${q}" == "ALL" ]; then
		for qnum in $( ${postqueue} -p | egrep "^[A-Z0-9]+" | grep "\@" | awk '{ print $1 }'); do
				checkIt ${qnum}
		done
	else
		checkIt ${q}
	fi
else
	echo "Syntax: `basename $0` <queue-id|ALL>"
fi
