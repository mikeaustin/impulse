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
  class ApplyExpression extends Node { }
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
  / ApplyExpression
  / FunctionExpression
  / TupleExpression
  / PrimaryExpression

ApplyExpression = $
  / expr:PrimaryExpression _ args:Expression {
      return new ApplyExpression({
        expr: expr,
        args: args
      })
    }

FunctionExpression = $
  / params:Pattern _ "=>" _ expr:Expression {
      return new FunctionExpression({
        params: params,
        body: expr
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

Pattern = $
  / TuplePattern
  / PrimaryPattern

TuplePattern = $
  / head:PrimaryPattern tail:(_ "," _ PrimaryPattern)+ {
    return new TuplePattern({
      elements: tail.reduce((r, e) => [...r, e[3]], [head])
    })
  }

PrimaryPattern = $
  / Literal
  / Identifier
  / "(" head:Pattern? ")" {
      return head ? head : new TuplePattern({
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
