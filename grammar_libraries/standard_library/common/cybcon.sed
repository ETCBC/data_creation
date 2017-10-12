# This sed(1) script adapts the word division of the Cyber encoding of
# Biblical Aramaic to the current encoding in which the article in
# particular is no longer considered a separate word.

#ident "@(#)witut/simple/cybcon.sed	1.3 13/11/11"

s|/T=-)>H |/)HT1H |g
s|/J2-> |/J(N1>2 |g
s|/J-)>H |/J(N1H |g
s|/(J-> |/(J(N1> |g
s|/T=-> |/)HT1> |g
s|/T-> |/)NT1> |g
s|/J-> |/J(N1> |g
s|/J-(> |/J(N |g
s|/-)>J |/1J |g
s|/-)>H |/1H |g
s|/-> |/1> |g
s|KL/= QBL=/|K-L QBL=/|g
