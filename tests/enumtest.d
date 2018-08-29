module tests.enumtest;

import unit_threaded;
import vibe.data.json;

enum StabilityMode {
   absolute,
   percent,
   autoAbsolute,
   autoPercent
}
struct SimpleEnum {
   @byName StabilityMode mode;
}
void testVibeEnum() {
   SimpleEnum s = SimpleEnum(StabilityMode.percent);
   s.serializeToJsonString().shouldBeSameJsonAs( `{"mode": "percent"}`);

   SimpleEnum expect = SimpleEnum(StabilityMode.autoPercent);
   enum data = `{"mode":"autoPercent"}`;
   data.deserializeJson!SimpleEnum().shouldEqual(expect);
}
