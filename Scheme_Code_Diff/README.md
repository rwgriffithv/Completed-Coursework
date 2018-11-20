# Scheme Code Difference Analyzer
**CS 131: Programming Languages** <br />
*18 November 2018*

The procedure expr-compare compares two Scheme expressions x and y, and produces a difference summary of where the two expressions are the same and where they differ. <br />
The difference summary produced is also a Scheme expression which, if executed in an environment where the Scheme variable % is true, has the same behavior as x, and otherwise has the same behavior as y. <br />
The summary expression uses the same identifiers as the two input expressions where they agree -- if x declares the bound variable X in the same place where y declares the bound variable Y, the summary expression should declare a bound variable X!Y and use it consistently thereafter wherever the input expressions use X and Y respectively. <br />

The assignment gave the following limitations to the input Scheme expressions x and y: <br />
"It can be limited to the Scheme subset that consists of constant literals, variable references, procedure calls, the special form (quote datum), the special form (lambda formals body) where body consists of a single expression, the special form (let bindings body) where body consists of a single expression, and the special-form conditional (if expr expr). To avoid confusion the input Scheme expressions cannot contain any symbols which contain the % or ! characters. Your prototype need not check that its inputs are valid; it can have undefined behavior if given inputs outside the specified subset."
