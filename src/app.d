import std.stdio;

void main() {
   asdfSerialize();
   vibeSerialize();

   asdfDeserialize();
   vibeDeserialize();
}

struct Simple {
   string name;
   ulong level;
   bool done;
}

void asdfSerialize() {
   import asdf;
   auto s = Simple("asdf", 42, true);
   string expected = `{"name":"asdf","level":42,"done":true}`;
   assert(s.serializeToJson() == expected);
}

void asdfDeserialize() {
   import asdf;
   auto s = Simple("asdf", 42, true);
   string data = `{"name":"asdf","level":42, "done":true}`;
   assert(data.deserialize!Simple == s);
}

void vibeSerialize() {
   import vibe.data.json;
   auto s = Simple("vibe", 42, true);
   string expected = `{"name":"vibe","level":42,"done":true}`;
   assert(s.serializeToJsonString() == expected);
}

void vibeDeserialize() {
   import vibe.data.json;
   auto s = Simple("vibe", 32, true);
   string data = `{"name":"vibe","level":32,"done":true}`;
   assert(data.deserializeJson!Simple() == s);
}
