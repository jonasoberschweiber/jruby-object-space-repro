package com.oberschweiber;

import org.jruby.Ruby;
import org.jruby.RubyClass;
import org.jruby.RubyModule;
import org.jruby.RubyObject;
import org.jruby.anno.JRubyMethod;
import org.jruby.runtime.ObjectAllocator;
import org.jruby.runtime.ThreadContext;
import org.jruby.runtime.builtin.IRubyObject;

public class MyRubyLoader {
  public class MyRubyObject extends RubyObject {
    public MyRubyObject(Ruby runtime, RubyClass rubyClass) {
      super(runtime, rubyClass);
    }
  }
}