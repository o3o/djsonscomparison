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
import std.variant;
alias Parm = Algebraic!(bool, int, long, double, string);

struct Copy {
   import asdf;
	string type;
	string key;
	@serializationIgnoreIn Parm[string] let;


	void finalizeDeserialization(Asdf json) {
      auto l = json["let"];
      foreach (k; l.byKeyValue) {
         const(char)[] key = k[0];
         let[key] = k[1].get("a");
         //switch (k[1].kind) {
            //case Asdf.Kind.string:
               //let[key] = l[key].get!string;
               //break;
            //case Asdf.Kind.false_:
               //let[key] = false;
               //break;
            //case Asdf.Kind.true_:
               //let[key] = true;
               //break;
            //case Asdf.Kind.number_:
               //let[key] = l[key].get!double;
               //break;
            //default:
               //assert(false);
         //}
      }
	}
}

/+
@("final")
unittest {
   import asdf;
   string json = `{
   "type": "copy",
   "key": "cp",
   "description": "copy data",
   "let": {
      "var_a": "var_x",
      "var_b": true,
      "var_c": 1964,
      "var_d": 12.5
   }
}`;

      Copy c =  json.deserialize!Copy();
      import std.stdio;
      writeln(c);

      Copy d = Copy("t");
      d.let["a"] = 20;
      writeln(d);
      writeln(d.serializeToJson);
}
+/
/+
struct ParmProxy {
   import asdf;
	Parm parms;
	alias parms this;

	static ParmProxy deserialize(Asdf data) {
/+      Parm[string] p;
      foreach (k; data.byKeyValue) {
         const(char)[] key = k[0];
         p[key] = k[1].get("a");
      }
+/
		return ParmProxy(data.get("a"));
	}

	void serialize(S)(ref S serializer) {
      import std.conv: to;
		serializer.putValue(parm.to!string);
	}
}


struct Copy2 {
   import asdf;
	string type;
	string key;
   @serializedAs!ParmProxy Parm[string] let;
}
@("final2")
unittest {
   import asdf;
   string json = `{
   "type": "copy",
   "key": "cp",
   "description": "copy data",
   "let": {
      "var_a": "var_x",
      "var_b": true,
      "var_c": 1964,
      "var_d": 12.5
   }
}`;

      Copy2 c =  json.deserialize!Copy2();
      import std.stdio;
      writeln(c);
}

struct PointProxy {
   import asdf;
	Point points;
	alias points this;

	static PointProxy deserialize(Asdf data) {
		return PointProxy(data.get("x"), data.get("y"));
	}

	void serialize(S)(ref S serializer) {
      /*
       *import std.conv: to;
		 *serializer.putValue(parm.to!string);
       */
	}
}
struct Copy3 {
   import asdf;
	string type;
	string key;
   @serializedAs!PointProxy Point[] points;
}
struct Point {
   int x;
   int y;
}

@("final3")
unittest {
   import asdf;
   string json = `{
   "type": "copy",
   "key": "cp",
   "description": "copy data",
   "points": [
      {"x":10, "y": 20 },
      {"x":11, "y": 21 }
   ]
}`;

      Copy3 c =  json.deserialize!Copy3();
      import std.stdio;
      writeln(c);
}

+/

