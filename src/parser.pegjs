{
  class Node {
    constructor(args) {
      Object.assign(this, args)
    }
  }

  class Literal extends Node { }
  class Identifier extends Node { }
  class TupleExpression extends Node { }
  class FunctionExpression extends Node { }
  class TuplePattern extends Node { }
}

Block = $
  / statements:(_ Statement)* {
      return statements.reduce((r, e) => e[1] ? [...r, e[1]] : r, [])
    }

Statement = $
  / _ expr:Expression? LineTerminator {
      return expr
    }

Expression = $
  / FunctionExpression
  / TupleExpression
  / PrimaryExpression

FunctionExpression = $
  / params:Pattern _ "=>" _ expr:Expression {
      return new FunctionExpression({
        params: params,
        body: expr
      })
    }

Pattern = $
  / head:Identifier tail:(_ "," _ Identifier)+ {
    return new TuplePattern({
      elements: tail.reduce((r, e) => [...r, e[3]], [head])
    })
  }

TupleExpression = $
  / head:PrimaryExpression tail:(_ "," _ PrimaryExpression)+ {
      return new TupleExpression({
        elements: tail.reduce((r, e) => [...r, e[3]], [head])
      })
    }

PrimaryExpression = $
  / Literal
  / Identifier
  / "(" head:Expression? ")" {
      return head ? head : new TupleExpression({
        elements: []
      })
    }

Literal = $
  / NumericLiteral

NumericLiteral = $
  / literal:[0-9]+ ("." !"." [0-9]+)? {
      return new Literal({
        value: Number(text())
      })
    }

Identifier = $
  / name:([a-zA-Z][a-zA-Z0-9]*) {
      return new Identifier({
        name: text()
      })
    }

_ = $
  / WhiteSpace*

WhiteSpace "whitespace" = $
  / " "
  
LineTerminator = $
  / [\n\r]

$ = "$"
