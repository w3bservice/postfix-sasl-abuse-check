# postfix-loose-spamcheck
Quick and dirty script to check the probability of spam for a mail in the postfix queue

Had a FreeBSD SMTP server running Postfix with SASL, wrote a quick script to determine if one or all of the mails in the queue could be "spam" - that is, if sender address was different from the authenticated account, which could indicate an abused account.

Syntax: script.sh <queue-id|ALL>
