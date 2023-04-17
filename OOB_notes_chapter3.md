## Equivalence ##

`==` is a method call and not a built in operator.
 When we build our own `==` in a class we also get `!=` for free.

`equal?` looks if the argument points at the same object or  space in memory as the object it was called upon.

`===` compares two objects, it's essentially asking if the argument of the method call is in the group of things of the object that it was called upon.
 `===` in Ruby is not same as in JavaScript

`eql?` determines if two objects contain the same value and if they're in the same class.

* for most objects, the == operator compares the values of the objects, and is frequently used.
* the == operator is actually a method. Most built-in Ruby classes, like Array, String, Integer, etc. provide their own == method to specify how to compare objects of those classes.
* by default, BasicObject#== does not perform an equality check; instead, it returns true if two objects are the same object. This is why other classes often provide their own behavior for #==.
* if you need to compare custom objects, you should define the == method.


## Variable Scope ##

Instance variable are variables that start with `@` and are scoped at the object level. They do not cross over between objects.
Instance variables scope is at the object level. This means that the instance variable is accessible in the object's instance, even if it's initialized outside of that instance method.

Class variables start with `@@` and are scoped at the class level.
All objects share 1 copy of the class variable.
Class methods can access class variables, regardless of where it's initialized.

Constant variables are usually just constants, because you're not supposed to re-assign them to a different value.
Constants begin with a capital letter and have lexical scope.
Lexical scope means that where the constant is defined in the source code determines where it is available.