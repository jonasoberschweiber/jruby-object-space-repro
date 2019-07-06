# JRuby behavior when introspecting object space

It is possible to generate a Java NullPointerException by enumerating all 
objects via `ObjectSpace` and doing a bit of reflection on them using 
`Module#constants`.

## How to run the repro case

1. Install dependencies via `bundle install` (`rake` and `rake-compiler`, to
  build the JAR file).
2. Build the JAR file: `rake compile`
3. Run the repro case: `ruby repro.rb`

## What I think is happening

**Note:** This is what I think is happening based on my limited understand of
what JRuby does behind the scenes from a cursory look at the JRuby source code.

When a JAR is required and a class inside that JAR is accessed, JRuby generates
proxy Ruby modules for the class that was accessed and the inner classes of that
class.

In the repro case, we require the JAR and access a class inside of it:

```ruby
require File.join(File.dirname(__FILE__), 'lib/my-ext.jar')
Java::com.oberschweiber.MyRubyLoader
```

The Java class is defined in `ext/com/oberschweiber/MyRubyLoader.java` and is 
a plain Java class that has an inner class called `MyRubyObject`. `MyRubyObject`
extends JRuby's `RubyObject`. 

After requiring the JAR and accessing `MyRubyLoader`, both `MyRubyLoader` and
`MyRubyObject` are in the object space:

```
Java::ComOberschweiber::MyRubyLoader::MyRubyObject
Java::ComOberschweiber::MyRubyLoader
```

If we inspect the constants on the `MyRubyObject` Ruby class, there are a few 
more than we expect:

```
[:REIFYING_OBJECT_ALLOCATOR, :NEVER, :USER2_F, :USER3_F, :TAINTED_F, :USER0_F, :USER1_F, :COMPARE_BY_IDENTITY_F, :IVAR_INSPECTING_OBJECT_ALLOCATOR, :USER8_F, :USER9_F, :FROZEN_F, :USER6_F, :USER7_F, :NIL_F, :USER4_F, :OBJECT_ALLOCATOR, :REFINED_MODULE_F, :USER5_F, :STAMP_OFFSET, :MyRubyObject, :USERA_F, :VAR_TABLE_OFFSET, :Finalizer, :NULL_ARRAY, :UNTRUST_F, :ERR_INSECURE_SET_INST_VAR, :Data, :IS_OVERLAID_F, :BASICOBJECT_ALLOCATOR, :FL_USHIFT, :UNDEF, :FALSE_F, :ALL_F]
```

Searching the JRuby code base for these constants, we come across 
`RubyBasicObject`, which is the super class of `RubyObject` (which is in turn
the super class of `MyRubyObject`). The most interesting constant of these is
`NEVER` (excerpt from the `RubyBasicObject` source code):

```java
    /**
     *  A value that is used as a null sentinel in among other places
     *  the RubyArray implementation. It will cause large problems to
     *  call any methods on this object.
     */
    public static final IRubyObject NEVER = new RubyBasicObject();
```

As the comment states, it will cause large problems to call any methods on 
`NEVER`. And indeed, calling anything -- `to_s`, `inspect`, `is_a` -- on `NEVER`
seems to cause the NullPointerException.