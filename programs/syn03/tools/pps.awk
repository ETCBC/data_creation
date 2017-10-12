BEGIN { n_atoms = 0; n_patterns = 0 }
$1 == "Pattern" { pfreq = $5; n_patterns++ }
/ = / { n_atoms += pfreq * split($0, a, ", ") }
END {
   print "patterns:", n_patterns
   print "atoms:", n_atoms
}
