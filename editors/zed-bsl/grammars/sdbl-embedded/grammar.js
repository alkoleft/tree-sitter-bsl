/// <reference types='tree-sitter-cli/dsl' />

const sdbl = require('../../../../grammars/sdbl/grammar');

module.exports = grammar(sdbl, {
  name: 'sdbl_embedded',

  extras: ($) => [/\s/, $.line_comment, $.bsl_string_continuation],

  conflicts: ($) => [[$.totals_clause]],

  rules: {
    source_file: ($) =>
      seq(
        $.bsl_string_delimiter,
        choice($.query_package, $.query, $.destroy_statement),
        $.bsl_string_delimiter,
      ),

    bsl_string_delimiter: () => '"',
    bsl_string_continuation: () => '|',
  },
});
