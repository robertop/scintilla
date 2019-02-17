-- Copyright 2015-2019 Charles Lehner. See License.txt.
-- ledger journal LPeg lexer, see http://www.ledger-cli.org/

local lexer = require('lexer')
local token, word_match = lexer.token, lexer.word_match
local P, R, S = lpeg.P, lpeg.R, lpeg.S

local lex = lexer.new('ledger', {lex_by_line = true})

local delim = P('\t') + P('  ')

-- Account.
lex:add_rule('account', token(lexer.VARIABLE,
                              lexer.starts_line(S(' \t')^1 *
                                                (lexer.print - delim)^1)))

-- Amount.
lex:add_rule('amount', token(lexer.NUMBER, delim * (1 - S(';\r\n'))^1))

-- Comments.
lex:add_rule('comment', token(lexer.COMMENT, S(';#') * lexer.nonnewline^0))

-- Whitespace.
lex:add_rule('whitespace', token(lexer.WHITESPACE, lexer.space^1))

-- Strings.
local sq_str = lexer.delimited_range("'")
local dq_str = lexer.delimited_range('"')
local label = lexer.delimited_range('[]', true, true)
lex:add_rule('string', token(lexer.STRING, sq_str + dq_str + label))

-- Date.
lex:add_rule('date', token(lexer.CONSTANT,
                           lexer.starts_line((lexer.digit + S('/-'))^1)))

-- Automated transactions.
lex:add_rule('auto_tx', token(lexer.PREPROCESSOR,
                              lexer.starts_line(S('=~') * lexer.nonnewline^0)))

-- Directives.
local directive_word = word_match[[
	account alias assert bucket capture check comment commodity define end fixed
  endfixed include payee apply tag test year
]] + S('AYNDCIiOobh')
lex:add_rule('directive', token(lexer.KEYWORD,
                                lexer.starts_line(S('!@')^-1 * directive_word)))

return lex
