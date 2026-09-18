// Typed core — a WHOLE Go program, run by the same binary:
//
//     bashy --bashsharp --source=go 03-whole-program.go
//
// No shell text here: this is Go 1.27, generics included, interpreted (and
// lowerable) by Bash#. This is the path the Go-corpus numbers are measured
// on — see docs/claims.md in the language repo.
package main

import "fmt"

type Number interface{ ~int | ~float64 }

func Sum[T Number](xs []T) T {
	var s T
	for _, x := range xs {
		s += x
	}
	return s
}

func main() {
	fmt.Println(Sum([]int{1, 2, 3}), Sum([]float64{0.5, 0.25}))
	if s := Sum([]int{}); s == 0 {
		fmt.Println("empty sums to zero")
	}
}
