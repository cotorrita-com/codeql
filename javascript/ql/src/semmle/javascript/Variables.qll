/** Provides classes for modeling program variables. */

import javascript

/** A scope in which variables can be declared. */
class Scope extends @scope {
  /** Gets a textual representation of this element. */
  string toString() { none() }

  /** Gets the scope in which this scope is nested, if any. */
  Scope getOuterScope() { scopenesting(this, result) }

  /** Gets a scope nested in this one, if any. */
  Scope getAnInnerScope() { result.getOuterScope() = this }

  /** Gets the program element this scope is associated with, if any. */
  ASTNode getScopeElement() { scopenodes(result, this) }

  /** Gets the location of the program element this scope is associated with, if any. */
  Location getLocation() { result = getScopeElement().getLocation() }

  /** Gets a variable declared in this scope. */
  Variable getAVariable() { result.getScope() = this }

  /** Gets the variable with the given name declared in this scope. */
  Variable getVariable(string name) {
    result = getAVariable() and
    result.getName() = name
  }
}

/**
 * A program element that induces a scope.
 */
class ScopeElement extends ASTNode {
  Scope s;

  ScopeElement() { this = s.getScopeElement() }

  /** Gets the scope induced by this element. */
  Scope getScope() { result = s }
}

/** The global scope. */
class GlobalScope extends Scope, @globalscope {
  override string toString() { result = "global scope" }
}

/** A local scope, that is, a scope that is not the global scope. */
class LocalScope extends Scope {
  LocalScope() { not this instanceof GlobalScope }
}

/**
 * A scope induced by a Node.js or ES2015 module
 */
class ModuleScope extends Scope, @modulescope {
  /** Gets the module that induces this scope. */
  Module getModule() { result = getScopeElement() }

  override string toString() { result = "module scope" }
}

/** A scope induced by a function. */
class FunctionScope extends Scope, @functionscope {
  /** Gets the function that induces this scope. */
  Function getFunction() { result = getScopeElement() }

  override string toString() { result = "function scope" }
}

/** A scope induced by a catch clause. */
class CatchScope extends Scope, @catchscope {
  /** Gets the catch clause that induces this scope. */
  CatchClause getCatchClause() { result = getScopeElement() }

  override string toString() { result = "catch scope" }
}

/** A scope induced by a block of statements. */
class BlockScope extends Scope, @blockscope {
  /** Gets the block of statements that induces this scope. */
  BlockStmt getBlock() { result = getScopeElement() }

  override string toString() { result = "block scope" }
}

/** A scope induced by a `for` statement. */
class ForScope extends Scope, @forscope {
  /** Gets the `for` statement that induces this scope. */
  ForStmt getLoop() { result = getScopeElement() }

  override string toString() { result = "for scope" }
}

/** A scope induced by a `for`-`in` or `for`-`of` statement. */
class ForInScope extends Scope, @forinscope {
  /** Gets the `for`-`in` or `for`-`of` statement that induces this scope. */
  EnhancedForLoop getLoop() { result = getScopeElement() }

  override string toString() { result = "for-in scope" }
}

/** A scope induced by a comprehension block. */
class ComprehensionBlockScope extends Scope, @comprehensionblockscope {
  /** Gets the comprehension block that induces this scope. */
  ComprehensionBlock getComprehensionBlock() { result = getScopeElement() }

  override string toString() { result = "comprehension block scope" }
}

/**
 * The lexical scope induced by a TypeScript namespace declaration.
 *
 * This scope is specific to a single syntactic declaration of a namespace,
 * and currently does not include variables exported from other declarations
 * of the same namespace.
 */
class NamespaceScope extends Scope, @namespacescope {
  override string toString() { result = "namespace scope" }
}

/** A variable declared in a scope. */
class Variable extends @variable, LexicalName {
  /** Gets the name of this variable. */
  override string getName() { variables(this, result, _) }

  /** Gets the scope this variable is declared in. */
  override Scope getScope() { variables(this, _, result) }

  /** Holds if this is a global variable. */
  predicate isGlobal() { getScope() instanceof GlobalScope }

  /**
   * Holds if this is a variable exported from a TypeScript namespace.
   *
   * Note that such variables are also considered local for the time being.
   */
  predicate isNamespaceExport() {
    getScope() instanceof NamespaceScope and
    exists(ExportNamedDeclaration decl | decl.getADecl().getVariable() = this)
  }

  /**
   * Holds if this is a local variable.
   *
   * Parameters and `arguments` variables are considered to be local.
   */
  predicate isLocal() { not isGlobal() }

  /** Holds if this variable is a parameter. */
  predicate isParameter() { exists(Parameter p | p.getAVariable() = this) }

  /** Gets a reference to this variable. */
  VarRef getAReference() { result.getVariable() = this }

  /** Gets an access to this variable. */
  VarAccess getAnAccess() { result.getVariable() = this }

  /** Gets a declaration declaring this variable, if any. */
  VarDecl getADeclaration() { result.getVariable() = this }

  /** Gets a declaration statement declaring this variable, if any. */
  DeclStmt getADeclarationStatement() {
    result.getADecl().getBindingPattern().getAVariable() = this
  }

  /** Gets a definition for this variable. */
  VarDef getADefinition() { result.getAVariable() = this }

  /** Gets an expression that is directly stored in this variable. */
  Expr getAnAssignedExpr() {
    // result is an expression that this variable is initialized to
    exists(VariableDeclarator vd | vd.getBindingPattern().(VarDecl).getVariable() = this |
      result = vd.getInit()
    )
    or
    // if this variable represents a function binding, return the function
    exists(FunctionExpr fn | fn.getVariable() = this | result = fn)
    or
    // there is an assignment to this variable
    exists(Assignment assgn | assgn.getLhs() = getAnAccess() and assgn.getRhs() = result)
  }

  /**
   * Holds if this variable is captured in the closure of a nested function.
   *
   * Global variables are always considered to be captured.
   */
  predicate isCaptured() {
    this instanceof GlobalVariable or
    getAnAccess().getContainer().getFunctionBoundary() != this
          .(LocalVariable)
          .getDeclaringContainer()
          .getFunctionBoundary()
  }

  /** Holds if there is a declaration of this variable in `tl`. */
  predicate declaredIn(TopLevel tl) { getADeclaration().getTopLevel() = tl }

  /** Gets a textual representation of this element. */
  override string toString() { result = getName() }

  override DeclarationSpace getDeclarationSpace() { result = "variable" }
}

/** An `arguments` variable of a function. */
class ArgumentsVariable extends Variable {
  ArgumentsVariable() { isArgumentsObject(this) }

  override FunctionScope getScope() { result = Variable.super.getScope() }

  /** Gets the function declaring this 'arguments' variable. */
  Function getFunction() { result = getScope().getFunction() }
}

/** An identifier that refers to a variable, either in a declaration or in a variable access. */
class VarRef extends @varref, Identifier, BindingPattern, LexicalRef {
  /** Gets the variable this identifier refers to. */
  Variable getVariable() { none() } // Overriden in VarAccess and VarDecl

  override string getName() { result = Identifier.super.getName() }

  override VarRef getABindingVarRef() { result = this }

  override predicate isImpure() { none() }

  override Expr getUnderlyingReference() { result = this }
}

/** An identifier that refers to a variable in a non-declaring position. */
class VarAccess extends @varaccess, VarRef, LexicalAccess {
  /**
   * Gets the variable this identifier refers to.
   *
   * When analyzing TypeScript code, a variable may spuriously be resolved as a
   * global due to incomplete modeling of exported variables in namespaces.
   */
  override Variable getVariable() { bind(this, result) }

  override predicate isLValue() {
    exists(Assignment assgn | assgn.getTarget() = this)
    or
    exists(UpdateExpr upd | upd.getOperand().getUnderlyingReference() = this)
    or
    exists(EnhancedForLoop efl | efl.getIterator() = this)
    or
    exists(BindingPattern p | this = p.getABindingVarRef() and p.isLValue())
  }

  override Variable getAVariable() { result = getVariable() }
}

/**
 * An identifier that occurs in a named export declaration, such as in `export { A }`.
 *
 * Such an identifier may refer to a variable, type, or namespace, or a combination of these.
 */
class ExportVarAccess extends VarAccess, @export_varaccess {
  /** Gets the type being exported, if this identifier refers to a type. */
  LocalTypeName getLocalTypeName() { result.getAnAccess() = this }

  /** Gets the namespace being exported, if this identifier refers to a namespace. */
  LocalNamespaceName getLocalNamespaceName() { result.getAnAccess() = this }
}

/** A global variable. */
class GlobalVariable extends Variable {
  GlobalVariable() { isGlobal() }
}

/** A local variable or a parameter. */
class LocalVariable extends Variable {
  LocalVariable() { isLocal() }

  /**
   * Gets the function or toplevel in which this variable is declared;
   * `arguments` variables are taken to be implicitly declared in the function
   * to which they belong.
   *
   * Note that for a function expression `function f() { ... }` the variable
   * `f` is declared in the function itself, while for a function statement
   * it is declared in the enclosing container.
   */
  StmtContainer getDeclaringContainer() {
    this = result.getScope().getAVariable()
    or
    exists(VarDecl d | d = getADeclaration() |
      if d = any(FunctionDeclStmt fds).getId()
      then exists(FunctionDeclStmt fds | d = fds.getId() | result = fds.getEnclosingContainer())
      else result = d.getContainer()
    )
  }
}

/** A local variable that is not captured. */
class PurelyLocalVariable extends LocalVariable {
  PurelyLocalVariable() { not isCaptured() }
}

/** An identifier that refers to a global variable. */
class GlobalVarAccess extends VarAccess {
  GlobalVarAccess() { getVariable().isGlobal() }
}

/**
 * A binding pattern, i.e., either an identifier or a destructuring pattern.
 *
 * Binding patterns can appear on the left hand side of assignments or in
 * variable or parameter declarations. They bind one or more variables to
 * values, either by means of a regular assignment as in `x = 42`, or
 * through a destructuring assignment as in `[x, y] = a`; see Chapter 12 of
 * the ECMAScript standard for more details.
 */
class BindingPattern extends @pattern, Expr {
  /** Gets the name of this binding pattern if it is an identifier. */
  string getName() { none() }

  /** Gets a variable reference in binding position within this pattern. */
  VarRef getABindingVarRef() { none() }

  /** Gets a variable bound by this pattern. */
  Variable getAVariable() { result = getABindingVarRef().getVariable() }

  /** Holds if this pattern appears in an l-value position. */
  predicate isLValue() { any() }

  /**
   * Returns the TypeScript type annotation for this variable or pattern, if any.
   *
   * Only the outermost part of a binding pattern can have a type annotation.
   * For instance, in the declaration,
   * <pre>
   * var {x}: Point
   * </pre>
   * the variable `x` has no type annotation, whereas the pattern `{x}` has the type
   * annotation `Point`.
   */
  TypeExpr getTypeAnnotation() {
    exists(VariableDeclarator decl | decl.getBindingPattern() = this |
      result = decl.getTypeAnnotation()
    )
    // note: Parameter overrides this to handle the parameter case
  }
}

/** A destructuring pattern, that is, either an array pattern or an object pattern. */
abstract class DestructuringPattern extends BindingPattern {
  /** Gets the rest pattern of this destructuring pattern, if any. */
  abstract Expr getRest();
}

/** An identifier that declares a variable. */
class VarDecl extends @vardecl, VarRef, LexicalDecl {
  override Variable getVariable() { decl(this, result) }

  override predicate isLValue() {
    exists(VariableDeclarator vd | vd.getBindingPattern() = this |
      exists(vd.getInit()) or
      exists(EnhancedForLoop efl | this = efl.getIterator())
    )
    or
    exists(BindingPattern p | this = p.getABindingVarRef() and p.isLValue())
  }
}

/** An identifier that declares a global variable. */
class GlobalVarDecl extends VarDecl {
  GlobalVarDecl() { getVariable() instanceof GlobalVariable }
}

/** An array pattern. */
class ArrayPattern extends DestructuringPattern, @arraypattern {
  /** Gets the `i`th element of this array pattern. */
  Expr getElement(int i) {
    i >= 0 and
    result = this.getChildExpr(i)
  }

  /** Gets an element of this array pattern. */
  Expr getAnElement() { exists(int i | i >= -1 | result = this.getChildExpr(i)) }

  /** Gets the default expression for the `i`th element of this array pattern, if any. */
  Expr getDefault(int i) {
    i in [0 .. getSize() - 1] and
    result = getChildExpr(-2 - i)
  }

  /** Holds if the `i`th element of this array pattern has a default expression. */
  predicate hasDefault(int i) { exists(getDefault(i)) }

  /** Gets the rest pattern of this array pattern, if any. */
  override Expr getRest() { result = getChildExpr(-1) }

  /** Holds if this array pattern has a rest pattern. */
  predicate hasRest() { exists(getRest()) }

  /** Gets the number of elements in this array pattern, not including any rest pattern. */
  int getSize() { arraySize(this, result) }

  /** Holds if the `i`th element of this array pattern is omitted. */
  predicate elementIsOmitted(int i) {
    i in [0 .. getSize() - 1] and
    not exists(getElement(i))
  }

  /** Holds if this array pattern has an omitted element. */
  predicate hasOmittedElement() { elementIsOmitted(_) }

  override predicate isImpure() { getAnElement().isImpure() }

  override VarRef getABindingVarRef() {
    result = getAnElement().(BindingPattern).getABindingVarRef()
  }
}

/** An object pattern. */
class ObjectPattern extends DestructuringPattern, @objectpattern {
  /** Gets the `i`th property pattern in this object pattern. */
  PropertyPattern getPropertyPattern(int i) { properties(result, this, i, _, _) }

  /** Gets a property pattern in this object pattern. */
  PropertyPattern getAPropertyPattern() { result = this.getPropertyPattern(_) }

  /** Gets the number of property patterns in this object pattern. */
  int getNumProperty() { result = count(this.getAPropertyPattern()) }

  /** Gets the property pattern with the given name, if any. */
  PropertyPattern getPropertyPatternByName(string name) {
    result = this.getAPropertyPattern() and
    result.getName() = name
  }

  /** Gets the rest property pattern of this object pattern, if any. */
  override Expr getRest() { result = getChildExpr(-1) }

  override predicate isImpure() { getAPropertyPattern().isImpure() }

  override VarRef getABindingVarRef() {
    result = getAPropertyPattern().getValuePattern().(BindingPattern).getABindingVarRef() or
    result = getRest().(BindingPattern).getABindingVarRef()
  }
}

/** A property pattern in an object pattern. */
class PropertyPattern extends @property, ASTNode {
  PropertyPattern() {
    // filter out ordinary properties
    exists(ObjectPattern obj | properties(this, obj, _, _, _))
  }

  /** Holds if the name of this property pattern is computed. */
  predicate isComputed() { isComputed(this) }

  /** Gets the expression specifying the name of the matched property. */
  Expr getNameExpr() { result = this.getChildExpr(0) }

  /** Gets the expression the matched property value is assigned to. */
  Expr getValuePattern() { result = this.getChildExpr(1) }

  /** Gets the default value of this property pattern, if any. */
  Expr getDefault() { result = this.getChildExpr(2) }

  /** Holds if this property pattern is a shorthand pattern. */
  predicate isShorthand() { getNameExpr().getLocation() = getValuePattern().getLocation() }

  /** Gets the name of the property matched by this pattern. */
  string getName() {
    not isComputed() and
    result = getNameExpr().(Identifier).getName()
    or
    result = getNameExpr().(Literal).getValue()
  }

  /** Gets the object pattern this property pattern belongs to. */
  ObjectPattern getObjectPattern() { properties(this, result, _, _, _) }

  /** Gets the nearest enclosing function or toplevel in which this property pattern occurs. */
  StmtContainer getContainer() { result = getObjectPattern().getContainer() }

  /** Holds if this pattern is impure, that is, if its evaluation could have side effects. */
  predicate isImpure() {
    isComputed() and getNameExpr().isImpure()
    or
    getValuePattern().isImpure()
  }

  override string toString() { properties(this, _, _, _, result) }

  override ControlFlowNode getFirstControlFlowNode() {
    result = getNameExpr().getFirstControlFlowNode()
  }
}

/** A variable declarator declaring a local or global variable. */
class VariableDeclarator extends Expr, @vardeclarator {
  /** Gets the pattern specifying the declared variable(s). */
  BindingPattern getBindingPattern() { result = this.getChildExpr(0) }

  /** Gets the expression specifying the initial value of the declared variable(s), if any. */
  Expr getInit() { result = this.getChildExpr(1) }

  /** Gets the TypeScript type annotation for the declared variable or binding pattern. */
  TypeExpr getTypeAnnotation() { result = this.getChildTypeExpr(2) }

  /** Holds if this is a TypeScript variable marked as definitely assigned with the `!` operator. */
  predicate hasDefiniteAssignmentAssertion() { hasDefiniteAssignmentAssertion(this) }

  /** Gets the declaration statement this declarator belongs to, if any. */
  DeclStmt getDeclStmt() { this = result.getADecl() }

  override ControlFlowNode getFirstControlFlowNode() {
    result = getBindingPattern().getFirstControlFlowNode()
  }
}

/**
 * For internal use, holding the decorators of a function parameter.
 */
private class DecoratorList extends Expr, @decorator_list {
  Decorator getDecorator(int i) { result = getChildExpr(i) }

  override ControlFlowNode getFirstControlFlowNode() {
    if exists(getDecorator(0))
    then result = getDecorator(0).getFirstControlFlowNode()
    else result = this
  }
}

/**
 * A program element that declares parameters, that is, either a function or
 * a catch clause.
 */
class Parameterized extends @parameterized, Documentable {
  /** Gets a parameter declared by this element. */
  Parameter getAParameter() { this = result.getParent() }

  /** Gets the number of parameters declared by this element. */
  int getNumParameter() { result = count(getAParameter()) }

  /** Gets a variable of the given name that is a parameter of this element. */
  Variable getParameterVariable(string name) {
    result = getAParameter().getAVariable() and
    result.getName() = name
  }
}

/** A parameter declaration. */
class Parameter extends BindingPattern {
  Parameter() {
    exists(Parameterized p, int n |
      this = p.getChildExpr(n) and
      n >= 0
    )
  }

  /**
   * Gets the index of this parameter within the parameter list of its
   * declaring entity.
   */
  int getIndex() { exists(Parameterized p | this = p.getChildExpr(result)) }

  /** Gets the element declaring this parameter. */
  override Parameterized getParent() { result = super.getParent() }

  /** Gets the default expression for this parameter, if any. */
  Expr getDefault() {
    exists(Function f, int n | this = f.getParameter(n) | result = f.getChildExpr(-(4 * n + 5)))
  }

  /** Gets the type annotation for this parameter, if any. */
  override TypeExpr getTypeAnnotation() {
    exists(Function f, int n | this = f.getParameter(n) | result = f.getChildTypeExpr(-(4 * n + 6)))
  }

  /** Holds if this parameter is a rest parameter. */
  predicate isRestParameter() {
    exists(Function f, int n | this = f.getParameter(n) |
      n = f.getNumParameter() - 1 and
      f.hasRestParameter()
    )
  }

  private DecoratorList getDecoratorList() {
    exists(Function f, int n | this = f.getParameter(n) | result = f.getChildExpr(-(4 * n + 8)))
  }

  /** Gets the `i`th decorator applied to this parameter. */
  Decorator getDecorator(int i) { result = getDecoratorList().getDecorator(i) }

  /** Gets a decorator applied to this parameter. */
  Decorator getADecorator() { result = getDecorator(_) }

  /** Gets the number of decorators applied to this parameter. */
  int getNumDecorator() { result = count(getADecorator()) }

  override predicate isLValue() { any() }

  /**
   * Gets the JSDoc tag describing this parameter, if any.
   */
  JSDocTag getJSDocTag() {
    none() // overridden in SimpleParameter
  }
}

/** A parameter declaration that is not an object or array pattern. */
class SimpleParameter extends Parameter, VarDecl {
  override predicate isLValue() { Parameter.super.isLValue() }

  /**
   * Gets a use of this parameter that refers to its initial value as
   * passed in from the caller.
   */
  VarUse getAnInitialUse() {
    exists(SsaDefinition ssa |
      ssa.getAContributingVarDef() = this and
      result = ssa.getVariable().getAUse()
    )
  }

  override JSDocParamTag getJSDocTag() {
    exists(Function fun |
      this = fun.getAParameter() and
      result = fun.getDocumentation().getATag() and
      result.getName() = getName()
    )
  }
}

/**
 * A constructor parameter that induces a field in its class, such as the parameter `x` in:
 * ```
 * class C {
 *   constructor(public x: number) {}
 * }
 * ```
 */
class FieldParameter extends SimpleParameter {
  FieldParameter() { exists(ParameterField field | field.getParameter() = this) }

  /** Gets the field induced by this parameter. */
  ParameterField getField() { result.getParameter() = this }
}

/**
 * A string representing one of the three TypeScript declaration spaces: `variable`, `type`, or `namespace`.
 */
class DeclarationSpace extends string {
  DeclarationSpace() { this = "variable" or this = "type" or this = "namespace" }
}

/**
 * A name that is declared in a particular scope.
 *
 * This can be a variable or a local name for a TypeScript type or namespace.
 */
class LexicalName extends @lexical_name {
  /** Gets the scope in which this name was declared. */
  abstract Scope getScope();

  /** Gets the name of this variable, type or namespace. */
  abstract string getName();

  /** Gets a string representation of this element. */
  abstract string toString();

  /**
   * Gets the declaration space this name belongs to.
   *
   * This can be either `variable`, `type`, or `namespace`.
   */
  abstract DeclarationSpace getDeclarationSpace();
}

/**
 * An identifier that refers to a variable, type, or namespace, or a combination of these.
 */
class LexicalRef extends Identifier, @lexical_ref {
  /**
   * Gets any of the names referenced by this identifier.
   *
   * Note that each identifier may reference up to one lexical name per declaration space.
   * For example, a class name declares both a type and a variable.
   */
  LexicalName getALexicalName() {
    bind(this, result) or
    decl(this, result) or
    typebind(this, result) or
    typedecl(this, result) or
    namespacebind(this, result) or
    namespacedecl(this, result)
  }
}

/**
 * An identifier that declares a variable, type, or namespace, or a combination of these.
 */
class LexicalDecl extends LexicalRef, @lexical_decl { }

/**
 * An identifier that refers to a variable, type, or namespace, or a combination of these,
 * in a non-declaring position.
 */
class LexicalAccess extends LexicalRef, @lexical_access { }
