# JSONTestSuite Conformance Fixtures

Imported from [nst/JSONTestSuite](https://github.com/nst/JSONTestSuite).

- **Commit**: `1ef36fa01286573e846ac449e8683f8833c5b26a` (2024-11-22)
- **Author**: Nicolas Seriot
- **License**: MIT (see [LICENSE](LICENSE))

## Structure

- `test_parsing/`: Test files for RFC 8259 parsing compliance:
  - `y_*.json`: Valid JSON. Must be accepted by a compliant parser.
  - `n_*.json`: Invalid JSON. Must be rejected by a compliant parser with a syntax/format exception.
  - `i_*.json`: Indeterminate inputs where RFC 8259 leaves behavior implementation-defined (parsers may accept or reject).
