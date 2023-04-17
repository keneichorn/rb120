## Different Variables ##
1. `@` before the variable name signifies a instance variable
2. `@@` before the variable name signifies a class variable
3. all caps signifies a constant variable
4. `$` before the variable name signifies a global variable

## Object level ##
* Objects do not share state between other objects, but do share behaviors.
* Put another way, the values in the objects' instance variables (states) are
    different, but they can call the same instance methods (behaviors) defined in the class

## Class level ##
* classes also have behaviors not for objects(class methods).

## Inheritance ##

  Inheritance is the process by which one class takes on the the attributes and 

methods of another, and it's used to express an `is-a` relationship.
 
For example, a cartoon fox is a cartoon mammal, so a CartoonFox class could 

inherit from a CartoonMammal class.

* sub-classing from parent class. Can only sub-class from 1 parent; used to model
    hierarchical inheritance.
* mixing in modules. Can mix in as many modules as needed; Ruby's way of implementing
    multiple inheritance.
* understand how sub-classing or mixxing in modules affects the method lookup path


Invoking `super` without parentheses pass all arguments to the superclass.s

## Attributes ##

 As a mental model, you can think of attributes in the conteext of Ruby as instance variables(that usually have accessor methods). This isn't perfect, but close enough.

 Using self.getter_method tends to be safer than calling the instance variable directly. It is safer since using the instance variable bypasses any checks or operations performed by the setter method. For instance, changing the "123"(string) to 123(integer) with .to_i method.

## Polymorphism ##

Polymorphism refers to the ability of different object types to respond to the same method invocation, often, but not always, in different ways.

In other words, data of different types can respond to a common interface.

  `Duck typing` occurs when objects of different unrelated types both resond to the same method name.

## Encapsulation ##

Encapsulation lets us hide the internal representation of an object from the outside and only expose the methods and properties that users of the object need. 


## notes ##

1. Classes define an essence for objects, consisting of attributes and behaviours.

2. Objects are instantiated from classes and are predetermined by the class definition.

3. An object’s state tracks the attributes of the class, and an object’s instance variables keep track of its state.

4. Class behaviours predetermine the instance methods accessible to every particular object of the class.

5. Class attributes predetermine the instance variables pertaining to every particular object of the class.

6. Attributes may posses two contingent behavioural properties, and the contingency of these two properties is a precondition for encapsulation.