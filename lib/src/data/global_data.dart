library my_prj.globals;

import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

String baseUrl = 'http://localhost:3000/v1';

// String baseUrl = 'http://192.168.0.109:3000/v1';

///////////////////////////////////////////////////////////////////////////
//////////////////////////////// CONTENTS /////////////////////////////////
///////////////////////////////////////////////////////////////////////////

final designPatternsContents = <String, List<Widget>>{
  'History of Design Patterns': [
    buildHeading('History of Design Patterns'),
    buildParagraph(
        "Who invented patterns? That’s a good, but not a very accurate, question. Design patterns aren’t obscure, sophisticated concepts—quite the opposite. Patterns are typical solutions to common problems in object-oriented design. When a solution gets repeated over and over in various projects, someone eventually puts a name to it and describes the solution in detail. That’s basically how a pattern gets discovered."),
    buildParagraph(
        "The concept of patterns was first described by Christopher Alexander in A Pattern Language: Towns, Buildings, Construction. The book describes a “language” for designing the urban environment. The units of this language are patterns. They may describe how high windows should be, how many levels a building should have, how large green areas in a neighborhood are supposed to be, and so on."),
    buildParagraph(
        "The idea was picked up by four authors: Erich Gamma, John Vlissides, Ralph Johnson, and Richard Helm. In 1994, they published Design Patterns: Elements of Reusable Object-Oriented Software, in which they applied the concept of design patterns to programming. The book featured 23 patterns solving various problems of object-oriented design and became a best-seller very quickly. Due to its lengthy name, people started to call it “the book by the gang of four” which was soon shortened to simply “the GoF book”."),
    buildParagraph(
        "Since then, dozens of other object-oriented patterns have been discovered. The “pattern approach” became very popular in other programming fields, so lots of other patterns now exist outside of object-oriented design as well."),
  ],
  'Why should I learn Design Patterns?': [
    buildHeading('Why should I learn Design Patterns?'),
    buildParagraph(
        "The truth is that you might manage to work as a programmer for many years without knowing about a single pattern. A lot of people do just that. Even in that case, though, you might be implementing some patterns without even knowing it. So why would you spend time learning them?"),
    buildParagraph(
        "Design patterns are a toolkit of tried and tested solutions to common problems in software design. Even if you never encounter these problems, knowing patterns is still useful because it teaches you how to solve all sorts of problems using principles of object-oriented design."),
    buildParagraph(
        "Design patterns define a common language that you and your teammates can use to communicate more efficiently. You can say, “Oh, just use a Singleton for that,” and everyone will understand the idea behind your suggestion. No need to explain what a singleton is if you know the pattern and its name."),
  ],
  'Criticism of patterns': [
    buildHeading('Criticism of patterns'),
    buildParagraph(
        "It seems like only lazy people haven’t criticized design patterns yet. Let’s take a look at the most typical arguments against using patterns."),
    buildParagraph("Kludges for a weak programming language"),
    buildParagraph(
        "Usually the need for patterns arises when people choose a programming language or a technology that lacks the necessary level of abstraction. In this case, patterns become a kludge that gives the language much-needed super-abilities."),
    buildParagraph(
        "For example, the Strategy pattern can be implemented with a simple anonymous (lambda) function in most modern programming languages."),
    buildParagraph("Inefficient solutions"),
    buildParagraph(
        "Patterns try to systematize approaches that are already widely used. This unification is viewed by many as a dogma, and they implement patterns “to the letter”, without adapting them to the context of their project."),
  ],
  'Classification of patterns': [
    buildHeading('Classification of patterns'),
    buildParagraph(
        "Design patterns differ by their complexity, level of detail and scale of applicability to the entire system being designed. I like the analogy to road construction: you can make an intersection safer by either installing some traffic lights or building an entire multi-level interchange with underground passages for pedestrians."),
    buildParagraph(
        "The most basic and low-level patterns are often called idioms. They usually apply only to a single programming language."),
    buildParagraph(
        "The most universal and high-level patterns are architectural patterns. Developers can implement these patterns in virtually any language. Unlike other patterns, they can be used to design the architecture of an entire application."),
    buildParagraph(
        "In addition, all patterns can be categorized by their intent, or purpose. This book covers three main groups of patterns."),
  ],
};

final contents = <String, List<Widget>>{
  'Factory Method': [
    buildHeading('Intent'),
    buildParagraph(
        'Factory Method is a creational design pattern that provides an interface for creating objects in a superclass, but allows subclasses to alter the type of objects that will be created.'),
    buildImage(
      'https://refactoring.guru/images/patterns/content/factory-method/factory-method-en-2x.png',
    ),
    buildHeading('Problem'),
    buildParagraph(
        'Imagine that you’re creating a logistics management application. The first version of your app can only handle transportation by trucks, so the bulk of your code lives inside the Truck class.'),
    buildParagraph(
        'After a while, your app becomes pretty popular. Each day you receive dozens of requests from sea transportation companies to incorporate their ships into the app. Another dozen requests come from train companies.'),
    buildParagraph(
        'In the end, you have no choice but to support all types of transportation. However, you can’t just go on stuffing your main class with conditional branches that check the transportation method requested by the client code.'),
    buildParagraph(
        'At some point, this code will become unwieldy, unmanageable, and filled with conditional statements. Adding new transportation methods will require changes to the main class, which will result in changes to other parts of the code.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/factory-method/problem1-en-2x.png'),
    buildHeading('Solution'),
    buildParagraph(
        'The Factory Method pattern suggests that you replace direct object construction calls (using the new operator) with calls to a special factory method. Don’t worry: the objects are still created via the new operator, but it’s being called from within the factory method.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/factory-method/solution1-2x.png'),
    buildParagraph(
        'At first glance, this change may look pointless: we just moved the constructor call from one part of the program to another. However, consider this: now you can override the factory method in a subclass and change the class of objects that will be created by the original method.'),
    buildParagraph(
        'There\'s a slight limitation to this pattern. The factory method in the base class should be abstract. This way, the subclasses are forced to implement it. If the base class returns an actual object, it would be impossible to override a creation process from the subclass.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/factory-method/solution2-en-2x.png'),
    buildParagraph(
        'For example, both Truck and Ship classes should implement the Transport interface, which declares a method called deliver. Each class implements this method differently: trucks deliver cargo by land, ships deliver cargo by sea. The factory method in the RoadLogistics class returns truck objects, whereas the factory method in the SeaLogistics class returns ships.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/factory-method/solution3-en-2x.png'),
    buildHeading('How to Implement'),
    buildParagraph(
        '1. Make all products follow the same interface. This interface should declare methods that make sense in every product.'),
    buildParagraph(
        '2. Declare the factory method in the base class. The return type of the method should match the common product interface.'),
    buildParagraph(
        '3. Implement a set of concrete products. Each concrete product must implement the product interface.'),
    buildParagraph(
        '4. Create a concrete creator class and implement the factory method. This method should return a new concrete product each time it’s called.'),
    buildParagraph('5. Optionally, the factory method can be made static.'),
    buildParagraph(
        '6. Consider adding a parameter to the factory method so that it can return different types of products.'),
    buildParagraph(
        '7. The client code calls the factory method to create a product object.'),
  ],
  'Abstract Factory': [
    buildHeading('Intent'),
    buildParagraph(
        'Abstract Factory is a creational design pattern that lets you produce families of related objects without specifying their concrete classes.'),
    buildImage(
        'https://refactoring.guru/images/patterns/content/abstract-factory/abstract-factory-en-2x.png'),
    buildHeading('Problem'),
    buildParagraph(
        'Imagine that you’re creating a furniture shop simulator. Your code consists of classes that represent:'),
    buildParagraph('1. A family of related products, say: Chair and Sofa.'),
    buildParagraph(
        '2. Several variants of this family. For example, products Chair and Sofa are available in these variants: Modern, Victorian, ArtDeco.'),
    buildParagraph(
        'You need a way to create individual furniture objects so that they match other objects of the same family. Customers get quite mad when they receive non-matching furniture.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/abstract-factory/problem-en-2x.png'),
    buildHeading('Solution'),
    buildParagraph(
        'The Abstract Factory pattern suggests that you create a separate factory interface for each product family. A factory is a class that returns products of a particular kind. All products of a factory belong to a single variant.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/abstract-factory/solution1-2x.png'),
    buildParagraph(
        'The client code has to work with both factories and products via their respective abstract interfaces. This lets you change the type of factory that you pass to the client code, as well as the product variant that the client code receives, without breaking the actual client code.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/abstract-factory/solution2-2x.png'),
    buildParagraph(
        'For example, the client code that uses a ModernFurnitureFactory object will create ModernChair and ModernSofa objects, whereas the same client code with a VictorianFurnitureFactory object will create VictorianChair and VictorianSofa objects.'),
    buildImage(
        'https://refactoring.guru/images/patterns/content/abstract-factory/abstract-factory-comic-2-en-2x.png'),
    buildHeading('How to Implement'),
    buildParagraph(
        '1. Declare interfaces for each distinct product of the product family.'),
    buildParagraph(
        '2. Declare the abstract factory interface with a set of creation methods for all products that are part of the product family.'),
    buildParagraph(
        '3. Implement a set of concrete product classes. Each concrete product class must implement the product interface declared by the abstract product interfaces.'),
    buildParagraph(
        '4. Implement a set of concrete factory classes. Each concrete factory class must implement the factory interface by creating the same set of products. The factory is responsible for returning products of one variant only.'),
    buildParagraph(
        '5. The client code must work with both factories and products via their respective abstract interfaces. This lets you change the type of factory that you pass to the client code, as well as the product variant that the client code receives, without breaking the actual client code.'),
  ],
  'Builder': [
    buildHeading('Intent'),
    buildParagraph(
        'Builder is a creational design pattern that lets you construct complex objects step by step. The pattern allows you to produce different types and representations of an object using the same construction code.'),
    buildImage(
        'https://refactoring.guru/images/patterns/content/builder/builder-en-2x.png'),
    buildHeading('Problem'),
    buildParagraph(
        'Imagine a complex object that requires laborious, step-by-step initialization of many fields and nested objects. Such initialization code is usually buried inside a monstrous constructor with lots of parameters. Or even worse: scattered all over the client code.'),
    buildParagraph(
        'The object construction code is very complex. Various pieces of the code must be executed in a particular order, at the right time, to produce a properly initialized object. The construction process can’t be easily reused in other parts of the program.'),
    buildParagraph(
        'For example, let’s think about how to create a House object. To build a simple house, you need to construct four walls and a floor, install a door, fit a pair of windows, and build a roof. But what if you want a bigger house with a swimming pool, a garden, and fancy furniture? The construction code will grow out of control, and the House class will become unmanageable.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/builder/problem2-2x.png'),
    buildHeading('Solution'),
    buildParagraph(
        'The Builder pattern suggests that you extract the object construction code out of its own class and move it to separate objects called builders.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/builder/solution1-2x.png'),
    buildParagraph(
        'The pattern organizes object construction into a set of steps (for example: wall construction and roof construction). To create an object, you execute a series of these steps on a builder object. The important part is that you don’t need to call all of the steps. You can call only those steps that are necessary for producing a particular configuration of an object.'),
    buildImage(
        'https://refactoring.guru/images/patterns/content/builder/builder-comic-1-en-2x.png'),
    buildParagraph(
        'When you’re done, the builder object will provide you with the desired object already fully initialized.'),
  ],
  'Prototype': [
    buildHeading('Intent'),
    buildParagraph(
        'Prototype is a creational design pattern that lets you copy existing objects without making your code dependent on their classes.'),
    buildImage(
        'https://refactoring.guru/images/patterns/content/prototype/prototype-2x.png'),
    buildHeading('Problem'),
    buildParagraph(
        'Say you have an object, and you want to create an exact copy of it. How would you do it? First, you have to create a new object of the same class. Then you have to go through all the fields of the original object and copy their values over to the new object.'),
    buildParagraph(
        'Nice, but there’s a catch. Not all objects can be copied that way because some of the object’s fields may be private and not visible from outside of the object itself.'),
    buildParagraph(
        'You could solve this problem by extending the object class and adding a copying method to the subclass. However, this solution isn’t always possible. For example, you might not have the ability to extend an object class, such as when working with an external library.'),
    buildImage(
        'https://refactoring.guru/images/patterns/content/prototype/prototype-comic-1-en-2x.png'),
    buildHeading('Solution'),
    buildParagraph(
        'The Prototype pattern delegates the cloning process to the actual objects that are being cloned. The pattern declares a common interface for all objects that support cloning. This interface lets you clone an object without coupling your code to the class of that object. Usually, such an interface contains just a single clone method.'),
    buildImage(
        'https://refactoring.guru/images/patterns/content/prototype/prototype-comic-2-en-2x.png'),
    buildParagraph(
        'This method creates a new object and passes it to the current object’s data. You can call the clone method on any object that follows the prototype interface, letting the objects copy themselves.'),
    buildImage(
        'https://refactoring.guru/images/patterns/content/prototype/prototype-comic-1-en-2x.png'),
    buildHeading('How to Implement'),
    buildParagraph(
        '1. Declare the clone method in the base class of the prototype hierarchy.'),
    buildParagraph(
        '2. Implement the clone method by delegating to the actual objects that need to be copied.'),
    buildParagraph(
        '3. Optionally, create a centralized prototype registry to store a catalog of frequently cloned objects.'),
    buildParagraph(
        '4. The client code must explicitly fetch prototypes from the registry and then call the clone method on them.'),
  ],
  'Singleton': [
    buildHeading('Intent'),
    buildParagraph(
        'Singleton is a creational design pattern that lets you ensure that a class has only one instance, while providing a global access point to this instance.'),
    buildImage(
        'https://refactoring.guru/images/patterns/content/singleton/singleton-2x.png'),
    buildHeading('Problem'),
    buildParagraph(
        'The Singleton pattern solves two problems at the same time, violating the Single Responsibility Principle:'),
    buildParagraph(
        '1. Ensure that a class has just a single instance. Why would anyone want to control how many instances a class has? The most common reason for this is to control access to some shared resource—for example, a database or a file.'),
    buildParagraph(
        '2. Provide a global access point to that instance. Remember those global variables that you (all right, your predecessors) used to store some essential objects? While they were the right solution at the time, they’re no longer the best option.'),
    buildParagraph(
        'But how can you be sure that a class has only a single instance and that the instance is easily accessible? How can you provide a global access point to that instance?'),
    buildImage(
        'https://refactoring.guru/images/patterns/content/singleton/singleton-comic-1-en-2x.png'),
    buildHeading('Solution'),
    buildParagraph(
        'All implementations of the Singleton have these two steps in common:'),
    buildParagraph(
        '1. Make the default constructor private, to prevent other objects from using the new operator with the Singleton class.'),
    buildParagraph(
        '2. Create a static creation method that acts as a constructor. Under the hood, this method calls the private constructor to create an object and saves it in a static field. All following calls to this method return the cached object.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/singleton/structure-en-2x.png'),
    buildParagraph(
        'If your code has access to the Singleton class, then it’s able to call the Singleton::getInstance method. So when would you use this method? The most common use is when you need a single point of access to a database or a file or some other resource.'),
  ],
  'Adapter': [
    buildHeading('Intent'),
    buildParagraph(
        'Adapter is a structural design pattern that allows objects with incompatible interfaces to collaborate.'),
    buildImage(
        'https://refactoring.guru/images/patterns/content/adapter/adapter-en-2x.png'),
    buildHeading('Problem'),
    buildParagraph(
        'Imagine that you’re creating a stock market monitoring app. You have a class that can fetch the data from a data provider. The data provider supplies the data in JSON format. You create a set of classes to fetch the data and render it on the screen.'),
    buildParagraph(
        'At some point, you decide to improve the app by integrating a third-party analytics library. But there’s a catch: the analytics library expects the data in XML format.'),
    buildParagraph(
        'You could change the library to work with JSON. However, this might not be possible, such as when you don’t have access to the library’s source code.'),
    buildParagraph(
        'You could create a new set of classes to work with XML. However, this might be a lot of work, especially if the app is large and the class already has lots of methods.'),
    buildParagraph(
        'You could create an adapter. This is a special object that converts the interface of one object so that another object can understand it.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/adapter/problem-en-2x.png'),
    buildHeading('Solution'),
    buildParagraph(
        'The Adapter pattern suggests that you create a new class that acts as a wrapper to an existing class. This wrapper class is usually called an adapter. The adapter contains an instance of the class it wraps. When the wrapper receives a call, it translates the incoming method call into something that the wrapped class can understand.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/adapter/solution-en-2x.png'),
    buildParagraph(
        'The adapter pattern allows otherwise incompatible classes to work together by converting the interface of one class into an interface expected by the clients.'),
    buildImage(
        'https://refactoring.guru/images/patterns/content/adapter/adapter-comic-1-en-2x.png'),
    buildHeading('How to Implement'),
    buildParagraph(
        '1. Make sure that you have at least two classes with incompatible interfaces'),
    buildParagraph(
        '2. Declare the client interface and describe how clients communicate with the service.'),
    buildParagraph(
        '3. Create the adapter class and make it follow the client interface. Leave all the methods empty for now.'),
    buildParagraph(
        '4. Add a field to the adapter class to store a reference to the service object. The common practice is to initialize this field via the constructor, but sometimes it’s more convenient to pass it to the adapter when calling its methods.'),
    buildParagraph(
        '5. One by one, implement all methods of the client interface in the adapter class. The adapter should delegate most of the real work to the service object, handling only the interface or data format conversion.'),
    buildParagraph(
        '6. Clients should use the adapter via the client interface. This will let you change or extend the adapters without affecting the client code.'),
  ],
  'Bridge': [
    buildHeading('Intent'),
    buildParagraph(
        'Bridge is a structural design pattern that lets you split a large class or a set of closely related classes into two separate hierarchies—abstraction and implementation—which can be developed independently of each other.'),
    buildImage(
        'https://refactoring.guru/images/patterns/content/bridge/bridge-2x.png'),
    buildHeading('Problem'),
    buildParagraph(
        'Imagine that you have a geometric Shape class with a pair of subclasses: Circle and Square. You want to extend this class hierarchy to incorporate colors, so you plan to create Red and Blue shape subclasses. However, since you already have two subclasses, you’ll need to create four class combinations such as BlueCircle and RedSquare.'),
    buildParagraph(
        'Adding new shape types and colors to the hierarchy will grow it exponentially. For example, to add a triangle shape you’d need to introduce two subclasses, one for each color. And after that, adding a new color would require creating three subclasses, one for each shape type. The further we go, the worse it becomes.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/bridge/problem-en-2x.png'),
    buildHeading('Solution'),
    buildParagraph(
        'The Bridge pattern suggests that you extract a part of an object into a separate class hierarchy that can vary independently of the original object. In our case, it’s the rendering behavior of the shape. By creating a set of bridge classes, you can change the behavior of the shape classes independently.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/bridge/solution-en-2x.png'),
    buildParagraph(
        'The Bridge pattern is especially useful when dealing with cross-platform apps, supporting multiple types of database servers, or working with several API providers of a certain kind.'),
  ],
  'Composite': [
    buildHeading('Intent'),
    buildParagraph(
        'Composite is a structural design pattern that lets you compose objects into tree structures to represent part-whole hierarchies. Composite lets clients treat individual objects and compositions of objects uniformly.'),
    buildImage(
        'https://refactoring.guru/images/patterns/content/composite/composite-2x.png'),
    buildHeading('Problem'),
    buildParagraph(
        'The Composite pattern is pretty common in graphical user interfaces. In a GUI, you can build a complex layout by combining simple UI components like panels, frames, and buttons. A UI component can either be a simple element or a composite of several elements. But from the client’s perspective, they’re all the same.'),
    buildParagraph(
        'The same applies to other areas. For example, you have a hierarchical structure of objects. Each object in the hierarchy can be a simple object or a composition of several objects. The client can treat both types uniformly without distinguishing between them.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/composite/problem-en-2x.png'),
    buildHeading('Solution'),
    buildParagraph(
        'The key idea of the Composite pattern is to treat both simple and complex objects uniformly. The solution is to define a common interface for all the objects in the hierarchy so that the client code can work with any of these objects without distinguishing between them.'),
    buildImage(
        'https://refactoring.guru/images/patterns/content/composite/composite-comic-1-en-2x.png'),
    buildParagraph(
        'When you have this interface, all the components become much easier to work with. The client code can treat complex and primitive objects uniformly, which considerably simplifies the client code.'),
  ],
  'Decorator': [
    buildHeading('Intent'),
    buildParagraph(
        'Decorator is a structural design pattern that lets you attach new behaviors to objects by placing these objects inside special wrapper objects that contain the new behaviors.'),
    buildImage(
        'https://refactoring.guru/images/patterns/content/decorator/decorator-2x.png'),
    buildHeading('Problem'),
    buildParagraph(
        'Imagine that you’re working on a notification library. The library lets you send notifications to users through various channels like email, SMS, and push notifications.'),
    buildParagraph(
        'At some point, you realize that the users might appreciate a new type of notification—sent with high-priority flags.'),
    buildParagraph(
        'The straightforward approach would be to extend the notification classes with new behavior. But what if you want to add some special behaviors to notifications based on their type? For example, you might want to log all email notifications.'),
    buildParagraph(
        'The Decorator pattern suggests that you create a new class that contains the original class and provides additional behavior. The new class should have the same methods as the original class. The original object is passed to the decorator via the constructor, while the methods are overridden to add new functionality.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/decorator/problem-en-2x.png'),
    buildHeading('Solution'),
    buildParagraph(
        'The Decorator pattern suggests that you create a new class that follows the original class’s interface and contains a pointer to the original object. The decorator delegates all work to the original object but can contain additional behavior.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/decorator/solution-en-2x.png'),
    buildParagraph(
        'The decorator receives all the client calls and redirects them to the wrapped object. As a result, the decorators can execute their behavior either before or after the call to the wrapped object.'),
  ],
  'Facade': [
    buildHeading('Intent'),
    buildParagraph(
        'Facade is a structural design pattern that provides a simplified interface to a library, a framework, or any other complex set of classes.'),
    buildImage(
        'https://refactoring.guru/images/patterns/content/facade/facade-2x.png'),
    buildHeading('Problem'),
    buildParagraph(
        'Imagine that you must make your code work with a broad set of objects that belong to a sophisticated library or framework. Ordinarily, you’d need to initialize all of those objects, keep track of dependencies, execute methods in the correct order, and so on.'),
    buildParagraph(
        'As a result, the business logic of your classes would become tightly coupled to the implementation details of the library or framework.'),
    buildParagraph(
        'As a result, the business logic of your classes would become tightly coupled to the implementation details of the library or framework.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/facade/problem-en-2x.png'),
    buildHeading('Solution'),
    buildParagraph(
        'The Facade pattern suggests that you add a new class that provides a simplified, unified interface to a set of complex classes.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/facade/solution-en-2x.png'),
    buildParagraph(
        'The Facade object provides a single, simplified interface to the more general facilities of a subsystem. It delegates the client requests to appropriate objects within the subsystem. The Facade is also responsible for managing their lifecycle. All of this shields the client from the undesired complexity of the subsystem.'),
  ],
  'Flyweight': [
    buildHeading('Intent'),
    buildParagraph(
        'Flyweight is a structural design pattern that lets you fit more objects into the available amount of RAM by sharing common parts of state between multiple objects instead of keeping all of the data in each object.'),
    buildImage(
        'https://refactoring.guru/images/patterns/content/flyweight/flyweight-2x.png'),
    buildHeading('Problem'),
    buildParagraph(
        'The Flyweight pattern is pretty useful when you need to create a vast number of similar objects. At some point, the memory consumption could become critical, and the application starts running much slower due to the sheer amount of data that needs to be processed.'),
    buildParagraph(
        'If you’ve ever used graphic editors like CorelDRAW or Photoshop, you’ll know they can handle an impressive number of objects. Each object in a graphic editor is a graphical primitive that can be selected, moved, transformed, and many other things. These programs can easily work with documents containing hundreds of megabytes of raster or vector data.'),
    buildParagraph(
        'But what if each of these objects consumes just a few bytes of memory, and the whole document is huge? You might not even have enough RAM to open it, not to mention making some changes.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/flyweight/problem-en-2x.png'),
    buildHeading('Solution'),
    buildParagraph(
        'The Flyweight pattern suggests that you stop storing the extrinsic state inside the object. Instead, you should pass this state to specific methods which work with this state.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/flyweight/solution-en-2x.png'),
    buildParagraph(
        'The Flyweight object’s methods must be able to work with the extrinsic state that clients pass to them. For the Flyweight pattern to work, you should move the extrinsic state outside the object into the client object. The client object is responsible for computing or fetching the extrinsic state and passing it to the flyweight’s methods.'),
  ],
  'Proxy': [
    buildHeading('Intent'),
    buildParagraph(
        'Proxy is a structural design pattern that lets you provide a substitute or placeholder for another object. A proxy controls access to the original object, allowing you to perform something either before or after the request gets through to the original object.'),
    buildImage(
        'https://refactoring.guru/images/patterns/content/proxy/proxy-2x.png'),
    buildHeading('Problem'),
    buildParagraph(
        'The Proxy pattern suggests that you create a new proxy class with the same interface as an original service object. Then you update your app so that it passes the proxy object to all of the original object’s clients. Upon receiving a request from a client, the proxy creates a real service object and delegates all the work to it.'),
    buildParagraph(
        'But what’s the benefit? If you need to execute some actions before or after the primary logic of the class, the proxy lets you do this without changing that class. Since the proxy implements the same interface as the original class, it can be passed to any client that expects a real service object.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/proxy/problem-en-2x.png'),
    buildHeading('Solution'),
    buildParagraph(
        'The Proxy pattern suggests that you create a new proxy class with the same interface as an original service object. Then you update your app so that it passes the proxy object to all of the original object’s clients. Upon receiving a request from a client, the proxy creates a real service object and delegates all the work to it.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/proxy/solution-en-2x.png'),
    buildParagraph(
        'But what’s the benefit? If you need to execute some actions before or after the primary logic of the class, the proxy lets you do this without changing that class. Since the proxy implements the same interface as the original class, it can be passed to any client that expects a real service object.'),
  ],
  'Chain of Responsibility': [
    buildHeading('Intent'),
    buildParagraph(
        'Chain of Responsibility is a behavioral design pattern that lets you pass requests along a chain of handlers. Upon receiving a request, each handler decides either to process the request or to pass it along the chain.'),
    buildImage(
        'https://refactoring.guru/images/patterns/content/chain-of-responsibility/chain-of-responsibility-2x.png'),
    buildHeading('Problem'),
    buildParagraph(
        'Imagine that you’re working on an online ordering system. You want to restrict access to the system so only authenticated users can create orders. Also, users who have administrative access should be able to create orders for other users.'),
    buildParagraph(
        'The first part of the problem is easy to implement. You just create a middleware that restricts access to the system. But the second part is trickier. It’s not just the middleware that has to keep the system secure. The order processing pipeline should also know about user roles and permissions.'),
    buildParagraph(
        'Now imagine that you decide to add a new check. You need to make sure that the user has enough permissions to create orders with a particular value. You add a new check to the middleware and the processing pipeline. After a while, you notice that you have a lot of similar checks all over the codebase.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/chain-of-responsibility/problem-en-2x.png'),
    buildHeading('Solution'),
    buildParagraph(
        'The Chain of Responsibility pattern suggests that you build a chain of objects that inspect a request. Each object in the chain has a reference to the next object in the chain. If an object can handle the request, it does so; otherwise, it passes the request to the next object in the chain.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/chain-of-responsibility/solution-en-2x.png'),
    buildParagraph(
        'The pattern allows multiple objects to handle the request without coupling sender classes to the concrete classes of the receivers. The chain can be composed dynamically at runtime with any handler that follows a standard handler interface.'),
  ],
  'Command': [
    buildHeading('Intent'),
    buildParagraph(
        'Command is a behavioral design pattern that turns a request into a stand-alone object that contains all information about the request. This transformation lets you parameterize methods with different requests, delay or queue a request’s execution, and support undoable operations.'),
    buildImage(
        'https://refactoring.guru/images/patterns/content/command/command-2x.png'),
    buildHeading('Problem'),
    buildParagraph(
        'Imagine that you’re working on a new text editor app. Your current task is to build a toolbar with a bunch of buttons for various operations of the editor. You created a simple command class for each operation, such as Copy, Cut, Paste, and so on.'),
    buildParagraph(
        'Each command class has a single method called execute. When this method is called, the command performs its operation on the editor. For instance, the Paste command inserts the current clipboard text into the text editor.'),
    buildParagraph(
        'The toolbar manages the commands and is responsible for their execution. However, you can’t just bind a command to a button and wait for a user to click it. You need to put the command’s execution logic into the user interface (UI) component that actually triggers the command.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/command/problem-en-2x.png'),
    buildHeading('Solution'),
    buildParagraph(
        'The Command pattern suggests that you create a new class for each command and move the command’s execution logic into the class. The class should have a method that triggers this logic.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/command/solution-en-2x.png'),
    buildParagraph(
        'In the simplest case, a command only requires one method to trigger a single operation. However, you can expand this class by adding more methods and parameters to cover a wider range of operations.'),
  ],
  'Interpreter': [
    buildHeading('Intent'),
    buildParagraph(
        'Interpreter is a behavioral design pattern that specifies how to evaluate sentences in a language. The basic idea is to have a class for each symbol (terminal or nonterminal) in a specialized computer language.'),
    buildImage(
        'https://refactoring.guru/images/patterns/content/interpreter/interpreter-2x.png'),
    buildHeading('Problem'),
    buildParagraph(
        'The Interpreter pattern is often used in the design of compilers and interpreters, but it can also be used in other areas, such as business rule engines.'),
    buildParagraph(
        'For example, you can use the pattern to parse SQL queries or expressions in a spreadsheet application.'),
    buildParagraph(
        'The Interpreter pattern is not commonly used in the design of modern software systems. It’s often implemented in special cases when you need to extend a DSL or create a new one.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/interpreter/problem-en-2x.png'),
    buildHeading('Solution'),
    buildParagraph(
        'The Interpreter pattern suggests that you create a class for each grammar rule. The class would be able to interpret sentences in the language defined by that grammar. The pattern is useful when you need to interpret formal languages, such as SQL or mathematical expressions.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/interpreter/solution-en-2x.png'),
    buildParagraph(
        'The Interpreter pattern is based on a hierarchy of classes, one class for each rule in the grammar. The class hierarchy is independent of the grammar hierarchy. The Interpreter pattern is usually implemented using the Composite pattern.'),
  ],
  'Iterator': [
    buildHeading('Intent'),
    buildParagraph(
        'Iterator is a behavioral design pattern that lets you traverse elements of a collection without exposing its underlying representation (list, stack, tree, etc.).'),
    buildImage(
        'https://refactoring.guru/images/patterns/content/iterator/iterator-2x.png'),
    buildHeading('Problem'),
    buildParagraph(
        'Collections are one of the most used data types in programming. Nevertheless, a collection is just a container for a group of objects. Most collections store their elements in simple lists, arrays, hash tables, or other basic data structures.'),
    buildParagraph(
        'However, some collections are quite complex, such as trees, graphs, and other intricate data structures. But no matter how complex the structure, consumers will always expect collections to provide a way to traverse their elements without exposing their internal details.'),
    buildParagraph(
        'For example, you have a complex tree object, and you want to traverse its elements. Without the Iterator pattern, you would be forced to implement a traversal algorithm directly within the tree class. That would be a bad idea because this algorithm might be useful for some other class of objects, which would force you to duplicate the traversal algorithm.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/iterator/problem-en-2x.png'),
    buildHeading('Solution'),
    buildParagraph(
        'The Iterator pattern suggests that you move the traversal algorithm out of the collection and into the iterator object. The pattern allows you to implement multiple traversal algorithms for the same collection.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/iterator/solution-en-2x.png'),
    buildParagraph(
        'The main idea of the pattern is to extract the traversal behavior of a collection into a separate object called an iterator.'),
  ],
  'Mediator': [
    buildHeading('Intent'),
    buildParagraph(
        'Mediator is a behavioral design pattern that reduces coupling between components of a program by making them communicate indirectly through a special mediator object.'),
    buildImage(
        'https://refactoring.guru/images/patterns/content/mediator/mediator-2x.png'),
    buildHeading('Problem'),
    buildParagraph(
        'Imagine that you have a dialog for creating and editing customer profiles. It consists of various form controls such as text fields, checkboxes, buttons, etc.'),
    buildParagraph(
        'After some time, you realize that the form has grown into a gigantic structure. It’s hard to maintain the code for such a monolith, and the complexity of the form raises the likelihood of introducing errors.'),
    buildParagraph(
        'One of the reasons that the form is so complex is that all of these controls are connected to each other. For instance, when a user changes the value in one field, several other fields must be updated accordingly.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/mediator/problem-en-2x.png'),
    buildHeading('Solution'),
    buildParagraph(
        'The Mediator pattern suggests that you should cease all direct communication between the components which you want to make independent of each other. Instead, these components must collaborate indirectly, by calling a special mediator object that redirects the calls to appropriate components. As a result, the components depend only on a single mediator class instead of being coupled to dozens of their colleagues.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/mediator/solution-en-2x.png'),
    buildParagraph(
        'The Mediator pattern lets you extract the relationships between various components into a separate class. The components become unaware of the changes in other components. They simply send and receive signals from the mediator object.'),
  ],
  'Memento': [
    buildHeading('Intent'),
    buildParagraph(
        'Memento is a behavioral design pattern that lets you save and restore the previous state of an object without revealing the details of its implementation.'),
    buildImage(
        'https://refactoring.guru/images/patterns/content/memento/memento-2x.png'),
    buildHeading('Problem'),
    buildParagraph(
        'Imagine that you’re creating a text editor app. In addition to simple text editing, your editor can format text, insert inline images, etc.'),
    buildParagraph(
        'At some point, you decided to let users undo any operations carried out on the text. To implement this feature, you need to save the state of the editor before making changes.'),
    buildParagraph(
        'The most straightforward way to do this is to store the entire state of the editor in a backup. However, such an approach is inefficient. Imagine that a user only changed a few words in the text. In this case, storing the entire text along with the cursor position would be a waste of memory.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/memento/problem-en-2x.png'),
    buildHeading('Solution'),
    buildParagraph(
        'The Memento pattern delegates creating the state snapshots to the actual originator object. The originator knows everything about its current state and can create a snapshot of it at any moment.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/memento/solution-en-2x.png'),
    buildParagraph(
        'The pattern suggests storing the state of the editor in a memento object. The editor itself is responsible for creating these objects and populating them with the necessary state. The memento object is then passed to the history stack, which is used to undo operations.'),
  ],
  'Observer': [
    buildHeading('Intent'),
    buildParagraph(
        'Observer is a behavioral design pattern that lets you define a subscription mechanism to notify multiple objects about any events that happen to the object they’re observing.'),
    buildImage(
        'https://refactoring.guru/images/patterns/content/observer/observer-2x.png'),
    buildHeading('Problem'),
    buildParagraph(
        'Imagine that you have two types of objects: a Customer and a Store. The customer is very interested in a particular brand of product, so they subscribe to updates from the store.'),
    buildParagraph(
        'When the store receives new products, it must notify all subscribed customers about each of them.'),
    buildParagraph(
        'The naive approach would be to directly call the update method of each customer when a new product arrives. But this approach has a significant drawback. If we decide to add new types of customers or change the way the store notifies customers, we must modify the store class.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/observer/problem-en-2x.png'),
    buildHeading('Solution'),
    buildParagraph(
        'The Observer pattern suggests that you add a subscription mechanism to the publisher class so individual objects can subscribe to or unsubscribe from a stream of events.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/observer/solution-en-2x.png'),
    buildParagraph(
        'The publisher notifies all subscribers when a significant event occurs. The subscribers may react in whatever way they see fit.'),
  ],
  'State': [
    buildHeading('Intent'),
    buildParagraph(
        'State is a behavioral design pattern that lets an object alter its behavior when its internal state changes. It appears as if the object changed its class.'),
    buildImage(
        'https://refactoring.guru/images/patterns/content/state/state-2x.png'),
    buildHeading('Problem'),
    buildParagraph(
        'The State pattern is closely related to the concept of a finite process. Imagine that you’re working on an online store application. The user puts some items in their shopping cart and then proceeds to checkout.'),
    buildParagraph(
        'The app needs to ensure that the user completes the checkout process before placing the order. Also, the app must track the order’s state and prevent the user from changing the order once it’s placed.'),
    buildParagraph(
        'The naive approach is to implement a massive conditional statement that would encapsulate all possible states of an order and switch the order’s behavior depending on these states.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/state/problem-en-2x.png'),
    buildHeading('Solution'),
    buildParagraph(
        'The State pattern suggests that you create a new class for every possible state of an object. This class should inherit from an abstract State class and declare all methods that the Context can use to handle this state.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/state/solution-en-2x.png'),
    buildParagraph(
        'The pattern lets you introduce changes to the classes of the context object without changing its code. All state-specific code lives in one place and makes it easy to extend, modify, or replace states independently.'),
  ],
  'Strategy': [
    buildHeading('Intent'),
    buildParagraph(
        'Strategy is a behavioral design pattern that lets you define a family of algorithms, put each of them into a separate class, and make their objects interchangeable.'),
    buildImage(
        'https://refactoring.guru/images/patterns/content/strategy/strategy-2x.png'),
    buildHeading('Problem'),
    buildParagraph(
        'Imagine that you have a TextEditor class. In addition to various text editing methods, it has a method that changes the selected text’s color.'),
    buildParagraph(
        'At some point, you decide to add a new feature to the editor: the ability to apply formatting to the selected text. The straightforward approach would be to extend the TextEditor class with new methods for each type of formatting.'),
    buildParagraph(
        'However, this approach would bloat the class with almost identical methods. Moreover, you’d need to modify the class each time when you add a new formatting algorithm or change the existing ones.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/strategy/problem-en-2x.png'),
    buildHeading('Solution'),
    buildParagraph(
        'The Strategy pattern suggests that you take a class that does something specific in a lot of different ways and extract all of these algorithms into separate classes called strategies.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/strategy/solution-en-2x.png'),
    buildParagraph(
        'The original class, called context, must have a field for storing a reference to one of the strategies. The context delegates the work to a linked strategy object instead of executing it on its own.'),
  ],
  'Template Method': [
    buildHeading('Intent'),
    buildParagraph(
        'Template Method is a behavioral design pattern that defines the skeleton of an algorithm in the superclass but lets subclasses override specific steps of the algorithm without changing its structure.'),
    buildImage(
        'https://refactoring.guru/images/patterns/content/template-method/template-method-2x.png'),
    buildHeading('Problem'),
    buildParagraph(
        'Imagine that you’re creating a data mining application that analyzes corporate documents. Users feed the app documents in various formats (PDF, DOC, CSV), and the app analyzes them and generates some statistics.'),
    buildParagraph(
        'The first version of the app could work only with DOC files. The second version added support for CSV files. The third one added support for PDF files.'),
    buildParagraph(
        'While the app’s core algorithm for analyzing documents remains the same, the implementation details vary greatly between the file formats.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/template-method/problem-en-2x.png'),
    buildHeading('Solution'),
    buildParagraph(
        'The Template Method pattern suggests that you break down an algorithm into a series of steps, turn these steps into methods, and put a series of calls to these methods inside a single template method. The steps may either be abstract, or have some default implementation.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/template-method/solution-en-2x.png'),
    buildParagraph(
        'To use the algorithm, the client is supposed to provide its own subclass, implement all abstract steps, and override some of the optional ones if needed (but not the template method itself).'),
  ],
  'Visitor': [
    buildHeading('Intent'),
    buildParagraph(
        'Visitor is a behavioral design pattern that lets you separate algorithms from the objects on which they operate.'),
    buildImage(
        'https://refactoring.guru/images/patterns/content/visitor/visitor-2x.png'),
    buildHeading('Problem'),
    buildParagraph(
        'Imagine that you have a complex structure made of simple and composite objects. You need to perform the same operation over all elements of this structure. For instance, you want to export these elements to a specific format.'),
    buildParagraph(
        'The straightforward way to do this is to add an export method to the base class of all element classes. However, this approach has a significant drawback. You need to modify all element classes whenever you change the export algorithm. Besides, this violates the Single Responsibility Principle because each class should only manage its data, not the export algorithm.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/visitor/problem-en-2x.png'),
    buildHeading('Solution'),
    buildParagraph(
        'The Visitor pattern suggests that you place the new behavior into a separate class called a visitor, instead of trying to integrate it into existing classes. The original object that had to perform the behavior is now passed to one of the visitor’s methods as an argument.'),
    buildImage(
        'https://refactoring.guru/images/patterns/diagrams/visitor/solution-en-2x.png'),
    buildParagraph(
        'The visitor class has access to the state of the original object. The visitor can do the operation over the element and change its state if necessary.'),
  ],
};

Widget buildHeading(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    ),
  );
}

Widget buildParagraph(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(fontSize: 16),
    ),
  );
}

Widget buildImage(String url) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: FadeInImage(
      // height: 250,
      width: double.infinity,
      placeholder: MemoryImage(kTransparentImage),
      image: NetworkImage(url),
      fit: BoxFit.cover,
    ),
  );
}
