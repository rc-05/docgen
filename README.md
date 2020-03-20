# docgen
A ChezScheme library for generating interactive documentation.

## Index

* [Usage](usage)
* [Install](install)
* [Api](api)
* [License](license)

The library has been conceived because ChezScheme (or Scheme in general) lack
a standard way of documenting the code.

## Usage {#usage}

```scheme
(gen-doc foo "Test symbol")
(define foo 'test)

(gen-doc bar "Bar function" p1 p2)
(define bar
  (lambda (p1 p2) p1 p2))
```

`gen-doc` is position independent: this means that you are not forced to
put the macro on top of a definition but it is really recommended that you
do so.

## Install {#install}

1. Install the [ChezScheme](https://cisco.github.io/ChezScheme) compiler.
2. Import the docgen library making sure that the library is in the same
   directory as your project.
3. Read the API! :smile:

## Api {#api}

`(describe defName)`
: Describes the definition denoted by the **symbol** *defName*.
  An error is signaled when:
  * An undocumented definition gets passed.
  * describe is used in an uncompletely undocumented code (no definition
    is actually documented).

`(gen-doc defName doc . parameters)`
: Generates interactive documentation that can be retrieved with
  `(describe defName)` and contains the **string** documentation *doc* and
  optional *parameters* for a function definition.

## License {#license}

This project is licensed under the GNU GPLv3 license.
Please refer to the LICENSE file for more information.
