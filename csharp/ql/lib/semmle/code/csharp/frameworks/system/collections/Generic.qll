/** Provides definitions related to the namespace `System.Collections.Generic`. */

import csharp
private import semmle.code.csharp.frameworks.system.Collections
private import semmle.code.csharp.dataflow.ExternalFlow

/** The `System.Collections.Generic` namespace. */
class SystemCollectionsGenericNamespace extends Namespace {
  SystemCollectionsGenericNamespace() {
    this.getParentNamespace() instanceof SystemCollectionsNamespace and
    this.hasName("Generic")
  }
}

/** An unbound generic interface in the `System.Collections.Generic` namespace. */
class SystemCollectionsGenericUnboundGenericInterface extends UnboundGenericInterface {
  SystemCollectionsGenericUnboundGenericInterface() {
    this.getNamespace() instanceof SystemCollectionsGenericNamespace
  }
}

/** An unbound generic class in the `System.Collections.Generic` namespace. */
class SystemCollectionsGenericUnboundGenericClass extends UnboundGenericClass {
  SystemCollectionsGenericUnboundGenericClass() {
    this.getNamespace() instanceof SystemCollectionsGenericNamespace
  }
}

/** An unbound generic struct in the `System.Collections.Generic` namespace. */
class SystemCollectionsGenericUnboundGenericStruct extends UnboundGenericStruct {
  SystemCollectionsGenericUnboundGenericStruct() {
    this.getNamespace() instanceof SystemCollectionsGenericNamespace
  }
}

/** The `System.Collections.Generic.IComparer<>` interface. */
class SystemCollectionsGenericIComparerTInterface extends SystemCollectionsGenericUnboundGenericInterface {
  SystemCollectionsGenericIComparerTInterface() { this.hasName("IComparer<>") }

  /** Gets the `int Compare(T, T)` method. */
  Method getCompareMethod() {
    result.getDeclaringType() = this and
    result.hasName("Compare") and
    result.getNumberOfParameters() = 2 and
    result.getParameter(0).getType() = this.getTypeParameter(0) and
    result.getParameter(1).getType() = this.getTypeParameter(0) and
    result.getReturnType() instanceof IntType
  }
}

/** The `System.Collections.Generic.IEqualityComparer<>` interface. */
class SystemCollectionsGenericIEqualityComparerTInterface extends SystemCollectionsGenericUnboundGenericInterface {
  SystemCollectionsGenericIEqualityComparerTInterface() { this.hasName("IEqualityComparer<>") }

  /** Gets the `bool Equals(T, T)` method. */
  Method getEqualsMethod() {
    result.getDeclaringType() = this and
    result.hasName("Equals") and
    result.getNumberOfParameters() = 2 and
    result.getParameter(0).getType() = this.getTypeParameter(0) and
    result.getParameter(1).getType() = this.getTypeParameter(0) and
    result.getReturnType() instanceof BoolType
  }
}

/** The `System.Collections.Generic.IEnumerable<>` interface. */
class SystemCollectionsGenericIEnumerableTInterface extends SystemCollectionsGenericUnboundGenericInterface {
  SystemCollectionsGenericIEnumerableTInterface() {
    this.hasName("IEnumerable<>") and
    this.getNumberOfTypeParameters() = 1
  }
}

/** Data flow for `System.Collections.Generic.IEnumerable<>`. */
private class SystemCollectionsGenericEnumerableTFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.Collections.Generic;IEnumerable<>;true;GetEnumerator;();;Element of Argument[-1];Property[System.Collections.Generic.IEnumerator<>.Current] of ReturnValue;value"
  }
}

/** The `System.Collections.Generic.IEnumerator<>` interface. */
class SystemCollectionsGenericIEnumeratorInterface extends SystemCollectionsGenericUnboundGenericInterface {
  SystemCollectionsGenericIEnumeratorInterface() {
    this.hasName("IEnumerator<>") and
    this.getNumberOfTypeParameters() = 1
  }

  /** Gets the `Current` property. */
  Property getCurrentProperty() {
    result.getDeclaringType() = this and
    result.hasName("Current") and
    result.getType() = this.getTypeParameter(0)
  }
}

/** The `System.Collections.Generic.IList<>` interface. */
class SystemCollectionsGenericIListTInterface extends SystemCollectionsGenericUnboundGenericInterface {
  SystemCollectionsGenericIListTInterface() {
    this.hasName("IList<>") and
    this.getNumberOfTypeParameters() = 1
  }
}

/** Data flow for `System.Collections.Generic.IList<>. */
private class SystemCollectionsGenericIListTFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections.Generic;IList<>;true;Insert;(System.Int32,T);;Argument[1];Element of Argument[-1];value",
        "System.Collections.Generic;IList<>;true;get_Item;(System.Int32);;Element of Argument[-1];ReturnValue;value",
        "System.Collections.Generic;IList<>;true;set_Item;(System.Int32,T);;Argument[1];Element of Argument[-1];value",
      ]
  }
}

/** The `System.Collections.Generic.List<>` class. */
class SystemCollectionsGenericListClass extends SystemCollectionsGenericUnboundGenericClass {
  SystemCollectionsGenericListClass() {
    this.hasName("List<>") and
    this.getNumberOfTypeParameters() = 1
  }
}

/** Data flow for `System.Collections.Generic.List<>. */
private class SystemCollectionsGenericListFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections.Generic;List<>;false;AddRange;(System.Collections.Generic.IEnumerable<T>);;Element of Argument[0];Element of Argument[-1];value",
        "System.Collections.Generic;List<>;false;AsReadOnly;();;Element of Argument[0];Element of ReturnValue;value",
        "System.Collections.Generic;List<>;false;Find;(System.Predicate<T>);;Element of Argument[-1];Parameter[0] of Argument[0];value",
        "System.Collections.Generic;List<>;false;Find;(System.Predicate<T>);;Element of Argument[-1];ReturnValue;value",
        "System.Collections.Generic;List<>;false;FindAll;(System.Predicate<T>);;Element of Argument[-1];Parameter[0] of Argument[0];value",
        "System.Collections.Generic;List<>;false;FindAll;(System.Predicate<T>);;Element of Argument[-1];ReturnValue;value",
        "System.Collections.Generic;List<>;false;FindLast;(System.Predicate<T>);;Element of Argument[-1];Parameter[0] of Argument[0];value",
        "System.Collections.Generic;List<>;false;FindLast;(System.Predicate<T>);;Element of Argument[-1];ReturnValue;value",
        "System.Collections.Generic;List<>;false;GetEnumerator;();;Element of Argument[-1];Property[System.Collections.Generic.List<>+Enumerator.Current] of ReturnValue;value",
        "System.Collections.Generic;List<>;false;GetRange;(System.Int32,System.Int32);;Element of Argument[0];Element of ReturnValue;value",
        "System.Collections.Generic;List<>;false;InsertRange;(System.Int32,System.Collections.Generic.IEnumerable<T>);;Element of Argument[1];Element of Argument[-1];value",
        "System.Collections.Generic;List<>;false;Reverse;();;Element of Argument[0];Element of ReturnValue;value",
        "System.Collections.Generic;List<>;false;Reverse;(System.Int32,System.Int32);;Element of Argument[0];Element of ReturnValue;value",
      ]
  }
}

/** The `System.Collections.Generic.KeyValuePair<,>` structure. */
class SystemCollectionsGenericKeyValuePairStruct extends SystemCollectionsGenericUnboundGenericStruct {
  SystemCollectionsGenericKeyValuePairStruct() {
    this.hasName("KeyValuePair<,>") and
    this.getNumberOfTypeParameters() = 2
  }

  /** Gets the `Key` property. */
  Property getKeyProperty() {
    result.getDeclaringType() = this and
    result.hasName("Key") and
    result.getType() = this.getTypeParameter(0)
  }

  /** Gets the `Value` property. */
  Property getValueProperty() {
    result.getDeclaringType() = this and
    result.hasName("Value") and
    result.getType() = this.getTypeParameter(1)
  }
}

/** Data flow for `System.Collections.Generic.KeyValuePair<,>`. */
private class SystemCollectionsGenericKeyValuePairStructFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections.Generic;KeyValuePair<,>;false;KeyValuePair;(TKey,TValue);;Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of ReturnValue;value",
        "System.Collections.Generic;KeyValuePair<,>;false;KeyValuePair;(TKey,TValue);;Argument[1];Property[System.Collections.Generic.KeyValuePair<,>.Value] of ReturnValue;value"
      ]
  }
}

/** The `System.Collections.Generic.ICollection<>` interface. */
class SystemCollectionsGenericICollectionInterface extends SystemCollectionsGenericUnboundGenericInterface {
  SystemCollectionsGenericICollectionInterface() { this.hasName("ICollection<>") }

  /** Gets the `Count` property. */
  Property getCountProperty() { result = this.getProperty("Count") }

  /** Gets the `Clear` method. */
  Method getClearMethod() { result = this.getAMethod("Clear") }

  /** Gets the `Add` method. */
  Method getAddMethod() { result = this.getAMethod("Add") }
}

/** Data flow for `System.Collections.Generic.ICollection<>`. */
private class SystemCollectionsGenericICollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections.Generic;ICollection<>;true;Add;(T);;Argument[0];Element of Argument[-1];value",
        "System.Collections.Generic;ICollection<>;true;CopyTo;(T[],System.Int32);;Element of Argument[-1];Element of Argument[0];value",
      ]
  }
}

/** The `System.Collections.Generic.IList<>` interface. */
class SystemCollectionsGenericIListInterface extends SystemCollectionsGenericUnboundGenericInterface {
  SystemCollectionsGenericIListInterface() { this.hasName("IList<>") }
}

/** The `System.Collections.Generic.IDictionary<>` interface. */
class SystemCollectionsGenericIDictionaryInterface extends SystemCollectionsGenericUnboundGenericInterface {
  SystemCollectionsGenericIDictionaryInterface() {
    this.hasName("IDictionary<,>") and
    this.getNumberOfTypeParameters() = 2
  }
}

/** Data flow for `System.Collections.Generic.IDictionary<,>`. */
private class SystemCollectionsGenericIDictionaryFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections.Generic;IDictionary<,>;true;Add;(TKey,TValue);;Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[-1];value",
        "System.Collections.Generic;IDictionary<,>;true;Add;(TKey,TValue);;Argument[1];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[-1];value",
        "System.Collections.Generic;IDictionary<,>;true;get_Item;(TKey);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[-1];ReturnValue;value",
        "System.Collections.Generic;IDictionary<,>;true;get_Keys;();;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[-1];Element of ReturnValue;value",
        "System.Collections.Generic;IDictionary<,>;true;get_Values;();;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[-1];Element of ReturnValue;value",
        "System.Collections.Generic;IDictionary<,>;true;set_Item;(TKey,TValue);;Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[-1];value",
        "System.Collections.Generic;IDictionary<,>;true;set_Item;(TKey,TValue);;Argument[1];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[-1];value",
      ]
  }
}

/** Data flow for `System.Collections.Generic.Dictionary<,>`. */
private class SystemCollectionsGenericDictionaryFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections.Generic;Dictionary<,>+KeyCollection;false;GetEnumerator;();;Element of Argument[-1];Property[System.Collections.Generic.Dictionary<,>+KeyCollection+Enumerator.Current] of ReturnValue;value",
        "System.Collections.Generic;Dictionary<,>+ValueCollection;false;GetEnumerator;();;Element of Argument[-1];Property[System.Collections.Generic.Dictionary<,>+ValueCollection+Enumerator.Current] of ReturnValue;value",
        "System.Collections.Generic;Dictionary<,>;false;Add;(System.Collections.Generic.KeyValuePair<TKey,TValue>);;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[-1];value",
        "System.Collections.Generic;Dictionary<,>;false;Add;(System.Collections.Generic.KeyValuePair<TKey,TValue>);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[-1];value",
        "System.Collections.Generic;Dictionary<,>;false;Dictionary;(System.Collections.Generic.IDictionary<TKey,TValue>);;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of ReturnValue;value",
        "System.Collections.Generic;Dictionary<,>;false;Dictionary;(System.Collections.Generic.IDictionary<TKey,TValue>);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of ReturnValue;value",
        "System.Collections.Generic;Dictionary<,>;false;Dictionary;(System.Collections.Generic.IDictionary<TKey,TValue>,System.Collections.Generic.IEqualityComparer<TKey>);;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of ReturnValue;value",
        "System.Collections.Generic;Dictionary<,>;false;Dictionary;(System.Collections.Generic.IDictionary<TKey,TValue>,System.Collections.Generic.IEqualityComparer<TKey>);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of ReturnValue;value",
        "System.Collections.Generic;Dictionary<,>;false;Dictionary;(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey,TValue>>);;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of ReturnValue;value",
        "System.Collections.Generic;Dictionary<,>;false;Dictionary;(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey,TValue>>);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of ReturnValue;value",
        "System.Collections.Generic;Dictionary<,>;false;Dictionary;(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey,TValue>>,System.Collections.Generic.IEqualityComparer<TKey>);;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of ReturnValue;value",
        "System.Collections.Generic;Dictionary<,>;false;Dictionary;(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey,TValue>>,System.Collections.Generic.IEqualityComparer<TKey>);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of ReturnValue;value",
        "System.Collections.Generic;Dictionary<,>;false;GetEnumerator;();;Element of Argument[-1];Property[System.Collections.Generic.Dictionary<,>+Enumerator.Current] of ReturnValue;value",
        "System.Collections.Generic;Dictionary<,>;false;get_Keys;();;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[-1];Element of ReturnValue;value",
        "System.Collections.Generic;Dictionary<,>;false;get_Values;();;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[-1];Element of ReturnValue;value",
      ]
  }
}

/** Data flow for `System.Collections.Generic.SortedDictionary<,>. */
private class SystemCollectionsGenericSortedDictionaryFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections.Generic;SortedDictionary<,>+KeyCollection;false;GetEnumerator;();;Element of Argument[-1];Property[System.Collections.Generic.SortedDictionary<,>+KeyCollection+Enumerator.Current] of ReturnValue;value",
        "System.Collections.Generic;SortedDictionary<,>+ValueCollection;false;GetEnumerator;();;Element of Argument[-1];Property[System.Collections.Generic.SortedDictionary<,>+ValueCollection+Enumerator.Current] of ReturnValue;value",
        "System.Collections.Generic;SortedDictionary<,>;false;Add;(System.Collections.Generic.KeyValuePair<TKey,TValue>);;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[-1];value",
        "System.Collections.Generic;SortedDictionary<,>;false;Add;(System.Collections.Generic.KeyValuePair<TKey,TValue>);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[-1];value",
        "System.Collections.Generic;SortedDictionary<,>;false;GetEnumerator;();;Element of Argument[-1];Property[System.Collections.Generic.SortedDictionary<,>+Enumerator.Current] of ReturnValue;value",
        "System.Collections.Generic;SortedDictionary<,>;false;SortedDictionary;(System.Collections.Generic.IDictionary<TKey,TValue>);;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of ReturnValue;value",
        "System.Collections.Generic;SortedDictionary<,>;false;SortedDictionary;(System.Collections.Generic.IDictionary<TKey,TValue>);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of ReturnValue;value",
        "System.Collections.Generic;SortedDictionary<,>;false;SortedDictionary;(System.Collections.Generic.IDictionary<TKey,TValue>,System.Collections.Generic.IComparer<TKey>);;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of ReturnValue;value",
        "System.Collections.Generic;SortedDictionary<,>;false;SortedDictionary;(System.Collections.Generic.IDictionary<TKey,TValue>,System.Collections.Generic.IComparer<TKey>);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of ReturnValue;value",
        "System.Collections.Generic;SortedDictionary<,>;false;get_Keys;();;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[-1];Element of ReturnValue;value",
        "System.Collections.Generic;SortedDictionary<,>;false;get_Values;();;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[-1];Element of ReturnValue;value",
      ]
  }
}

/** Data flow for `System.Collections.Generic.SortedList<,>. */
private class SystemCollectionsGenericSortedListFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections.Generic;SortedList<,>;false;Add;(System.Collections.Generic.KeyValuePair<TKey,TValue>);;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[-1];value",
        "System.Collections.Generic;SortedList<,>;false;Add;(System.Collections.Generic.KeyValuePair<TKey,TValue>);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[-1];value",
        "System.Collections.Generic;SortedList<,>;false;GetEnumerator;();;Element of Argument[-1];Property[System.Collections.Generic.IEnumerator<>.Current] of ReturnValue;value",
        "System.Collections.Generic;SortedList<,>;false;SortedList;(System.Collections.Generic.IDictionary<TKey,TValue>);;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of ReturnValue;value",
        "System.Collections.Generic;SortedList<,>;false;SortedList;(System.Collections.Generic.IDictionary<TKey,TValue>);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of ReturnValue;value",
        "System.Collections.Generic;SortedList<,>;false;SortedList;(System.Collections.Generic.IDictionary<TKey,TValue>,System.Collections.Generic.IComparer<TKey>);;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of ReturnValue;value",
        "System.Collections.Generic;SortedList<,>;false;SortedList;(System.Collections.Generic.IDictionary<TKey,TValue>,System.Collections.Generic.IComparer<TKey>);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of ReturnValue;value",
        "System.Collections.Generic;SortedList<,>;false;get_Keys;();;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[-1];Element of ReturnValue;value",
        "System.Collections.Generic;SortedList<,>;false;get_Values;();;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[-1];Element of ReturnValue;value",
      ]
  }
}

/** Data flow for `System.Collections.Generic.Queue<>. */
private class SystemCollectionsGenericQueueFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections.Generic;Queue<>;false;CopyTo;(T[],System.Int32);;Element of Argument[-1];Element of Argument[0];value",
        "System.Collections.Generic;Queue<>;false;GetEnumerator;();;Element of Argument[-1];Property[System.Collections.Generic.Queue<>+Enumerator.Current] of ReturnValue;value",
        "System.Collections.Generic;Queue<>;false;Peek;();;Element of Argument[-1];ReturnValue;value",
      ]
  }
}

/** Data flow for `System.Collections.Generic.Stack<>. */
private class SystemCollectionsGenericStackFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections.Generic;Stack<>;false;CopyTo;(T[],System.Int32);;Element of Argument[-1];Element of Argument[0];value",
        "System.Collections.Generic;Stack<>;false;GetEnumerator;();;Element of Argument[-1];Property[System.Collections.Generic.Stack<>+Enumerator.Current] of ReturnValue;value",
        "System.Collections.Generic;Stack<>;false;Peek;();;Element of Argument[-1];ReturnValue;value",
        "System.Collections.Generic;Stack<>;false;Pop;();;Element of Argument[-1];ReturnValue;value",
      ]
  }
}

/** Data flow for `System.Collections.Generic.HashSet<>. */
private class SystemCollectionsGenericHashSetFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.Collections.Generic;HashSet<>;false;GetEnumerator;();;Element of Argument[-1];Property[System.Collections.Generic.HashSet<>+Enumerator.Current] of ReturnValue;value"
  }
}

/** Data flow for `System.Collections.Generic.ISet<>. */
private class SystemCollectionsGenericISetFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.Collections.Generic;ISet<>;true;Add;(T);;Argument[0];Element of Argument[-1];value"
  }
}

/** Data flow for `System.Collections.Generic.LinkedList<>. */
private class SystemCollectionsGenericLinkedListFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections.Generic;LinkedList<>;false;Find;(T);;Element of Argument[-1];ReturnValue;value",
        "System.Collections.Generic;LinkedList<>;false;FindLast;(T);;Element of Argument[-1];ReturnValue;value",
        "System.Collections.Generic;LinkedList<>;false;GetEnumerator;();;Element of Argument[-1];Property[System.Collections.Generic.LinkedList<>+Enumerator.Current] of ReturnValue;value",
      ]
  }
}

/** Data flow for `System.Collections.Generic.SortedSet<>. */
private class SystemCollectionsGenericSortedSetFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Collections.Generic;SortedSet<>;false;GetEnumerator;();;Element of Argument[-1];Property[System.Collections.Generic.SortedSet<>+Enumerator.Current] of ReturnValue;value",
        "System.Collections.Generic;SortedSet<>;false;Reverse;();;Element of Argument[0];Element of ReturnValue;value",
      ]
  }
}
