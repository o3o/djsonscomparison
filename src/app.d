version (unittest) {
   import unit_threaded;
} else {
   import std.stdio;
   void main(string[] args) {
      writeln("USE dub test -- -d testname");
   }
}

struct Simple {
   string name;
   ulong level;
   bool done;
}

@("asdfSerialize")
unittest {
   import asdf;
   auto s = Simple("asdf", 42, true);
   string expected = `{"name":"asdf","level":42,"done":true}`;
   assert(s.serializeToJson() == expected);
}

@("asdfDeserialize")
unittest {
   import asdf;
   auto s = Simple("asdf", 42, true);
   string data = `{"name":"asdf","level":42, "done":true}`;
   assert(data.deserialize!Simple == s);
}

@("vibeSerialize")
unittest {
   import vibe.data.json;
   auto s = Simple("vibe", 42, true);
   enum expected = `{"name":"vibe","level":42,"done":true}`;
   assert(s.serializeToJsonString() == expected);
}

@("vibeDeserialize")
unittest {
   import vibe.data.json;
   auto s = Simple("vibe", 32, true);
   enum data = `{"name":"vibe","level":32,"done":true}`;
   assert(data.deserializeJson!Simple() == s);
}

@("vibeDeserializeName")
unittest {
import vibe.data.json;
   struct Options {
      @name("number_of_di") int diSize;
      @name("connection_string") string connectionString;
   }


   auto s = Options( 32, "vibe");
   enum data = `{"connection_string":"vibe","number_of_di":32}`;
   data.deserializeJson!Options.shouldEqual(s);
}


@("asdfDeserializeName")
unittest {
   import asdf;
   struct Options {
      @serializationKeys("number_of_di") int diSize;
      @serializationKeys("connection_string", "cs") string connectionString;
   }

   auto s = Options( 32, "vibe");
   enum DATA = `{"connection_string":"vibe","number_of_di":32}`;
   DATA.deserialize!Options.shouldEqual(s);

   enum SHORT_DATA = `{"cs":"vibe","number_of_di":32}`;
   SHORT_DATA.deserialize!Options.shouldEqual(s);

}
